cuda_add_executable(sampleFp16 simpleCUDA2GL.cu main.cpp)
#target_link_libraries(sampleFp16 freeglut glew)
TARGET_LINK_LIBRARIES(sampleFp16 ${CMAKE_SOURCE_DIR}/common/lib/Win32/freeglut.lib ${CMAKE_SOURCE_DIR}/common/lib/Win32/glew32.lib)
string(REGEX REPLACE "/" "\\\\" TARGET_BIN1 ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR})
string(REGEX REPLACE "/" "\\\\" TARGET_BIN2 ${CMAKE_CURRENT_BINARY_DIR})
string(REGEX REPLACE "/" "\\\\" SOURCE_DLL1 ${CMAKE_SOURCE_DIR}/common/lib/Win32/glew32.dll)
string(REGEX REPLACE "/" "\\\\" SOURCE_DLL2 ${CMAKE_SOURCE_DIR}/common/lib/Win32/freeglut.dll)
add_custom_command(TARGET sampleFp16 COMMAND copy ${SOURCE_DLL1} ${TARGET_BIN1})
add_custom_command(TARGET sampleFp16 COMMAND copy ${SOURCE_DLL2} ${TARGET_BIN1})
add_custom_command(TARGET sampleFp16 COMMAND copy ${SOURCE_DLL1} ${TARGET_BIN2})
add_custom_command(TARGET sampleFp16 COMMAND copy ${SOURCE_DLL2} ${TARGET_BIN2})

 
