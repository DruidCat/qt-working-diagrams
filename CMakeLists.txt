cmake_minimum_required(VERSION 3.14)

project(ru.WorkingDiagrams VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Sql)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Sql)

set(PROJECT_SOURCES
        src/copydannie.h
        src/copydannie.cpp
        src/cppqml.h
		src/cppqml.cpp
		src/datadannie.h
		src/datadannie.cpp
		src/dataelement.h
		src/dataelement.cpp
		src/dataspisok.h
		src/dataspisok.cpp
		src/datatitul.h
		src/datatitul.cpp
		src/dcclass.h
		src/dcclass.cpp
		src/dcdb.h
		src/dcdb.cpp
		src/dcdbdata.h
		src/dcdbdata.cpp
		src/dcfiledialog.h
		src/dcfiledialog.cpp
		src/main.cpp
		qml.qrc
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
	qt_add_executable(ru.WorkingDiagrams
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET ru.WorkingDiagrams APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
		add_library(ru.WorkingDiagrams SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
		add_executable(ru.WorkingDiagrams
          ${PROJECT_SOURCES}
        )
    endif()
endif()

target_link_libraries(ru.WorkingDiagrams
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::Sql)

set_target_properties(ru.WorkingDiagrams PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

install(TARGETS ru.WorkingDiagrams
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
	qt_import_qml_plugins(ru.WorkingDiagrams)
	qt_finalize_executable(ru.WorkingDiagrams)
endif()
