#include <cstdio>
#include <cstdlib>
#include <cstdint>

#include <thrust/device_ptr.h>
#include <thrust/device_vector.h>


extern "C" void test_thrust_openmp(int32_t* data, int32_t data_size, int32_t* data_sum)
{

    //thrust::device_ptr<int32_t> d_beg(data);
    //thrust::device_ptr<int32_t> d_end(d_beg+data_size);
    //*data_sum = thrust::reduce(d_beg, d_end, (int32_t) 0, thrust::plus<int32_t>());

    thrust::device_vector<int32_t> d_data(data, data+data_size);
    *data_sum = thrust::reduce(d_data.begin(), d_data.end(), (int32_t) 0, thrust::plus<int32_t>());

}
