require 'ffi'

require 'lzo/raw'
require 'lzo/ffi'
require 'lzo/lzop'
require 'lzo/version'
require 'lzo/multi_io'

module LZO
  class << self
    def compress(input, lzop: false)
      io = input.respond_to?(:read) ? input : StringIO.new(input)

      if lzop
        output_io = StringIO.new ''.force_encoding 'BINARY'
        compressor = LzopCompressor.new output_io, name: '', mode: 0100644, mtime: Time.now

        until io.eof?
          bytes = io.read 2**20 # 1MB chunks
          compressor.write bytes
        end

        compressor.close
        output_io.string
      else
        Raw.compress io
      end
    end

    def decompress(input)
      io = input.respond_to?(:read) ? input : StringIO.new(input)

      magic = LZOP::Header::MAGIC
      start = io.read magic.length
      multi_io = MultiIO.new [StringIO.new(start), io]

      if start == magic
        LzopDecompressor.new(multi_io).read
      else
        Raw.decompress multi_io
      end
    end

    def library_version
      FFI.lzo_version
    end
  end
end
