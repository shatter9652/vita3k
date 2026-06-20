set(VCPKG_TARGET_TRIPLET arm64-ios)
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/../external/vcpkg/scripts/toolchains/ios.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/../external/vcpkg/scripts/buildsystems/vcpkg.cmake")
