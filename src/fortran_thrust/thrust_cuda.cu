#include <cstdio>
#include <cstdlib>
#include <cstdint>

#include <thrust/device_ptr.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>


extern "C" void test_thrust_cuda(int32_t* data, int32_t data_size, int32_t* data_sum)
{

  //thrust::device_ptr<int32_t> d_beg(data);
  //thrust::device_ptr<int32_t> d_end(d_beg+data_size);
  //*data_sum = thrust::reduce(d_beg, d_end, (int32_t) 0, thrust::plus<int32_t>());

  // create a host vector wrapper arround the input data pointer
  thrust::host_vector<int32_t> h_data(data, data+data_size);

  // copy data on device
  thrust::device_vector<int32_t> d_data = h_data;

  // perform reduction on GPU device
  *data_sum = thrust::reduce(d_data.begin(), d_data.end(), (int32_t) 0, thrust::plus<int32_t>());

}
