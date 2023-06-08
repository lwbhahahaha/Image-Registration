# Install script for directory: C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib

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
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Debug/_reg_maths.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Release/_reg_maths.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/MinSizeRel/_reg_maths.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/RelWithDebInfo/_reg_maths.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_maths.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_maths_eigen.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Debug/_reg_tools.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Release/_reg_tools.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/MinSizeRel/_reg_tools.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/RelWithDebInfo/_reg_tools.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_tools.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Debug/_reg_globalTrans.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Release/_reg_globalTrans.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/MinSizeRel/_reg_globalTrans.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/RelWithDebInfo/_reg_globalTrans.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_globalTrans.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Debug/_reg_localTrans.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Release/_reg_localTrans.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/MinSizeRel/_reg_localTrans.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/RelWithDebInfo/_reg_localTrans.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_localTrans.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_splineBasis.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_localTrans_regul.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_localTrans_jac.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Debug/_reg_measure.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Release/_reg_measure.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/MinSizeRel/_reg_measure.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/RelWithDebInfo/_reg_measure.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_measure.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_nmi.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_ssd.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_kld.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_lncc.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_dti.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_mind.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Debug/_reg_resampling.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Release/_reg_resampling.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/MinSizeRel/_reg_resampling.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/RelWithDebInfo/_reg_resampling.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_resampling.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Debug/_reg_blockMatching.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Release/_reg_blockMatching.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/MinSizeRel/_reg_blockMatching.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/RelWithDebInfo/_reg_blockMatching.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_blockMatching.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Debug/_reg_femTrans.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Release/_reg_femTrans.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/MinSizeRel/_reg_femTrans.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/RelWithDebInfo/_reg_femTrans.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_femTrans.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Debug/_reg_aladin.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Release/_reg_aladin.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/MinSizeRel/_reg_aladin.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/RelWithDebInfo/_reg_aladin.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_macros.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/_reg_aladin.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/_reg_aladin_sym.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/_reg_aladin.cpp"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/_reg_aladin_sym.cpp"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/AladinContent.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/Platform.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/Kernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/AffineDeformationFieldKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/BlockMatchingKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/ConvolutionKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/OptimiseKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/ResampleImageKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/CPUAffineDeformationFieldKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/CPUBlockMatchingKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/CPUConvolutionKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/CPUOptimiseKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/CPUResampleImageKernel.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/KernelFactory.h"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/CPUKernelFactory.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Debug/_reg_f3d.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/Release/_reg_f3d.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/MinSizeRel/_reg_f3d.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/RelWithDebInfo/_reg_f3d.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/_reg_base.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/_reg_f3d.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/_reg_f3d2.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/_reg_f3d_sym.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_optimiser.cpp"
    "C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/reg-lib/cpu/_reg_optimiser.h"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("C:/Users/wenbl13/Desktop/logan_reg/libs/niftyReg/niftyreg-git/niftyreg-build/reg-lib/cuda/cmake_install.cmake")

endif()

