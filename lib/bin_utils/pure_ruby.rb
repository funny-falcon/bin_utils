class String
  unless method_defined?(:byteslice)
    alias :byteslice :[]
  end
end

module BinUtils
  module PureRuby
    extend self
    INT32_INT32_LE = 'VV'.freeze
    INT32_INT32_BE = 'NN'.freeze
    MIN_INT   = 0
    MAX_INT64 = 2**64 - 1
    MAX_INT32 = 2**32 - 1
    MAX_INT16 = 2**16 - 1
    MAX_INT8 = 2**8 - 1
    MAX_SINT64 = 2**63 - 1
    MAX_SINT32 = 2**31 - 1
    MAX_SINT16 = 2**15 - 1
    MAX_SINT8 = 2**7 - 1
    MIN_SINT64 = -(2**63)
    MIN_SINT32 = -(2**31)
    MIN_SINT16 = -(2**15)
    MIN_SINT8  = -(2**7)
    EMPTY = ''.freeze
    ONE = "\x01".freeze

    def get_int8(data, i=0)
      data.getbyte(i)
    end

    def slice_int8!(data)
      int = data.getbyte(0)
      data[0, 1] = EMPTY
      int
    end

    def get_int16_le(data, i=0)
      data.getbyte(i) + data.getbyte(i+1) * 256
    end

    def slice_int16_le!(data)
      int = data.getbyte(0) + data.getbyte(1) * 256
      data[0, 2] = EMPTY
      int
    end

    def get_int16_be(data, i=0)
      data.getbyte(i+1) + data.getbyte(i) * 256
    end

    def slice_int16_be!(data)
      int = data.getbyte(1) + data.getbyte(0) * 256
      data[0, 2] = EMPTY
      int
    end

    def get_int24_le(data, i=0)
      data.getbyte(i) + data.getbyte(i+1) * 256 + data.getbyte(i+2) * 65536
    end

    def slice_int24_le!(data)
      int = data.getbyte(0) + data.getbyte(1) * 256 + data.getbyte(2) * 65536
      data[0, 3] = EMPTY
      int
    end

    def get_int24_be(data, i=0)
      data.getbyte(i+2) + data.getbyte(i+1) * 256 + data.getbyte(i) * 65536
    end

    def slice_int24_be!(data)
      int = data.getbyte(2) + data.getbyte(1) * 256 + data.getbyte(0) * 65536
      data[0, 3] = EMPTY
      int
    end

    def get_int32_le(data, i=0)
      (data.getbyte(i) + data.getbyte(i+1) * 256 +
       data.getbyte(i+2) * 65536 + data.getbyte(i+3) * 16777216)
    end

    def slice_int32_le!(data)
      int = (data.getbyte(0) + data.getbyte(1) * 256 +
             data.getbyte(2) * 65536 + data.getbyte(3) * 16777216)
      data[0, 4] = EMPTY
      int
    end

    def get_int32_be(data, i=0)
      (data.getbyte(i+3) + data.getbyte(i+2) * 256 +
       data.getbyte(i+1) * 65536 + data.getbyte(i) * 16777216)
    end

    def slice_int32_be!(data)
      int = (data.getbyte(3) + data.getbyte(2) * 256 +
             data.getbyte(1) * 65536 + data.getbyte(0) * 16777216)
      data[0, 4] = EMPTY
      int
    end

    def get_int40_le(data, i=0)
      (data.getbyte(i) + data.getbyte(i+1) * 256 +
       data.getbyte(i+2) * 65536 + data.getbyte(i+3) * 16777216 +
       (data.getbyte(i+4) << 32))
    end

    def slice_int40_le!(data)
      int = (data.getbyte(0) + data.getbyte(1) * 256 +
             data.getbyte(2) * 65536 + data.getbyte(3) * 16777216 +
             (data.getbyte(4) << 32))
      data[0, 5] = EMPTY
      int
    end

    def get_int40_be(data, i=0)
      (data.getbyte(i+4) + data.getbyte(i+3) * 256 +
       data.getbyte(i+2) * 65536 + data.getbyte(i+1) * 16777216 +
       (data.getbyte(i) << 32))
    end

    def slice_int40_be!(data)
      int = (data.getbyte(4) + data.getbyte(3) * 256 +
             data.getbyte(2) * 65536 + data.getbyte(1) * 16777216 +
             (data.getbyte(0) << 32))
      data[0, 5] = EMPTY
      int
    end

    INT32_INT16_LE = 'Vv'.freeze
    def slice_int48_le!(data)
      int0, int1 = data.unpack(INT32_INT16_LE)
      data[0, 6] = EMPTY
      int0 + (int1 << 32)
    end

    def get_int48_le(data, i=0)
      data = data.byteslice(i, 6)  if i > 0
      int0, int1 = data.unpack(INT32_INT16_LE)
      int0 + (int1 << 32)
    end

    INT16_INT32_BE = 'nN'.freeze
    def slice_int48_be!(data)
      int1, int0 = data.unpack(INT16_INT32_BE)
      data[0, 6] = EMPTY
      int0 + (int1 << 32)
    end

    def get_int48_be(data, i=0)
      data = data.byteslice(i, 6)  if i > 0
      int1, int0 = data.unpack(INT16_INT32_BE)
      int0 + (int1 << 32)
    end

    INT32_INT16_INT8_LE = 'VvC'.freeze
    def slice_int56_le!(data)
      int0, int1, int2 = data.unpack(INT32_INT16_INT8_LE)
      data[0, 7] = EMPTY
      int0 + (int1 << 32) + (int2 << 48)
    end

    def get_int56_le(data, i=0)
      data = data.byteslice(i, 7)  if i > 0
      int0, int1, int2 = data.unpack(INT32_INT16_INT8_LE)
      int0 + (int1 << 32) + (int2 << 48)
    end

    INT8_INT16_INT32_BE = 'CnN'.freeze
    def slice_int56_be!(data)
      int2, int1, int0 = data.unpack(INT8_INT16_INT32_BE)
      data[0, 7] = EMPTY
      int0 + (int1 << 32) + (int2 << 48)
    end

    def get_int56_be(data, i=0)
      data = data.byteslice(i, 7)  if i > 0
      int2, int1, int0 = data.unpack(INT8_INT16_INT32_BE)
      int0 + (int1 << 32) + (int2 << 48)
    end

    def slice_int64_le!(data)
      int0, int1 = data.unpack(INT32_INT32_LE)
      data[0, 8] = EMPTY
      int0 + (int1 << 32)
    end

    def get_int64_le(data, i=0)
      data = data.byteslice(i, 8)  if i > 0
      int0, int1 = data.unpack(INT32_INT32_LE)
      int0 + (int1 << 32)
    end

    def slice_int64_be!(data)
      int1, int0 = data.unpack(INT32_INT32_BE)
      data[0, 8] = EMPTY
      int0 + (int1 << 32)
    end

    def get_int64_be(data, i=0)
      data = data.byteslice(i, 8)  if i > 0
      int1, int0 = data.unpack(INT32_INT32_BE)
      int0 + (int1 << 32)
    end

    def get_sint8(data, i=0)
      i = get_int8(data, i)
      i - ((i & 128) << 1)
    end

    def slice_sint8!(data)
      i = slice_int8!(data)
      i - ((i & 128) << 1)
    end

    for size in [16, 24, 32, 40, 48, 56, 64]
      for endian in %w{le be}
        class_eval <<-EOF, __FILE__, __LINE__
          def get_sint#{size}_#{endian}(data, i=0)
            i = get_int#{size}_#{endian}(data, i)
            i - ((i >> #{size - 1}) << #{size})
          end

          def slice_sint#{size}_#{endian}!(data)
            i = slice_int#{size}_#{endian}!(data)
            i - ((i >> #{size - 1}) << #{size})
          end
        EOF
      end
    end

    BER_5 = 128 ** 5
    BER_6 = 128 ** 6
    BER_7 = 128 ** 7
    BER_8 = 128 ** 8
    BER_9 = 128 ** 9
    def ber_size(int)
      int < 128 ? 1 :
      int < 16384 ? 2 :
      int < 2097153 ? 3 :
      int < 268435456 ? 4 :
      int < BER_5 ? 5 :
      int < BER_6 ? 6 :
      int < BER_7 ? 7 :
      int < BER_8 ? 8 :
      int < BER_9 ? 9 :
      10
    end

    def get_ber(data, i=0)
      res = 0
      while true
        if (byte = data.getbyte(i)) <= 127
          res += byte
          break
        else
          res = (res + (byte - 128)) * 128
          i += 1
        end
      end
      res
    end

    def slice_ber!(data)
      res = 0
      pos = 0
      while true
        if (byte = data.getbyte(pos)) <= 127
          res += byte
          break
        else
          res = (res + (byte - 128)) * 128
          pos += 1
        end
      end
      data[0, pos+1] = EMPTY
      res
    end

    def append_int8!(str, int)
      str << (int & 255)
    end

    def append_bersize_int8!(str, int)
      str << 1 << (int & 255)
    end

    def append_int16_le!(str, int)
      str << (int & 255) << ((int>>8) & 255)
    end

    def append_int24_le!(str, int)
      str << (int & 255) << ((int>>8) & 255) <<
             ((int>>16) & 255)
    end

    def append_int32_le!(str, int)
      str << (int & 255) << ((int>>8) & 255) <<
             ((int>>16) & 255) << ((int>>24) & 255)
    end

    def append_int40_le!(str, int)
      str << (int & 255) << ((int>>8) & 255) <<
             ((int>>16) & 255) << ((int>>24) & 255) <<
             ((int>>32) & 255)
    end

    def append_int48_le!(str, int)
      str << [int & MAX_INT32, int >> 32].pack(INT32_INT16_LE)
    end

    def append_int56_le!(str, int)
      str << [int & MAX_INT32, (int >> 32) & MAX_INT16, (int >> 48)].pack(INT32_INT16_INT8_LE)
    end

    def append_int64_le!(str, int)
      str << [int & MAX_INT32, int >> 32].pack(INT32_INT32_LE)
    end

    alias append_sint8! append_int8!
    alias append_sint16_le! append_int16_le!
    alias append_sint24_le! append_int24_le!
    alias append_sint32_le! append_int32_le!
    alias append_sint40_le! append_int40_le!
    alias append_sint48_le! append_int48_le!
    alias append_sint56_le! append_int56_le!
    alias append_sint64_le! append_int64_le!

    def append_int16_be!(str, int)
      str << ((int>>8) & 255) << (int & 255)
    end

    def append_int24_be!(str, int)
      str << ((int>>16) & 255) << ((int>>8) & 255) << (int & 255)
    end

    def append_int32_be!(str, int)
      str << ((int>>24) & 255) << ((int>>16) & 255) <<
             ((int>>8) & 255) << (int & 255)
    end

    def append_int40_be!(str, int)
      str << ((int>>32) & 255) << ((int>>24) & 255) <<
             ((int>>16) & 255) << ((int>>8) & 255) <<
             (int & 255)
    end

    def append_int48_be!(str, int)
      str << [int >> 32, int & MAX_INT32].pack(INT16_INT32_BE)
    end

    def append_int56_be!(str, int)
      str << [(int >> 48), (int >> 32) & MAX_INT16, int & MAX_INT32].pack(INT8_INT16_INT32_BE)
    end

    def append_int64_be!(str, int)
      str << [int >> 32, int & MAX_INT32].pack(INT32_INT32_BE)
    end

    alias append_sint8! append_int8!
    alias append_sint16_be! append_int16_be!
    alias append_sint24_be! append_int24_be!
    alias append_sint32_be! append_int32_be!
    alias append_sint40_be! append_int40_be!
    alias append_sint48_be! append_int48_be!
    alias append_sint56_be! append_int56_be!
    alias append_sint64_be! append_int64_be!

    def append_bersize_int16_le!(str, int)
      str << 2 << (int & 255) << ((int>>8) & 255)
    end

    def append_bersize_int24_le!(str, int)
      str << 3 << (int & 255) << ((int>>8) & 255) <<
             ((int>>16) & 255)
    end

    def append_bersize_int32_le!(str, int)
      str << 4 <<
              (int & 255) << ((int>>8) & 255) <<
             ((int>>16) & 255) << ((int>>24) & 255)
    end

    def append_bersize_int40_le!(str, int)
      str << 5 <<
             (int & 255) << ((int>>8) & 255) <<
             ((int>>16) & 255) << ((int>>24) & 255) <<
             ((int>>32) & 255)
    end

    def append_bersize_int48_le!(str, int)
      str << 6 << [int & MAX_INT32, int >> 32].pack(INT32_INT16_LE)
    end

    def append_bersize_int56_le!(str, int)
      str << 7 << [int & MAX_INT32, (int >> 32) & MAX_INT16, (int >> 48)].pack(INT32_INT16_INT8_LE)
    end

    def append_bersize_int64_le!(str, int)
      str << 8 << [int & MAX_INT32, int >> 32].pack(INT32_INT32_LE)
    end

    alias append_bersize_sint8! append_bersize_int8!
    alias append_bersize_sint16_le! append_bersize_int16_le!
    alias append_bersize_sint24_le! append_bersize_int24_le!
    alias append_bersize_sint32_le! append_bersize_int32_le!
    alias append_bersize_sint40_le! append_bersize_int40_le!
    alias append_bersize_sint48_le! append_bersize_int48_le!
    alias append_bersize_sint56_le! append_bersize_int56_le!
    alias append_bersize_sint64_le! append_bersize_int64_le!

    def append_bersize_int16_be!(str, int)
      str << 2 << ((int>>8) & 255) << (int & 255)
    end

    def append_bersize_int24_be!(str, int)
      str << 3 << ((int>>16) & 255) << ((int>>8) & 255) << (int & 255)
    end

    def append_bersize_int32_be!(str, int)
      str << 4 <<
             ((int>>24) & 255) << ((int>>16) & 255) <<
             ((int>>8) & 255) << (int & 255)
    end

    def append_bersize_int40_be!(str, int)
      str << 5 <<
             ((int>>32) & 255) << ((int>>24) & 255) <<
             ((int>>16) & 255) << ((int>>8) & 255) <<
             (int & 255)
    end

    def append_bersize_int48_be!(str, int)
      str << 6 << [int >> 32, int & MAX_INT32].pack(INT16_INT32_BE)
    end

    def append_bersize_int56_be!(str, int)
      str << 7 << [(int >> 48), (int >> 32) & MAX_INT16, int & MAX_INT32].pack(INT8_INT16_INT32_BE)
    end

    def append_bersize_int64_be!(str, int)
      str << 8 << [int >> 32, int & MAX_INT32].pack(INT32_INT32_BE)
    end

    alias append_bersize_sint16_be! append_bersize_int16_be!
    alias append_bersize_sint24_be! append_bersize_int24_be!
    alias append_bersize_sint32_be! append_bersize_int32_be!
    alias append_bersize_sint40_be! append_bersize_int40_be!
    alias append_bersize_sint48_be! append_bersize_int48_be!
    alias append_bersize_sint56_be! append_bersize_int56_be!
    alias append_bersize_sint64_be! append_bersize_int64_be!

    INT32LE_1 = "\x01\x00\x00\x00"
    INT32LE_2 = "\x02\x00\x00\x00"
    INT32LE_3 = "\x03\x00\x00\x00"
    INT32LE_4 = "\x04\x00\x00\x00"
    INT32LE_5 = "\x05\x00\x00\x00"
    INT32LE_6 = "\x06\x00\x00\x00"
    INT32LE_7 = "\x07\x00\x00\x00"
    INT32LE_8 = "\x08\x00\x00\x00"
    def append_int32lesize_int8!(str, int)
      str << INT32LE_1 << (int & 255)
    end

    def append_int32lesize_int16_le!(str, int)
      str << INT32LE_2 << (int & 255) << ((int>>8) & 255)
    end

    def append_int32lesize_int24_le!(str, int)
      str << INT32LE_3 << (int & 255) << ((int>>8) & 255) <<
             ((int>>16) & 255)
    end

    def append_int32lesize_int32_le!(str, int)
      str << INT32LE_4 <<
              (int & 255) << ((int>>8) & 255) <<
             ((int>>16) & 255) << ((int>>24) & 255)
    end

    def append_int32lesize_int40_le!(str, int)
      str << INT32LE_5 <<
             (int & 255) << ((int>>8) & 255) <<
             ((int>>16) & 255) << ((int>>24) & 255) <<
             ((int>>32) & 255)
    end

    def append_int32lesize_int48_le!(str, int)
      str << INT32LE_6 << [int & MAX_INT32, int >> 32].pack(INT32_INT16_LE)
    end

    def append_int32lesize_int56_le!(str, int)
      str << INT32LE_7 << [int & MAX_INT32, (int >> 32) & MAX_INT16, (int >> 48)].pack(INT32_INT16_INT8_LE)
    end

    def append_int32lesize_int64_le!(str, int)
      str << INT32LE_8 << [int & MAX_INT32, int >> 32].pack(INT32_INT32_LE)
    end

    alias append_int32lesize_sint8! append_int32lesize_int8!
    alias append_int32lesize_sint16_le! append_int32lesize_int16_le!
    alias append_int32lesize_sint24_le! append_int32lesize_int24_le!
    alias append_int32lesize_sint32_le! append_int32lesize_int32_le!
    alias append_int32lesize_sint40_le! append_int32lesize_int40_le!
    alias append_int32lesize_sint48_le! append_int32lesize_int48_le!
    alias append_int32lesize_sint56_le! append_int32lesize_int56_le!
    alias append_int32lesize_sint64_le! append_int32lesize_int64_le!

    def append_int32lesize_int16_be!(str, int)
      str << INT32LE_2 << ((int>>8) & 255) << (int & 255)
    end

    def append_int32lesize_int24_be!(str, int)
      str << INT32LE_3 << ((int>>16) & 255) << ((int>>8) & 255) << (int & 255)
    end

    def append_int32lesize_int32_be!(str, int)
      str << INT32LE_4 <<
             ((int>>24) & 255) << ((int>>16) & 255) <<
             ((int>>8) & 255) << (int & 255)
    end

    def append_int32lesize_int40_be!(str, int)
      str << INT32LE_5 <<
             ((int>>32) & 255) << ((int>>24) & 255) <<
             ((int>>16) & 255) << ((int>>8) & 255) <<
             (int & 255)
    end

    def append_int32lesize_int48_be!(str, int)
      str << INT32LE_6 << [int >> 32, int & MAX_INT32].pack(INT16_INT32_BE)
    end

    def append_int32lesize_int56_be!(str, int)
      str << INT32LE_7 << [(int >> 48), (int >> 32) & MAX_INT16, int & MAX_INT32].pack(INT8_INT16_INT32_BE)
    end

    def append_int32lesize_int64_be!(str, int)
      str << INT32LE_8 << [int >> 32, int & MAX_INT32].pack(INT32_INT32_BE)
    end

    alias append_int32lesize_sint16_be! append_int32lesize_int16_be!
    alias append_int32lesize_sint24_be! append_int32lesize_int24_be!
    alias append_int32lesize_sint32_be! append_int32lesize_int32_be!
    alias append_int32lesize_sint40_be! append_int32lesize_int40_be!
    alias append_int32lesize_sint48_be! append_int32lesize_int48_be!
    alias append_int32lesize_sint56_be! append_int32lesize_int56_be!
    alias append_int32lesize_sint64_be! append_int32lesize_int64_be!

    INT32BE_1 = "\x00\x00\x00\x01"
    INT32BE_2 = "\x00\x00\x00\x02"
    INT32BE_3 = "\x00\x00\x00\x03"
    INT32BE_4 = "\x00\x00\x00\x04"
    INT32BE_5 = "\x00\x00\x00\x05"
    INT32BE_6 = "\x00\x00\x00\x06"
    INT32BE_7 = "\x00\x00\x00\x07"
    INT32BE_8 = "\x00\x00\x00\x08"
    def append_int32besize_int8!(str, int)
      str << INT32BE_1 << (int & 255)
    end

    def append_int32besize_int16_le!(str, int)
      str << INT32BE_2 << (int & 255) << ((int>>8) & 255)
    end

    def append_int32besize_int24_le!(str, int)
      str << INT32BE_3 << (int & 255) << ((int>>8) & 255) <<
             ((int>>16) & 255)
    end

    def append_int32besize_int32_le!(str, int)
      str << INT32BE_4 <<
              (int & 255) << ((int>>8) & 255) <<
             ((int>>16) & 255) << ((int>>24) & 255)
    end

    def append_int32besize_int40_le!(str, int)
      str << INT32BE_5 <<
             (int & 255) << ((int>>8) & 255) <<
             ((int>>16) & 255) << ((int>>24) & 255) <<
             ((int>>32) & 255)
    end

    def append_int32besize_int48_le!(str, int)
      str << INT32BE_6 << [int & MAX_INT32, int >> 32].pack(INT32_INT16_LE)
    end

    def append_int32besize_int56_le!(str, int)
      str << INT32BE_7 << [int & MAX_INT32, (int >> 32) & MAX_INT16, (int >> 48)].pack(INT32_INT16_INT8_LE)
    end

    def append_int32besize_int64_le!(str, int)
      str << INT32BE_8 << [int & MAX_INT32, int >> 32].pack(INT32_INT32_LE)
    end

    alias append_int32besize_sint8! append_int32besize_int8!
    alias append_int32besize_sint16_le! append_int32besize_int16_le!
    alias append_int32besize_sint24_le! append_int32besize_int24_le!
    alias append_int32besize_sint32_le! append_int32besize_int32_le!
    alias append_int32besize_sint40_le! append_int32besize_int40_le!
    alias append_int32besize_sint48_le! append_int32besize_int48_le!
    alias append_int32besize_sint56_le! append_int32besize_int56_le!
    alias append_int32besize_sint64_le! append_int32besize_int64_le!

    def append_int32besize_int16_be!(str, int)
      str << INT32BE_2 << ((int>>8) & 255) << (int & 255)
    end

    def append_int32besize_int24_be!(str, int)
      str << INT32BE_3 << ((int>>16) & 255) << ((int>>8) & 255) << (int & 255)
    end

    def append_int32besize_int32_be!(str, int)
      str << INT32BE_4 <<
             ((int>>24) & 255) << ((int>>16) & 255) <<
             ((int>>8) & 255) << (int & 255)
    end

    def append_int32besize_int40_be!(str, int)
      str << INT32BE_5 <<
             ((int>>32) & 255) << ((int>>24) & 255) <<
             ((int>>16) & 255) << ((int>>8) & 255) <<
             (int & 255)
    end

    def append_int32besize_int48_be!(str, int)
      str << INT32BE_6 << [int >> 32, int & MAX_INT32].pack(INT16_INT32_BE)
    end

    def append_int32besize_int56_be!(str, int)
      str << INT32BE_7 << [(int >> 48), (int >> 32) & MAX_INT16, int & MAX_INT32].pack(INT8_INT16_INT32_BE)
    end

    def append_int32besize_int64_be!(str, int)
      str << INT32BE_8 << [int >> 32, int & MAX_INT32].pack(INT32_INT32_BE)
    end

    alias append_int32besize_sint16_be! append_int32besize_int16_be!
    alias append_int32besize_sint24_be! append_int32besize_int24_be!
    alias append_int32besize_sint32_be! append_int32besize_int32_be!
    alias append_int32besize_sint40_be! append_int32besize_int40_be!
    alias append_int32besize_sint48_be! append_int32besize_int48_be!
    alias append_int32besize_sint56_be! append_int32besize_int56_be!
    alias append_int32besize_sint64_be! append_int32besize_int64_be!

    BINARY = ::Encoding::BINARY
    def append_string!(data, str)
      data << str.dup.force_encoding(BINARY)
    end

    BER_STRING = "wa*".freeze
    INT32LE_STRING = "Va*".freeze
    INT32BE_STRING = "Na*".freeze
    def append_bersize_string!(data, str)
      data << [str.bytesize, str].pack(BER_STRING)
    end

    def append_int32lesize_string!(data, str)
      data << [str.bytesize, str].pack(INT32LE_STRING)
    end

    def append_int32besize_string!(data, str)
      data << [str.bytesize, str].pack(INT32BE_STRING)
    end

    BER = 'w'
    INT32LE_BER = 'Vw'
    INT32BE_BER = 'Nw'
    def append_ber!(data, int)
      data << [int].pack(BER)
    end

    def append_bersize_ber!(data, int)
      data << ber_size(int) << [int].pack(BER)
    end

    def append_int32lesize_ber!(data, int)
      data << [ber_size(int), int].pack(INT32LE_BER)
    end

    def append_int32besize_ber!(data, int)
      data << [ber_size(int), int].pack(INT32BE_BER)
    end
  end
end
