cmake_minimum_required(VERSION 3.14)

set (EXECUTABLE_NAME "ru.WorkingDiagrams") # Задаём имя проекта.

project(${EXECUTABLE_NAME} VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(RES_FILES "${PROJECT_SOURCE_DIR}/icons/ico/ru.WorkingDiagrams.rc")

# Закоментированны строки, которые были в начальном варианте.
# find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Sql Pdf)
# find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Sql Pdf)

# Удалить Qt5 или Qt6 в зависимости от версии Qt, под которую будет собираться проект.
find_package(QT NAMES Qt6 REQUIRED COMPONENTS Core Quick Sql Pdf)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Sql)

if(Qt5_FOUND) # Если Qt5, то ...
	find_package(Qt5 REQUIRED COMPONENTS Pdf) # Добавляем библиотеку Pdf, в Qt6 её не нужно добавлять.
endif()
# Создаём переменную PROJECT_SOURCES и добавляем в неё файлы *.cpp и *.h
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
# Создаём переменную DATA_FILE, и добавляем в неё файлы, которые не участвуют в создании кода.
# set(DATA_FILE ${PROJECT_SOURCE_DIR}/TODO.txt)
set(DATA_FILE
        .gitignore
        TODO.txt
        vim.txt
)
# add_executable() собирает переменные объявленные выше с файлами С++, стронними файлами под именем проекта.
if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
        # Добавляем все файлы ${PROJECT_SOURCES}, ${DATA_FILE} в проект ${EXECUTABLE_NAME}
        qt_add_executable(	${EXECUTABLE_NAME}
        					MANUAL_FINALIZATION
        					${PROJECT_SOURCES}
        					${DATA_FILE}
                            ${RES_FILES}
    	)
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET ru.WorkingDiagrams APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
            add_library(${EXECUTABLE_NAME} SHARED
            			${PROJECT_SOURCES}
            			${DATA_FILE}
        	)
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
		add_executable(	${EXECUTABLE_NAME}
						${PROJECT_SOURCES}
						${DATA_FILE}
        )
    endif()
endif()

# Это новая политика вышедшая с Qt6.6 для Android: https://doc.qt.io/qt-6/qt-cmake-policy-qtp0002.html
qt_policy(SET QTP0002 NEW)

target_link_libraries(${EXECUTABLE_NAME}
        PRIVATE 	Qt${QT_VERSION_MAJOR}::Core
  					Qt${QT_VERSION_MAJOR}::Quick
					Qt${QT_VERSION_MAJOR}::Sql)
					# Qt${QT_VERSION_MAJOR}::Pdf)

if(Qt5_FOUND) # Если Qt5, то добавляем библиотеку Pdf, в Qt6 её не нужно добавлять.
	target_link_libraries(${EXECUTABLE_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Pdf)
endif()

set_target_properties(${EXECUTABLE_NAME} PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

install(TARGETS ${EXECUTABLE_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

set_property(	TARGET ${EXECUTABLE_NAME}
                PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")

if(QT_VERSION_MAJOR EQUAL 6)
	qt_import_qml_plugins(${EXECUTABLE_NAME})
	qt_finalize_executable(${EXECUTABLE_NAME})
endif()
