# BinUtils

It is specialized versions of methods for working with binary data.
It were written cause:
- MRI's #pack and #unpack seems to be slow
- result of #pack is often appended to a string at the very next step.
- usually we need to drop unpacked string head

## Installation

Add this line to your application's Gemfile:

    gem 'bin_utils'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bin_utils

## Usage

```ruby
  require 'bin_utils'
  # using Ruby 1.9.3 sintax for some little-endian and big-endian
  BinUtils.get_int8(str) == str.unpack('C')[0]
  BinUtils.get_sint8(str) == str.unpack('c')[0]
  BinUtils.get_int8(str, i) == str[i,1].unpack('C')[0]
  BinUtils.get_sint8(str, i) == str[i,1].unpack('c')[0]

  BinUtils.get_int16_le(str) == str.unpack('v')[0]
  BinUtils.get_sint16_le(str) == str.unpack('s<')[0]
  BinUtils.get_int16_le(str, i) == str[i,2].unpack('v')[0]
  BinUtils.get_sint16_le(str, i) == str[i,2].unpack('s<')[0]

  BinUtils.get_int32_le(str) == str.unpack('V')[0]
  BinUtils.get_sint32_le(str) == str.unpack('l<')[0]
  BinUtils.get_int32_le(str, i) == str[i,4].unpack('V')[0]
  BinUtils.get_sint32_le(str, i) == str[i,4].unpack('l<')[0]

  BinUtils.get_int64_le(str) == str.unpack('Q<')[0]
  BinUtils.get_sint64_le(str) == str.unpack('q<')[0]
  BinUtils.get_int64_le(str, i) == str[i,8].unpack('Q<')[0]
  BinUtils.get_sint64_le(str, i) == str[i,8].unpack('q<')[0]

  BinUtils.get_int16_be(str) == str.unpack('n')[0]
  BinUtils.get_sint16_be(str) == str.unpack('s>')[0]
  BinUtils.get_int16_be(str, i) == str[i,2].unpack('n')[0]
  BinUtils.get_sint16_be(str, i) == str[i,2].unpack('s>')[0]

  BinUtils.get_int32_be(str) == str.unpack('N')[0]
  BinUtils.get_sint32_be(str) == str.unpack('l>')[0]
  BinUtils.get_int32_be(str, i) == str[i,4].unpack('N')[0]
  BinUtils.get_sint32_be(str, i) == str[i,4].unpack('l>')[0]

  BinUtils.get_int64_be(str) == str.unpack('Q>')[0]
  BinUtils.get_sint64_be(str) == str.unpack('q>')[0]
  BinUtils.get_int64_be(str, i) == str[i,8].unpack('Q>')[0]
  BinUtils.get_sint64_be(str, i) == str[i,8].unpack('q>')[0]

  BinUtils.get_ber(str) == str.unpack('w')
  BinUtils.get_ber(str, i) == str[i..-1].unpack('w')

  BinUtils.slice_int8!(str) == str.slice!(0,1).unpack('C')[0]
  BinUtils.slice_sint8!(str) == str.slice!(0,1).unpack('c')[0]
  BinUtils.slice_int16_le!(str) == str.slice!(0,2).unpack('v')[0]
  BinUtils.slice_sint16_le!(str) == str.slice!(0,2).unpack('s<')[0]
  BinUtils.slice_int32_le!(str) == str.slice!(0,4).unpack('V')[0]
  BinUtils.slice_sint32_le!(str) == str.slice!(0,4).unpack('l<')[0]
  BinUtils.slice_int64_le!(str) == str.slice!(0,8).unpack('Q<')[0]
  BinUtils.slice_sint64_le!(str) == str.slice!(0,8).unpack('q<')[0]
  BinUtils.slice_int16_be!(str) == str.slice!(0,2).unpack('n')[0]
  BinUtils.slice_sint16_be!(str) == str.slice!(0,2).unpack('s>')[0]
  BinUtils.slice_int32_be!(str) == str.slice!(0,4).unpack('N')[0]
  BinUtils.slice_sint32_be!(str) == str.slice!(0,4).unpack('l>')[0]
  BinUtils.slice_int64_be!(str) == str.slice!(0,8).unpack('Q>')[0]
  BinUtils.slice_sint64_be!(str) == str.slice!(0,8).unpack('q>')[0]

  BinUtils.slice_ber!(str) == (v=str.unpack('w'); i=[v].pack('w').bytesize; str.slice!(0,i); v)

  BinUtils.append_int8!(str, i) # str << [i].pack('C')
  BinUtils.append_sint8!(str, i) # str << [i].pack('c')
  BinUtils.append_int16_le!(str, i) # str << [i].pack('v')
  BinUtils.append_sint16_le!(str, i) # str << [i].pack('s<')
  BinUtils.append_int32_le!(str, i) # str << [i].pack('V')
  BinUtils.append_sint32_le!(str, i) # str << [i].pack('l<')
  BinUtils.append_int64_le!(str, i) # str << [i].pack('Q<')
  BinUtils.append_sint64_le!(str, i) # str << [i].pack('q<')

  BinUtils.append_int16_be!(str, i) # str << [i].pack('n')
  BinUtils.append_sint16_be!(str, i) # str << [i].pack('s>')
  BinUtils.append_int32_be!(str, i) # str << [i].pack('N')
  BinUtils.append_sint32_be!(str, i) # str << [i].pack('l>')
  BinUtils.append_int64_be!(str, i) # str << [i].pack('Q>')
  BinUtils.append_sint64_be!(str, i) # str << [i].pack('q>')

  BinUtils.append_ber!(str, i) # str << [i].pack('w')

  BinUtils.append_bersize_int8!(str, i) # str << [1, i].pack('wC')
  BinUtils.append_bersize_sint8!(str, i) # str << [1, i].pack('wc')
  BinUtils.append_bersize_int16_le!(str, i) # str << [2, i].pack('wv')
  BinUtils.append_bersize_sint16_le!(str, i) # str << [2, i].pack('ws<')
  BinUtils.append_bersize_int32_le!(str, i) # str << [4, i].pack('wV')
  BinUtils.append_bersize_sint32_le!(str, i) # str << [4, i].pack('wl<')
  BinUtils.append_bersize_int64_le!(str, i) # str << [8, i].pack('wQ<')
  BinUtils.append_bersize_sint64_le!(str, i) # str << [8, i].pack('wq<')

  BinUtils.append_bersize_int16_be!(str, i) # str << [2, i].pack('wn')
  BinUtils.append_bersize_sint16_be!(str, i) # str << [2, i].pack('ws>')
  BinUtils.append_bersize_int32_be!(str, i) # str << [4, i].pack('wN')
  BinUtils.append_bersize_sint32_be!(str, i) # str << [4, i].pack('wl>')
  BinUtils.append_bersize_int64_be!(str, i) # str << [8, i].pack('wQ>')
  BinUtils.append_bersize_sint64_be!(str, i) # str << [8, i].pack('wq>')

  BinUtils.append_bersize_ber!(str, i) # v = [i].pack('w'); s << [v.bytesize, i].pack('ww')

  BinUtils.append_int32lesize_int8!(str, i) # str << [1, i].pack('VC')
  BinUtils.append_int32lesize_sint8!(str, i) # str << [1, i].pack('Vc')
  BinUtils.append_int32lesize_int16_le!(str, i) # str << [2, i].pack('Vv')
  BinUtils.append_int32lesize_sint16_le!(str, i) # str << [2, i].pack('Vs<')
  BinUtils.append_int32lesize_int32_le!(str, i) # str << [4, i].pack('VV')
  BinUtils.append_int32lesize_sint32_le!(str, i) # str << [4, i].pack('Vl<')
  BinUtils.append_int32lesize_int64_le!(str, i) # str << [8, i].pack('VQ<')
  BinUtils.append_int32lesize_sint64_le!(str, i) # str << [8, i].pack('Vq<')

  BinUtils.append_int32lesize_int16_be!(str, i) # str << [2, i].pack('Vn')
  BinUtils.append_int32lesize_sint16_be!(str, i) # str << [2, i].pack('Vs>')
  BinUtils.append_int32lesize_int32_be!(str, i) # str << [4, i].pack('VN')
  BinUtils.append_int32lesize_sint32_be!(str, i) # str << [4, i].pack('Vl>')
  BinUtils.append_int32lesize_int64_be!(str, i) # str << [8, i].pack('VQ>')
  BinUtils.append_int32lesize_sint64_be!(str, i) # str << [8, i].pack('Vq>')

  BinUtils.append_int32lesize_ber!(str, i) # v = [i].pack('w'); s << [v.bytesize, i].pack('Vw')

  BinUtils.append_int32besize_int8!(str, i) # str << [1, i].pack('NC')
  BinUtils.append_int32besize_sint8!(str, i) # str << [1, i].pack('Nc')
  BinUtils.append_int32besize_int16_le!(str, i) # str << [2, i].pack('Nv')
  BinUtils.append_int32besize_sint16_le!(str, i) # str << [2, i].pack('Ns<')
  BinUtils.append_int32besize_int32_le!(str, i) # str << [4, i].pack('NV')
  BinUtils.append_int32besize_sint32_le!(str, i) # str << [4, i].pack('Nl<')
  BinUtils.append_int32besize_int64_le!(str, i) # str << [8, i].pack('NQ<')
  BinUtils.append_int32besize_sint64_le!(str, i) # str << [8, i].pack('Nq<')

  BinUtils.append_int32besize_int16_be!(str, i) # str << [2, i].pack('Nn')
  BinUtils.append_int32besize_sint16_be!(str, i) # str << [2, i].pack('Ns>')
  BinUtils.append_int32besize_int32_be!(str, i) # str << [4, i].pack('NN')
  BinUtils.append_int32besize_sint32_be!(str, i) # str << [4, i].pack('Nl>')
  BinUtils.append_int32besize_int64_be!(str, i) # str << [8, i].pack('NQ>')
  BinUtils.append_int32besize_sint64_be!(str, i) # str << [8, i].pack('Nq>')

  BinUtils.append_int32besize_ber!(str, i) # v = [i].pack('w'); str << [v.bytesize, i].pack('Nw')

  BinUtils.append_string!(str, add) # str << [add].pack('a*')
  BinUtils.append_bersize_string!(str, add) # str << [add.bytesize, add].pack('wa*')
  BinUtils.append_int32lesize_string!(str, add) # str << [add.bytesize, add].pack('Va*')
  BinUtils.append_int32besize_string!(str, add) # str << [add.bytesize, add].pack('Na*')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
