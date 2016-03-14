module LZO
  module LZOP
    class HeaderFlags < BinData::Primitive
      uint32be :flags

      # rubocop:disable Metrics/MethodLength
      def map
        {
          (1 << 0) => :F_ADLER32_D,
          (1 << 1) => :F_ADLER32_C,
          (1 << 2) => :F_STDIN,
          (1 << 3) => :F_STDOUT,
          (1 << 4) => :F_NAME_DEFAULT,
          (1 << 5) => :F_DOSISH,
          (1 << 6) => :F_H_EXTRA_FIELD,
          (1 << 7) => :F_H_GMTDIFF,
          (1 << 8) => :F_CRC32_D,
          (1 << 9) => :F_CRC32_C,
          (1 << 10) => :F_MULTIPART,
          (1 << 11) => :F_H_FILTER,
          (1 << 12) => :F_H_CRC32,
          (1 << 13) => :F_H_PATH
        }
      end
      # rubocop:enable Metrics/MethodLength

      def get
        ary = [flags.to_i]
        map.each do |k, v|
          ary << v if k & flags.to_i > 0
        end
        ary
      end

      def set(v)
        tmp = 0
        v.each do |f|
          if f.is_a?(Symbol)
            tmp |= map.invert[f]
          else
            tmp |= f
          end
        end
        self.flags = tmp
      end
    end
  end
end
