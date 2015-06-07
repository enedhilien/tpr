all:
	gcc -lstdc++ -o FD_2D_cpu FD_2D_cpu.cpp
	nvcc -o FD_2D_global FD_2D_global.cu
	nvcc -o FD_2D_shared FD_2D_shared.cu
	nvcc -o FD_2D_texture_pad FD_2D_texture_pad.cu
