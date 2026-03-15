cmake_minimum_required(VERSION 3.16)
project(ModManagerX LANGUAGES CXX)

if(MSVC)
    add_compile_options(/Zc:__cplusplus /permissive-)
endif()

include(qt.cmake)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR}
    COMPONENTS
        Quick
        Svg
        QuickControls2
        Widgets
        Network
)
qt_standard_project_setup()


set(APP_RESOURCES resources.rc)

set(PROJECT_SOURCES
    main.cpp
    backend.cpp
    utilities.cpp
    backend.h
    modpack.h
    modpack.cpp
    language.cpp
    language.h
    ${APP_RESOURCES}
)

if(QT_VERSION VERSION_LESS 5.15)
    qt5_add_resources(PROJECT_SOURCES qml.qrc)
elseif(QT_VERSION VERSION_LESS 6.2)
    qt_add_resources(PROJECT_SOURCES qml.qrc)
endif()

qt_add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})

if(QT_VERSION VERSION_GREATER_EQUAL 6.2)
    qt_add_qml_module(${PROJECT_NAME}
        URI modmanagerx
        VERSION 1.0
        RESOURCE_PREFIX "/qt/qml/"
        QML_FILES
            Main.qml
            MainScreen.ui.qml
            MainMenu.ui.qml
            ImportDialog.ui.qml
        RESOURCES
            lang/en_US.json
            images/RadWare.svg

            "images/Mod Manager X.ico"
            "images/GrayMMX.png"
    )
endif()

set_target_properties(${PROJECT_NAME}
    PROPERTIES
        WIN32_EXECUTABLE TRUE
)

target_link_libraries(${PROJECT_NAME}
    PUBLIC
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Svg
        Qt6::Widgets
        Qt6::Core
        Qt6::Network
)

target_precompile_headers(${PROJECT_NAME} PUBLIC stdafx.h)

if(WIN32)
    set(DEPLOY_SUBFOLDER "${CMAKE_BINARY_DIR}/Final")


    get_target_property(_qmake_executable Qt6::qmake IMPORTED_LOCATION)
    get_filename_component(_qt_bin_dir "${_qmake_executable}" DIRECTORY)
    find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS "${_qt_bin_dir}")

    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory "${DEPLOY_SUBFOLDER}"
        COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:${PROJECT_NAME}>" "${DEPLOY_SUBFOLDER}/"
        COMMAND "${WINDEPLOYQT_EXECUTABLE}"
                --release
                --no-translations
                --compiler-runtime
                --qmldir "${CMAKE_CURRENT_SOURCE_DIR}"
                "${DEPLOY_SUBFOLDER}/$<TARGET_FILE_NAME:${PROJECT_NAME}>"
    )
endif()

#if(Qt6_FOUND)
#    qt_import_qml_plugins(${PROJECT_NAME})
#endif()
