// Install:
//
// ```bash
// g++ -std=c++11 ./crlf_to_lf.cc -o crlf_to_lf
// sudo cp ./crlf_to_lf /usr/bin
// ```
//
#include <stdlib.h>

#include <fstream>
#include <iostream>
#include <string>

int main(int argc, char *argv[]) {
  if (argc < 2) {
    std::cerr << "Usage: " << argv[0] << " filename" << std::endl;
    return 1;
  }
  const std::string input_file = std::string(argv[1]) + ".bak";
  const std::string output_file = argv[1];

  // Use `cp` command to simply retaining the permissions
  auto command = "cp -f " + output_file + " " + input_file;
  std::system(command.c_str());

  std::ifstream in(input_file);
  std::ofstream out(output_file);

  std::string line;
  while (in && std::getline(in, line)) {
    if (!line.empty() && line.back() == '\r') {
      line.pop_back();
    }
    out << line << "\n";
  }

  command = "rm -f " + input_file;
  std::system(command.c_str());

  out.close();
  in.close();
  return 0;
}
