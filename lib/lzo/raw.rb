module LZO
  module Raw
    class << self
      def compress(io)
        str = ''
        str << io.read until io.eof?

        buf_len = str.bytesize
        buf = ::FFI::MemoryPointer.new :char, buf_len
        buf.put_bytes 0, str

        out_len = output_length_for_input str
        out_len_buf = ::FFI::MemoryPointer.new :size_t, 1
        out_len_buf.put_uint64 0, out_len

        out_buf = ::FFI::MemoryPointer.new :char, out_len

        work_mem_buf = ::FFI::MemoryPointer.new :char, FFI::WORKMEM_SIZE_64

        ret_code = FFI.lzo1x_1_compress buf, buf_len, out_buf, out_len_buf, work_mem_buf
        raise "Unexpected error code: #{ret_code}" if ret_code != :LZO_E_OK # apparently never fails?

        out_len = out_len_buf.read_ulong_long
        out_buf.read_bytes out_len
      end

      def decompress(io)
        str = ''
        str << io.read until io.eof?

        buf_len = str.bytesize
        buf = ::FFI::MemoryPointer.new :char, buf_len
        buf.put_bytes 0, str

        # TODO: how can we realloc? this is wasteful
        out_len = 512
        begin
          out_len *= 2
          out_len_buf = ::FFI::MemoryPointer.new :size_t, 1
          out_len_buf.put_uint64 0, out_len
          out_buf = ::FFI::MemoryPointer.new :char, out_len

          ret_code = FFI.lzo1x_decompress_safe buf, buf_len, out_buf, out_len_buf, nil
        end while ret_code == :LZO_E_OUTPUT_OVERRUN

        if ret_code == :LZO_E_OK
          out_len = out_len_buf.read_ulong_long
          out_buf.read_bytes out_len
        else
          raise "Error: #{ret_code}" # TODO: do something?
        end
      end

      def output_length_for_input(input)
        inlen = input.length
        inlen + (inlen / 16) + 64 + 3 # worst case
      end

      def adler32(input)
        buf_len = input.bytesize
        buf = ::FFI::MemoryPointer.new :char, buf_len
        buf.put_bytes 0, input

        FFI.lzo_adler32 1, buf, buf_len
      end

      def crc32(input)
        buf_len = input.bytesize
        buf = ::FFI::MemoryPointer.new :char, buf_len
        buf.put_bytes 0, input

        FFI.lzo_crc32 0, buf, buf_len
      end
    end
  end
end
