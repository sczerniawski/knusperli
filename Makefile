SRC := lodepng.cpp preprocess_downsample.cc gamma_correct.cc dct_double.cc \
       quantize.cc idct.cc output_image.cc jpeg_data.cc \
       jpeg_huffman_decode.cc jpeg_data_reader.cc jpeg_data_decoder.cc

HDR := lodepng.h preprocess_downsample.h gamma_correct.h dct_double.h \
       quantize.h idct.h output_image.h jpeg_data.h jpeg_huffman_decode.h \
	   jpeg_data_reader.h jpeg_data_decoder.h jpeg_error.h color_transform.h

all: knusperli libknusperli.so

knusperli: $(SRC) $(HDR) decode.cc
	g++ -O3 $(SRC) decode.cc -o knusperli

libknusperli.so: $(SRC) $(HDR) libknusperli.cc
	g++ -fPIC -O3 $(SRC) libknusperli.cc -shared -o libknusperli.so
