#include <torch/torch.h>

extern "C" {
    // 创建一个 2x2 的张量
    void* create_tensor() {
        auto tensor = torch::ones({2, 2}, torch::kFloat);
        return new torch::Tensor(tensor);
    }

    // 打印张量
    void print_tensor(void* tensor_ptr) {
        auto& tensor = *static_cast<torch::Tensor*>(tensor_ptr);
        std::cout << tensor << std::endl;
    }

    // 释放张量
    void free_tensor(void* tensor_ptr) {
        delete static_cast<torch::Tensor*>(tensor_ptr);
    }
}
