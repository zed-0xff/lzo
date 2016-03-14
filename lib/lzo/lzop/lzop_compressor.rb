module LZO
  class LzopCompressor
    def initialize(io, name:, mode:, mtime:)
      @io = io
      @name = name
      @mode = mode
      @mtime = mtime
    end

    def write(bytes)
      write_header_once!

      block = LZOP::Block.new flags: [:F_ADLER32_D]

      checksum = Raw.adler32 bytes
      compressed = Raw.compress StringIO.new bytes

      if compressed.length >= bytes.length
        block.block = bytes
      else
        block.block = compressed
      end

      # NOTE: compressed_length is set by bindata
      block.decompressed_checksum = checksum
      block.decompressed_length = bytes.length

      io.write block.to_binary_s
    end

    def close
      eof_marker = [0].pack 'N'
      io.write eof_marker
      io.close
    end

    private
    attr_reader :io, :name, :mode, :mtime

    def write_header_once!
      @header ||= begin
        header = LZOP::Header.new
        fields = header.checksummable
        fields.version = 0x0940
        fields.lib_version = LZO.library_version
        fields.version_needed = 0x0940
        fields.lzo_method = :M_LZO1X_1
        fields.level = 1
        fields.flags = [:F_ADLER32_D]
        fields.mode = mode
        fields.mtime_low = mtime.to_i
        fields.name = name
        io.write header.to_binary_s
      end
    end
  end
end
