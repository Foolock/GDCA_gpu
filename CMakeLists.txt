cmake_minimum_required (VERSION 3.12)

project(MyCudaProject LANGUAGES CXX CUDA)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CUDA_ARCHITECTURES 75)

# Find CUDA package
find_package(CUDA REQUIRED)

# Specify source files
set(SRC_FILES
    source/main.cu
)

set(CMAKE_CUDA_FLAGS_DEBUG " -Xcompiler -O3 -Xcompiler -Wall")

# Specify the output directory for the executable
set(EXECUTABLE_OUTPUT_PATH "${PROJECT_SOURCE_DIR}/bin")
# Add an executable target
cuda_add_executable(partition ${SRC_FILES})
