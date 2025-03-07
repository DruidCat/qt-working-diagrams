# Название исполняемого файла.
TARGET = ru.WorkingDiagrams

# В свойстве файла Версия приложения.
VERSION = 0.1.1.0

# В свойстве файла Компания.
QMAKE_TARGET_COMPANY = DruidCat Co

# В свойстве файла Название приложения.
QMAKE_TARGET_PRODUCT = Working Diagrams

# В свойстве файла Описание.
QMAKE_TARGET_DESCRIPTION = For working with the document catalog.

# В свойстве файла Права.
QMAKE_TARGET_COPYRIGHT = DruidCat

# Добавляем библиотеки сюда.
QT += \
	quick \
    sql
   # pdf
   # core5compat	# Добавить в Qt6 для UTF8

CONFIG += c++11

# Иконка для exe файла в Windows.
win32: RC_ICONS += ru.WorkingDiagrams.ico

# Следующее определение заставляет ваш компьютер выдавать предупреждения,
# если вы используете какую-либо функцию Qt,
# которая была помечена как устаревшая (точные предупреждения зависят от вашего компилятора).
# Обратитесь к документации по устаревшему API, чтобы узнать, как перенести свой код с него.
DEFINES += QT_DEPRECATED_WARNINGS

# Вы также можете привести к сбою компиляции вашего кода, если он использует устаревшие API.
# Для этого раскомментируйте следующую строку.
# Вы также можете отключить устаревшие API только до определенной версии Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000   # отключает все API, которые были устаревшими до Qt 6.0.0

SOURCES += \
		src/copydannie.cpp \
		src/cppqml.cpp \
		src/datadannie.cpp \
		src/dataelement.cpp \
		src/dataspisok.cpp \
		src/datatitul.cpp \
		src/dcclass.cpp \
		src/dcdb.cpp \
		src/dcdbdata.cpp \
		src/dcfiledialog.cpp \
		src/main.cpp

# Добавляем здесь файлы ресурсы.
RESOURCES += qml.qrc

# Дополнительный путь импорта, используемый для разрешения QML-модулей в модели кода Qt Creator
QML_IMPORT_PATH =

# Дополнительный путь импорта, используемый для разрешения модулей QML только для Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Правила развертывания по умолчанию.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
	src/copydannie.h \
	src/cppqml.h \
	src/datadannie.h \
	src/dataelement.h \
	src/dataspisok.h \
	src/datatitul.h \
	src/dcclass.h \
	src/dcdb.h \
	src/dcdbdata.h \
	src/dcfiledialog.h

DISTFILES += \
	AUTHORS.md \
	CODE_OF_CONDUCT.md \
	CONTRIBUTING.md \
	LICENSE.GPLv3.md \
	README.md \
	README.ru.md \
	TODO.txt \
	images/ru.WorkingDiagrams.png \
	images/Qt_logo_2016.png \
	screenshots/KnopkiQML.png \
    screenshots/ru.WorkingDiagrams.png \
	Qt5_AltLinux.txt \
	Qt6_AltLinux.txt \
	vim.txt \
	CMakeLists.txt
