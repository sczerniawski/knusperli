sources := lodepng.cpp preprocess_downsample.cc gamma_correct.cc \
           dct_double.cc quantize.cc idct.cc output_image.cc jpeg_data.cc \
           jpeg_huffman_decode.cc jpeg_data_reader.cc jpeg_data_decoder.cc

headers := lodepng.h preprocess_downsample.h gamma_correct.h \
           dct_double.h quantize.h idct.h output_image.h jpeg_data.h \
	       jpeg_huffman_decode.h jpeg_data_reader.h jpeg_data_decoder.h \
	       jpeg_error.h color_transform.h

CXXFLAGS ?= -O3 -flto

all: knusperli libknusperli.so

knusperli: decode.cc $(sources) $(headers)
	$(CXX) $(CXXFLAGS) $(filter %.cc %.cpp,$^) -o $@

libknusperli.so: libknusperli.cc $(sources) $(headers)
	$(CXX) $(CXXFLAGS) -fPIC -shared $(filter %.cc %.cpp,$^) -o $@

test:
	python3 knusperli.py

clean:
	rm -f knusperli libknusperli.so

.PHONY: all test clean
