#!/bin/bash

set -euxo pipefail

mariadbc_dir="$_BUILDDIR/$_MARIADBC_DIR"
[[ -d "$mariadbc_dir" ]] || tar -C "$_BUILDDIR" -xf "$_ASSETSDIR/$_MARIADBC_ARCHIVE"
cd "$mariadbc_dir"

sed -i 's/^  END()$/  ENDIF()/' cmake/ConnectorName.cmake

build_dir="build"
pkg_dir="pkg"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_C_COMPILER="gcc" -DWITH_UNIT_TESTS=OFF
cmake --build "$build_dir" --parallel

cmake --install "$build_dir" --prefix "$pkg_dir"
cp -r "$pkg_dir/include/mariadb" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"
cp -r "$pkg_dir/include/mariadb" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include/mysql"
cp "$pkg_dir/lib/mariadb/libmariadbclient.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib"
cp "$pkg_dir/lib/mariadb/libmariadbclient.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib/libmysqlclient.a"
