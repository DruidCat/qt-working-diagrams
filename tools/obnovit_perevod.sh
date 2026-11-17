#!/usr/bin/env bash
# Задача #773: регенерация каталога переводов интерфейса «Ментор».
# lupdate собирает строки из qml/, src/ и js/ в i18n/mentor_en.ts (не теряет готовый перевод),
# lrelease компилирует i18n/mentor_en.qm, который вшит в qml.qrc как :/i18n/mentor_en.qm.
# Незаполненные (<translation type="unfinished">) строки в .qm не попадают и остаются русскими.
set -euo pipefail
cd "$(dirname "$0")/.."
# В Debian/Ubuntu Qt6 кладет linguist-инструменты в /usr/lib/qt6/bin (их нет в PATH).
QT6BIN=/usr/lib/qt6/bin
LUPDATE=${LUPDATE:-$(command -v lupdate || echo "$QT6BIN/lupdate")}
LRELEASE=${LRELEASE:-$(command -v lrelease || echo "$QT6BIN/lrelease")}
"$LUPDATE" -source-language ru -target-language en qml src js -ts i18n/mentor_en.ts
"$LRELEASE" i18n/mentor_en.ts -qm i18n/mentor_en.qm
