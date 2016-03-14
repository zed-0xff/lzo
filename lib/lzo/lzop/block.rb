module LZO
  module LZOP
    class Block < BinData::Record
      mandatory_parameter :flags
      hide :block
      endian :big
      virtual :flags_ary, value: :flags # TODO: is this necessary?

      uint32 :decompressed_length, assert: -> { value > 0 }
      uint32 :compressed_length, value: -> { block.length }
      uint32 :decompressed_checksum, onlyif: -> { flags.include?(:F_ADLER32_D) || flags.include?(:F_CRC32_D) }
      uint32 :compressed_checksum, onlyif: -> { flags.include?(:F_ADLER32_C) || flags.include?(:F_CRC32_C) }
      string :block, read_length: :compressed_length

      def body(validate: true)
        # TODO: spec for raising error when data is invalid
        raise 'Invalid data' unless !validate || valid?
        str = block.force_encoding 'BINARY'

        if compressed?
          io = StringIO.new str
          Raw.decompress io
        else
          str
        end
      end

      def compressed?
        compressed_length.to_i < decompressed_length.to_i
      end

      def valid?
        fa = flags_ary
        is_adler = fa.include?(:F_ADLER32_D) || fa.include?(:F_ADLER32_C)
        is_compressed = fa.include?(:F_ADLER32_C) || fa.include?(:F_CRC32_C)

        checksum_method = is_adler ? Raw.method(:adler32) : Raw.method(:crc32)
        checksum_body = is_compressed ? block.to_s : body(validate: false)

        expected_checksum = is_compressed ? compressed_checksum.to_i : decompressed_checksum.to_i
        calculated_checksum = checksum_method.call(checksum_body)

        calculated_checksum == expected_checksum
      end
    end
  end
end
