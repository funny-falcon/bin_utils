# coding: utf-8
require 'minitest/spec'
require 'minitest/autorun'

shared_example = proc do
  def src; "\x01\x02\x03\x04\xf5\xf6\xf7\xf8\xf9\x0a\x0b\x0c".force_encoding(::Encoding::BINARY) ; end
  def dest; "\x01\x02".force_encoding(::Encoding::BINARY); end

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

  def asrc; "\x01\x02\x03\x04\x05\x06\x07\x08\x09".force_encoding(::Encoding::BINARY) ; end
  def msrc; "\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding(::Encoding::BINARY) ; end

  it "must slice integer" do
    s = asrc; util.slice_int8!(s).must_equal 0x01; s.must_equal asrc[1..-1]
    s = msrc; util.slice_int8!(s).must_equal 0xf1; s.must_equal msrc[1..-1]
    s = asrc; util.slice_sint8!(s).must_equal 0x01; s.must_equal asrc[1..-1]
    s = msrc; util.slice_sint8!(s).must_equal(-15); s.must_equal msrc[1..-1]

    s = asrc; util.slice_int16_le!(s).must_equal 0x0201; s.must_equal asrc[2..-1]
    s = msrc; util.slice_int16_le!(s).must_equal 0xf2f1; s.must_equal msrc[2..-1]
    s = asrc; util.slice_sint16_le!(s).must_equal 0x0201; s.must_equal asrc[2..-1]
    s = msrc; util.slice_sint16_le!(s).must_equal(-3343); s.must_equal msrc[2..-1]

    s = asrc; util.slice_int16_be!(s).must_equal 0x0102; s.must_equal asrc[2..-1]
    s = msrc; util.slice_int16_be!(s).must_equal 0xf1f2; s.must_equal msrc[2..-1]
    s = asrc; util.slice_sint16_be!(s).must_equal 0x0102; s.must_equal asrc[2..-1]
    s = msrc; util.slice_sint16_be!(s).must_equal(-3598); s.must_equal msrc[2..-1]

    s = asrc; util.slice_int24_le!(s).must_equal 0x030201; s.must_equal asrc[3..-1]
    s = msrc; util.slice_int24_le!(s).must_equal 0xf3f2f1; s.must_equal msrc[3..-1]
    s = asrc; util.slice_sint24_le!(s).must_equal 0x030201; s.must_equal asrc[3..-1]
    s = msrc; util.slice_sint24_le!(s).must_equal(-789775); s.must_equal msrc[3..-1]

    s = asrc; util.slice_int24_be!(s).must_equal 0x010203; s.must_equal asrc[3..-1]
    s = msrc; util.slice_int24_be!(s).must_equal 0xf1f2f3; s.must_equal msrc[3..-1]
    s = asrc; util.slice_sint24_be!(s).must_equal 0x010203; s.must_equal asrc[3..-1]
    s = msrc; util.slice_sint24_be!(s).must_equal(-920845); s.must_equal msrc[3..-1]

    s = asrc; util.slice_int32_le!(s).must_equal 0x04030201; s.must_equal asrc[4..-1]
    s = msrc; util.slice_int32_le!(s).must_equal 0xf4f3f2f1; s.must_equal msrc[4..-1]
    s = asrc; util.slice_sint32_le!(s).must_equal 0x04030201; s.must_equal asrc[4..-1]
    s = msrc; util.slice_sint32_le!(s).must_equal(-185339151); s.must_equal msrc[4..-1]

    s = asrc; util.slice_int32_be!(s).must_equal 0x01020304; s.must_equal asrc[4..-1]
    s = msrc; util.slice_int32_be!(s).must_equal 0xf1f2f3f4; s.must_equal msrc[4..-1]
    s = asrc; util.slice_sint32_be!(s).must_equal 0x01020304; s.must_equal asrc[4..-1]
    s = msrc; util.slice_sint32_be!(s).must_equal(-235736076); s.must_equal msrc[4..-1]

    s = asrc; util.slice_int40_le!(s).must_equal 0x0504030201; s.must_equal asrc[5..-1]
    s = msrc; util.slice_int40_le!(s).must_equal 0xf5f4f3f2f1; s.must_equal msrc[5..-1]
    s = asrc; util.slice_sint40_le!(s).must_equal 0x0504030201; s.must_equal asrc[5..-1]
    s = msrc; util.slice_sint40_le!(s).must_equal(-43135012111); s.must_equal msrc[5..-1]

    s = asrc; util.slice_int40_be!(s).must_equal 0x0102030405; s.must_equal asrc[5..-1]
    s = msrc; util.slice_int40_be!(s).must_equal 0xf1f2f3f4f5; s.must_equal msrc[5..-1]
    s = asrc; util.slice_sint40_be!(s).must_equal 0x0102030405; s.must_equal asrc[5..-1]
    s = msrc; util.slice_sint40_be!(s).must_equal(-60348435211); s.must_equal msrc[5..-1]

    s = asrc; util.slice_int48_le!(s).must_equal 0x060504030201; s.must_equal asrc[6..-1]
    s = msrc; util.slice_int48_le!(s).must_equal 0xf6f5f4f3f2f1; s.must_equal msrc[6..-1]
    s = asrc; util.slice_sint48_le!(s).must_equal 0x060504030201; s.must_equal asrc[6..-1]
    s = msrc; util.slice_sint48_le!(s).must_equal(-9938739662095); s.must_equal msrc[6..-1]

    s = asrc; util.slice_int48_be!(s).must_equal 0x010203040506; s.must_equal asrc[6..-1]
    s = msrc; util.slice_int48_be!(s).must_equal 0xf1f2f3f4f5f6; s.must_equal msrc[6..-1]
    s = asrc; util.slice_sint48_be!(s).must_equal 0x010203040506; s.must_equal asrc[6..-1]
    s = msrc; util.slice_sint48_be!(s).must_equal(-15449199413770); s.must_equal msrc[6..-1]

    s = asrc; util.slice_int56_le!(s).must_equal 0x07060504030201; s.must_equal asrc[7..-1]
    s = msrc; util.slice_int56_le!(s).must_equal 0xf7f6f5f4f3f2f1; s.must_equal msrc[7..-1]
    s = asrc; util.slice_sint56_le!(s).must_equal 0x07060504030201; s.must_equal asrc[7..-1]
    s = msrc; util.slice_sint56_le!(s).must_equal(-2261738553347343); s.must_equal msrc[7..-1]

    s = asrc; util.slice_int56_be!(s).must_equal 0x01020304050607; s.must_equal asrc[7..-1]
    s = msrc; util.slice_int56_be!(s).must_equal 0xf1f2f3f4f5f6f7; s.must_equal msrc[7..-1]
    s = asrc; util.slice_sint56_be!(s).must_equal 0x01020304050607; s.must_equal asrc[7..-1]
    s = msrc; util.slice_sint56_be!(s).must_equal(-3954995049924873); s.must_equal msrc[7..-1]

    s = asrc; util.slice_int64_le!(s).must_equal 0x0807060504030201; s.must_equal asrc[8..-1]
    s = msrc; util.slice_int64_le!(s).must_equal 0xf8f7f6f5f4f3f2f1; s.must_equal msrc[8..-1]
    s = asrc; util.slice_sint64_le!(s).must_equal 0x0807060504030201; s.must_equal asrc[8..-1]
    s = msrc; util.slice_sint64_le!(s).must_equal(-506664896818842895); s.must_equal msrc[8..-1]

    s = asrc; util.slice_int64_be!(s).must_equal 0x0102030405060708; s.must_equal asrc[8..-1]
    s = msrc; util.slice_int64_be!(s).must_equal 0xf1f2f3f4f5f6f7f8; s.must_equal msrc[8..-1]
    s = asrc; util.slice_sint64_be!(s).must_equal 0x0102030405060708; s.must_equal asrc[8..-1]
    s = msrc; util.slice_sint64_be!(s).must_equal(-1012478732780767240); s.must_equal msrc[8..-1]

    s = "\x01\x02\x03\x04"; util.slice_ber!(s).must_equal 1; s.must_equal "\x02\x03\x04"
    s = "\xf1\x02\x03\x04"; util.slice_ber!(s).must_equal 14466; s.must_equal "\x03\x04"
    s = "\xf1\xf2\x03\x04"; util.slice_ber!(s).must_equal 1865987; s.must_equal "\x04"
    s = "\xf1\xf2\xf3\x04"; util.slice_ber!(s).must_equal 238860676; s.must_equal ""
  end

  it "must append integer" do
    d = dest; util.append_int8!(d, 0x03); d.must_equal "\x01\x02\x03"
    d = dest; util.append_int8!(d, 0xf3); d.must_equal "\x01\x02\xf3".force_encoding('binary')
    d = dest; util.append_int8!(d, -13); d.must_equal "\x01\x02\xf3".force_encoding('binary')

    d = dest; util.append_int16_le!(d, 0x0403); d.must_equal "\x01\x02\x03\x04"
    d = dest; util.append_int16_le!(d, 0xf4f3); d.must_equal "\x01\x02\xf3\xf4".force_encoding('binary')
    d = dest; util.append_int16_le!(d, -2829); d.must_equal "\x01\x02\xf3\xf4".force_encoding('binary')

    d = dest; util.append_int16_be!(d, 0x0304); d.must_equal "\x01\x02\x03\x04"
    d = dest; util.append_int16_be!(d, 0xf3f4); d.must_equal "\x01\x02\xf3\xf4".force_encoding('binary')
    d = dest; util.append_int16_be!(d, -3084); d.must_equal "\x01\x02\xf3\xf4".force_encoding('binary')

    d = dest; util.append_int24_le!(d, 0x050403); d.must_equal "\x01\x02\x03\x04\x05"
    d = dest; util.append_int24_le!(d, 0xf5f4f3); d.must_equal "\x01\x02\xf3\xf4\xf5".force_encoding('binary')
    d = dest; util.append_int24_le!(d, -658189); d.must_equal "\x01\x02\xf3\xf4\xf5".force_encoding('binary')

    d = dest; util.append_int24_be!(d, 0x030405); d.must_equal "\x01\x02\x03\x04\x05"
    d = dest; util.append_int24_be!(d, 0xf3f4f5); d.must_equal "\x01\x02\xf3\xf4\xf5".force_encoding('binary')
    d = dest; util.append_int24_be!(d, -789259); d.must_equal "\x01\x02\xf3\xf4\xf5".force_encoding('binary')

    d = dest; util.append_int32_le!(d, 0x06050403); d.must_equal "\x01\x02\x03\x04\x05\x06"
    d = dest; util.append_int32_le!(d, 0xf6f5f4f3); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6".force_encoding('binary')
    d = dest; util.append_int32_le!(d, -151653133); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6".force_encoding('binary')

    d = dest; util.append_int32_be!(d, 0x03040506); d.must_equal "\x01\x02\x03\x04\x05\x06"
    d = dest; util.append_int32_be!(d, 0xf3f4f5f6); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6".force_encoding('binary')
    d = dest; util.append_int32_be!(d, -202050058); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6".force_encoding('binary')

    d = dest; util.append_int40_le!(d, 0x0706050403); d.must_equal "\x01\x02\x03\x04\x05\x06\x07"
    d = dest; util.append_int40_le!(d, 0xf7f6f5f4f3); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7".force_encoding('binary')
    d = dest; util.append_int40_le!(d, -34511391501); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7".force_encoding('binary')

    d = dest; util.append_int40_be!(d, 0x0304050607); d.must_equal "\x01\x02\x03\x04\x05\x06\x07"
    d = dest; util.append_int40_be!(d, 0xf3f4f5f6f7); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7".force_encoding('binary')
    d = dest; util.append_int40_be!(d, -51724814601); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7".force_encoding('binary')

    d = dest; util.append_int48_le!(d, 0x080706050403); d.must_equal "\x01\x02\x03\x04\x05\x06\x07\x08"
    d = dest; util.append_int48_le!(d, 0xf8f7f6f5f4f3); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7\xf8".force_encoding('binary')
    d = dest; util.append_int48_le!(d, -7731092785933); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7\xf8".force_encoding('binary')

    d = dest; util.append_int48_be!(d, 0x030405060708); d.must_equal "\x01\x02\x03\x04\x05\x06\x07\x08"
    d = dest; util.append_int48_be!(d, 0xf3f4f5f6f7f8); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7\xf8".force_encoding('binary')
    d = dest; util.append_int48_be!(d, -13241552537608); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7\xf8".force_encoding('binary')

    d = dest; util.append_int56_le!(d, 0x09080706050403); d.must_equal "\x01\x02\x03\x04\x05\x06\x07\x08\x09"
    d = dest; util.append_int56_le!(d, 0xf9f8f7f6f5f4f3); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding('binary')
    d = dest; util.append_int56_le!(d, -1696580953049869); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding('binary')

    d = dest; util.append_int56_be!(d, 0x03040506070809); d.must_equal "\x01\x02\x03\x04\x05\x06\x07\x08\x09"
    d = dest; util.append_int56_be!(d, 0xf3f4f5f6f7f8f9); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding('binary')
    d = dest; util.append_int56_be!(d, -3389837449627399); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding('binary')

    d = dest; util.append_int64_le!(d, 0x0a09080706050403); d.must_equal "\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a"
    d = dest; util.append_int64_le!(d, 0xfaf9f8f7f6f5f4f3); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa".force_encoding('binary')
    d = dest; util.append_int64_le!(d, -361984551142689549); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa".force_encoding('binary')

    d = dest; util.append_int64_be!(d, 0x030405060708090a); d.must_equal "\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a"
    d = dest; util.append_int64_be!(d, 0xf3f4f5f6f7f8f9fa); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa".force_encoding('binary')
    d = dest; util.append_int64_be!(d, -867798387104613894); d.must_equal "\x01\x02\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa".force_encoding('binary')

    d = dest; util.append_ber!(d, 3); d.must_equal "\x01\x02\x03"
    d = dest; util.append_ber!(d, 14724); d.must_equal "\x01\x02\xf3\x04".force_encoding('binary')
    d = dest; util.append_ber!(d, 1899013); d.must_equal "\x01\x02\xf3\xf4\x05".force_encoding('binary')
    d = dest; util.append_ber!(d, 243088006); d.must_equal "\x01\x02\xf3\xf4\xf5\x06".force_encoding('binary')
  end

  it "must append bersize and integer" do
    d = dest; util.append_bersize_int8!(d, 0x03); d.must_equal "\x01\x02\x01\x03"
    d = dest; util.append_bersize_int8!(d, 0xf3); d.must_equal "\x01\x02\x01\xf3".force_encoding('binary')
    d = dest; util.append_bersize_int8!(d, -13); d.must_equal "\x01\x02\x01\xf3".force_encoding('binary')

    d = dest; util.append_bersize_int16_le!(d, 0x0403); d.must_equal "\x01\x02\x02\x03\x04"
    d = dest; util.append_bersize_int16_le!(d, 0xf4f3); d.must_equal "\x01\x02\x02\xf3\xf4".force_encoding('binary')
    d = dest; util.append_bersize_int16_le!(d, -2829); d.must_equal "\x01\x02\x02\xf3\xf4".force_encoding('binary')

    d = dest; util.append_bersize_int16_be!(d, 0x0304); d.must_equal "\x01\x02\x02\x03\x04"
    d = dest; util.append_bersize_int16_be!(d, 0xf3f4); d.must_equal "\x01\x02\x02\xf3\xf4".force_encoding('binary')
    d = dest; util.append_bersize_int16_be!(d, -3084); d.must_equal "\x01\x02\x02\xf3\xf4".force_encoding('binary')

    d = dest; util.append_bersize_int24_le!(d, 0x050403); d.must_equal "\x01\x02\x03\x03\x04\x05"
    d = dest; util.append_bersize_int24_le!(d, 0xf5f4f3); d.must_equal "\x01\x02\x03\xf3\xf4\xf5".force_encoding('binary')
    d = dest; util.append_bersize_int24_le!(d, -658189); d.must_equal "\x01\x02\x03\xf3\xf4\xf5".force_encoding('binary')

    d = dest; util.append_bersize_int24_be!(d, 0x030405); d.must_equal "\x01\x02\x03\x03\x04\x05"
    d = dest; util.append_bersize_int24_be!(d, 0xf3f4f5); d.must_equal "\x01\x02\x03\xf3\xf4\xf5".force_encoding('binary')
    d = dest; util.append_bersize_int24_be!(d, -789259); d.must_equal "\x01\x02\x03\xf3\xf4\xf5".force_encoding('binary')

    d = dest; util.append_bersize_int32_le!(d, 0x06050403); d.must_equal "\x01\x02\x04\x03\x04\x05\x06"
    d = dest; util.append_bersize_int32_le!(d, 0xf6f5f4f3); d.must_equal "\x01\x02\x04\xf3\xf4\xf5\xf6".force_encoding('binary')
    d = dest; util.append_bersize_int32_le!(d, -151653133); d.must_equal "\x01\x02\x04\xf3\xf4\xf5\xf6".force_encoding('binary')

    d = dest; util.append_bersize_int32_be!(d, 0x03040506); d.must_equal "\x01\x02\x04\x03\x04\x05\x06"
    d = dest; util.append_bersize_int32_be!(d, 0xf3f4f5f6); d.must_equal "\x01\x02\x04\xf3\xf4\xf5\xf6".force_encoding('binary')
    d = dest; util.append_bersize_int32_be!(d, -202050058); d.must_equal "\x01\x02\x04\xf3\xf4\xf5\xf6".force_encoding('binary')

    d = dest; util.append_bersize_int40_le!(d, 0x0706050403); d.must_equal "\x01\x02\x05\x03\x04\x05\x06\x07"
    d = dest; util.append_bersize_int40_le!(d, 0xf7f6f5f4f3); d.must_equal "\x01\x02\x05\xf3\xf4\xf5\xf6\xf7".force_encoding('binary')
    d = dest; util.append_bersize_int40_le!(d, -34511391501); d.must_equal "\x01\x02\x05\xf3\xf4\xf5\xf6\xf7".force_encoding('binary')

    d = dest; util.append_bersize_int40_be!(d, 0x0304050607); d.must_equal "\x01\x02\x05\x03\x04\x05\x06\x07"
    d = dest; util.append_bersize_int40_be!(d, 0xf3f4f5f6f7); d.must_equal "\x01\x02\x05\xf3\xf4\xf5\xf6\xf7".force_encoding('binary')
    d = dest; util.append_bersize_int40_be!(d, -51724814601); d.must_equal "\x01\x02\x05\xf3\xf4\xf5\xf6\xf7".force_encoding('binary')

    d = dest; util.append_bersize_int48_le!(d, 0x080706050403); d.must_equal "\x01\x02\x06\x03\x04\x05\x06\x07\x08"
    d = dest; util.append_bersize_int48_le!(d, 0xf8f7f6f5f4f3); d.must_equal "\x01\x02\x06\xf3\xf4\xf5\xf6\xf7\xf8".force_encoding('binary')
    d = dest; util.append_bersize_int48_le!(d, -7731092785933); d.must_equal "\x01\x02\x06\xf3\xf4\xf5\xf6\xf7\xf8".force_encoding('binary')

    d = dest; util.append_bersize_int48_be!(d, 0x030405060708); d.must_equal "\x01\x02\x06\x03\x04\x05\x06\x07\x08"
    d = dest; util.append_bersize_int48_be!(d, 0xf3f4f5f6f7f8); d.must_equal "\x01\x02\x06\xf3\xf4\xf5\xf6\xf7\xf8".force_encoding('binary')
    d = dest; util.append_bersize_int48_be!(d, -13241552537608); d.must_equal "\x01\x02\x06\xf3\xf4\xf5\xf6\xf7\xf8".force_encoding('binary')

    d = dest; util.append_bersize_int56_le!(d, 0x09080706050403); d.must_equal "\x01\x02\x07\x03\x04\x05\x06\x07\x08\x09"
    d = dest; util.append_bersize_int56_le!(d, 0xf9f8f7f6f5f4f3); d.must_equal "\x01\x02\x07\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding('binary')
    d = dest; util.append_bersize_int56_le!(d, -1696580953049869); d.must_equal "\x01\x02\x07\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding('binary')

    d = dest; util.append_bersize_int56_be!(d, 0x03040506070809); d.must_equal "\x01\x02\x07\x03\x04\x05\x06\x07\x08\x09"
    d = dest; util.append_bersize_int56_be!(d, 0xf3f4f5f6f7f8f9); d.must_equal "\x01\x02\x07\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding('binary')
    d = dest; util.append_bersize_int56_be!(d, -3389837449627399); d.must_equal "\x01\x02\x07\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding('binary')

    d = dest; util.append_bersize_int64_le!(d, 0x0a09080706050403); d.must_equal "\x01\x02\x08\x03\x04\x05\x06\x07\x08\x09\x0a"
    d = dest; util.append_bersize_int64_le!(d, 0xfaf9f8f7f6f5f4f3); d.must_equal "\x01\x02\x08\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa".force_encoding('binary')
    d = dest; util.append_bersize_int64_le!(d, -361984551142689549); d.must_equal "\x01\x02\x08\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa".force_encoding('binary')

    d = dest; util.append_bersize_int64_be!(d, 0x030405060708090a); d.must_equal "\x01\x02\x08\x03\x04\x05\x06\x07\x08\x09\x0a"
    d = dest; util.append_bersize_int64_be!(d, 0xf3f4f5f6f7f8f9fa); d.must_equal "\x01\x02\x08\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa".force_encoding('binary')
    d = dest; util.append_bersize_int64_be!(d, -867798387104613894); d.must_equal "\x01\x02\x08\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa".force_encoding('binary')

    d = dest; util.append_bersize_ber!(d, 3); d.must_equal "\x01\x02\x01\x03"
    d = dest; util.append_bersize_ber!(d, 14724); d.must_equal "\x01\x02\x02\xf3\x04".force_encoding('binary')
    d = dest; util.append_bersize_ber!(d, 1899013); d.must_equal "\x01\x02\x03\xf3\xf4\x05".force_encoding('binary')
    d = dest; util.append_bersize_ber!(d, 243088006); d.must_equal "\x01\x02\x04\xf3\xf4\xf5\x06".force_encoding('binary')
  end

  it "must append int32size little endian and integer" do
    d = dest; util.append_int32size_int8_le!(d, 0x03); d.must_equal "\x01\x02\x01\x00\x00\x00\x03"
    d = dest; util.append_int32size_int8_le!(d, 0xf3); d.must_equal "\x01\x02\x01\x00\x00\x00\xf3".force_encoding('binary')
    d = dest; util.append_int32size_int8_le!(d, -13); d.must_equal "\x01\x02\x01\x00\x00\x00\xf3".force_encoding('binary')

    d = dest; util.append_int32size_int16_le!(d, 0x0403); d.must_equal "\x01\x02\x02\x00\x00\x00\x03\x04"
    d = dest; util.append_int32size_int16_le!(d, 0xf4f3); d.must_equal "\x01\x02\x02\x00\x00\x00\xf3\xf4".force_encoding('binary')
    d = dest; util.append_int32size_int16_le!(d, -2829); d.must_equal "\x01\x02\x02\x00\x00\x00\xf3\xf4".force_encoding('binary')

    d = dest; util.append_int32size_int24_le!(d, 0x050403); d.must_equal "\x01\x02\x03\x00\x00\x00\x03\x04\x05"
    d = dest; util.append_int32size_int24_le!(d, 0xf5f4f3); d.must_equal "\x01\x02\x03\x00\x00\x00\xf3\xf4\xf5".force_encoding('binary')
    d = dest; util.append_int32size_int24_le!(d, -658189); d.must_equal "\x01\x02\x03\x00\x00\x00\xf3\xf4\xf5".force_encoding('binary')

    d = dest; util.append_int32size_int32_le!(d, 0x06050403); d.must_equal "\x01\x02\x04\x00\x00\x00\x03\x04\x05\x06"
    d = dest; util.append_int32size_int32_le!(d, 0xf6f5f4f3); d.must_equal "\x01\x02\x04\x00\x00\x00\xf3\xf4\xf5\xf6".force_encoding('binary')
    d = dest; util.append_int32size_int32_le!(d, -151653133); d.must_equal "\x01\x02\x04\x00\x00\x00\xf3\xf4\xf5\xf6".force_encoding('binary')

    d = dest; util.append_int32size_int40_le!(d, 0x0706050403); d.must_equal "\x01\x02\x05\x00\x00\x00\x03\x04\x05\x06\x07"
    d = dest; util.append_int32size_int40_le!(d, 0xf7f6f5f4f3); d.must_equal "\x01\x02\x05\x00\x00\x00\xf3\xf4\xf5\xf6\xf7".force_encoding('binary')
    d = dest; util.append_int32size_int40_le!(d, -34511391501); d.must_equal "\x01\x02\x05\x00\x00\x00\xf3\xf4\xf5\xf6\xf7".force_encoding('binary')

    d = dest; util.append_int32size_int48_le!(d, 0x080706050403); d.must_equal "\x01\x02\x06\x00\x00\x00\x03\x04\x05\x06\x07\x08"
    d = dest; util.append_int32size_int48_le!(d, 0xf8f7f6f5f4f3); d.must_equal "\x01\x02\x06\x00\x00\x00\xf3\xf4\xf5\xf6\xf7\xf8".force_encoding('binary')
    d = dest; util.append_int32size_int48_le!(d, -7731092785933); d.must_equal "\x01\x02\x06\x00\x00\x00\xf3\xf4\xf5\xf6\xf7\xf8".force_encoding('binary')

    d = dest; util.append_int32size_int56_le!(d, 0x09080706050403); d.must_equal "\x01\x02\x07\x00\x00\x00\x03\x04\x05\x06\x07\x08\x09"
    d = dest; util.append_int32size_int56_le!(d, 0xf9f8f7f6f5f4f3); d.must_equal "\x01\x02\x07\x00\x00\x00\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding('binary')
    d = dest; util.append_int32size_int56_le!(d, -1696580953049869); d.must_equal "\x01\x02\x07\x00\x00\x00\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding('binary')

    d = dest; util.append_int32size_int64_le!(d, 0x0a09080706050403); d.must_equal "\x01\x02\x08\x00\x00\x00\x03\x04\x05\x06\x07\x08\x09\x0a"
    d = dest; util.append_int32size_int64_le!(d, 0xfaf9f8f7f6f5f4f3); d.must_equal "\x01\x02\x08\x00\x00\x00\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa".force_encoding('binary')
    d = dest; util.append_int32size_int64_le!(d, -361984551142689549); d.must_equal "\x01\x02\x08\x00\x00\x00\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa".force_encoding('binary')

    d = dest; util.append_int32size_ber_le!(d, 3); d.must_equal "\x01\x02\x01\x00\x00\x00\x03"
    d = dest; util.append_int32size_ber_le!(d, 14724); d.must_equal "\x01\x02\x02\x00\x00\x00\xf3\x04".force_encoding('binary')
    d = dest; util.append_int32size_ber_le!(d, 1899013); d.must_equal "\x01\x02\x03\x00\x00\x00\xf3\xf4\x05".force_encoding('binary')
    d = dest; util.append_int32size_ber_le!(d, 243088006); d.must_equal "\x01\x02\x04\x00\x00\x00\xf3\xf4\xf5\x06".force_encoding('binary')
  end

  it "must append int32size big endian and integer" do
    d = dest; util.append_int32size_int8_be!(d, 0x03); d.must_equal "\x01\x02\x00\x00\x00\x01\x03"
    d = dest; util.append_int32size_int8_be!(d, 0xf3); d.must_equal "\x01\x02\x00\x00\x00\x01\xf3".force_encoding('binary')
    d = dest; util.append_int32size_int8_be!(d, -13); d.must_equal "\x01\x02\x00\x00\x00\x01\xf3".force_encoding('binary')

    d = dest; util.append_int32size_int16_be!(d, 0x0304); d.must_equal "\x01\x02\x00\x00\x00\x02\x03\x04"
    d = dest; util.append_int32size_int16_be!(d, 0xf3f4); d.must_equal "\x01\x02\x00\x00\x00\x02\xf3\xf4".force_encoding('binary')
    d = dest; util.append_int32size_int16_be!(d, -3084); d.must_equal "\x01\x02\x00\x00\x00\x02\xf3\xf4".force_encoding('binary')

    d = dest; util.append_int32size_int24_be!(d, 0x030405); d.must_equal "\x01\x02\x00\x00\x00\x03\x03\x04\x05"
    d = dest; util.append_int32size_int24_be!(d, 0xf3f4f5); d.must_equal "\x01\x02\x00\x00\x00\x03\xf3\xf4\xf5".force_encoding('binary')
    d = dest; util.append_int32size_int24_be!(d, -789259); d.must_equal "\x01\x02\x00\x00\x00\x03\xf3\xf4\xf5".force_encoding('binary')

    d = dest; util.append_int32size_int32_be!(d, 0x03040506); d.must_equal "\x01\x02\x00\x00\x00\x04\x03\x04\x05\x06"
    d = dest; util.append_int32size_int32_be!(d, 0xf3f4f5f6); d.must_equal "\x01\x02\x00\x00\x00\x04\xf3\xf4\xf5\xf6".force_encoding('binary')
    d = dest; util.append_int32size_int32_be!(d, -202050058); d.must_equal "\x01\x02\x00\x00\x00\x04\xf3\xf4\xf5\xf6".force_encoding('binary')

    d = dest; util.append_int32size_int40_be!(d, 0x0304050607); d.must_equal "\x01\x02\x00\x00\x00\x05\x03\x04\x05\x06\x07"
    d = dest; util.append_int32size_int40_be!(d, 0xf3f4f5f6f7); d.must_equal "\x01\x02\x00\x00\x00\x05\xf3\xf4\xf5\xf6\xf7".force_encoding('binary')
    d = dest; util.append_int32size_int40_be!(d, -51724814601); d.must_equal "\x01\x02\x00\x00\x00\x05\xf3\xf4\xf5\xf6\xf7".force_encoding('binary')

    d = dest; util.append_int32size_int48_be!(d, 0x030405060708); d.must_equal "\x01\x02\x00\x00\x00\x06\x03\x04\x05\x06\x07\x08"
    d = dest; util.append_int32size_int48_be!(d, 0xf3f4f5f6f7f8); d.must_equal "\x01\x02\x00\x00\x00\x06\xf3\xf4\xf5\xf6\xf7\xf8".force_encoding('binary')
    d = dest; util.append_int32size_int48_be!(d, -13241552537608); d.must_equal "\x01\x02\x00\x00\x00\x06\xf3\xf4\xf5\xf6\xf7\xf8".force_encoding('binary')

    d = dest; util.append_int32size_int56_be!(d, 0x03040506070809); d.must_equal "\x01\x02\x00\x00\x00\x07\x03\x04\x05\x06\x07\x08\x09"
    d = dest; util.append_int32size_int56_be!(d, 0xf3f4f5f6f7f8f9); d.must_equal "\x01\x02\x00\x00\x00\x07\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding('binary')
    d = dest; util.append_int32size_int56_be!(d, -3389837449627399); d.must_equal "\x01\x02\x00\x00\x00\x07\xf3\xf4\xf5\xf6\xf7\xf8\xf9".force_encoding('binary')

    d = dest; util.append_int32size_int64_be!(d, 0x030405060708090a); d.must_equal "\x01\x02\x00\x00\x00\x08\x03\x04\x05\x06\x07\x08\x09\x0a"
    d = dest; util.append_int32size_int64_be!(d, 0xf3f4f5f6f7f8f9fa); d.must_equal "\x01\x02\x00\x00\x00\x08\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa".force_encoding('binary')
    d = dest; util.append_int32size_int64_be!(d, -867798387104613894); d.must_equal "\x01\x02\x00\x00\x00\x08\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa".force_encoding('binary')

    d = dest; util.append_int32size_ber_be!(d, 3); d.must_equal "\x01\x02\x00\x00\x00\x01\x03"
    d = dest; util.append_int32size_ber_be!(d, 14724); d.must_equal "\x01\x02\x00\x00\x00\x02\xf3\x04".force_encoding('binary')
    d = dest; util.append_int32size_ber_be!(d, 1899013); d.must_equal "\x01\x02\x00\x00\x00\x03\xf3\xf4\x05".force_encoding('binary')
    d = dest; util.append_int32size_ber_be!(d, 243088006); d.must_equal "\x01\x02\x00\x00\x00\x04\xf3\xf4\xf5\x06".force_encoding('binary')
  end

  it "must append string" do
    d = dest; util.append_string!(d, "asdfфыва"); d.must_equal "\x01\x02asdf\xD1\x84\xD1\x8B\xD0\xB2\xD0\xB0".force_encoding('binary')
    d = dest; util.append_bersize_string!(d, "asdfфыва"); d.must_equal "\x01\x02\x0casdf\xD1\x84\xD1\x8B\xD0\xB2\xD0\xB0".force_encoding('binary')
    d = dest; util.append_int32size_string_le!(d, "asdfфыва"); d.must_equal "\x01\x02\x0c\x00\x00\x00asdf\xD1\x84\xD1\x8B\xD0\xB2\xD0\xB0".force_encoding('binary')
    d = dest; util.append_int32size_string_be!(d, "asdfфыва"); d.must_equal "\x01\x02\x00\x00\x00\x0casdf\xD1\x84\xD1\x8B\xD0\xB2\xD0\xB0".force_encoding('binary')
  end

  it "must append complex" do
    d0 = dest; util.append_int8_ber!(d0, 5, 500)
    d1 = dest; util.append_int8!(d1, 5); util.append_ber!(d1, 500)
    d0.must_equal d1
    d0 = dest; util.append_ber_int8!(d0, 500, 5)
    d1 = dest; util.append_ber!(d1, 500); util.append_int8!(d1, 5)
    d0.must_equal d1

    for _e in %w{le be}
      for m1 in %w{ber int8}
        for m2 in %w{int16 int24 int32}
          d0 = dest; util.send(:"append_#{m1}_#{m2}_#{_e}!", d0, 251, 172)
          d1 = dest; util.send(:"append_#{m1}!", d1, 251); util.send(:"append_#{m2}_#{_e}!", d1, 172)
          d0.must_equal d1
          d0 = dest; util.send(:"append_#{m2}_#{m1}_#{_e}!", d0, 251, 172)
          d1 = dest; util.send(:"append_#{m2}_#{_e}!", d1, 251); util.send(:"append_#{m1}!", d1, 172)
          d0.must_equal d1
        end
      end

      for m1 in %w{int16 int24 int32}
        for m2 in %w{int16 int24 int32}
          next if m1 == m2
          d0 = dest; util.send(:"append_#{m1}_#{m2}_#{_e}!", d0, 254, 199)
          d1 = dest; util.send(:"append_#{m1}_#{_e}!", d1, 254); util.send(:"append_#{m2}_#{_e}!", d1, 199)
          d0.must_equal d1
        end
      end
    end
  end
end

require 'bin_utils/pure_ruby'
describe 'pure_ruby' do
  let(:util){ BinUtils::PureRuby }
  class_eval(&shared_example)
end

begin
  require 'bin_utils/native_bin_utils'
  describe 'native' do
    let(:util){ BinUtils::Native }
    class_eval(&shared_example)
  end
rescue LoadError
  puts "NO NATIVE MODULE TESTED"
end

