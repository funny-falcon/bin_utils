class String
  unless method_defined?(:byteslice)
    alias :byteslice :[]
  end
end

module BinUtils
  # Pure Ruby implementation of bin utils.
  # It is provided just reference implementation, so that I could write tests before writting
  # native code. You should not expect performance from it.
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

    BINARY = ::Encoding::BINARY
    def append_int8!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        str << (ints[i] & 255)
        i += 1
      end
      str
    end

    def append_int16_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << (int & 255) << ((int>>8) & 255)
        i += 1
      end
      str
    end

    def append_int24_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << (int & 255) << ((int>>8) & 255) <<
               ((int>>16) & 255)
        i += 1
      end
      str
    end

    def append_int32_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << (int & 255) << ((int>>8) & 255) <<
               ((int>>16) & 255) << ((int>>24) & 255)
        i += 1
      end
      str
    end

    def append_int40_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << (int & 255) << ((int>>8) & 255) <<
               ((int>>16) & 255) << ((int>>24) & 255) <<
               ((int>>32) & 255)
        i += 1
      end
      str
    end

    def append_int48_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << [int & MAX_INT32, int >> 32].pack(INT32_INT16_LE)
        i += 1
      end
      str
    end

    def append_int56_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << [int & MAX_INT32, (int >> 32) & MAX_INT16, (int >> 48)].pack(INT32_INT16_INT8_LE)
        i += 1
      end
      str
    end

    def append_int64_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << [int & MAX_INT32, int >> 32].pack(INT32_INT32_LE)
        i += 1
      end
      str
    end

    def append_int16_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << ((int>>8) & 255) << (int & 255)
        i += 1
      end
      str
    end

    def append_int24_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << ((int>>16) & 255) << ((int>>8) & 255) << (int & 255)
        i += 1
      end
      str
    end

    def append_int32_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << ((int>>24) & 255) << ((int>>16) & 255) <<
               ((int>>8) & 255) << (int & 255)
        i += 1
      end
      str
    end

    def append_int40_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << ((int>>32) & 255) << ((int>>24) & 255) <<
               ((int>>16) & 255) << ((int>>8) & 255) <<
               (int & 255)
        i += 1
      end
      str
    end

    def append_int48_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << [int >> 32, int & MAX_INT32].pack(INT16_INT32_BE)
        i += 1
      end
      str
    end

    def append_int56_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << [(int >> 48), (int >> 32) & MAX_INT16, int & MAX_INT32].pack(INT8_INT16_INT32_BE)
        i += 1
      end
      str
    end

    def append_int64_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      i = 0
      sz = ints.size
      while i < sz
        int = ints[i]
        str << [int >> 32, int & MAX_INT32].pack(INT32_INT32_BE)
        i += 1
      end
      str
    end

    def append_bersize_int8!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size)
      append_int8!(str, *ints)
    end

    def append_bersize_int16_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 2)
      append_int16_le!(str, *ints)
    end

    def append_bersize_int24_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 3)
      append_int24_le!(str, *ints)
    end

    def append_bersize_int32_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 4)
      append_int32_le!(str, *ints)
    end

    def append_bersize_int40_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 5)
      append_int40_le!(str, *ints)
    end

    def append_bersize_int48_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 6)
      append_int48_le!(str, *ints)
    end

    def append_bersize_int56_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 7)
      append_int56_le!(str, *ints)
    end

    def append_bersize_int64_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 8)
      append_int64_le!(str, *ints)
    end

    def append_bersize_int16_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 2)
      append_int16_be!(str, *ints)
    end

    def append_bersize_int24_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 3)
      append_int24_be!(str, *ints)
    end

    def append_bersize_int32_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 4)
      append_int32_be!(str, *ints)
    end

    def append_bersize_int40_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 5)
      append_int40_be!(str, *ints)
    end

    def append_bersize_int48_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 6)
      append_int48_be!(str, *ints)
    end

    def append_bersize_int56_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 7)
      append_int56_be!(str, *ints)
    end

    def append_bersize_int64_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(str, ints.size * 8)
      append_int64_be!(str, *ints)
    end

    def append_int32size_int8_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_le!(str, ints.size)
      append_int8!(str, *ints)
    end

    def append_int32size_int16_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_le!(str, ints.size * 2)
      append_int16_le!(str, *ints)
    end

    def append_int32size_int24_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_le!(str, ints.size * 3)
      append_int24_le!(str, *ints)
    end

    def append_int32size_int32_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_le!(str, ints.size * 4)
      append_int32_le!(str, *ints)
    end

    def append_int32size_int40_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_le!(str, ints.size * 5)
      append_int40_le!(str, *ints)
    end

    def append_int32size_int48_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_le!(str, ints.size * 6)
      append_int48_le!(str, *ints)
    end

    def append_int32size_int56_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_le!(str, ints.size * 7)
      append_int56_le!(str, *ints)
    end

    def append_int32size_int64_le!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_le!(str, ints.size * 8)
      append_int64_le!(str, *ints)
    end

    def append_int32size_int8_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_be!(str, ints.size)
      append_int8!(str, *ints)
    end

    def append_int32size_int16_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_be!(str, ints.size * 2)
      append_int16_be!(str, *ints)
    end

    def append_int32size_int24_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_be!(str, ints.size * 3)
      append_int24_be!(str, *ints)
    end

    def append_int32size_int32_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_be!(str, ints.size * 4)
      append_int32_be!(str, *ints)
    end

    def append_int32size_int40_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_be!(str, ints.size * 5)
      append_int40_be!(str, *ints)
    end

    def append_int32size_int48_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_be!(str, ints.size * 6)
      append_int48_be!(str, *ints)
    end

    def append_int32size_int56_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_be!(str, ints.size * 7)
      append_int56_be!(str, *ints)
    end

    def append_int32size_int64_be!(str, *ints)
      str ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_be!(str, ints.size * 8)
      append_int64_be!(str, *ints)
    end

    def append_string!(data, str)
      data ||= ''.force_encoding(BINARY)
      data << str.dup.force_encoding(BINARY)
    end

    BER_STRING = "wa*".freeze
    INT32LE_STRING = "Va*".freeze
    INT32BE_STRING = "Na*".freeze
    def append_bersize_string!(data, str)
      data ||= ''.force_encoding(BINARY)
      data << [str.bytesize, str].pack(BER_STRING)
    end

    def append_int32size_string_le!(data, str)
      data ||= ''.force_encoding(BINARY)
      data << [str.bytesize, str].pack(INT32LE_STRING)
    end

    def append_int32size_string_be!(data, str)
      data ||= ''.force_encoding(BINARY)
      data << [str.bytesize, str].pack(INT32BE_STRING)
    end

    BER = 'w*'
    INT32LE_BER = 'Vw'
    INT32BE_BER = 'Nw'
    def append_ber!(data, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      if ints.size == 1 && ints[0] < 128
        data << ints[0]
      else
        data << ints.pack(BER)
      end
    end

    def append_bersize_ber!(data, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      bers = ints.pack(BER)
      append_ber!(data, bers.size)
      data << bers
    end

    def append_int32size_ber_le!(data, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      bers = ints.pack(BER)
      append_int32_le!(data, bers.size)
      data << bers
    end

    def append_int32size_ber_be!(data, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      bers = ints.pack(BER)
      append_int32_be!(data, bers.size)
      data << bers
    end

    # complex
    
    def append_int8_ber!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      data << (int1 & 255)
      append_ber!(data, *ints)
    end

    def append_int8_int16_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      data << (int1 & 255)
      append_int16_le!(data, *ints)
    end

    def append_int8_int24_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      data << (int1 & 255)
      append_int24_le!(data, *ints)
    end

    def append_int8_int32_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      data << (int1 & 255)
      append_int32_le!(data, *ints)
    end

    def append_int16_ber_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int16_le!(data, int1)
      append_ber!(data, *ints)
    end

    def append_int16_int8_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int16_le!(data, int1)
      append_int8!(data, *ints)
    end

    def append_int16_int24_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int16_le!(data, int1)
      append_int24_le!(data, *ints)
    end

    def append_int16_int32_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int16_le!(data, int1)
      append_int32_le!(data, *ints)
    end
    
    def append_int24_ber_le!(data, int1, *ints)
      append_int24_le!(data, int1)
      append_ber!(data, *ints)
    end

    def append_int24_int8_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int24_le!(data, int1)
      append_int8!(data, *ints)
    end

    def append_int24_int16_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int24_le!(data, int1)
      append_int16_le!(data, *ints)
    end

    def append_int24_int32_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int24_le!(data, int1)
      append_int32_le!(data, *ints)
    end

    def append_int32_ber_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_le!(data, int1)
      append_ber!(data, *ints)
    end

    def append_int32_int8_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_le!(data, int1)
      append_int8!(data, *ints)
    end

    def append_int32_int16_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_le!(data, int1)
      append_int16_le!(data, *ints)
    end

    def append_int32_int24_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_le!(data, int1)
      append_int24_le!(data, *ints)
    end

    def append_int8_int16_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      data << (int1 & 255)
      append_int16_be!(data, *ints)
    end

    def append_int8_int24_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      data << (int1 & 255)
      append_int24_be!(data, *ints)
    end

    def append_int8_int32_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      data << (int1 & 255)
      append_int32_be!(data, *ints)
    end

    def append_int16_ber_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int16_be!(data, int1)
      append_ber!(data, *ints)
    end

    def append_int16_int8_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int16_be!(data, int1)
      append_int8!(data, *ints)
    end

    def append_int16_int24_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int16_be!(data, int1)
      append_int24_be!(data, *ints)
    end

    def append_int16_int32_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int16_be!(data, int1)
      append_int32_be!(data, *ints)
    end

    def append_int24_ber_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int24_be!(data, int1)
      append_ber!(data, *ints)
    end

    def append_int24_int8_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int24_be!(data, int1)
      append_int8!(data, *ints)
    end

    def append_int24_int16_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int24_be!(data, int1)
      append_int16_be!(data, *ints)
    end

    def append_int24_int32_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int24_be!(data, int1)
      append_int32_be!(data, *ints)
    end

    def append_int32_ber_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_be!(data, int1)
      append_ber!(data, *ints)
    end

    def append_int32_int8_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_be!(data, int1)
      append_int8!(data, *ints)
    end

    def append_int32_int16_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_be!(data, int1)
      append_int16_be!(data, *ints)
    end

    def append_int32_int24_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_int32_be!(data, int1)
      append_int24_be!(data, *ints)
    end

    def append_ber_int8!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(data, int1)
      append_int8!(data, *ints)
    end

    def append_ber_int16_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(data, int1)
      append_int16_le!(data, *ints)
    end

    def append_ber_int24_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(data, int1)
      append_int24_le!(data, *ints)
    end

    def append_ber_int32_le!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(data, int1)
      append_int32_le!(data, *ints)
    end

    def append_ber_int8!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(data, int1)
      append_int8!(data, *ints)
    end

    def append_ber_int16_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(data, int1)
      append_int16_be!(data, *ints)
    end

    def append_ber_int24_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(data, int1)
      append_int24_be!(data, *ints)
    end

    def append_ber_int32_be!(data, int1, *ints)
      data ||= ''.force_encoding(BINARY)
      ints = ints[0] if ints.size == 1 && Array === ints[0]
      append_ber!(data, int1)
      append_int32_be!(data, *ints)
    end
  end
end
