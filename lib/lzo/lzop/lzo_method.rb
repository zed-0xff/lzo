module LZO
  module LZOP
    class LzoMethod < BinData::Primitive
      uint8be :val

      def map
        { M_LZO1X_1: 1, M_LZO1X_1_15: 2, M_LZO1X_999: 3 }
      end

      def get
        map.invert[val.to_i]
      end

      def set(v)
        self.val = map[v]
      end
    end
  end
end
