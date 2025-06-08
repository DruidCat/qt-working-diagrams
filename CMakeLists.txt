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

# Установить Qt5 или Qt6 в зависимости от версии Qt, под которую будет собираться проект.
find_package(QT NAMES Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Sql)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick QuickControls2 Sql)

# Создаём переменную PROJECT_SOURCES и добавляем в неё файлы *.cpp и *.h
set(PROJECT_SOURCES
        src/copydannie.h
        src/copydannie.cpp
		src/copykatalog.h
		src/copykatalog.cpp
		src/copyplan.h
		src/copyplan.cpp
        src/cppqml.h
        src/cppqml.cpp
        src/datadannie.h
        src/datadannie.cpp
        src/dataelement.h
        src/dataelement.cpp
        src/datakatalog.h
        src/datakatalog.cpp
		src/dataplan.h
		src/dataplan.cpp
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

# Три строчки - это лоадер qmlcompat для Qt5 и Qt6, чтоб не прописывать в QML версии импортируемх библиотек.
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
						${RES_FILES}
        )
    endif()
endif()

if(ANDROID)
	# Это новая политика вышедшая с Qt6.6 для Android: https://doc.qt.io/qt-6/qt-cmake-policy-qtp0002.html
	qt_policy(SET QTP0002 NEW)
endif()

# Указываем путь к QML, чтоб QtCreator увидел пути к qmldir находящийся в /qml или подпапках.
# set(QML_IMPORT_PATH "${CMAKE_SOURCE_DIR}/qml")
# чтобы QML Language Server понимал структуру проекта, особенно модули с qmldir. В build создаётся .qmlls.ini
# set(QT_QML_GENERATE_QMLLS_INI ON) #Работает только с qt_add_qml_module()

target_link_libraries(${EXECUTABLE_NAME}
        PRIVATE 	Qt${QT_VERSION_MAJOR}::Core
  					Qt${QT_VERSION_MAJOR}::Quick
					Qt${QT_VERSION_MAJOR}::QuickControls2
					Qt${QT_VERSION_MAJOR}::Sql)

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

# Копируем qml/ директорию в build. Чтоб не было ошибок при import модуль 1.0, qmldir без ошибок.
add_custom_target(copy_qml ALL
	COMMAND ${CMAKE_COMMAND} -E copy_directory
	        ${CMAKE_SOURCE_DIR}/qml
			${CMAKE_BINARY_DIR}/qml
)
add_dependencies(${EXECUTABLE_NAME} copy_qml)
# Qt Creator автоматически подхватывает эту переменную при генерации проекта, qmldir без ошибок.
set(QML_IMPORT_PATH "${CMAKE_BINARY_DIR}/qml" CACHE INTERNAL "")

if(QT_VERSION_MAJOR EQUAL 6)
	qt_import_qml_plugins(${EXECUTABLE_NAME})
	qt_finalize_executable(${EXECUTABLE_NAME})
endif()
