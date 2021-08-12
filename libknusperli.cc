#include <cstring>

#include "jpeg_data_decoder.h"
#include "jpeg_data_reader.h"

using knusperli::DecodeJpegToRGB;
using knusperli::JPEGData;
using knusperli::JPEG_READ_ALL;
using knusperli::JPEG_READ_HEADER;
using knusperli::ReadJpeg;


extern "C" int read_jpeg_header(const uint8_t *jpeg,
                                size_t jpeg_len,
                                unsigned *width,
                                unsigned *height)
{
    JPEGData jpeg_data;

    if (!ReadJpeg(jpeg, jpeg_len, JPEG_READ_HEADER, &jpeg_data))
        return -1;

    *width = jpeg_data.width;
    *height = jpeg_data.height;

    return 0;
}

extern "C" int decode_jpeg(const uint8_t *jpeg,
                           size_t jpeg_len,
                           uint8_t *rgb)
{
    JPEGData jpeg_data;

    if (!ReadJpeg(jpeg, jpeg_len, JPEG_READ_ALL, &jpeg_data))
        return -1;

    auto rgb_vec = DecodeJpegToRGB(jpeg_data);
    if (rgb_vec.empty())
        return -1;

    memcpy(rgb, rgb_vec.data(), rgb_vec.size());

    return 0;
}
