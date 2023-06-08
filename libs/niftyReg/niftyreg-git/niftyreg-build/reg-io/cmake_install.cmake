# Install script for directory: C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-io

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:\Users\wenbl13\Desktop\logan_reg\libs\niftyReg\nift_reg_app")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Development" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-io/Debug/_reg_ReadWriteImage.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-io/Release/_reg_ReadWriteImage.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-io/MinSizeRel/_reg_ReadWriteImage.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-io/RelWithDebInfo/_reg_ReadWriteImage.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Development" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-io/_reg_ReadWriteImage.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-io/_reg_ReadWriteMatrix.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-io/_reg_stringFormat.h"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-io/zlib/cmake_install.cmake")
  include("C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-io/nifti/cmake_install.cmake")
  include("C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-io/png/cmake_install.cmake")

endif()

