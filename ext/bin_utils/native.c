#include <ruby.h>

#if HAVE_STDINT_H
#include "stdint.h"
#elif defined(_MSC_VER)
typedef __int8 int8_t;
typedef unsigned __int8 uint8_t;
typedef __int16 int16_t;
typedef unsigned __int16 uint16_t;
typedef __int32 int32_t;
typedef unsigned __int32 uint32_t;
typedef __int64 int64_t;
typedef unsigned __int64 uint64_t;
#else
typedef char int8_t;
typedef unsigned char uint8_t;
typedef short int16_t;
typedef unsigned short uint16_t;
typedef int int32_t;
typedef unsigned int uint32_t;
#if SIZEOF_LONG==8
typedef long int64_t;
typedef unsigned long uint64_t;
#else
typedef long long int64_t;
typedef unsigned long long uint64_t;
#endif
#endif

#ifdef __GNUC__
#define FORCE_INLINE __attribute__((always_inline))
#elif defined(_MSC_VER)
#define FORCE_INLINE  __forceinline
#else
#define FORCE_INLINE
#endif

#if defined(_MSC_VER)
#define LL(x) (x)
#define LLU(x) (x)
#else
#define LL(x) (x##LL)
#define LLU(x) (x##LLU)
#endif

#define GCC_VERSION_SINCE(major, minor, patchlevel) \
   (defined(__GNUC__) && !defined(__INTEL_COMPILER) && \
    ((__GNUC__ > (major)) ||  \
     (__GNUC__ == (major) && __GNUC_MINOR__ > (minor)) || \
     (__GNUC__ == (major) && __GNUC_MINOR__ == (minor) && __GNUC_PATCHLEVEL__ >= (patchlevel))))

#if GCC_VERSION_SINCE(4,3,0)
# define swap16(x) __builtin_bswap16(x)
# define swap32(x) __builtin_bswap32(x)
# define swap64(x) __builtin_bswap64(x)
#endif

#ifndef swap16
# define swap16(x)	((((x)&0xFF)<<8)	\
			|(((x)>>8)&0xFF)
#endif

#ifndef swap32
# define swap32(x)	((((x)&0xFF)<<24)	\
			|(((x)>>24)&0xFF)	\
			|(((x)&0x0000FF00)<<8)	\
			|(((x)&0x00FF0000)>>8)	)
#endif

#ifndef swap64
static inline FORCE_INLINE uint64_t
swap64(uint64_t x) {
    x = (x>>32) | (x << 32);
    x = ((x & LLU(0xFFFF0000FFFF0000)) >> 16) |
        ((x & LLU(0x0000FFFF0000FFFF)) << 16);
    return ((x & LLU(0xFF00FF00FF00FF00)) >> 8) |
           ((x & LLU(0x00FF00FF00FF00FF)) << 8);
}
#endif


static long
check_size(long i, long strlen, long ilen)
{
    if (i < 0) { i += strlen; }
    if (i > strlen - ilen || i < 0) {
        rb_raise(rb_eArgError, "index %ld be in range 0..%ld or in range -%ld..-%ld for string of size %ld", i, strlen-ilen, strlen, -ilen, strlen);
    }
    return i;
}

static int32_t
get_int8(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 1);
    return (uint8_t)(RSTRING_PTR(rstr)[i]);
}

static int32_t
get_sint8(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 1);
    return (int8_t)(RSTRING_PTR(rstr)[i]);
}

static int32_t
get_int16_le(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1;
    int32_t res;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 2);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    byte0 = ptr[i];
    byte1 = ptr[i+1];
    return byte0 + (byte1 << 8);
}

static int32_t
get_sint16_le(VALUE rstr, VALUE ri)
{
    int32_t res = get_int16_le(rstr, ri);
    return res - ((res >> 15)<<16);
}

static int32_t
get_int16_be(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 2);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    byte0 = ptr[i+1];
    byte1 = ptr[i];
    return byte0 + (byte1 << 8);
}

static int32_t
get_sint16_be(VALUE rstr, VALUE ri)
{
    int32_t res = get_int16_be(rstr, ri);
    return res - ((res >> 15) << 16);
}

static int32_t
get_int24_le(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1, byte2;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 3);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    byte0 = ptr[i];
    byte1 = ptr[i+1];
    byte2 = ptr[i+2];
    return byte0 + (byte1 << 8) + (byte2 << 16);
}

static int32_t
get_sint24_le(VALUE rstr, VALUE ri)
{
    int32_t res = get_int24_le(rstr, ri);
    return res - ((res >> 23) << 24);
}

static int32_t
get_int24_be(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1, byte2;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 3);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    byte0 = ptr[i+2];
    byte1 = ptr[i+1];
    byte2 = ptr[i];
    return byte0 + (byte1 << 8) + (byte2 << 16);
}

static int32_t
get_sint24_be(VALUE rstr, VALUE ri)
{
    int32_t res = get_int24_be(rstr, ri);
    return res - ((res >> 23) << 24);
}

static uint32_t
get_int32_le(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1, byte2, byte3;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 4);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    
    byte0 = ptr[i];
    byte1 = ptr[i+1];
    byte2 = ptr[i+2];
    byte3 = ptr[i+3];
    return byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24);
}

static int32_t
get_sint32_le(VALUE rstr, VALUE ri)
{
    return (int32_t)get_int32_le(rstr, ri);
}

static uint32_t
get_int32_be(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1, byte2, byte3;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 4);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    byte0 = ptr[i+3];
    byte1 = ptr[i+2];
    byte2 = ptr[i+1];
    byte3 = ptr[i+0];
    return byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24);
}

static int32_t
get_sint32_be(VALUE rstr, VALUE ri)
{
    return (int32_t)get_int32_be(rstr, ri);
}

#if SIZEOF_LONG == 8
#define I642NUM(v) LONG2NUM(v)
#define U642NUM(v) ULONG2NUM(v)
#else
#define I642NUM(v) LL2NUM(v)
#define U642NUM(v) ULL2NUM(v)
#endif

static int64_t
get_int40_le(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1, byte2, byte3;
    int64_t res;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 5);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    
    byte0 = ptr[i];
    byte1 = ptr[i+1];
    byte2 = ptr[i+2];
    byte3 = ptr[i+3];
    res = byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24);
    byte0 = ptr[i+4];
    return res + ((int64_t)byte0 << 32);
}

static int64_t
get_sint40_le(VALUE rstr, VALUE ri)
{
    int64_t res = get_int40_le(rstr, ri);
    return res - ((res >> 39) << 40);
}

static int64_t
get_int40_be(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1, byte2, byte3;
    int64_t res;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 5);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    
    byte0 = ptr[i+4];
    byte1 = ptr[i+3];
    byte2 = ptr[i+2];
    byte3 = ptr[i+1];
    res = byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24);
    byte0 = ptr[i];
    return res + ((int64_t)byte0 << 32);
}

static int64_t
get_sint40_be(VALUE rstr, VALUE ri)
{
    int64_t res = get_int40_be(rstr, ri);
    return res - ((res >> 39) << 40);
}

static int64_t
get_int48_le(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1, byte2, byte3;
    int64_t res, res1;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 6);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    
    byte0 = ptr[i];
    byte1 = ptr[i+1];
    byte2 = ptr[i+2];
    byte3 = ptr[i+3];
    res = byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24);
    byte0 = ptr[i+4];
    byte1 = ptr[i+5];
    res1 = byte0 + (byte1 << 8);
    return res + (res1 << 32);
}

static int64_t
get_sint48_le(VALUE rstr, VALUE ri)
{
    int64_t res = get_int48_le(rstr, ri);
    return res - ((res >> 47) << 48);
}

static int64_t
get_int48_be(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1, byte2, byte3;
    int64_t res, res1;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 6);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    
    byte0 = ptr[i+5];
    byte1 = ptr[i+4];
    byte2 = ptr[i+3];
    byte3 = ptr[i+2];
    res = byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24);
    byte0 = ptr[i+1];
    byte1 = ptr[i+0];
    res1 = byte0 + (byte1 << 8);
    return res + (res1 << 32);
}

static int64_t
get_sint48_be(VALUE rstr, VALUE ri)
{
    int64_t res = get_int48_be(rstr, ri);
    return res - ((res >> 47) << 48);
}

static int64_t
get_int56_le(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1, byte2, byte3;
    int64_t res, res1;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 7);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    
    byte0 = ptr[i];
    byte1 = ptr[i+1];
    byte2 = ptr[i+2];
    byte3 = ptr[i+3];
    res = byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24);
    byte0 = ptr[i+4];
    byte1 = ptr[i+5];
    byte2 = ptr[i+6];
    res1 = byte0 + (byte1 << 8) + (byte2 << 16);
    return res + (res1 << 32);
}

static int64_t
get_sint56_le(VALUE rstr, VALUE ri)
{
    int64_t res = get_int56_le(rstr, ri);
    return res - ((res >> 55) << 56);
}

static int64_t
get_int56_be(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1, byte2, byte3;
    int64_t res, res1;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 7);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    
    byte0 = ptr[i+6];
    byte1 = ptr[i+5];
    byte2 = ptr[i+4];
    byte3 = ptr[i+3];
    res = byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24);
    byte0 = ptr[i+2];
    byte1 = ptr[i+1];
    byte2 = ptr[i];
    res1 = byte0 + (byte1 << 8) + (byte2 << 16);
    return res + (res1 << 32);
}

static int64_t
get_sint56_be(VALUE rstr, VALUE ri)
{
    int64_t res = get_int56_be(rstr, ri);
    return res - ((res >> 55) << 56);
}

static uint64_t
get_int64_le(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1, byte2, byte3;
    int64_t res, res1;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 8);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    
    byte0 = ptr[i];
    byte1 = ptr[i+1];
    byte2 = ptr[i+2];
    byte3 = ptr[i+3];
    res = byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24);
    byte0 = ptr[i+4];
    byte1 = ptr[i+5];
    byte2 = ptr[i+6];
    byte3 = ptr[i+7];
    res1 = byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24);
    return res + (res1 << 32);
}

static int64_t
get_sint64_le(VALUE rstr, VALUE ri)
{
    return (int64_t)get_int64_le(rstr, ri);
}

static uint64_t
get_int64_be(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri);
    const uint8_t *ptr;
    uint32_t byte0, byte1, byte2, byte3;
    int64_t res, res1;
    StringValue(rstr);
    i = check_size(i, RSTRING_LEN(rstr), 8);
    ptr = (const uint8_t*)RSTRING_PTR(rstr);
    
    byte0 = ptr[i+7];
    byte1 = ptr[i+6];
    byte2 = ptr[i+5];
    byte3 = ptr[i+4];
    res = byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24);
    byte0 = ptr[i+3];
    byte1 = ptr[i+2];
    byte2 = ptr[i+1];
    byte3 = ptr[i];
    res1 = byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24);
    return res + (res1 << 32);
}

static int64_t
get_sint64_be(VALUE rstr, VALUE ri)
{
    return (int64_t)get_int64_be(rstr, ri);
}

static uint64_t
parse_ber(const uint8_t *ptr, long max, long *i)
{
    uint64_t res = 0;
    while (1) {
        if (*ptr < 128) {
            res += *ptr;
            break;
        }
        if (res > LLU(0xFFFFFFFFFFFFFFFF) / 128) {
            rb_raise(rb_eArgError, "BER integer is greater then 2**64, could not parse such big");
        }
        res = (res + ((*ptr) - 128)) * 128;
        ptr++;
        if (++(*i) >= max) {
            rb_raise(rb_eArgError, "String unexpectedly finished while parsing BER integer");
        }
    }
    return res;
}

static uint64_t
get_ber(VALUE rstr, VALUE ri)
{
    long i = NUM2LONG(ri), len;
    const uint8_t *ptr;
    StringValue(rstr);
    len = RSTRING_LEN(rstr);
    i = check_size(i, len, 1);
    ptr = RSTRING_PTR(rstr) + i;
    return parse_ber(ptr, len, &i);
}

static VALUE
check_argc(int argc, VALUE *argv)
{
    if (argc == 0 || argc > 2) {
        rb_raise(rb_eArgError, "accepts 1 or 2 arguments: (string[, offset=0])");
    }
    return argc == 2 ? argv[1] : INT2FIX(0);
}

static VALUE
rb_get_int8(int argc, VALUE *argv, VALUE self)
{
    return INT2FIX(get_int8(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint8(int argc, VALUE *argv, VALUE self)
{
    return INT2FIX(get_sint8(argv[0], check_argc(argc, argv)));
}


static VALUE
rb_get_int16_le(int argc, VALUE *argv, VALUE self)
{
    return INT2FIX(get_int16_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint16_le(int argc, VALUE *argv, VALUE self)
{
    return INT2FIX(get_sint16_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int16_be(int argc, VALUE *argv, VALUE self)
{
    return INT2FIX(get_int16_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint16_be(int argc, VALUE *argv, VALUE self)
{
    return INT2FIX(get_sint16_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int24_le(int argc, VALUE *argv, VALUE self)
{
    return INT2FIX(get_int24_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint24_le(int argc, VALUE *argv, VALUE self)
{
    return INT2FIX(get_sint24_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int24_be(int argc, VALUE *argv, VALUE self)
{
    return INT2FIX(get_int24_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint24_be(int argc, VALUE *argv, VALUE self)
{
    return INT2FIX(get_sint24_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int32_le(int argc, VALUE *argv, VALUE self)
{
    return UINT2NUM(get_int32_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint32_le(int argc, VALUE *argv, VALUE self)
{
    return INT2NUM(get_sint32_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int32_be(int argc, VALUE *argv, VALUE self)
{
    return UINT2NUM(get_int32_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint32_be(int argc, VALUE *argv, VALUE self)
{
    return INT2NUM(get_sint32_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int40_le(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_int40_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint40_le(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_sint40_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int40_be(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_int40_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint40_be(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_sint40_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int48_le(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_int48_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint48_le(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_sint48_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int48_be(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_int48_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint48_be(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_sint48_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int56_le(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_int56_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint56_le(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_sint56_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int56_be(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_int56_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint56_be(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_sint56_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int64_le(int argc, VALUE *argv, VALUE self)
{
    return U642NUM(get_int64_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint64_le(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_sint64_le(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_int64_be(int argc, VALUE *argv, VALUE self)
{
    return U642NUM(get_int64_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_sint64_be(int argc, VALUE *argv, VALUE self)
{
    return I642NUM(get_sint64_be(argv[0], check_argc(argc, argv)));
}

static VALUE
rb_get_ber(int argc, VALUE *argv, VALUE self)
{
    return U642NUM(get_ber(argv[0], check_argc(argc, argv)));
}

void
Init_native_bin_utils()
{
    VALUE mod_bin_utils = rb_define_module("BinUtils");
    VALUE mod_native = rb_define_module_under(mod_bin_utils, "Native");

    rb_define_method(mod_native, "get_ber", rb_get_ber, -1);
    rb_define_method(mod_native, "get_int8", rb_get_int8, -1);
    rb_define_method(mod_native, "get_sint8", rb_get_sint8, -1);
    rb_define_method(mod_native, "get_int16_le", rb_get_int16_le, -1);
    rb_define_method(mod_native, "get_sint16_le", rb_get_sint16_le, -1);
    rb_define_method(mod_native, "get_int16_be", rb_get_int16_be, -1);
    rb_define_method(mod_native, "get_sint16_be", rb_get_sint16_be, -1);
    rb_define_method(mod_native, "get_int24_le", rb_get_int24_le, -1);
    rb_define_method(mod_native, "get_sint24_le", rb_get_sint24_le, -1);
    rb_define_method(mod_native, "get_int24_be", rb_get_int24_be, -1);
    rb_define_method(mod_native, "get_sint24_be", rb_get_sint24_be, -1);
    rb_define_method(mod_native, "get_int32_le", rb_get_int32_le, -1);
    rb_define_method(mod_native, "get_sint32_le", rb_get_sint32_le, -1);
    rb_define_method(mod_native, "get_int32_be", rb_get_int32_be, -1);
    rb_define_method(mod_native, "get_sint32_be", rb_get_sint32_be, -1);
    rb_define_method(mod_native, "get_int40_le", rb_get_int40_le, -1);
    rb_define_method(mod_native, "get_sint40_le", rb_get_sint40_le, -1);
    rb_define_method(mod_native, "get_int40_be", rb_get_int40_be, -1);
    rb_define_method(mod_native, "get_sint40_be", rb_get_sint40_be, -1);
    rb_define_method(mod_native, "get_int48_le", rb_get_int48_le, -1);
    rb_define_method(mod_native, "get_sint48_le", rb_get_sint48_le, -1);
    rb_define_method(mod_native, "get_int48_be", rb_get_int48_be, -1);
    rb_define_method(mod_native, "get_sint48_be", rb_get_sint48_be, -1);
    rb_define_method(mod_native, "get_int56_le", rb_get_int56_le, -1);
    rb_define_method(mod_native, "get_sint56_le", rb_get_sint56_le, -1);
    rb_define_method(mod_native, "get_int56_be", rb_get_int56_be, -1);
    rb_define_method(mod_native, "get_sint56_be", rb_get_sint56_be, -1);
    rb_define_method(mod_native, "get_int64_le", rb_get_int64_le, -1);
    rb_define_method(mod_native, "get_sint64_le", rb_get_sint64_le, -1);
    rb_define_method(mod_native, "get_int64_be", rb_get_int64_be, -1);
    rb_define_method(mod_native, "get_sint64_be", rb_get_sint64_be, -1);
    rb_extend_object(mod_native, mod_native);
}
