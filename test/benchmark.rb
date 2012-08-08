require 'benchmark'
require 'bin_utils'

N = (ARGV[0] || 1_000_000).to_i
a = 'asdfzxcvqwerasdfzxcvqwer1234'.force_encoding('binary').freeze

EMPTY = ''.freeze
_V = 'V'.freeze
_Vv = 'Vv'.freeze
_Vvw = 'Vvw'.freeze
_VvwQ = 'VvwQ'.freeze
_VV = 'VV'.freeze
_VVv = 'VVv'.freeze
_vVV = 'vVV'.freeze
_VVn = 'VVn'.freeze
_nVw = 'nVw'.freeze
_w = 'w*'.freeze

Benchmark.bmbm(6) do |x|
  x.report('get i32le') { N.times{|_| 
    i = ::BinUtils.get_int32_le(a)
  } }
  x.report('get i32le i32le') { N.times{|_| 
    i = ::BinUtils.get_int32_le(a); i2 = ::BinUtils.get_int32_le(a, 4)
  } }
  x.report('get i32le i32le i16be') { N.times{|_|
    i = ::BinUtils.get_int32_le(a); i2 = ::BinUtils.get_int32_le(a, 4)
    i3 = ::BinUtils.get_int16_be(a, 9)
  } }
  x.report('get i16be i32le ber') { N.times{|_|
    i = ::BinUtils.get_int16_be(a); i2 = ::BinUtils.get_int32_le(a, 2)
    i3 = ::BinUtils.get_ber(a, 6)
  } }
  x.report('unpack i32le') { N.times{|_| i, = a.unpack(_V)} }
  x.report('unpack i32le`') { N.times{|_| i = a.unpack(_V)[0]} }
  x.report('unpack i32le i32le') { N.times{|_| i, i2 = a.unpack(_VV)} }
  x.report('unpack i32le i32le i16be') { N.times{|_| i, i2, i3 = a.unpack(_VVn)} }
  x.report('unpack i16be i32le ber') { N.times{|_| i, i2, i3 = a.unpack(_nVw)} }
  x.report('slice i32le') { N.times{|_|
    b = a.dup
    i = ::BinUtils.slice_int32_le!(b)
  } }
  x.report('slice i32le i16le') { N.times{|_|
    b = a.dup
    i = ::BinUtils.slice_int32_le!(b)
    i2 = ::BinUtils.slice_int16_le!(b)
  } }
  x.report('slice i32le i16le ber') { N.times{|_|
    b = a.dup
    i = ::BinUtils.slice_int32_le!(b)
    i2 = ::BinUtils.slice_int16_le!(b)
    i3 = ::BinUtils.slice_ber!(b)
  } }
  x.report('slice i32le i16le ber i64le') { N.times{|_|
    b = a.dup
    i = ::BinUtils.slice_int32_le!(b)
    i2 = ::BinUtils.slice_int16_le!(b)
    i3 = ::BinUtils.slice_ber!(b)
    i4 = ::BinUtils.slice_int64_le!(b)
  } }
  x.report('cut unpack i32le') { N.times{|_|
    b = a.dup
    i, = b.unpack(_V)
    b[0, 4] = EMPTY
  } }
  x.report('cut unpack i32le i16le') { N.times{|_|
    b = a.dup
    i, i2 = b.unpack(_Vv)
    b[0, 6] = EMPTY
  } }
  x.report('cut unpack i32le i16le ber') { N.times{|_|
    b = a.dup
    i, i2, i3 = b.unpack(_Vvw)
    if i3 < 128
      b[0, 7] = EMPTY
    else
      b[0, 8] = EMPTY # simplify ber size only to two cases
    end
  } }
  x.report('cut unpack i32le i16le ber i64le') { N.times{|_|
    b = a.dup
    i, i2, i3, i4 = b.unpack(_VvwQ)
    if i3 < 128
      b[0, 15] = EMPTY
    else
      b[0, 16] = EMPTY # simplify ber size only to two cases
    end
  } }
  x.report('create i32le') { N.times{|i|
    b = ::BinUtils.append_int32_le!(nil, i)
  } }
  x.report('create i32le i32le') { N.times{|i|
    b = ::BinUtils.append_int32_le!(nil, i, i+1)
  } }
  x.report('create i32le i32le i16le') { N.times{|i|
    b = ::BinUtils.append_int32_le!(nil, i, i+1)
    ::BinUtils.append_int16_le!(b, i+2)
  } }
  x.report('create i16le i32le i32le') { N.times{|i|
    b = ::BinUtils.append_int16_int32_le!(nil, i, i+1, i+2)
  } }
  x.report('create i16be i32le ber') { N.times{|i|
    b = ::BinUtils.append_int16_be!(nil, i)
    ::BinUtils.append_int32_le!(b, i)
    ::BinUtils.append_ber!(b, i+2)
  } }
  x.report('append i32le') { N.times{|i|
    b = a.dup
    ::BinUtils.append_int32_le!(b, i)
  } }
  x.report('append i32le i32le') { N.times{|i|
    b = a.dup
    ::BinUtils.append_int32_le!(b, i, i+1)
  } }
  x.report('append i32le i32le i16le') { N.times{|i|
    b = a.dup
    ::BinUtils.append_int32_le!(b, i, i+1)
    ::BinUtils.append_int16_le!(b, i+2)
  } }
  x.report('append i16le i32le i32le') { N.times{|i|
    b = a.dup
    ::BinUtils.append_int16_int32_le!(b, i, i+1, i+2)
  } }
  x.report('append i16be i32le ber') { N.times{|i|
    b = a.dup
    ::BinUtils.append_int16_be!(b, i)
    ::BinUtils.append_int32_le!(b, i)
    ::BinUtils.append_ber!(b, i+2)
  } }
  x.report('pack i32le') { N.times{|i|
    b = [i].pack(_V)
  } }
  x.report('pack i32le i32le') { N.times{|i|
    b = [i, i+1].pack(_VV)
  } }
  x.report('pack i32le i32le i16le') { N.times{|i|
    b = [i, i+1, i+2].pack(_VVv)
  } }
  x.report('pack i16le i32le i32le') { N.times{|i|
    b = [i, i+1, i+2].pack(_vVV)
  } }
  x.report('pack i16be i32le ber') { N.times{|i|
    b = [i, i+1, i+2].pack(_nVw)
  } }
  x.report('pack append i32le') { N.times{|i|
    b = a.dup
    b << [i].pack(_V)
  } }
  x.report('pack append i32le i32le') { N.times{|i|
    b = a.dup
    b << [i, i+1].pack(_VV)
  } }
  x.report('pack append i32le i32le i16le') { N.times{|i|
    b = a.dup
    b << [i, i+1, i+2].pack(_VVv)
  } }
  x.report('pack append i16le i32le i32le') { N.times{|i|
    b = a.dup
    b << [i, i+1, i+2].pack(_vVV)
  } }
  x.report('pack append i16be i32le ber') { N.times{|i|
    b = a.dup
    b << [i, i+1, i+2].pack(_nVw)
  } }
  x.report('create ber array') { arr = [1,10,100,1000,10000,100000,1000000]; N.times {|_|
    ::BinUtils.append_ber!(nil, arr)
  } }
  x.report('pack ber array') { arr = [1,10,100,1000,10000,100000,1000000]; N.times {|_|
    arr.pack(_w)
  } }
end
