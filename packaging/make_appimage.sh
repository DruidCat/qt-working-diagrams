#!/usr/bin/env bash
# Сборка AppImage «Ментора» для десктопного Linux.
# Используется в CI (.github/workflows) и локально.
# Требуется: собранное приложение (build/ru.Mentor), Qt 6 на PATH (qmake),
# linuxdeploy + qmlimportscanner из комплекта Qt.
set -euo pipefail
export LC_ALL=C

# Аргументы: каталог сборки приложения, каталог выхода.
BUILD_DIR=${1:?usage: $0 <build-dir> <out-dir>}
OUT_DIR=${2:?usage: $0 <out-dir>}
REPO_DIR=$(cd "$(dirname "$0")/.." && pwd)
QMAKE_BIN=$(qmake -query QT_INSTALL_BINS)
QML_DIR=$(qmake -query QT_INSTALL_QML)
PLUGINS_DIR=$(qmake -query QT_INSTALL_PLUGINS)
QML_SCANNER="$QMAKE_BIN/qmlimportscanner"
[ -x "$QML_SCANNER" ] || QML_SCANNER="$(qmake -query QT_INSTALL_LIBEXECS)/qmlimportscanner"

QML_IMPORTS=$(mktemp)
"$QML_SCANNER" -rootPath "$REPO_DIR/qml" -importPath "$QML_DIR" > "$QML_IMPORTS"

APPDIR="$OUT_DIR/AppDir"
rm -rf "$APPDIR"
mkdir -p "$APPDIR/usr/bin" "$APPDIR/usr/lib" "$APPDIR/usr/plugins" "$APPDIR/usr/qml"
cp "$BUILD_DIR/ru.Mentor" "$APPDIR/usr/bin/ru.Mentor"

# QML-модули Qt: берём те, что нашёл qmlimportscanner, + весь QtQml (рантайм).
python3 - "$QML_IMPORTS" "$QML_DIR" "$APPDIR/usr/qml" <<'PYEOF'
import json, os, shutil, sys
imports_path, src_root, dst_root = sys.argv[1:4]
data = json.load(open(imports_path))
mods = set()
def walk(nodes):
    for m in nodes:
        p = m.get('path')
        if p and '://' not in p:
            mods.add(p)
        walk(m.get('imports', []))
walk(data)
print('qml modules:', sorted(mods))
for p in mods:
    # qmlimportscanner отдаёт абсолютные пути при -importPath; переводим в relpath.
    rel = os.path.relpath(p, src_root) if os.path.isabs(p) else p.replace('.', '/')
    if rel.startswith('..'):
        continue  # чужие модули (локальные qrc/js пути) — не трогаем
    parts = rel.split('/')
    for i in range(1, len(parts) + 1):
        s = os.path.join(src_root, *parts[:i])
        d = os.path.join(dst_root, *parts[:i])
        if os.path.isdir(s):
            shutil.copytree(s, d, dirs_exist_ok=True)
# QtQml целиком — плагины рантайма QML (Meta и т.п.).
shutil.copytree(os.path.join(src_root, 'QtQml'),
                os.path.join(dst_root, 'QtQml'), dirs_exist_ok=True)
PYEOF

# Платформенные Qt-плагины: Wayland + XCB + нужные подкаталоги.
for pdir in platforms xcb-gl imageformats sqldrivers platforminputcontexts \
             wayland-shell-integration; do
    if [ -d "$PLUGINS_DIR/$pdir" ]; then
        mkdir -p "$APPDIR/usr/plugins/$pdir"
        cp -a "$PLUGINS_DIR/$pdir/." "$APPDIR/usr/plugins/$pdir/"
    fi
done
# Избыточные драйверы SQL кроме sqlite вычищаем (тянут chameleon-зависимости).
find "$APPDIR/usr/plugins/sqldrivers" -name 'libqsql*' ! -name 'libqsqlite*' -delete 2>/dev/null || true
# Платформы, не нужные на обычном десктопе.
rm -f "$APPDIR"/usr/plugins/platforms/libqminimal.dll 2>/dev/null || true
find "$APPDIR/usr/plugins/platforms" -name 'libqvnc*' -delete 2>/dev/null || true

# Рекурсивное замыкание ldd по exe + всем .so в AppDir; копируем в usr/lib.
# ldd крутим с LD_LIBRARY_PATH=официальные библиотеки Qt: иначе системный Qt
# другой версии просачивается в бандл, когда родная зависимость ещё не скопирована.
python3 - "$APPDIR" "$(qmake -query QT_INSTALL_LIBS)" <<'PYEOF'
import os, re, subprocess, sys
appdir, qtlib = sys.argv[1], sys.argv[2]
ldenv = dict(os.environ, LD_LIBRARY_PATH=qtlib)
libdst = os.path.join(appdir, 'usr', 'lib')
whitelist = re.compile(r'^(ld-linux|libc\.so|libm\.so|libdl\.so|libpthread\.so|'
                       r'librt\.so|libresolv\.so|libnsl\.so|libutil\.so|'
                       r'libgcc_s\.so|libstdc\+\.so|linux-vdso)')
seen, copied = set(), set()
todo = []
def elfs():
    for root, _, files in os.walk(os.path.join(appdir, 'usr')):
        for f in files:
            p = os.path.join(root, f)
            if os.path.isfile(p) and not os.path.islink(p):
                try:
                    with open(p, 'rb') as fh:
                        if fh.read(4) == b'\x7fELF':
                            yield p
                except OSError:
                    pass
todo = list(elfs())
while todo:
    p = todo.pop()
    if p in seen:
        continue
    seen.add(p)
    try:
        out = subprocess.run(['ldd', p], capture_output=True,
                             text=True, timeout=60, env=ldenv).stdout
    except Exception:
        continue
    for line in out.splitlines():
        m = re.search(r'=>\s+(/\S+)', line)
        if not m:
            continue
        dep = os.path.realpath(m.group(1))
        # Имя назначения — запрошенное SONAME (левая колонка ldd), а не basename
        # реального файла: иначе загрузчик не находит lib*.so.N по DT_NEEDED.
        lhs = line.split()[0]
        name = lhs if lhs.endswith('.so') or '.so.' in lhs else os.path.basename(dep)
        if whitelist.match(os.path.basename(dep)) or not os.path.isfile(dep):
            continue
        if name not in copied:
            copied.add(name)
            subprocess.run(['cp', '-a', dep, os.path.join(libdst, name)], check=True)
            todo.append(os.path.join(libdst, name))
print(f'deployed {len(copied)} shared libs')
PYEOF

# ICU: официальные бинарники Qt6 слинкованы с конкретной версией ICU,
# которой нет в целевых дистрибутивах. Бандлим deb из snapshot.debian.org,
# всегда (а не только при отсутствии в системе) — ради воспроизводимости.
ICU_MAJOR=$( (readelf -d "$APPDIR/usr/lib/libQt6Core.so.6" 2>/dev/null \
    | grep -m1 -oE 'libicuuc\.so\.[0-9]+' | cut -d. -f3) || true)
if [ -n "$ICU_MAJOR" ]; then
    case "$ICU_MAJOR" in
        72) ICU_DEB="libicu72_72.1-3_amd64.deb"; ICU_SNAP="20230601T000000Z" ;;
        73) ICU_DEB="libicu73_73.2-1_amd64.deb"; ICU_SNAP="20231001T000000Z" ;;
        74) ICU_DEB="libicu74_74.2-1_amd64.deb"; ICU_SNAP="20241101T000000Z" ;;
        *) echo "ERROR: неизвестная версия ICU $ICU_MAJOR — обнови ICU_DEB" >&2; exit 1 ;;
    esac
    ICU_TMP=$(mktemp -d)
    curl -fL --retry 3 -o "$ICU_TMP/icu.deb" \
        "https://snapshot.debian.org/archive/debian/$ICU_SNAP/pool/main/i/icu/$ICU_DEB"
    dpkg-deb -x "$ICU_TMP/icu.deb" "$ICU_TMP/ex"
    # Только то, что реально нужно Qt6: uc, i18n, data (icutu/icuio не тащим).
    for ic in libicudata libicui18n libicuuc; do
        cp -a "$ICU_TMP"/ex/usr/lib/*/${ic}.so.$ICU_MAJOR* "$APPDIR/usr/lib/"
    done
    rm -rf "$ICU_TMP"
    echo "bundled ICU $ICU_MAJOR"
fi

# Единый RUNPATH $ORIGIN для всех библиотек в usr/lib: внутренние зависимости
# резолвятся сами в себе до того, как AppImage соберётся (linuxdeploy это
# делает по ходу, и проверки падают на перекрёстных зависимостях бандла).
PATCHELF=${PATCHELF:-$(command -v patchelf || true)}
[ -n "$PATCHELF" ] || { echo "ERROR: нужен patchelf (apt install patchelf)" >&2; exit 1; }
find "$APPDIR/usr/lib" -maxdepth 1 -type f | while read -r f; do
    "$PATCHELF" --output "$f" --set-rpath '$ORIGIN' "$f" 2>/dev/null || true
done

# Иконка и desktop-файл по конвенции AppImage.
cp "$REPO_DIR/packaging/mentor.desktop" "$APPDIR/ru.Mentor.desktop"
cp "$REPO_DIR/packaging/mentor.desktop" "$APPDIR/usr/share/applications/ru.Mentor.desktop" \
    2>/dev/null || mkdir -p "$APPDIR/usr/share/applications" && \
    cp "$REPO_DIR/packaging/mentor.desktop" "$APPDIR/usr/share/applications/ru.Mentor.desktop"
cp "$REPO_DIR/icons/128x128/ru.Mentor.png" "$APPDIR/ru.Mentor.png"
cp "$REPO_DIR/icons/128x128/ru.Mentor.png" "$APPDIR/usr/share/icons/hicolor/128x128/apps/ru.Mentor.png" \
    2>/dev/null || mkdir -p "$APPDIR/usr/share/icons/hicolor/128x128/apps" && \
    cp "$REPO_DIR/icons/128x128/ru.Mentor.png" "$APPDIR/usr/share/icons/hicolor/128x128/apps/ru.Mentor.png"

# Свой AppRun: пути через окружение, без патчинга RPATH.
# Шаблон держим ВНЕ AppDir: linuxdeploy копирует custom-apprun в AppDir/AppRun,
# и тот же путь дал бы самокопирование с ошибкой.
cat > "$OUT_DIR/AppRun" <<'APPRUNEOF'
#!/usr/bin/env bash
here="$(dirname "$(readlink -f "$0")")"
export LD_LIBRARY_PATH="$here/usr/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export QML2_IMPORT_PATH="$here/usr/qml"
export QT_PLUGIN_PATH="$here/usr/plugins"
exec "$here/usr/bin/ru.Mentor" "$@"
APPRUNEOF
chmod +x "$OUT_DIR/AppRun"
sed 's/^Exec=ru.Mentor/Exec=AppRun/' "$REPO_DIR/packaging/mentor.desktop" > "$APPDIR/ru.Mentor.desktop"

# Версия для имени AppImage — из git describe (CI на теге даёт чистую).
VER=$(git -C "$REPO_DIR" describe --tags --match "v[0-9]*" 2>/dev/null | sed 's/^v//' || echo 0.0.0)
"$LINUXDEPLOY" --appimage-extract-and-run --appdir "$APPDIR" \
    --output appimage --custom-apprun "$OUT_DIR/AppRun"
# linuxdeploy пишет образ в текущий каталог, не в OUT_DIR — ищем оба.
find "$OUT_DIR" "$PWD" -maxdepth 1 -name 'Mentor-x86_64.AppImage' -exec mv -f {} "$OUT_DIR/Mentor-${VER}-x86_64.AppImage" \;
echo "APPIMAGE_DONE: $OUT_DIR/Mentor-${VER}-x86_64.AppImage"
