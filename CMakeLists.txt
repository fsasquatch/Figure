cmake_minimum_required(VERSION 3.10)
project(figure)

set(TARGET_NAME figure)
set(TARGET_EXT .hdll)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(SOURCES 
    src/native/frame.c
    src/native/extension.c
)

add_subdirectory(libs/SDL EXCLUDE_FROM_ALL)
add_library(${TARGET_NAME}${TARGET_EXT} SHARED ${SOURCES})
target_include_directories(${TARGET_NAME}${TARGET_EXT} PRIVATE libs)
target_link_libraries(${TARGET_NAME}${TARGET_EXT} SDL3::SDL3 m)

set_target_properties(${TARGET_NAME}${TARGET_EXT}
    PROPERTIES
    PREFIX ""
    OUTPUT_NAME ${TARGET_NAME}
    SUFFIX ${TARGET_EXT}
)

IF(WIN32)
    target_include_directories(${TARGET_NAME}${TARGET_EXT} PUBLIC $ENV{HASHLINKPATH}/include)
    target_link_libraries(${TARGET_NAME}${TARGET_EXT} $ENV{HASHLINKPATH}/libhl.lib)
ELSEIF(APPLE)
    find_library(APPLICATION_SERVICES_FRAMEWORK ApplicationServices REQUIRED)
    set(HLPATH /usr/local/opt/hashlink/libexec)
    target_include_directories(${TARGET_NAME}${TARGET_EXT} PUBLIC ${HLPATH}/include)
    target_link_libraries(${TARGET_NAME}${TARGET_EXT} ${HLPATH}/lib/libhl.dylib ${APPLICATION_SERVICES_FRAMEWORK})
ELSE()
    target_link_libraries(${TARGET_NAME}${TARGET_EXT} hl)
ENDIF()
