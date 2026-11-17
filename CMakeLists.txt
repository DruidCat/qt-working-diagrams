cmake_minimum_required(VERSION 3.14)

set (EXECUTABLE_NAME "ru.Mentor") # Задаём имя проекта.

project(${EXECUTABLE_NAME} VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(RES_FILES "${PROJECT_SOURCE_DIR}/icons/ico/ru.Mentor.rc")

# Установить Qt5 или Qt6 в зависимости от версии Qt, под которую будет собираться проект.
find_package(QT NAMES Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Sql Pdf PdfQuick)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick QuickControls2 Sql Pdf PdfQuick)

# Qt 6.7's FindWrapOpenGL.cmake links against AGL: it either finds a stale
# AGL.framework stub path in the SDK (current ld rejects it: "framework 'AGL'
# not found") or hardcodes -framework AGL. AGL was removed from macOS 10.14
# and is used by neither the app nor the Qt frameworks - strip it from the
# WrapOpenGL::WrapOpenGL interface target right after Qt is found.
if(APPLE AND TARGET WrapOpenGL::WrapOpenGL)
    get_target_property(_ogl_libs WrapOpenGL::WrapOpenGL INTERFACE_LINK_LIBRARIES)
    list(REMOVE_ITEM _ogl_libs "-framework AGL")
    list(FILTER _ogl_libs EXCLUDE REGEX "AGL[.]framework")
    set_property(TARGET WrapOpenGL::WrapOpenGL PROPERTY
        INTERFACE_LINK_LIBRARIES "${_ogl_libs}")
endif()

# ==== MENTOR_DB_MOBILE: база druidcat.db и документы в установочном пакете ====
# OFF — классический режим: workingdata лежит на файловой системе рядом с приложением.
# ON  — данные упаковываются в пакет: Android — в assets APK (шаг синхронизации перед
# линковкой, tools/sync_dbmobile_assets.sh), Аврора — в /usr/share/ru.druidcat.mentor/
# workingdata состава RPM (adq_pack.py при MENTOR_DB_MOBILE=1). При первом запуске
# DCAssets распаковывает каталог в данные приложения; режим администратора в QML
# принудительно выключен (isAdmin=false): править базу в таком пакете нельзя.
option(MENTOR_DB_MOBILE "База данных и документы внутри установочного пакета" OFF)

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
        src/dcassets.h
        src/dcassets.cpp
        src/dcdb.h
        src/dcdb.cpp
        src/dcdbdata.h
        src/dcdbdata.cpp
        src/dcfiledialog.h
        src/dcfiledialog.cpp
        src/dclogger.h
        src/dclogger.cpp
        src/dcpdfpoisk.h
        src/dcpdfpoisk.cpp
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
#    set_property(TARGET ru.Mentor APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
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
                    Qt${QT_VERSION_MAJOR}::Sql
                    Qt${QT_VERSION_MAJOR}::Pdf # Для поиска в С++
                    Qt${QT_VERSION_MAJOR}::PdfQuick # Для поиска в С++
                    )

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
	# Shared-сборка десктопа: QML-плагины грузятся рантаймом из установки Qt, сканирование
	# qmlimportscanner и линковка плагинов не нужны. Без этого флага finalize
	# вызывает qt_import_qml_plugins и сыплет предупреждениями про Qt6::<plugin>.
	# Под Android флаг НЕ ставим: там QML-плагины — статические библиотеки, их обязательно
	# линковать в libproject_.so, а androiddeployqt берёт список QML-модулей из результата
	# этого сканирования. Без сканирования APK не получит плагины и приложение упадёт
	# на старте с «module ... not found».
	if(NOT ANDROID)
		set_property(TARGET ${EXECUTABLE_NAME} PROPERTY QT_QML_MODULE_NO_IMPORT_SCAN TRUE)
	endif()
	qt_finalize_executable(${EXECUTABLE_NAME})
endif()

# Автоверсия приложения из git (формат: vX.Y.Z[-N-g<sha>[-dirty]])
find_package(Git QUIET)
set(APP_VERSION "v0.0.0")
set(APP_SEMVER "0.0.0")
set(GIT_SHA "")
set(APP_VERSION_SEED "" CACHE STRING "x.y.z версия-сид, если git недоступен")

if(GIT_FOUND AND EXISTS "${CMAKE_SOURCE_DIR}/.git")
	# Короткий SHA
	execute_process(
		COMMAND ${GIT_EXECUTABLE} rev-parse --short=7 HEAD
		WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
		OUTPUT_VARIABLE GIT_SHA
		OUTPUT_STRIP_TRAILING_WHITESPACE
		ERROR_QUIET
	)
	# Пытаемся получить версию по тегам вида v1.2.3
	execute_process(
		COMMAND ${GIT_EXECUTABLE} describe --tags --match "v[0-9]*" --abbrev=7 --dirty
		WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
		RESULT_VARIABLE DESCRIBE_RESULT
		OUTPUT_VARIABLE GIT_DESCRIBE
		OUTPUT_STRIP_TRAILING_WHITESPACE
		ERROR_QUIET
	)
	# Формируем APP_VERSION без префикса "v"
	if(GIT_DESCRIBE MATCHES "^v[0-9]+\\.[0-9]+\\.[0-9]+")
		# Находимся на теге или рядом с ним: vX.Y.Z[-N-g<sha>[-dirty]]
		set(APP_VERSION "${GIT_DESCRIBE}")
		string(REGEX REPLACE "^v" "" APP_VERSION "${APP_VERSION}")  # убираем ведущую "v"
		# Semver — старший сегмент тега (как в ru.Mentor.pro): v0.33.3[-...]- > 0.33.3.
		string(REGEX REPLACE "^v([0-9]+\\.[0-9]+\\.[0-9]+).*$" "\\1" APP_SEMVER "${GIT_DESCRIBE}")
	else()
		# Сид версии для песочниц сборки без git (sb2/пакет chroot на Авроре):
		# qt-cmake -DAPP_VERSION_SEED=1.1.1 (значение берут из git describe
		# вне песочницы). Без сида включается фоллбек 0.0.0-<BUILD_NUM>.
		if(APP_VERSION_SEED MATCHES "^[0-9]+\\.[0-9]+\\.[0-9]+$")
			set(APP_VERSION "${APP_VERSION_SEED}")
			set(APP_SEMVER "${APP_VERSION_SEED}")
		else()
			# Нет подходящих тегов — фоллбек
			# Было: v0.0.0-<count>-g<sha> → станет: 0.0.0-<count>-g<sha>
			if(NOT BUILD_NUM)
				set(BUILD_NUM 0)
			endif()
			if(GIT_SHA)
				set(APP_VERSION "0.0.0-${BUILD_NUM}-g${GIT_SHA}")
			else()
				set(APP_VERSION "0.0.0-${BUILD_NUM}")
			endif()
		endif()
	endif()
else()
	# Песочница сборки вообще без git (sb2 на Авроре): сработал бы только сид,
	# иначе в бинарник ушёл бы стартовый фоллбек v0.0.0.
	if(APP_VERSION_SEED MATCHES "^[0-9]+\\.[0-9]+\\.[0-9]+$")
		set(APP_VERSION "${APP_VERSION_SEED}")
		set(APP_SEMVER "${APP_VERSION_SEED}")
	endif()
endif()
# Прокидываем в код. ДОЛЖНО стоять после add_executable(...)
target_compile_definitions(${EXECUTABLE_NAME} PRIVATE
  APP_VERSION="${APP_VERSION}"      # например: v1.2.3-12-g1a2b3c4
  APP_SEMVER="${APP_SEMVER}"        # например: 1.2.3
  GIT_SHA="${GIT_SHA}"              # например: 1a2b3c4
)

# Android: versionName/versionCode в манифесте из git-тега (публичные релизы).
if(ANDROID)
    string(REGEX MATCH "^[0-9]+\\.[0-9]+\\.[0-9]+" MENTOR_SEMVER "${APP_SEMVER}")
    string(REPLACE "." "" MENTOR_VERCODE "${MENTOR_SEMVER}")
    set_target_properties(${EXECUTABLE_NAME} PROPERTIES
        QT_ANDROID_VERSION_NAME "${MENTOR_SEMVER}"
        QT_ANDROID_VERSION_CODE "${MENTOR_VERCODE}")
endif()

# ==== MENTOR_DB_MOBILE: определения и упаковка данных в пакет ====
if(MENTOR_DB_MOBILE)
    target_compile_definitions(${EXECUTABLE_NAME} PRIVATE MENTOR_DB_MOBILE)
    if(NOT CMAKE_CROSSCOMPILING)
        # Десктопная сборка: бандл берётся прямо из workingdata проекта — так режим
        # можно проверять без сборки APK/RPM. Кросс-сборки (Android/Аврора) путь не
        # получают: там бандл ищется в assets APK / каталоге RPM (см. DCAssets).
        target_compile_definitions(${EXECUTABLE_NAME} PRIVATE
            MENTOR_BUNDLE_DIR="${CMAKE_CURRENT_SOURCE_DIR}/workingdata")
    endif()
    if(ANDROID)
        target_link_libraries(${EXECUTABLE_NAME} PRIVATE android)# AAssetManager для распаковки assets
        # Перед линковкой синхронизируем workingdata в android/assets (инкрементально,
        # rsync копирует только изменения). MENTOR_WORKINGDATA — источник данных вне
        # репозитория (полный комплект документов), по умолчанию workingdata проекта.
        add_custom_command(TARGET ${EXECUTABLE_NAME} PRE_LINK
            COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/tools/sync_dbmobile_assets.sh
                    ${CMAKE_CURRENT_SOURCE_DIR}
            COMMENT "MENTOR_DB_MOBILE: обновление workingdata в assets APK"
            VERBATIM)
    endif()
endif()
