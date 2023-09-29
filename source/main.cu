#include <cuda.h>
#include <stdio.h>
#include <vector>
#include <cstdio>
#include <iostream>
#include <fstream>
#include <sstream>

void readDumpFile(const std::string& filename, std::vector<int>& vector1, std::vector<int>& vector2) {

  std::ifstream file(filename);
  if (!file.is_open()) {
    std::cerr << "Failed to open the file.\n";
    return;
  }

  std::string line;

  // Read the first line of integers
  if (std::getline(file, line)) {
    std::istringstream stream(line);
    int num;
    while (stream >> num) {
      vector1.push_back(num);
    }
  }

  // Read the second line of integers
  if (std::getline(file, line)) {
    std::istringstream stream(line);
    int num;
    while (stream >> num) {
      vector2.push_back(num);
    }
  }

  file.close();
}

__global__ void csr_graph(const int* adjp_gpu, const int* adjncy_gpu, int N, int M) {

  /*
  // check csr
  printf("adjp_gpu = [");
  for(size_t i=0; i<N; i++) {
    printf("%d ", adjp_gpu[i]);
  }
  printf("]\n");
  printf("adjncy_gpu = [");
  for(size_t i=0; i<M; i++) {
    printf("%d ", adjncy_gpu[i]);
  }
  printf("]\n");
  */

}

int main() {

  /*
   * read graph information
   */

  std::vector<int> adjp, adjncy;
  std::string csr_path = "../../csr_data/csr.dmp"; // Change this to your file path
  readDumpFile(csr_path, adjp, adjncy); 

  /*
  // check csr
  std::cerr << "adjp = [";
  for(auto id : adjp) {
    std::cerr << id << " ";
  }
  std::cerr << "]\n";
  std::cerr << "adjncy = [";
  for(auto id : adjncy) {
    std::cerr << id << " ";
  }
  std::cerr << "]\n";
  */

  /*
   * transfer csr data to gpu
   */

  int* adjp_gpu; 
  int* adjncy_gpu; 
  cudaMalloc(&adjp_gpu, sizeof(int)*adjp.size());
  cudaMalloc(&adjncy_gpu, sizeof(int)*adjncy.size());
  cudaMemcpy(adjp_gpu, adjp.data(), sizeof(int)*adjp.size(), cudaMemcpyDefault);
  cudaMemcpy(adjncy_gpu, adjncy.data(), sizeof(int)*adjncy.size(), cudaMemcpyDefault);

  unsigned num_block = 1; 	
  unsigned num_threads = 1;
 
  csr_graph<<<num_block, num_threads>>>(adjp_gpu, adjncy_gpu, adjp.size(), adjncy.size()); 

  cudaDeviceSynchronize();

  return 0;
}

