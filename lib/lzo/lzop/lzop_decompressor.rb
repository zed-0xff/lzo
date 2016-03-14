module LZO
  class LzopDecompressor
    def initialize(io)
      @io = io
    end

    def name
      header.checksummable.name.to_s
    end

    def mode
      header.checksummable.mode.to_i
    end

    def mtime
      Time.at header.checksummable.mtime_low
    end

    def method
      header.checksummable.lzo_method.get
    end

    def level
      header.checksummable.level.to_i
    end

    def read(nbytes = nil)
      @enum ||= enum_for :yield_blocks, io, header
      @leftover ||= ''.force_encoding 'BINARY'

      output = StringIO.new @leftover.dup
      @leftover = ''.force_encoding 'BINARY'

      output.seek 0, ::IO::SEEK_END

      while nbytes.nil? || output.length < nbytes
        begin
          block = @enum.next
        rescue StopIteration
          break
        end

        bytes = block.body
        output.write bytes
      end

      if nbytes && nbytes < output.length
        output.seek nbytes, ::IO::SEEK_SET
        @leftover = output.read
      end

      output.rewind
      output.read nbytes
    end

    def eof?
      io.eof? && @leftover.length == 0
    end

    private

    attr_reader :io

    def header
      @header ||= LZOP::Header.read io
    end

    def yield_blocks(io, header)
      loop do
        # TODO: there's gotta be a better way than a validity error?
        begin
          block = LZOP::Block.read(io, flags: header.checksummable.flags)
          yield block
        rescue BinData::ValidityError
          # this "exception" is expected: last block of the stream
          break
        end
      end
    end
  end
end
