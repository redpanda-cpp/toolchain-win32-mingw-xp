#!/bin/bash

set -euxo pipefail

xege_dir="$_BUILDDIR/$_XEGE_DIR"
if [[ ! -d "$xege_dir" ]]; then
  mkdir -p "$xege_dir"
  pushd "$xege_dir"
  git --git-dir="$_ASSETSDIR/$_XEGE_REPO" --work-tree="." checkout -f "$XEGE_COMMIT"
  git --git-dir="$_ASSETSDIR/$_XEGE_REPO" --work-tree="." submodule update --init --recursive
  popd
fi
cd "$xege_dir"
cp -r include/{ege,ege.h,graphics.h} "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/include"

build_dir="build"
cmake -S . -B "$build_dir" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE="MinSizeRel" -DCMAKE_CXX_COMPILER="g++"
cmake --build "$build_dir" --parallel

cp "$build_dir/libgraphics.a" "$_BUILDDIR/$_MINGW_DIR/$_TRIPLET/lib/libgraphics.a"
