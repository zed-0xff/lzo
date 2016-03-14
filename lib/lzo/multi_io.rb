module LZO
  # TODO: surely there's a better way to do this that i'm not aware of
  class MultiIO
    def initialize(ios)
      @ios = ios
    end

    def read(nbytes = nil)
      output = StringIO.new ''.force_encoding('BINARY')

      while nbytes.nil? || output.length < nbytes
        io = @ios.first
        break if io.nil?
        read_len = (nbytes - output.length) if nbytes
        bytes = io.read read_len
        @ios.shift if io.eof?
        output.write bytes
      end

      output.rewind
      output.read
    end

    def eof?
      @ios.length == 0
    end
  end
end
