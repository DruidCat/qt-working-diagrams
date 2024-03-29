cmake_minimum_required(VERSION 3.16)

project(qt-working-diagrams VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
# Команда включает файлы *.qrc.
set(CMAKE_AUTORCC ON)
# Команда добавляет библиотеки, с которыми будет работать проект.
find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Sql Core)

qt_standard_project_setup()

qt_add_executable(appqt-working-diagrams
    main.cpp
)

qt_add_qml_module(appqt-working-diagrams
    URI qt-working-diagrams
    VERSION 1.0
	QML_FILES DCKnopkaInfo.qml
	# QML_FILES DCKnopkaKruglaya.qml
	QML_FILES DCKnopkaMenu.qml
	QML_FILES DCKnopkaNastroiki.qml
	QML_FILES DCKnopkaNazad.qml
	QML_FILES DCKnopkaOk.qml
	QML_FILES DCKnopkaOriginal.qml
	# QML_FILES DCKnopkaPoisk.qml
	QML_FILES DCKnopkaSozdat.qml
	# QML_FILES DCKnopkaZakrit.qml
	QML_FILES DCLogoTMK.qml
	QML_FILES DCMenu.qml
	QML_FILES DCTextEdit.qml
	QML_FILES DCTextInput.qml
	QML_FILES PathViewSpisok.qml
	QML_FILES StrAvtor.qml
	QML_FILES StrDannie.qml
	QML_FILES StrDebug.qml
	QML_FILES StrElement.qml
	QML_FILES StrMenu.qml
	QML_FILES StrOpisanie.qml
	QML_FILES StrSpisok.qml
	QML_FILES StrSvet.qml
	QML_FILES Stranica.qml
	QML_FILES ZonaElement.qml
	QML_FILES ZonaSpisok.qml
	QML_FILES Main.qml
	RESOURCES qml.qrc
	SOURCES main.cpp
	SOURCES dcdb.h dcdb.cpp
	SOURCES dcclass.h dcclass.cpp
	SOURCES cppqml.h cppqml.cpp
	SOURCES dataspisok.h dataspisok.cpp
	SOURCES dataelement.h dataelement.cpp
	SOURCES datatitul.h datatitul.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appqt-working-diagrams PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appqt-working-diagrams
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)
# Добавляем библиотеки в наш проект.
target_link_libraries(appqt-working-diagrams
	PRIVATE Qt6::Quick
	PRIVATE Qt6::Sql
	PRIVATE Qt6::Core
)

include(GNUInstallDirs)
install(TARGETS appqt-working-diagrams
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
