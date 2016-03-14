module LZO
  module FFI
    extend ::FFI::Library
    ffi_lib ['lzo2', 'liblzo2.so.2']

    # TODO: all "uint64" refs should check platform bitness
    WORKMEM_SIZE_32 = 65_536
    WORKMEM_SIZE_64 = 131_072

    enum :lzo_error_code, [
      :LZO_E_INTERNAL_ERROR, -99,
      :LZO_E_OUTPUT_NOT_CONSUMED, -12,
      :LZO_E_INVALID_ALIGNMENT,
      :LZO_E_INVALID_ARGUMENT,
      :LZO_E_NOT_YET_IMPLEMENTED,
      :LZO_E_INPUT_NOT_CONSUMED,
      :LZO_E_EOF_NOT_FOUND,
      :LZO_E_LOOKBEHIND_OVERRUN,
      :LZO_E_OUTPUT_OVERRUN,
      :LZO_E_INPUT_OVERRUN,
      :LZO_E_NOT_COMPRESSIBLE,
      :LZO_E_OUT_OF_MEMORY,
      :LZO_E_ERROR,
      :LZO_E_OK
    ]

    attach_function :lzo1x_1_compress, [
      :buffer_in, # input buffer
      :uint, # input buffer length
      :buffer_out, # output buffer
      :pointer, # pointer to output buffer length
      :buffer_inout # work mem
    ], :lzo_error_code

    attach_function :lzo1x_decompress_safe, [
      :buffer_in, # input buffer
      :uint, # input buffer length
      :buffer_out, # output buffer
      :pointer, # pointer to output buffer length
      :pointer # work mem (always NULL)
    ], :lzo_error_code

    attach_function :lzo_adler32, [:uint, :buffer_in, :uint], :uint
    attach_function :lzo_crc32, [:uint, :buffer_in, :uint], :uint
    attach_function :lzo_version, [], :uint
  end
end
