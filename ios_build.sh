#!/bin/bash

# https://github.com/leetal/ios-cmake

minimum_target=12.0
git submodule update --init
root_dir=$(dirname "$(realpath "$0")")

ios_build_dir="${root_dir}/ios_build"
rm -rf ${ios_build_dir}
mkdir -p ${ios_build_dir}

output_dir="${root_dir}/ios_output"
rm -rf ${output_dir}
output_lib_dir="${output_dir}/lib"
mkdir -p "${output_lib_dir}"

build_ios() {
    if [ "$1" == "os" ]; then
        platform="OS64"
    elif [ "$1" == "sim" ]; then
        platform="SIMULATOR64"
    else
        echo "未知的参数 $1"
        exit 1
    fi

    local build_dir="${ios_build_dir}/$1_build"
    local build_output_dir="$2"

    mkdir -p "${build_dir}"
    cd "${build_dir}"

    # # 执行 cmake 命令
    cmake ${root_dir} -G Xcode -DCMAKE_INSTALL_PREFIX="${build_dir}" -DCMAKE_TOOLCHAIN_FILE="${root_dir}/cmake/ios.toolchain.cmake" -DPLATFORM="${platform}" -DDEPLOYMENT_TARGET="${minimum_target}" -DENABLE_SRT=OFF -DENABLE_WEBRTC=OFF -DENABLE_PLAYER=OFF -DENABLE_SERVER=OFF

    # # 编译项目
    cmake --build . --config Release

    if [ "$1" == "os" ]; then
        cmake --install . --config Release
        mv "${build_dir}/include" "${output_dir}"
    fi

    # # 移动文件
    mv "${root_dir}/release/ios/Debug/Release" "${build_output_dir}"
}

sim_dir="${ios_build_dir}/sim_out"
build_ios "sim" "${sim_dir}"

os_dir="${ios_build_dir}/os_out"
build_ios "os" "${os_dir}"


# 遍历每个文件
for file in $os_dir/*.a; do
    # 获取文件名
    filename=$(basename "$file")
    
    # 检查文件是否存在于 sim 目录中
    if [ -f "${sim_dir}/${filename}" ]; then
        echo "合并 ${filename} ..."
        
        # 使用 lipo 合并文件
        lipo -create "${os_dir}/${filename}" "${sim_dir}/${filename}" -output "${output_lib_dir}/${filename}"
        
        echo "合并完成: ${output_lib_dir}/${filename}"
    else
        echo "文件 ${filename} 在 ${sim_dir} 中不存在，将跳过。"
    fi
done

echo "所有文件合并完成: ${output_lib_dir}"

exit 0