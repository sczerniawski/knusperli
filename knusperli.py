import numpy as np
import os

from ctypes import cdll, c_char_p, c_uint, c_size_t, c_void_p, byref


libdir = os.path.dirname(os.path.abspath(__file__))
lib = cdll.LoadLibrary(os.path.join(libdir, 'libknusperli.so'))


def imread(path_or_bytes):
    if isinstance(path_or_bytes, str):
        with open(path_or_bytes, 'rb') as f:
            path_or_bytes = f.read()
    elif callable(getattr(path_or_bytes, 'read', None)):
        path_or_bytes = path_or_bytes.read()
    elif not isinstance(path_or_bytes, bytes):
        raise ValueError('path (str), open file or a bytes object required')

    jpeg_buf = c_char_p(path_or_bytes)
    jpeg_len = c_size_t(len(path_or_bytes))
    width = c_uint()
    height = c_uint()
    err = lib.read_jpeg_header(jpeg_buf, jpeg_len, byref(width), byref(height))
    if err:
        raise RuntimeError('Failed to read jpeg header')

    rgb = np.empty((height.value, width.value, 3), dtype=np.uint8)
    err = lib.decode_jpeg(jpeg_buf, jpeg_len, c_void_p(rgb.ctypes.data))
    if err:
        raise RuntimeError('Failed to decode jpeg')

    return rgb


if __name__ == '__main__':
    decoded = imread('test.jpeg')
    reference = np.fromfile('test.bin', dtype=np.uint8).reshape((201, 251, 3))
    assert np.all(decoded == reference)
