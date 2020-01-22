module LZO
  module LZOP
    class Header < BinData::Record
      MAGIC = "\x89\x4C\x5A\x4F\x00\x0D\x0A\x1A\x0A".force_encoding('BINARY')
      endian :big

      string :magic, read_length: 9, asserted_value: MAGIC

      struct :checksummable do
        uint16 :version
        uint16 :lib_version
        uint16 :version_needed, onlyif: -> { version >= 0x0940 }
        LzoMethod :lzo_method
        uint8 :level, onlyif: -> { version >= 0x940 }
        HeaderFlags :flags
        uint32 :fhfilter, onlyif: -> { flags.include? :F_H_FILTER }
        uint32 :mode
        uint32 :mtime_low
        uint32 :mtime_high, onlyif: -> { version >= 0x0940 }
        uint8  :name_length, value: -> { name.length }
        string :name, read_length: :name_length
      end

      uint32 :checksum, asserted_value: -> { Raw.adler32(checksummable.to_binary_s) }
      struct :extra, onlyif: -> { checksummable.flags.include? :F_H_EXTRA_FIELD } do
        uint32 :extra_length
        string :extra_field, length: :extra_length
        uint32 :extra_checksum
      end
    end
  end
end
