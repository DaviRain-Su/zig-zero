#ifndef TORCH_WRAPPER_H
#define TORCH_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

void* create_tensor();
void print_tensor(void* tensor_ptr);
void free_tensor(void* tensor_ptr);

#ifdef __cplusplus
}
#endif

#endif // TORCH_WRAPPER_H
