#!/usr/bin/env bash
# Задача #28 (MENTOR_DB_MOBILE, Android): синхронизация workingdata в assets APK.
# Вызывается шагом PRE_LINK из CMakeLists.txt; можно запускать и вручную:
#   tools/sync_dbmobile_assets.sh [каталог_проекта]
# Источник по умолчанию — workingdata проекта. Полный комплект документов хранится
# вне репозитория (git его не содержит) — указать через MENTOR_WORKINGDATA=/путь.
# В бандл пишется bundleversion.txt: при её изменении приложение на устройстве
# переустанавливает файлы принудительно (сверка только по размеру правки не видит).
set -euo pipefail
REPO_DIR="${1:-$(dirname "$(dirname "$(realpath "$0")")")}"
SRC="${MENTOR_WORKINGDATA:-$REPO_DIR/workingdata}"
DST="$REPO_DIR/android/assets/workingdata"
if [ ! -d "$SRC" ]; then
    echo "ОШИБКА: каталог данных не найден: $SRC" >&2
    exit 1
fi
if [ ! -f "$SRC/druidcat.db" ]; then
    echo "ПРЕДУПРЕЖДЕНИЕ: в $SRC нет druidcat.db — бандл будет неполным" >&2
fi
VER="${MENTOR_BUNDLE_VERSION:-$(git -C "$REPO_DIR" describe --tags --match 'v[0-9]*' 2>/dev/null || echo 0.0.0)}"
mkdir -p "$DST"
rsync -a --delete "$SRC/" "$DST/"
echo "$VER" > "$DST/bundleversion.txt"
echo "Бандл workingdata: $(find "$DST" -type f | wc -l) файлов, $(du -sh "$DST" | cut -f1), версия $VER"
