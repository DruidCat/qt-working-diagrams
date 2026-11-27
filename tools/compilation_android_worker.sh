#!/usr/bin/env bash
# Сборка «Ментора» под Android в защищённом режиме мобильных рабочих:
# MENTOR_DB_MOBILE=ON + MENTOR_DATA_ENCRYPTED=ON (шифрованный workingdata
# с проверкой по коду устройства), оба ABI, universal APK.
# Отличия от compilation_android_admin.sh помечены словом (worker).
# Запуск из корня клона: bash tools/compilation_android_worker.sh [-y]
# Требуется (worker, скачать нельзя - только привезти/скопировать):
#   ~/secrets/mentor-licensing/license.json  - лицензия с мастер-секретом;
#   каталог workingdata (287 файлов)        - через MENTOR_WORKINGDATA или
#                                             <репозиторий>/workingdata;
#   ~/secrets/mentor-release.keystore       - релизный ключ DruidCat.
set -euo pipefail

QT_VER=6.7.3
QTDIR="$HOME/Qt6"
SDKDIR="$HOME/Android/Sdk"
NDK_VER=26.1.10909125
BT_VER=34.0.0
FAU=https://ftp.fau.de/qtproject/online/qtsdkrepository/linux_x64
GOOG=https://dl.google.com/android/repository
ABIS=(armeabi-v7a arm64-v8a)
QTABI=(android_armv7 android_arm64_v8a)
declare -a APK_UN
ASSUM=YES
for a in "$@"; do [ "$a" = "-y" ] && ASSUM=YES; done

ask() { # вопрос с подтверждением
    if [ "$ASSUM" = YES ]; then return 0; fi
    printf '%s [y/N]: ' "$1"
    local r; read -r r; [ "$r" = "y" ] || [ "$r" = "Y" ]
}

cd "$(dirname "$0")/.."
REPO=$PWD
echo "=== Шаг 0: лицензия и исходные данные (worker) ==="
LIC="$HOME/secrets/mentor-licensing/license.json"
if [ ! -f "$LIC" ]; then
    echo "НЕТ ЛИЦЕНЗИИ: $LIC"
    echo "Её нужно СКОПИРОВАТЬ с основной машины сборки (тот же файл! новый"
    echo "мастер-секрет сделает ранее выданные APK нечитаемыми)."
    echo "Формат файла (mentor-license-v1):"
    echo '  { "format": "mentor-license-v1", "kdf_iterations": 100000,'
    echo '    "master_secret_hex": "<64 hex>", "devices": [ { "code": "<код из О приложении>" } ] }'
    echo "Каталог: mkdir -p ~/secrets/mentor-licensing && chmod 700 ~/secrets/mentor-licensing"
    exit 1
fi
WD="${MENTOR_WORKINGDATA:-$REPO/workingdata}"
if [ ! -d "$WD" ] || [ -z "$(ls -A "$WD" 2>/dev/null)" ]; then
    echo "НЕ НАЙДЕН КАТАЛОГ ДАННЫХ: $WD"
    echo "workingdata (287 файлов, ~553 МБ) не хранится в git - скопируйте его"
    echo "с основной машины и задайте: MENTOR_WORKINGDATA=/путь $0"
    exit 1
fi
echo "Лицензия: $LIC"
echo "Данные:   $WD ($(find "$WD" -type f | wc -l) файлов)"
echo "=== Шаг 1: базовые утилиты ==="
APT_PKGS=""
need_util() { # утилита пакет
    command -v "$1" >/dev/null 2>&1 || { APT_PKGS="$APT_PKGS $2"; echo "нет: $1 (пакет $2)"; }
}
need_util git git
need_util cmake cmake
need_util ninja ninja-build
need_util python3 python3
need_util zip zip
need_util unzip unzip
need_util curl curl
need_util 7za p7zip-full
JDK=""
for d in "$HOME"/jdk/jdk-11*; do [ -x "$d/bin/java" ] && JDK=$d; done
if [ -z "$JDK" ] && java -version 2>&1 | grep -q 'version "11'; then
    JDK=$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")
fi
[ -n "$JDK" ] || echo "нет: JDK 11 (нужен Gradle)"
if [ -n "$APT_PKGS" ]; then
    echo "Установка: sudo apt-get install -y$APT_PKGS"
    echo "или инструкция: https://packages.ubuntu.com/"
    if ask "Установить эти пакеты?"; then
        # сломанные сторонние репозитории не должны блокировать установку:
        # apt использует прошлые списки пакетов
        sudo apt-get update -qq || \
            echo "apt update завершился ошибкой - ставлю из кэшированных списков"
        sudo apt-get install -y $APT_PKGS
    else
        echo "Без них сборка невозможна - выход."
        exit 1
    fi
fi
if [ -z "$JDK" ]; then
    echo "JDK 11 не найден. Источник: Temurin 11 (Adoptium), установлю в ~/jdk:"
    echo "https://api.adoptium.net/v3/binary/latest/11/ga/linux/x64/jdk/hotspot/normal/eclipse"
    if ask "Скачать и установить JDK 11?"; then
        mkdir -p "$HOME/jdk"
        curl -fL -o /tmp/jdk11.tar.gz \
            "https://api.adoptium.net/v3/binary/latest/11/ga/linux/x64/jdk/hotspot/normal/eclipse"
        tar -xzf /tmp/jdk11.tar.gz -C "$HOME/jdk"
        JDK=$(echo "$HOME"/jdk/jdk-11*)
        rm -f /tmp/jdk11.tar.gz
    else
        echo "Gradle требует JDK 11 - выход."
        exit 1
    fi
fi
echo "JDK: $JDK"

echo "=== Шаг 2: Qt $QT_VER ($QTDIR/$QT_VER) ==="
QT_OK=false
[ -x "$QTDIR/$QT_VER/gcc_64/bin/androiddeployqt" ] && \
[ -d "$QTDIR/$QT_VER/${QTABI[0]}/lib/cmake/Qt6" ] && \
[ -d "$QTDIR/$QT_VER/${QTABI[1]}/lib/cmake/Qt6" ] && QT_OK=true
if $QT_OK; then
    echo "Qt $QT_VER на месте: gcc_64, ${QTABI[0]}, ${QTABI[1]}"
else
    echo "Будет создано:"
    echo "  $QTDIR/$QT_VER/gcc_64        (хост-инструменты, ~1.5 ГБ)"
    echo "  $QTDIR/$QT_VER/${QTABI[0]}   (Qt для armeabi-v7a, ~0.5 ГБ)"
    echo "  $QTDIR/$QT_VER/${QTABI[1]}   (Qt для arm64-v8a, ~0.5 ГБ)"
    echo "Источник: $FAU (download.qt.io часто блокируется)"
    if ! ask "Скачать Qt?"; then
        echo "Выход."
        exit 1
    fi
    get_qt() { # базовый URL каталога; затем имена пакетов
        local url=$1 pkg listing fname
        for pkg in "${@:2}"; do
            listing=$(curl -fsSL --retry 3 "$url$pkg/")
            for fname in $(echo "$listing" | grep -oE 'href="[^"]+\.7z"' | \
                               sed 's/href="//;s/"$//' | grep -v meta.7z); do
                echo "  $pkg/$fname"
                curl -fL -C - --retry 5 -o /tmp/qtq.7z "$url$pkg/$fname"
                mkdir -p /tmp/qtq
                7za x -y -o/tmp/qtq /tmp/qtq.7z >/dev/null
                # архивы кладут содержимое в ./6.7.3/... - сливаем в $QTDIR
                rsync -a /tmp/qtq/6.7.3/ "$QTDIR/$QT_VER/"
            done
        done
        rm -rf /tmp/qtq /tmp/qtq.7z
    }
    mkdir -p "$QTDIR/$QT_VER"
    for abi in "${QTABI[@]}"; do
        get_qt "$FAU/android/qt6_7_3/qt6_673_${abi#android_}/" \
            "qt.qt6.673.$abi/" "qt.qt6.673.addons.qtpdf.$abi/" "qt.qt6.673.qtshadertools.$abi/"
    done
    get_qt "$FAU/desktop/qt6_673/" \
        "qt.qt6.673.linux_gcc_64/" "qt.qt6.673.addons.qtpdf.linux_gcc_64/" \
        "qt.qt6.673.qtshadertools.linux_gcc_64/"
    # 7za не сохраняет бит +x на бинарниках
    chmod -R +x "$QTDIR/$QT_VER/gcc_64/bin" "$QTDIR/$QT_VER/gcc_64/libexec" 2>/dev/null || true
    for abi in "${QTABI[@]}"; do chmod -R +x "$QTDIR/$QT_VER/$abi/bin" 2>/dev/null || true; done
fi

echo "=== Шаг 3: Android SDK/NDK ($SDKDIR) ==="
MISSING=()
[ -d "$SDKDIR/platforms/android-34" ] || MISSING+=("platforms/android-34")
[ -d "$SDKDIR/build-tools/$BT_VER" ] || MISSING+=("build-tools/$BT_VER")
[ -d "$SDKDIR/ndk/$NDK_VER" ] || MISSING+=("ndk/$NDK_VER")
if [ ${#MISSING[@]} -eq 0 ]; then
    echo "SDK на месте: platforms/android-34, build-tools/$BT_VER, ndk/$NDK_VER"
else
    echo "Отсутствует: ${MISSING[*]}"
    echo "Будет создано в $SDKDIR (зеркало Google, ~3.5 ГБ):"
    echo "  platforms/android-34   <- $GOOG/platform-34-ext7_r03.zip"
    echo "  build-tools/$BT_VER    <- $GOOG/build-tools_r34-linux.zip"
    echo "  ndk/$NDK_VER           <- $GOOG/android-ndk-r26b-linux.zip"
    if ! ask "Скачать компоненты SDK?"; then
        echo "Выход."
        exit 1
    fi
    mkdir -p "$SDKDIR"
    unpack() { # архив каталог_назначения верхний_каталог_в_архиве
        local z=$1 dst=$2 inner=$3 tmp=/tmp/undl
        curl -fL -C - --retry 5 -o "/tmp/$z" "$GOOG/$z"
        rm -rf $tmp; mkdir -p $tmp
        unzip -q "/tmp/$z" -d $tmp
        mkdir -p "$(dirname "$dst")"
        mv "$tmp/$inner" "$dst"
        rm -rf "/tmp/$z" $tmp
    }
    unpack platform-34-ext7_r03.zip "$SDKDIR/platforms/android-34" android-14
    unpack build-tools_r34-linux.zip "$SDKDIR/build-tools/$BT_VER" android-14
    unpack android-ndk-r26b-linux.zip "$SDKDIR/ndk/$NDK_VER" android-ndk-r26b
fi

echo "=== Шаг 4: шифрование данных и сборка (worker: DB_MOBILE + ENCRYPTED) ==="
# (worker) генерируем бандл руками ДО ninja: ninja не отслеживает правки
# тулзы, а один и тот же blob+licenziya.bin должны попасть в оба ABI.
echo "Шифрование workingdata (tools/shifruj_dannie.py)..."
MENTOR_WORKINGDATA="$WD" MENTOR_LICENSE_JSON="$LIC" python3 tools/shifruj_dannie.py
T0=$SECONDS
konfig() { # каталог_qt каталог_сборки abi
    local qt=$QTDIR/$QT_VER/$1
    rm -rf "$2"
    JAVA_HOME=$JDK "$qt/bin/qt-cmake" -S . -B "$2" -G Ninja -DCMAKE_BUILD_TYPE=Release \
        -DMENTOR_DB_MOBILE=ON -DMENTOR_DATA_ENCRYPTED=ON -DMENTOR_LICENSE_JSON="$LIC" \
        -DANDROID_SDK_ROOT="$SDKDIR" \
        -DANDROID_NDK_ROOT="$SDKDIR/ndk/$NDK_VER" \
        -DANDROID_ABI="$3" -DANDROID_PLATFORM=android-22 \
        -DQT_HOST_PATH="$QTDIR/$QT_VER/gcc_64" \
        -DQt6_DIR="$qt/lib/cmake/Qt6"
}
for i in 0 1; do
    echo "--- configure + ninja: ${ABIS[$i]}"
    konfig "${QTABI[$i]}" "build-android-${ABIS[$i]}" "${ABIS[$i]}"
    JAVA_HOME=$JDK ninja -C "build-android-${ABIS[$i]}" >/dev/null
    APK_UN[$i]="build-android-${ABIS[$i]}/android-build/build/outputs/apk/release"
    APK_UN[$i]="${APK_UN[$i]}/android-build-release-unsigned.apk"
    [ -f "${APK_UN[$i]}" ] || { echo "СБОРКА НЕ УДАЛАСЬ: ${APK_UN[$i]}"; exit 1; }
done

echo "=== Шаг 5: подпись двух APK (arm64 и armv7) ==="
# Имена APK кодируют режим и версию из git describe.
# (27.11.2026) Universal-склейка ОТМЕНЕНА: Qt 6.7.3 не умеет multi-ABI,
# его загрузчик в склеенном APK не определяет ABI (ищет libru.Mentor_null.so)
# и приложение убивается на старте. Официальный multi-ABI только в Qt >= 6.8,
# где уже нет бинарей armv7. Правильный результат - два отдельных APK.
VER=$(git describe --tags | sed -e 's/^v//' -e 's/-g[0-9a-f]*$//')
OUT_V7=mentor-worker-$VER-armv7.apk
OUT_A64=mentor-worker-$VER-arm64.apk
KS="$HOME/secrets/mentor-release.keystore"
KSPASS="$HOME/secrets/mentor-release-keystore-pass.txt"
SIGNED=NO
sign_rel() {
    "$SDKDIR/build-tools/$BT_VER/zipalign" -f 4 "$1" "$2"
    "$SDKDIR/build-tools/$BT_VER/apksigner" sign --ks "$KS" --ks-key-alias mentor \
        --ks-pass env:MENTOR_KS_PASS --key-pass env:MENTOR_KS_PASS "$2"
}
if [ -f "$KS" ] && [ -f "$KSPASS" ]; then
    echo "Найден релизный ключ DruidCat: $KS"
    if ask "Подписать релизным ключом?"; then
        export MENTOR_KS_PASS
        MENTOR_KS_PASS=$(< "$KSPASS")
        sign_rel "${APK_UN[0]}" "$OUT_V7"
        sign_rel "${APK_UN[1]}" "$OUT_A64"
        unset MENTOR_KS_PASS
        SIGNED=YES
    fi
elif [ -f "$KS" ]; then
    echo "Внимание: keystore есть, но нет файла пароля $KSPASS."
else
    echo "Папки ~/secrets с релизным ключом нет. Инструкция создания:"
    echo "  mkdir -p ~/secrets && chmod 700 ~/secrets"
    echo "  положить mentor-release.keystore (из хранилища DruidCat)"
    echo "  echo ПАРОЛЬ > ~/secrets/mentor-release-keystore-pass.txt"
    echo "  chmod 600 ~/secrets/mentor-release-keystore-pass.txt"
    echo "Без релизного ключа подпись будет отладочной:"
    echo "приложение установится, но обновления поверх релизных версий не встанут."
fi
if [ "$SIGNED" = NO ]; then
    DBG="$HOME/.android/debug.keystore"
    if [ ! -f "$DBG" ]; then
        mkdir -p "$HOME/.android"
        "$JDK/bin/keytool" -genkeypair -keystore "$DBG" -alias android \
            -keypass android -storepass android -dname "CN=Android Debug" \
            -keyalg RSA -keysize 2048 -validity 10000 >/dev/null
    fi
    echo "Подпись отладочным ключом ($DBG)"
    for pair in "${APK_UN[0]}|$OUT_V7" "${APK_UN[1]}|$OUT_A64"; do
        src=${pair%%|*}; dst=${pair#*|}
        "$SDKDIR/build-tools/$BT_VER/zipalign" -f 4 "$src" "$dst"
        "$SDKDIR/build-tools/$BT_VER/apksigner" sign --ks "$DBG" \
            --ks-pass pass:android --key-pass pass:android "$dst"
    done
fi

echo "=== Шаг 6: статистика сборки ==="
for F in "$OUT_A64" "$OUT_V7"; do
    echo "APK: $REPO/$F"
    ls -la "$F"
    "$SDKDIR/build-tools/$BT_VER/aapt2" dump badging "$F" | \
        grep -E "^package|sdkVersion|targetSdkVersion|native-code"
    "$SDKDIR/build-tools/$BT_VER/apksigner" verify --print-certs "$F" 2>/dev/null | \
        grep -E "Signer #1 certificate DN|SHA-256" | head -2
    unzip -l "$F" | grep -E "dannie.tar.enc|licenziya.bin"
done
echo "Время сборки: $((SECONDS - T0)) с"
echo "APK ~600 МБ, на телефоне нужно ~1.2 ГБ свободно."
echo "Доступ к данным - только у устройств с кодом из лицензии."
echo "64-битные телефоны (POCO X7 Pro и новее) - ставьте $OUT_A64."
echo "32-битные телефоны (Luck L130) - ставьте $OUT_V7."
