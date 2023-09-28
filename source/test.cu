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
__global__ void kernel1() {

  int num = threadIdx.x + 1; // a number between 1 to 8  
  int result = 1; // factorial result of the number

  for(int i=1; i<=num; i++) {
    result = result * i;
  }
  std::printf("%d!=%d\n", num, result);
   
}

int main() {

  /*
   * read graph information
   */

  std::vector<int> _adjp, _adjncy;
  std::string csr_path = "../../csr_data/csr.dmp"; // Change this to your file path

  readDumpFile(csr_path, _adjp, _adjncy); 

  // check csr
  std::cerr << "_adjp = [";
  for(auto id : _adjp) {
    std::cerr << id << " ";
  }
  std::cerr << "]\n";
  std::cerr << "_adjncy = [";
  for(auto id : _adjncy) {
    std::cerr << id << " ";
  }
  std::cerr << "]\n";

  unsigned num_block = 1; 	
  unsigned num_threads = 8;

  kernel1<<<num_block, num_threads>>>();

  cudaDeviceSynchronize();

  return 0;
}

