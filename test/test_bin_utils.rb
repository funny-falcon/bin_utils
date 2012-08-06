require 'minitest/spec'
require 'minitest/autorun'

shared_example = proc do
  let(:src){ "\x01\x02\x03\x04\xf5\xf6\xf7\xf8\xf9\x0a\x0b\x0c".force_encoding(::Encoding::BINARY) }
  let(:dest){ "\x01\x02".force_encoding(::Encoding::BINARY) }

  it "must get integer" do
    util.get_int8(src).must_equal 1
    util.get_int8(src, 0).must_equal 1
    util.get_int8(src, 4).must_equal 0xf5
    util.get_sint8(src).must_equal 1
    util.get_sint8(src, 0).must_equal 1
    util.get_sint8(src, 4).must_equal(-11)

    util.get_int16_le(src).must_equal 0x0201
    util.get_int16_le(src, 0).must_equal 0x0201
    util.get_int16_le(src, 5).must_equal 0xf7f6
    util.get_sint16_le(src).must_equal 0x0201
    util.get_sint16_le(src, 0).must_equal 0x0201
    util.get_sint16_le(src, 5).must_equal(-2058)

    util.get_int16_be(src).must_equal 0x0102
    util.get_int16_be(src, 0).must_equal 0x0102
    util.get_int16_be(src, 5).must_equal 0xf6f7
    util.get_sint16_be(src).must_equal 0x0102
    util.get_sint16_be(src, 0).must_equal 0x0102
    util.get_sint16_be(src, 5).must_equal(-2313)

    util.get_int24_le(src).must_equal 0x030201
    util.get_int24_le(src, 0).must_equal 0x030201
    util.get_int24_le(src, 5).must_equal 0xf8f7f6
    util.get_sint24_le(src).must_equal 0x030201
    util.get_sint24_le(src, 0).must_equal 0x030201
    util.get_sint24_le(src, 5).must_equal(-460810)

    util.get_int24_be(src).must_equal 0x010203
    util.get_int24_be(src, 0).must_equal 0x010203
    util.get_int24_be(src, 5).must_equal 0xf6f7f8
    util.get_sint24_be(src).must_equal 0x010203
    util.get_sint24_be(src, 0).must_equal 0x010203
    util.get_sint24_be(src, 5).must_equal(-591880)

    util.get_int32_le(src).must_equal 0x04030201
    util.get_int32_le(src, 0).must_equal 0x04030201
    util.get_int32_le(src, 4).must_equal 0xf8f7f6f5
    util.get_sint32_le(src).must_equal 0x04030201
    util.get_sint32_le(src, 0).must_equal 0x04030201
    util.get_sint32_le(src, 4).must_equal(-117967115)

    util.get_int32_be(src).must_equal 0x01020304
    util.get_int32_be(src, 0).must_equal 0x01020304
    util.get_int32_be(src, 4).must_equal 0xf5f6f7f8
    util.get_sint32_be(src).must_equal 0x01020304
    util.get_sint32_be(src, 0).must_equal 0x01020304
    util.get_sint32_be(src, 4).must_equal(-168364040)

    util.get_int40_le(src).must_equal 0xf504030201
    util.get_int40_le(src, 0).must_equal 0xf504030201
    util.get_int40_le(src, 3).must_equal 0xf8f7f6f504
    util.get_sint40_le(src).must_equal(-47177334271)
    util.get_sint40_le(src, 0).must_equal(-47177334271)
    util.get_sint40_le(src, 3).must_equal(-30199581436)

    util.get_int40_be(src).must_equal 0x01020304f5
    util.get_int40_be(src, 0).must_equal 0x01020304f5
    util.get_int40_be(src, 4).must_equal 0xf5f6f7f8f9
    util.get_sint40_be(src).must_equal 0x01020304f5
    util.get_sint40_be(src, 0).must_equal 0x01020304f5
    util.get_sint40_be(src, 4).must_equal(-43101193991)

    util.get_int48_le(src).must_equal 0xf6f504030201
    util.get_int48_le(src, 0).must_equal 0xf6f504030201
    util.get_int48_le(src, 4).must_equal 0x0af9f8f7f6f5
    util.get_sint48_le(src).must_equal(-9942781984255)
    util.get_sint48_le(src, 0).must_equal(-9942781984255)
    util.get_sint48_le(src, 4).must_equal 0x0af9f8f7f6f5

    util.get_int48_be(src).must_equal 0x01020304f5f6
    util.get_int48_be(src, 0).must_equal 0x01020304f5f6
    util.get_int48_be(src, 4).must_equal 0xf5f6f7f8f90a
    util.get_sint48_be(src).must_equal 0x01020304f5f6
    util.get_sint48_be(src, 0).must_equal 0x01020304f5f6
    util.get_sint48_be(src, 4).must_equal(-11033905661686)

    util.get_int56_le(src).must_equal 0xf7f6f504030201
    util.get_int56_le(src, 0).must_equal 0xf7f6f504030201
    util.get_int56_le(src, 4).must_equal 0x0b0af9f8f7f6f5
    util.get_sint56_le(src).must_equal(-2261742595669503)
    util.get_sint56_le(src, 0).must_equal(-2261742595669503)
    util.get_sint56_le(src, 4).must_equal 3108293483951861

    util.get_int56_be(src).must_equal 0x01020304f5f6f7
    util.get_int56_be(src, 0).must_equal 0x01020304f5f6f7
    util.get_int56_be(src, 4).must_equal 0xf5f6f7f8f90a0b
    util.get_sint56_be(src).must_equal 0x01020304f5f6f7
    util.get_sint56_be(src, 0).must_equal 0x01020304f5f6f7
    util.get_sint56_be(src, 4).must_equal(-2824679849391605)

    util.get_int64_le(src).must_equal 0xf8f7f6f504030201
    util.get_int64_le(src, 0).must_equal 0xf8f7f6f504030201
    util.get_int64_le(src, 4).must_equal 0x0c0b0af9f8f7f6f5
    util.get_sint64_le(src).must_equal(-506664900861165055)
    util.get_sint64_le(src, 0).must_equal(-506664900861165055)
    util.get_sint64_le(src, 4).must_equal 0x0c0b0af9f8f7f6f5

    util.get_int64_be(src).must_equal 0x01020304f5f6f7f8
    util.get_int64_be(src, 0).must_equal 0x01020304f5f6f7f8
    util.get_int64_be(src, 4).must_equal 0xf5f6f7f8f90a0b0c
    util.get_sint64_be(src).must_equal 0x01020304f5f6f7f8
    util.get_sint64_be(src, 0).must_equal 0x01020304f5f6f7f8
    util.get_sint64_be(src, 4).must_equal(-723118041444250868)

    util.get_ber(src).must_equal 1
    util.get_ber(src, 0).must_equal 1
    util.get_ber(src, 6).must_equal 251542666
  end
end

require 'bin_utils/pure_ruby'
describe 'pure_ruby' do
  let(:util){ BinUtils::PureRuby }
  class_eval(&shared_example)
end
