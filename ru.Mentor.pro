# ru.Mentor.pro — qmake-аналог CMakeLists.txt (Qt6).
# Держать в синхроне с CMakeLists.txt: те же исходники, модули Qt, C++17
# и автоверсия из git (APP_VERSION / APP_SEMVER / GIT_SHA).

# Название исполняемого файла.
TARGET = ru.Mentor

# В свойстве файла Версия приложения.
VERSION = 0.1.1.0

# В свойстве файла Компания.
QMAKE_TARGET_COMPANY = DruidCat Co

# В свойстве файла Название приложения.
QMAKE_TARGET_PRODUCT = Mentor

# В свойстве файла Описание.
QMAKE_TARGET_DESCRIPTION = For working with the document catalog.

# В свойстве файла Права.
QMAKE_TARGET_COPYRIGHT = DruidCat

# Модули Qt — как в find_package(...) из CMakeLists.txt:
# Core Quick QuickControls2 Sql Pdf PdfQuick (Pdf — поиск в С++, PdfQuick — в QML).
QT += core quick quickcontrols2 sql pdf pdfquick

# Только Qt6 (CMakeLists требует Qt6; модуля PdfQuick в Qt5 нет).
lessThan(QT_MAJOR_VERSION, 6): error("Проект собирается только под Qt6 (нужен Qt::PdfQuick).")

CONFIG += c++17

# Свойства exe на Windows (WIN32_EXECUTABLE TRUE в CMake — без окна консоли).
win32: CONFIG += windows

# Ресурсный файл Windows с иконкой и свойствами (RES_FILES в CMakeLists.txt).
win32: RC_FILE = icons/ico/ru.Mentor.rc

# Предупреждения об устаревших API Qt.
# Точные предупреждения зависят от компилятора; для жёсткого запрета устаревшего API
# раскомментируй строку ниже (отключает всё, устаревшее до Qt 6.0.0).
DEFINES += QT_DEPRECATED_WARNINGS
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000

# === Автоверсия приложения из git (аналог execute_process в CMakeLists.txt) ===
# Считается при запуске qmake (аналог configure-шага CMake).
GIT_SHA = $$system(git rev-parse --short=7 HEAD 2> /dev/null)
GIT_DESCRIBE = $$system(git describe --tags --match "v[0-9]*" --abbrev=7 --dirty 2> /dev/null)

APP_VERSION = 0.0.0-0
APP_SEMVER = 0.0.0
!isEmpty(GIT_DESCRIBE) {
    # На теге или рядом с ним: vX.Y.Z[-N-g<sha>[-dirty]] -> убираем ведущую "v".
    APP_VERSION = $$replace(GIT_DESCRIBE, ^v, )
    # Semver — старший сегмент тега: v0.33.3[-N-gsha][-dirty] -> 0.33.3.
    APP_SEMVER = $$replace(GIT_DESCRIBE, ^v([0-9]+\.[0-9]+\.[0-9]+).*, \1)
} else {
    # Нет подходящих тегов — фоллбек 0.0.0-<BUILD_NUM>-g<sha>, как в CMake.
    isEmpty(BUILD_NUM): BUILD_NUM = 0
    !isEmpty(GIT_SHA): APP_VERSION = 0.0.0-$$BUILD_NUM-g$$GIT_SHA
    else: APP_VERSION = 0.0.0-$$BUILD_NUM
}

# Прокидываем версию в код (target_compile_definitions в CMakeLists.txt).
DEFINES += APP_VERSION=\\\"$$APP_VERSION\\\" \
           APP_SEMVER=\\\"$$APP_SEMVER\\\" \
           GIT_SHA=\\\"$$GIT_SHA\\\"

SOURCES += \
    src/copydannie.cpp \
    src/copykatalog.cpp \
    src/copyplan.cpp \
    src/cppqml.cpp \
    src/datadannie.cpp \
    src/dataelement.cpp \
    src/datakatalog.cpp \
    src/dataplan.cpp \
    src/dataspisok.cpp \
    src/datatitul.cpp \
    src/dcclass.cpp \
    src/dcdb.cpp \
    src/dcdbdata.cpp \
    src/dcfiledialog.cpp \
    src/dclogger.cpp \
    src/dcpdfpoisk.cpp \
    src/main.cpp

HEADERS += \
    src/copydannie.h \
    src/copykatalog.h \
    src/copyplan.h \
    src/cppqml.h \
    src/datadannie.h \
    src/dataelement.h \
    src/datakatalog.h \
    src/dataplan.h \
    src/dataspisok.h \
    src/datatitul.h \
    src/dcclass.h \
    src/dcdb.h \
    src/dcdbdata.h \
    src/dcfiledialog.h \
    src/dclogger.h \
    src/dcpdfpoisk.h

# Файлы ресурсы (rcc); в qml.qrc сидят qml/, fonts/, js/, images/, icons/.
RESOURCES += qml.qrc

# Пути для модели кода Qt Creator: qmldir-модули DCPages / DCMethods / DCButtons.
# Runtime-импорты идут из qrc:/qml (engine.addImportPath в main.cpp), так что
# QML_IMPORT_PATH нужен только редактору / QML Language Server
# (в CMakeLists для этого qml/ копируется в build — копия в сборке qmake не нужна).
QML_IMPORT_PATH += $$PWD/qml
QML_DESIGNER_IMPORT_PATH =

# Правила развертывания по умолчанию (install(TARGETS ...) в CMakeLists.txt).
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

# Файлы, не участвующие в создании кода (DATA_FILE + документация в CMakeLists).
DISTFILES += \
    AUTHORS.md \
    CMakeLists.txt \
    CODE_OF_CONDUCT.md \
    CONTRIBUTING.md \
    LICENSE.GPLv3.md \
    README.md \
    README.ru.md \
    TODO.txt \
    .gitignore \
    Qt5_AltLinux.txt \
    Qt6_AltLinux.txt \
    vim.txt \
    images/ru.Mentor.png \
    images/Qt_logo_2016.png \
    screenshots/KnopkiQML.png \
    screenshots/ru.WorkingDiagrams.png \
    icons/ico/ru.Mentor.rc \
    icons/ico/ru.Mentor.ico
