# Install script for directory: C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda

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

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/Debug/_reg_common_cuda.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/Release/_reg_common_cuda.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/MinSizeRel/_reg_common_cuda.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/RelWithDebInfo/_reg_common_cuda.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/cuda" TYPE FILE FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/_reg_common_cuda.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/Debug/_reg_cuda_kernels.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/Release/_reg_cuda_kernels.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/MinSizeRel/_reg_cuda_kernels.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/RelWithDebInfo/_reg_cuda_kernels.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/cuda" TYPE FILE FILES
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/blockMatchingKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/CUDAContextSingletton.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/CUDAAladinContent.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/cuda" TYPE FILE FILES
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/CUDAKernelFactory.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/affineDeformationKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/resampleKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/optimizeKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/CUDAAffineDeformationFieldKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/CUDABlockMatchingKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/CUDAConvolutionKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/CUDAOptimiseKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/CUDAResampleImageKernel.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/Debug/_reg_cudainfo.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/Release/_reg_cudainfo.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/MinSizeRel/_reg_cudainfo.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/RelWithDebInfo/_reg_cudainfo.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/cuda" TYPE FILE FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cuda/_reg_cudainfo.h")
endif()

