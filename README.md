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

  ints = [i1, i2, ..., in]
  # Append functions can accept vararg
  BinUtils.append_int8!(str, *ints) # str << ints.pack('C*')
  BinUtils.append_int16_le!(str, *ints) # str << ints.pack('v*')
  BinUtils.append_int32_le!(str, *ints) # str << ints.pack('V*')
  BinUtils.append_int64_le!(str, *ints) # str << ints.pack('Q<*')
  BinUtils.append_int16_be!(str, *ints) # str << ints.pack('n*')
  BinUtils.append_int32_be!(str, *ints) # str << ints.pack('N*')
  BinUtils.append_int64_be!(str, *ints) # str << ints.pack('Q>*')
  BinUtils.append_ber!(str, *ints) # str << ints.pack('w*')

  # Append functions can accept single array
  BinUtils.append_int8!(str, ints) # str << ints.pack('C*')
  BinUtils.append_int16_le!(str, ints) # str << ints.pack('v*')
  BinUtils.append_int32_le!(str, ints) # str << ints.pack('V*')
  BinUtils.append_int64_le!(str, ints) # str << ints.pack('Q<*')
  BinUtils.append_int16_be!(str, ints) # str << ints.pack('n*')
  BinUtils.append_int32_be!(str, ints) # str << ints.pack('N*')
  BinUtils.append_int64_be!(str, ints) # str << ints.pack('Q>*')
  BinUtils.append_ber!(str, ints) # str << ints.pack('w*')


  # Other append functions also accept both vararg or array (but not vararg with arrays)
  # For simplicity, only vararg is shown in this example
  BinUtils.append_bersize_int8!(str, *ints) # str << [n, *ints].pack('wC*')
  BinUtils.append_bersize_int16_le!(str, *ints) # str << [n*2, *ints].pack('wv*')
  BinUtils.append_bersize_int32_le!(str, *ints) # str << [n*4, *ints].pack('wV*')
  BinUtils.append_bersize_int64_le!(str, *ints) # str << [n*8, *ints].pack('wQ<*')
  BinUtils.append_bersize_int16_be!(str, *ints) # str << [n*2, *ints].pack('wn*')
  BinUtils.append_bersize_int32_be!(str, *ints) # str << [n*4, *ints].pack('wN*')
  BinUtils.append_bersize_int64_be!(str, *ints) # str << [n*8, *ints].pack('wQ>*')
  BinUtils.append_bersize_ber!(str, *ints) # v = [*ints].pack('w*'); s << [v.bytesize, *ints].pack('ww*')

  BinUtils.append_int32size_int8_le!(str, *ints) # str << [n, *ints].pack('VC*')
  BinUtils.append_int32size_int16_le!(str, *ints) # str << [n*2, *ints].pack('Vv*')
  BinUtils.append_int32size_int32_le!(str, *ints) # str << [n*4, *ints].pack('VV*')
  BinUtils.append_int32size_int64_le!(str, *ints) # str << [n*8, *ints].pack('VQ<*')
  BinUtils.append_int32size_ber_le!(str, *ints) # v = [*ints].pack('w*'); s << [v.bytesize, *ints].pack('Vw*')

  BinUtils.append_int32size_int8_be!(str, *ints) # str << [n, *ints].pack('NC*')
  BinUtils.append_int32size_int16_be!(str, *ints) # str << [n*2, *ints].pack('Nn*')
  BinUtils.append_int32size_int32_be!(str, *ints) # str << [n*4, *ints].pack('NN*')
  BinUtils.append_int32size_int64_be!(str, *ints) # str << [n*8, *ints].pack('NQ>*')
  BinUtils.append_int32size_ber_be!(str, *ints) # v = [*ints].pack('w*'); str << [v.bytesize, *ints].pack('Nw*')

  BinUtils.append_int8_ber!(str, int, *ints) # str << [int, *ints].pack('Cw*')
  BinUtils.append_ber_int8!(str, int, *ints) # str << [int, *ints].pack('wC*')
  BinUtils.append_ber_int16_le!(str, int, *ints) # str << [int, *ints].pack('wv*')
  BinUtils.append_ber_int32_le!(str, int, *ints) # str << [int, *ints].pack('wV*')
  BinUtils.append_ber_int16_be!(str, int, *ints) # str << [int, *ints].pack('wn*')
  BinUtils.append_ber_int32_be!(str, int, *ints) # str << [int, *ints].pack('wN*')
  BinUtils.append_int16_ber_le!(str, int, *ints) # str << [int, *ints].pack('vw*')
  BinUtils.append_int32_ber_le!(str, int, *ints) # str << [int, *ints].pack('Vw*')
  BinUtils.append_int16_ber_be!(str, int, *ints) # str << [int, *ints].pack('nw*')
  BinUtils.append_int32_ber_be!(str, int, *ints) # str << [int, *ints].pack('Nw*')
  BinUtils.append_int8_int16_le!(str, int, *ints) # str << [int, *ints].pack('Cv*')
  BinUtils.append_int8_int32_le!(str, int, *ints) # str << [int, *ints].pack('CV*')
  BinUtils.append_int8_int16_be!(str, int, *ints) # str << [int, *ints].pack('Cn*')
  BinUtils.append_int8_int32_be!(str, int, *ints) # str << [int, *ints].pack('CN*')
  BinUtils.append_int16_int8_le!(str, int, *ints)  # str << [int, *ints].pack('vC*')
  BinUtils.append_int16_int32_le!(str, int, *ints) # str << [int, *ints].pack('vV*')
  BinUtils.append_int16_int8_be!(str, int, *ints)  # str << [int, *ints].pack('nC*')
  BinUtils.append_int16_int32_be!(str, int, *ints) # str << [int, *ints].pack('nN*')
  BinUtils.append_int32_int8_le!(str, int, *ints)  # str << [int, *ints].pack('VC*')
  BinUtils.append_int32_int16_le!(str, int, *ints) # str << [int, *ints].pack('Vv*')
  BinUtils.append_int32_int8_be!(str, int, *ints)  # str << [int, *ints].pack('NC*')
  BinUtils.append_int32_int16_be!(str, int, *ints) # str << [int, *ints].pack('Nn*')

  # String append functions do not accepts varargs nor array
  # Only single string is accepted
  BinUtils.append_string!(str, add) # str << [add].pack('a*')
  BinUtils.append_bersize_string!(str, add) # str << [add.bytesize, add].pack('wa*')
  BinUtils.append_int32size_string_le!(str, add) # str << [add.bytesize, add].pack('Va*')
  BinUtils.append_int32size_string_be!(str, add) # str << [add.bytesize, add].pack('Na*')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
