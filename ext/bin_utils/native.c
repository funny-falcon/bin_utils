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

#if SIZEOF_LONG == 8
#define I642NUM(v) LONG2NUM(v)
#define U642NUM(v) ULONG2NUM(v)
#define NUM2I64(v) NUM2LONG(v)
#define NUM2U64(v) NUM2ULONG(v)
#else
#define I642NUM(v) LL2NUM(v)
#define U642NUM(v) ULL2NUM(v)
#define NUM2I64(v) NUM2LL(v)
#define NUM2U64(v) NUM2ULL(v)
#endif

ID rshft;
ID band;

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

static int64_t
safe_int64_t(VALUE i)
{
    if (FIXNUM_P(i)) {
        return NUM2I64(i);
    }
    else {
        VALUE argm = UINT2NUM(0xffffffff);
        VALUE arg32 = INT2FIX(32);
        uint64_t i0 = NUM2I64(rb_funcall2(i, band, 1, &argm));
        i = rb_funcall2(i, rshft, 1, &arg32);
        return i0 + (NUM2I64(rb_funcall2(i, band, 1, &argm)) << 32);
    }
}

static VALUE
check_argc(int argc, VALUE *argv)
{
    if (argc == 0 || argc > 2) {
        rb_raise(rb_eArgError, "accepts 1 or 2 arguments: (string[, offset=0])");
    }
    return argc == 2 ? argv[1] : INT2FIX(0);
}

/**** GET ****/
/**** 32bit ***/
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
/*** 32BIT END ***/

/*** 64BIT ***/
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
/*** 64BIT END ***/

static VALUE
rb_get_ber(int argc, VALUE *argv, VALUE self)
{
    return U642NUM(get_ber(argv[0], check_argc(argc, argv)));
}
/** GET END **/

/** SLICE **/
/*** 32BIT ***/
static VALUE
rb_slice_int8(VALUE self, VALUE rstr)
{
    int32_t res = get_int8(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 1);
    return INT2FIX(res);
}

static VALUE
rb_slice_sint8(VALUE self, VALUE rstr)
{
    int32_t res = get_sint8(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 1);
    return INT2FIX(res);
}

static VALUE
rb_slice_int16_le(VALUE self, VALUE rstr)
{
    int32_t res = get_int16_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 2);
    return INT2FIX(res);
}

static VALUE
rb_slice_sint16_le(VALUE self, VALUE rstr)
{
    int32_t res = get_sint16_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 2);
    return INT2FIX(res);
}

static VALUE
rb_slice_int16_be(VALUE self, VALUE rstr)
{
    int32_t res = get_int16_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 2);
    return INT2FIX(res);
}

static VALUE
rb_slice_sint16_be(VALUE self, VALUE rstr)
{
    int32_t res = get_sint16_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 2);
    return INT2FIX(res);
}

static VALUE
rb_slice_int24_le(VALUE self, VALUE rstr)
{
    int32_t res = get_int24_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 3);
    return INT2FIX(res);
}

static VALUE
rb_slice_sint24_le(VALUE self, VALUE rstr)
{
    int32_t res = get_sint24_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 3);
    return INT2FIX(res);
}

static VALUE
rb_slice_int24_be(VALUE self, VALUE rstr)
{
    int32_t res = get_int24_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 3);
    return INT2FIX(res);
}

static VALUE
rb_slice_sint24_be(VALUE self, VALUE rstr)
{
    int32_t res = get_sint24_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 3);
    return INT2FIX(res);
}

static VALUE
rb_slice_int32_le(VALUE self, VALUE rstr)
{
    uint32_t res = get_int32_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 4);
    return UINT2NUM(res);
}

static VALUE
rb_slice_sint32_le(VALUE self, VALUE rstr)
{
    int32_t res = get_sint32_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 4);
    return INT2NUM(res);
}

static VALUE
rb_slice_int32_be(VALUE self, VALUE rstr)
{
    uint32_t res = get_int32_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 4);
    return UINT2NUM(res);
}

static VALUE
rb_slice_sint32_be(VALUE self, VALUE rstr)
{
    int32_t res = get_sint32_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 4);
    return INT2NUM(res);
}
/*** 32BIT END ***/

/*** 64BIT ***/
static VALUE
rb_slice_int40_le(VALUE self, VALUE rstr)
{
    int64_t res = get_int40_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 5);
    return I642NUM(res);
}

static VALUE
rb_slice_sint40_le(VALUE self, VALUE rstr)
{
    int64_t res = get_sint40_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 5);
    return I642NUM(res);
}

static VALUE
rb_slice_int40_be(VALUE self, VALUE rstr)
{
    int64_t res = get_int40_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 5);
    return I642NUM(res);
}

static VALUE
rb_slice_sint40_be(VALUE self, VALUE rstr)
{
    int64_t res = get_sint40_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 5);
    return I642NUM(res);
}

static VALUE
rb_slice_int48_le(VALUE self, VALUE rstr)
{
    int64_t res = get_int48_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 6);
    return I642NUM(res);
}

static VALUE
rb_slice_sint48_le(VALUE self, VALUE rstr)
{
    int64_t res = get_sint48_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 6);
    return I642NUM(res);
}

static VALUE
rb_slice_int48_be(VALUE self, VALUE rstr)
{
    int64_t res = get_int48_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 6);
    return I642NUM(res);
}

static VALUE
rb_slice_sint48_be(VALUE self, VALUE rstr)
{
    int64_t res = get_sint48_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 6);
    return I642NUM(res);
}

static VALUE
rb_slice_int56_le(VALUE self, VALUE rstr)
{
    int64_t res = get_int56_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 7);
    return I642NUM(res);
}

static VALUE
rb_slice_sint56_le(VALUE self, VALUE rstr)
{
    int64_t res = get_sint56_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 7);
    return I642NUM(res);
}

static VALUE
rb_slice_int56_be(VALUE self, VALUE rstr)
{
    int64_t res = get_int56_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 7);
    return I642NUM(res);
}

static VALUE
rb_slice_sint56_be(VALUE self, VALUE rstr)
{
    int64_t res = get_sint56_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 7);
    return I642NUM(res);
}

static VALUE
rb_slice_int64_le(VALUE self, VALUE rstr)
{
    uint64_t res = get_int64_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 8);
    return U642NUM(res);
}

static VALUE
rb_slice_sint64_le(VALUE self, VALUE rstr)
{
    int64_t res = get_sint64_le(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 8);
    return I642NUM(res);
}

static VALUE
rb_slice_int64_be(VALUE self, VALUE rstr)
{
    uint64_t res = get_int64_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 8);
    return U642NUM(res);
}

static VALUE
rb_slice_sint64_be(VALUE self, VALUE rstr)
{
    int64_t res = get_sint64_be(rstr, INT2FIX(0));
    rb_str_drop_bytes(rstr, 8);
    return I642NUM(res);
}
/*** 64BIT END ***/

static uint64_t
slice_ber(VALUE rstr, long *i)
{
    long len;
    const uint8_t *ptr;
    StringValue(rstr);
    len = RSTRING_LEN(rstr);
    ptr = RSTRING_PTR(rstr);
    return parse_ber(ptr, len, i);
}

static VALUE
rb_slice_ber(VALUE self, VALUE rstr)
{
    long i = 0;
    int64_t res = slice_ber(rstr, &i);
    rb_str_drop_bytes(rstr, i+1);
    return U642NUM(res);
}
/** SLICE END **/

/** APPEND **/
static void
append_int8(VALUE rstr, int32_t v)
{
    char a[1] = {v & 255};
    rb_str_cat(rstr, a, 1);
}

static void
append_int16_le(VALUE rstr, int32_t v)
{
    char a[2] = {v & 255, (v >> 8) & 255};
    rb_str_cat(rstr, a, 2);
}

static void
append_int16_be(VALUE rstr, int32_t v)
{
    char a[2] = {(v >> 8) & 255, v & 255};
    rb_str_cat(rstr, a, 2);
}

static void
append_int24_le(VALUE rstr, int32_t v)
{
    char a[3] = {v & 255, (v >> 8) & 255, (v >> 16) & 255};
    rb_str_cat(rstr, a, 3);
}

static void
append_int24_be(VALUE rstr, int32_t v)
{
    char a[3] = {(v >> 16) & 255, (v >> 8) & 255, v & 255};
    rb_str_cat(rstr, a, 3);
}

static void
append_int32_le(VALUE rstr, int32_t v)
{
    char a[4] = {v & 255, (v >> 8) & 255, (v >> 16) & 255, (v >> 24) & 255};
    rb_str_cat(rstr, a, 4);
}

static void
append_int32_be(VALUE rstr, int32_t v)
{
    char a[4] = {(v >> 24) & 255, (v >> 16) & 255, (v >> 8) & 255, v & 255};
    rb_str_cat(rstr, a, 4);
}

static void
append_int40_le(VALUE rstr, int64_t v)
{
    char a[5] = {v & 255, (v >> 8) & 255, (v >> 16) & 255, (v >> 24) & 255,
                 (v >> 32) & 255};
    rb_str_cat(rstr, a, 5);
}

static void
append_int40_be(VALUE rstr, int64_t v)
{
    char a[5] = {(v >> 32) & 255,
                 (v >> 24) & 255, (v >> 16) & 255, (v >> 8) & 255, v & 255};
    rb_str_cat(rstr, a, 5);
}

static void
append_int48_le(VALUE rstr, int64_t v)
{
    char a[6] = {v & 255, (v >> 8) & 255, (v >> 16) & 255, (v >> 24) & 255,
                 (v >> 32) & 255, (v >> 40) & 255};
    rb_str_cat(rstr, a, 6);
}

static void
append_int48_be(VALUE rstr, int64_t v)
{
    char a[6] = {(v >> 40) & 255, (v >> 32) & 255,
                 (v >> 24) & 255, (v >> 16) & 255, (v >> 8) & 255, v & 255};
    rb_str_cat(rstr, a, 6);
}

static void
append_int56_le(VALUE rstr, int64_t v)
{
    char a[7] = {v & 255, (v >> 8) & 255, (v >> 16) & 255, (v >> 24) & 255,
                 (v >> 32) & 255, (v >> 40) & 255, (v >> 48) & 255};
    rb_str_cat(rstr, a, 7);
}

static void
append_int56_be(VALUE rstr, int64_t v)
{
    char a[7] = {(v >> 48) & 255, (v >> 40) & 255, (v >> 32) & 255,
                 (v >> 24) & 255, (v >> 16) & 255, (v >> 8) & 255, v & 255};
    rb_str_cat(rstr, a, 7);
}

static void
append_int64_le(VALUE rstr, int64_t v)
{
    char a[8] = {v & 255, (v >> 8) & 255, (v >> 16) & 255, (v >> 24) & 255,
                 (v >> 32) & 255, (v >> 40) & 255, (v >> 48) & 255, (v >> 56) & 255};
    rb_str_cat(rstr, a, 8);
}

static void
append_int64_be(VALUE rstr, int64_t v)
{
    char a[8] = {(v >> 56) & 255, (v >> 48) & 255, (v >> 40) & 255, (v >> 32) & 255,
                 (v >> 24) & 255, (v >> 16) & 255, (v >> 8) & 255, v & 255};
    rb_str_cat(rstr, a, 8);
}

static int
append_ber(VALUE rstr, uint64_t ber)
{
    int i = 10;
    char a[11] = {128, 128, 128, 128,
                  128, 128 ,128 ,128,
                  128, 128, 0};
    do {
        a[i] += ber % 128;
        ber /= 128;
        i--;
    } while (ber);
    i++;
    rb_str_cat(rstr, a+i, 11-i);
    
    return 11-i;
}

static void
check_argc_append(int argc, int bits)
{
    if (argc < 1) {
        rb_raise(rb_eArgError, "accepts at least 1 argument: (string[, *int%ds])", bits);
    }
}

static void
check_argc_append_2(int argc, int bits, int bits1)
{
    if (argc <= 1) {
        rb_raise(rb_eArgError, "accepts at least 2 arguments: (string, int%d[, *int%ds])", bits, bits1);
    }
}

/*** 32BIT **/
static VALUE
rb_append_int8(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 8);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int8(str, NUM2INT(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int16_le(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 16);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int16_le(str, NUM2INT(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int24_le(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 24);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int24_le(str, NUM2INT(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int32_le(int argc, VALUE* argv, VALUE self)
{
    VALUE str = argv[0];
    int i;
    for(i = 1; i < argc; i++) {
        append_int32_le(str, (int32_t)NUM2I64(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int16_be(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 16);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int16_be(str, NUM2INT(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int24_be(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 24);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int24_be(str, NUM2INT(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int32_be(int argc, VALUE* argv, VALUE self)
{
    VALUE str = argv[0];
    int i;
    for(i = 1; i < argc; i++) {
        append_int32_be(str, (int32_t)NUM2I64(argv[i]));
    }
    return str;
}
/*** 32BIT END ***/

/*** 64BIT ***/
static VALUE
rb_append_int40_le(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 40);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int40_le(str, NUM2I64(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int48_le(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 48);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int48_le(str, NUM2I64(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int56_le(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 56);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int56_le(str, NUM2I64(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int64_le(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 64);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int64_le(str, safe_int64_t(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int40_be(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 40);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int40_be(str, NUM2I64(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int48_be(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 48);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int48_be(str, NUM2I64(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int56_be(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 56);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int56_be(str, NUM2I64(argv[i]));
    }
    return str;
}

static VALUE
rb_append_int64_be(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 64);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_int64_be(str, safe_int64_t(argv[i]));
    }
    return str;
}
/*** 64BIT END **/

/** APPEND END **/

/** APPEND BERSIZE **/
static VALUE
rb_append_bersize_int8(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 8);
    append_ber(argv[0], (argc-1));
    return rb_append_int8(argc, argv, self);
}

static VALUE
rb_append_bersize_int16_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 16);
    append_ber(argv[0], (argc-1)*2);
    return rb_append_int16_le(argc, argv, self);
}

static VALUE
rb_append_bersize_int24_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 24);
    append_ber(argv[0], (argc-1)*3);
    return rb_append_int24_le(argc, argv, self);
}

static VALUE
rb_append_bersize_int32_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 32);
    append_ber(argv[0], (argc-1)*4);
    return rb_append_int32_le(argc, argv, self);
}

static VALUE
rb_append_bersize_int40_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 40);
    append_ber(argv[0], (argc-1)*5);
    return rb_append_int40_le(argc, argv, self);
}

static VALUE
rb_append_bersize_int48_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 48);
    append_ber(argv[0], (argc-1)*6);
    return rb_append_int48_le(argc, argv, self);
}

static VALUE
rb_append_bersize_int56_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 56);
    append_ber(argv[0], (argc-1)*7);
    return rb_append_int56_le(argc, argv, self);
}

static VALUE
rb_append_bersize_int64_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 64);
    append_ber(argv[0], (argc-1)*8);
    return rb_append_int64_le(argc, argv, self);
}

static VALUE
rb_append_bersize_int16_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 16);
    append_ber(argv[0], (argc-1)*2);
    return rb_append_int16_be(argc, argv, self);
}

static VALUE
rb_append_bersize_int24_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 24);
    append_ber(argv[0], (argc-1)*3);
    return rb_append_int24_be(argc, argv, self);
}

static VALUE
rb_append_bersize_int32_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 32);
    append_ber(argv[0], (argc-1)*4);
    return rb_append_int32_be(argc, argv, self);
}

static VALUE
rb_append_bersize_int40_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 40);
    append_ber(argv[0], (argc-1)*5);
    return rb_append_int40_be(argc, argv, self);
}

static VALUE
rb_append_bersize_int48_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 48);
    append_ber(argv[0], (argc-1)*6);
    return rb_append_int48_be(argc, argv, self);
}

static VALUE
rb_append_bersize_int56_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 56);
    append_ber(argv[0], (argc-1)*7);
    return rb_append_int56_be(argc, argv, self);
}

static VALUE
rb_append_bersize_int64_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 64);
    append_ber(argv[0], (argc-1)*8);
    return rb_append_int64_be(argc, argv, self);
}
/** APPEND BERSIZE END **/

/** APPEND INT32SIZE **/
static VALUE
rb_append_int32size_int8_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 8);
    append_int32_le(argv[0], (argc-1));
    return rb_append_int8(argc, argv, self);
}

static VALUE
rb_append_int32size_int16_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 16);
    append_int32_le(argv[0], (argc-1)*2);
    return rb_append_int16_le(argc, argv, self);
}

static VALUE
rb_append_int32size_int24_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 24);
    append_int32_le(argv[0], (argc-1)*3);
    return rb_append_int24_le(argc, argv, self);
}

static VALUE
rb_append_int32size_int32_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 32);
    append_int32_le(argv[0], (argc-1)*4);
    return rb_append_int32_le(argc, argv, self);
}

static VALUE
rb_append_int32size_int40_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 40);
    append_int32_le(argv[0], (argc-1)*5);
    return rb_append_int40_le(argc, argv, self);
}

static VALUE
rb_append_int32size_int48_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 48);
    append_int32_le(argv[0], (argc-1)*6);
    return rb_append_int48_le(argc, argv, self);
}

static VALUE
rb_append_int32size_int56_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 56);
    append_int32_le(argv[0], (argc-1)*7);
    return rb_append_int56_le(argc, argv, self);
}

static VALUE
rb_append_int32size_int64_le(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 64);
    append_int32_le(argv[0], (argc-1)*8);
    return rb_append_int64_le(argc, argv, self);
}

static VALUE
rb_append_int32size_int8_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 8);
    append_int32_be(argv[0], (argc-1));
    return rb_append_int8(argc, argv, self);
}

static VALUE
rb_append_int32size_int16_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 16);
    append_int32_be(argv[0], (argc-1)*2);
    return rb_append_int16_be(argc, argv, self);
}

static VALUE
rb_append_int32size_int24_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 24);
    append_int32_be(argv[0], (argc-1)*3);
    return rb_append_int24_be(argc, argv, self);
}

static VALUE
rb_append_int32size_int32_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 32);
    append_int32_be(argv[0], (argc-1)*4);
    return rb_append_int32_be(argc, argv, self);
}

static VALUE
rb_append_int32size_int40_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 40);
    append_int32_be(argv[0], (argc-1)*5);
    return rb_append_int40_be(argc, argv, self);
}

static VALUE
rb_append_int32size_int48_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 48);
    append_int32_be(argv[0], (argc-1)*6);
    return rb_append_int48_be(argc, argv, self);
}

static VALUE
rb_append_int32size_int56_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 56);
    append_int32_be(argv[0], (argc-1)*7);
    return rb_append_int56_be(argc, argv, self);
}

static VALUE
rb_append_int32size_int64_be(int argc, VALUE* argv, VALUE self)
{
    check_argc_append(argc, 64);
    append_int32_be(argv[0], (argc-1)*8);
    return rb_append_int64_be(argc, argv, self);
}
/** APPEND BERSIZE END **/
/** APPEND INT32SIZE END **/

/** APPEND BER **/

static VALUE
rb_append_ber(int argc, VALUE* argv, VALUE self)
{
    VALUE str; int i;
    check_argc_append(argc, 0);
    str = argv[0];
    for(i = 1; i < argc; i++) {
        append_ber(str, safe_int64_t(argv[i]));
    }
    return str;
}

static VALUE rb_append_bersize_string(VALUE self, VALUE str, VALUE add);

static const char zeros[4] = {0, 0, 0, 0};
static VALUE
rb_append_bersize_ber(int argc, VALUE* argv, VALUE self)
{
    VALUE str, add_str;
    int i;
    check_argc_append(argc, 0);
    str = argv[0];
    add_str = rb_str_tmp_new(0);
    for(i = 1; i < argc; i++) {
        append_ber(add_str, safe_int64_t(argv[i]));
    }
    return rb_append_bersize_string(self, str, add_str);
}

static VALUE
rb_append_int32size_ber_le(int argc, VALUE* argv, VALUE self)
{
    VALUE str;
    int i, bs=0, ss;
    uint8_t *ptr;
    check_argc_append(argc, 0);
    str = argv[0];
    rb_str_cat(str, zeros, 4);
    ss = RSTRING_LEN(str) - 4;
    for(i = 1; i < argc; i++) {
        bs += append_ber(str, safe_int64_t(argv[i]));
    }
    ptr = ((uint8_t*)RSTRING_PTR(str)) + ss;
    ptr[0] = bs & 255;
    ptr[1] = (bs >> 8) & 255;
    ptr[2] = (bs >> 16) & 255;
    ptr[3] = (bs >> 24) & 255;
    return str;
}

static VALUE
rb_append_int32size_ber_be(int argc, VALUE* argv, VALUE self)
{
    VALUE str;
    int i = 0, bs=0, ss;
    uint8_t *ptr;
    check_argc_append(argc, 0);
    str = argv[0];
    rb_str_cat(str, zeros, 4);
    ss = RSTRING_LEN(str) - 4;
    for(i = 1; i < argc; i++) {
        bs += append_ber(str, safe_int64_t(argv[i]));
    }
    ptr = ((uint8_t*)RSTRING_PTR(str)) + ss;
    ptr[3] = bs & 255;
    ptr[2] = (bs >> 8) & 255;
    ptr[1] = (bs >> 16) & 255;
    ptr[0] = (bs >> 24) & 255;
    return str;
}
/** APPEND BER END **/

/** APPEND STRING **/
static VALUE
rb_append_string(VALUE self, VALUE str, VALUE add)
{
    StringValue(add);
    rb_str_cat(str, RSTRING_PTR(add), RSTRING_LEN(add));
    RB_GC_GUARD(add);
    return str;
}

static VALUE
rb_append_bersize_string(VALUE self, VALUE str, VALUE add)
{
    StringValue(add);
    append_ber(str, RSTRING_LEN(add));
    rb_str_cat(str, RSTRING_PTR(add), RSTRING_LEN(add));
    RB_GC_GUARD(add);
    return str;
}

static VALUE
rb_append_int32size_string_le(VALUE self, VALUE str, VALUE add)
{
    StringValue(add);
    append_int32_le(str, RSTRING_LEN(add));
    rb_str_cat(str, RSTRING_PTR(add), RSTRING_LEN(add));
    RB_GC_GUARD(add);
    return str;
}

static VALUE
rb_append_int32size_string_be(VALUE self, VALUE str, VALUE add)
{
    StringValue(add);
    append_int32_be(str, RSTRING_LEN(add));
    rb_str_cat(str, RSTRING_PTR(add), RSTRING_LEN(add));
    RB_GC_GUARD(add);
    return str;
}

/** APPEND STRING END **/

/** APPEND COMPLEX **/
static VALUE
rb_append_int8_ber(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 8, 0);
    rb_append_int8(2, argv, self);
    argv[1] = argv[0];
    return rb_append_ber(argc-1, argv+1, self);
}

static VALUE
rb_append_int16_ber_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 16, 0);
    rb_append_int16_le(2, argv, self);
    argv[1] = argv[0];
    return rb_append_ber(argc-1, argv+1, self);
}

static VALUE
rb_append_int24_ber_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 24, 0);
    rb_append_int24_le(2, argv, self);
    argv[1] = argv[0];
    return rb_append_ber(argc-1, argv+1, self);
}

static VALUE
rb_append_int32_ber_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 32, 0);
    rb_append_int32_le(2, argv, self);
    argv[1] = argv[0];
    return rb_append_ber(argc-1, argv+1, self);
}

static VALUE
rb_append_int16_ber_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 16, 0);
    rb_append_int16_be(2, argv, self);
    argv[1] = argv[0];
    return rb_append_ber(argc-1, argv+1, self);
}

static VALUE
rb_append_int24_ber_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 24, 0);
    rb_append_int24_be(2, argv, self);
    argv[1] = argv[0];
    return rb_append_ber(argc-1, argv+1, self);
}

static VALUE
rb_append_int32_ber_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 32, 0);
    rb_append_int32_be(2, argv, self);
    argv[1] = argv[0];
    return rb_append_ber(argc-1, argv+1, self);
}

static VALUE
rb_append_int8_int16_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 8, 16);
    rb_append_int8(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int16_le(argc-1, argv+1, self);
}

static VALUE
rb_append_int8_int24_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 8, 24);
    rb_append_int8(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int24_le(argc-1, argv+1, self);
}

static VALUE
rb_append_int8_int32_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 8, 32);
    rb_append_int8(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int32_le(argc-1, argv+1, self);
}

static VALUE
rb_append_int8_int16_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 8, 16);
    rb_append_int8(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int16_be(argc-1, argv+1, self);
}

static VALUE
rb_append_int8_int24_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 8, 24);
    rb_append_int8(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int24_be(argc-1, argv+1, self);
}

static VALUE
rb_append_int8_int32_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 8, 32);
    rb_append_int8(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int32_be(argc-1, argv+1, self);
}

static VALUE
rb_append_int16_int8_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 16, 8);
    rb_append_int16_le(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int8(argc-1, argv+1, self);
}

static VALUE
rb_append_int16_int24_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 16, 24);
    rb_append_int16_le(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int24_le(argc-1, argv+1, self);
}

static VALUE
rb_append_int16_int32_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 16, 32);
    rb_append_int16_le(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int32_le(argc-1, argv+1, self);
}

static VALUE
rb_append_int16_int8_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 16, 8);
    rb_append_int16_be(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int8(argc-1, argv+1, self);
}

static VALUE
rb_append_int16_int24_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 16, 24);
    rb_append_int16_be(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int24_be(argc-1, argv+1, self);
}

static VALUE
rb_append_int16_int32_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 16, 32);
    rb_append_int16_be(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int32_be(argc-1, argv+1, self);
}

static VALUE
rb_append_int24_int16_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 24, 16);
    rb_append_int24_le(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int16_le(argc-1, argv+1, self);
}

static VALUE
rb_append_int24_int8_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 24, 8);
    rb_append_int24_le(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int8(argc-1, argv+1, self);
}

static VALUE
rb_append_int24_int32_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 24, 32);
    rb_append_int24_le(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int32_le(argc-1, argv+1, self);
}

static VALUE
rb_append_int24_int16_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 24, 16);
    rb_append_int24_be(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int16_be(argc-1, argv+1, self);
}

static VALUE
rb_append_int24_int8_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 24, 8);
    rb_append_int24_be(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int8(argc-1, argv+1, self);
}

static VALUE
rb_append_int24_int32_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 24, 32);
    rb_append_int24_be(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int32_be(argc-1, argv+1, self);
}

static VALUE
rb_append_int32_int16_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 32, 16);
    rb_append_int32_le(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int16_le(argc-1, argv+1, self);
}

static VALUE
rb_append_int32_int24_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 32, 24);
    rb_append_int32_le(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int24_le(argc-1, argv+1, self);
}

static VALUE
rb_append_int32_int8_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 32, 8);
    rb_append_int32_le(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int8(argc-1, argv+1, self);
}

static VALUE
rb_append_int32_int16_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 32, 16);
    rb_append_int32_be(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int16_be(argc-1, argv+1, self);
}

static VALUE
rb_append_int32_int24_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 32, 24);
    rb_append_int32_be(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int24_be(argc-1, argv+1, self);
}

static VALUE
rb_append_int32_int8_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 32, 8);
    rb_append_int32_be(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int8(argc-1, argv+1, self);
}

static VALUE
rb_append_ber_int8(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 0, 8);
    rb_append_ber(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int8(argc-1, argv+1, self);
}

static VALUE
rb_append_ber_int16_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 0, 16);
    rb_append_ber(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int16_le(argc-1, argv+1, self);
}

static VALUE
rb_append_ber_int16_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 0, 16);
    rb_append_ber(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int16_be(argc-1, argv+1, self);
}

static VALUE
rb_append_ber_int24_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 0, 24);
    rb_append_ber(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int24_le(argc-1, argv+1, self);
}

static VALUE
rb_append_ber_int24_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 0, 24);
    rb_append_ber(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int24_be(argc-1, argv+1, self);
}

static VALUE
rb_append_ber_int32_le(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 0, 32);
    rb_append_ber(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int32_le(argc-1, argv+1, self);
}

static VALUE
rb_append_ber_int32_be(int argc, VALUE *argv, VALUE self)
{
    check_argc_append_2(argc, 0, 32);
    rb_append_ber(2, argv, self);
    argv[1] = argv[0];
    return rb_append_int32_be(argc-1, argv+1, self);
}


/** APPEND COMPLEX END **/

void
Init_native_bin_utils()
{
    VALUE mod_bin_utils = rb_define_module("BinUtils");
    VALUE mod_native = rb_define_module_under(mod_bin_utils, "Native");
    CONST_ID(rshft, ">>");
    CONST_ID(band, "&");

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

    rb_define_method(mod_native, "slice_ber!", rb_slice_ber, 1);
    rb_define_method(mod_native, "slice_int8!", rb_slice_int8, 1);
    rb_define_method(mod_native, "slice_sint8!", rb_slice_sint8, 1);
    rb_define_method(mod_native, "slice_int16_le!", rb_slice_int16_le, 1);
    rb_define_method(mod_native, "slice_sint16_le!", rb_slice_sint16_le, 1);
    rb_define_method(mod_native, "slice_int16_be!", rb_slice_int16_be, 1);
    rb_define_method(mod_native, "slice_sint16_be!", rb_slice_sint16_be, 1);
    rb_define_method(mod_native, "slice_int24_le!", rb_slice_int24_le, 1);
    rb_define_method(mod_native, "slice_sint24_le!", rb_slice_sint24_le, 1);
    rb_define_method(mod_native, "slice_int24_be!", rb_slice_int24_be, 1);
    rb_define_method(mod_native, "slice_sint24_be!", rb_slice_sint24_be, 1);
    rb_define_method(mod_native, "slice_int32_le!", rb_slice_int32_le, 1);
    rb_define_method(mod_native, "slice_sint32_le!", rb_slice_sint32_le, 1);
    rb_define_method(mod_native, "slice_int32_be!", rb_slice_int32_be, 1);
    rb_define_method(mod_native, "slice_sint32_be!", rb_slice_sint32_be, 1);
    rb_define_method(mod_native, "slice_int40_le!", rb_slice_int40_le, 1);
    rb_define_method(mod_native, "slice_sint40_le!", rb_slice_sint40_le, 1);
    rb_define_method(mod_native, "slice_int40_be!", rb_slice_int40_be, 1);
    rb_define_method(mod_native, "slice_sint40_be!", rb_slice_sint40_be, 1);
    rb_define_method(mod_native, "slice_int48_le!", rb_slice_int48_le, 1);
    rb_define_method(mod_native, "slice_sint48_le!", rb_slice_sint48_le, 1);
    rb_define_method(mod_native, "slice_int48_be!", rb_slice_int48_be, 1);
    rb_define_method(mod_native, "slice_sint48_be!", rb_slice_sint48_be, 1);
    rb_define_method(mod_native, "slice_int56_le!", rb_slice_int56_le, 1);
    rb_define_method(mod_native, "slice_sint56_le!", rb_slice_sint56_le, 1);
    rb_define_method(mod_native, "slice_int56_be!", rb_slice_int56_be, 1);
    rb_define_method(mod_native, "slice_sint56_be!", rb_slice_sint56_be, 1);
    rb_define_method(mod_native, "slice_int64_le!", rb_slice_int64_le, 1);
    rb_define_method(mod_native, "slice_sint64_le!", rb_slice_sint64_le, 1);
    rb_define_method(mod_native, "slice_int64_be!", rb_slice_int64_be, 1);
    rb_define_method(mod_native, "slice_sint64_be!", rb_slice_sint64_be, 1);

    rb_define_method(mod_native, "append_ber!", rb_append_ber, -1);
    rb_define_method(mod_native, "append_int8!", rb_append_int8, -1);
    rb_define_method(mod_native, "append_int16_le!", rb_append_int16_le, -1);
    rb_define_method(mod_native, "append_int16_be!", rb_append_int16_be, -1);
    rb_define_method(mod_native, "append_int24_le!", rb_append_int24_le, -1);
    rb_define_method(mod_native, "append_int24_be!", rb_append_int24_be, -1);
    rb_define_method(mod_native, "append_int32_le!", rb_append_int32_le, -1);
    rb_define_method(mod_native, "append_int32_be!", rb_append_int32_be, -1);
    rb_define_method(mod_native, "append_int40_le!", rb_append_int40_le, -1);
    rb_define_method(mod_native, "append_int40_be!", rb_append_int40_be, -1);
    rb_define_method(mod_native, "append_int48_le!", rb_append_int48_le, -1);
    rb_define_method(mod_native, "append_int48_be!", rb_append_int48_be, -1);
    rb_define_method(mod_native, "append_int56_le!", rb_append_int56_le, -1);
    rb_define_method(mod_native, "append_int56_be!", rb_append_int56_be, -1);
    rb_define_method(mod_native, "append_int64_le!", rb_append_int64_le, -1);
    rb_define_method(mod_native, "append_int64_be!", rb_append_int64_be, -1);

    rb_define_method(mod_native, "append_bersize_ber!", rb_append_bersize_ber, -1);
    rb_define_method(mod_native, "append_bersize_int8!", rb_append_bersize_int8, -1);
    rb_define_method(mod_native, "append_bersize_int16_le!", rb_append_bersize_int16_le, -1);
    rb_define_method(mod_native, "append_bersize_int16_be!", rb_append_bersize_int16_be, -1);
    rb_define_method(mod_native, "append_bersize_int24_le!", rb_append_bersize_int24_le, -1);
    rb_define_method(mod_native, "append_bersize_int24_be!", rb_append_bersize_int24_be, -1);
    rb_define_method(mod_native, "append_bersize_int32_le!", rb_append_bersize_int32_le, -1);
    rb_define_method(mod_native, "append_bersize_int32_be!", rb_append_bersize_int32_be, -1);
    rb_define_method(mod_native, "append_bersize_int40_le!", rb_append_bersize_int40_le, -1);
    rb_define_method(mod_native, "append_bersize_int40_be!", rb_append_bersize_int40_be, -1);
    rb_define_method(mod_native, "append_bersize_int48_le!", rb_append_bersize_int48_le, -1);
    rb_define_method(mod_native, "append_bersize_int48_be!", rb_append_bersize_int48_be, -1);
    rb_define_method(mod_native, "append_bersize_int56_le!", rb_append_bersize_int56_le, -1);
    rb_define_method(mod_native, "append_bersize_int56_be!", rb_append_bersize_int56_be, -1);
    rb_define_method(mod_native, "append_bersize_int64_le!", rb_append_bersize_int64_le, -1);
    rb_define_method(mod_native, "append_bersize_int64_be!", rb_append_bersize_int64_be, -1);

    rb_define_method(mod_native, "append_int32size_ber_le!", rb_append_int32size_ber_le, -1);
    rb_define_method(mod_native, "append_int32size_int8_le!", rb_append_int32size_int8_le, -1);
    rb_define_method(mod_native, "append_int32size_int16_le!", rb_append_int32size_int16_le, -1);
    rb_define_method(mod_native, "append_int32size_int24_le!", rb_append_int32size_int24_le, -1);
    rb_define_method(mod_native, "append_int32size_int32_le!", rb_append_int32size_int32_le, -1);
    rb_define_method(mod_native, "append_int32size_int40_le!", rb_append_int32size_int40_le, -1);
    rb_define_method(mod_native, "append_int32size_int48_le!", rb_append_int32size_int48_le, -1);
    rb_define_method(mod_native, "append_int32size_int56_le!", rb_append_int32size_int56_le, -1);
    rb_define_method(mod_native, "append_int32size_int64_le!", rb_append_int32size_int64_le, -1);

    rb_define_method(mod_native, "append_int32size_ber_be!", rb_append_int32size_ber_be, -1);
    rb_define_method(mod_native, "append_int32size_int8_be!", rb_append_int32size_int8_be, -1);
    rb_define_method(mod_native, "append_int32size_int16_be!", rb_append_int32size_int16_be, -1);
    rb_define_method(mod_native, "append_int32size_int24_be!", rb_append_int32size_int24_be, -1);
    rb_define_method(mod_native, "append_int32size_int32_be!", rb_append_int32size_int32_be, -1);
    rb_define_method(mod_native, "append_int32size_int40_be!", rb_append_int32size_int40_be, -1);
    rb_define_method(mod_native, "append_int32size_int48_be!", rb_append_int32size_int48_be, -1);
    rb_define_method(mod_native, "append_int32size_int56_be!", rb_append_int32size_int56_be, -1);
    rb_define_method(mod_native, "append_int32size_int64_be!", rb_append_int32size_int64_be, -1);

    rb_define_method(mod_native, "append_string!", rb_append_string, 2);
    rb_define_method(mod_native, "append_bersize_string!", rb_append_bersize_string, 2);
    rb_define_method(mod_native, "append_int32size_string_le!", rb_append_int32size_string_le, 2);
    rb_define_method(mod_native, "append_int32size_string_be!", rb_append_int32size_string_be, 2);

    rb_define_method(mod_native, "append_int8_ber!", rb_append_int8_ber, -1);
    rb_define_method(mod_native, "append_ber_int8!", rb_append_ber_int8, -1);
    rb_define_method(mod_native, "append_int8_int16_le!", rb_append_int8_int16_le, -1);
    rb_define_method(mod_native, "append_int8_int24_le!", rb_append_int8_int24_le, -1);
    rb_define_method(mod_native, "append_int8_int32_le!", rb_append_int8_int32_le, -1);
    rb_define_method(mod_native, "append_int8_int16_be!", rb_append_int8_int16_be, -1);
    rb_define_method(mod_native, "append_int8_int24_be!", rb_append_int8_int24_be, -1);
    rb_define_method(mod_native, "append_int8_int32_be!", rb_append_int8_int32_be, -1);
    rb_define_method(mod_native, "append_int16_int8_le!", rb_append_int16_int8_le, -1);
    rb_define_method(mod_native, "append_int16_int24_le!", rb_append_int16_int24_le, -1);
    rb_define_method(mod_native, "append_int16_int32_le!", rb_append_int16_int32_le, -1);
    rb_define_method(mod_native, "append_int16_int8_be!", rb_append_int16_int8_be, -1);
    rb_define_method(mod_native, "append_int16_int24_be!", rb_append_int16_int24_be, -1);
    rb_define_method(mod_native, "append_int16_int32_be!", rb_append_int16_int32_be, -1);
    rb_define_method(mod_native, "append_int24_int16_le!", rb_append_int24_int16_le, -1);
    rb_define_method(mod_native, "append_int24_int8_le!", rb_append_int24_int8_le, -1);
    rb_define_method(mod_native, "append_int24_int32_le!", rb_append_int24_int32_le, -1);
    rb_define_method(mod_native, "append_int24_int16_be!", rb_append_int24_int16_be, -1);
    rb_define_method(mod_native, "append_int24_int8_be!", rb_append_int24_int8_be, -1);
    rb_define_method(mod_native, "append_int24_int32_be!", rb_append_int24_int32_be, -1);
    rb_define_method(mod_native, "append_int32_int16_le!", rb_append_int32_int16_le, -1);
    rb_define_method(mod_native, "append_int32_int24_le!", rb_append_int32_int24_le, -1);
    rb_define_method(mod_native, "append_int32_int8_le!", rb_append_int32_int8_le, -1);
    rb_define_method(mod_native, "append_int32_int16_be!", rb_append_int32_int16_be, -1);
    rb_define_method(mod_native, "append_int32_int24_be!", rb_append_int32_int24_be, -1);
    rb_define_method(mod_native, "append_int32_int8_be!", rb_append_int32_int8_be, -1);
    rb_define_method(mod_native, "append_ber_int16_le!", rb_append_ber_int16_le, -1);
    rb_define_method(mod_native, "append_ber_int24_le!", rb_append_ber_int24_le, -1);
    rb_define_method(mod_native, "append_ber_int32_le!", rb_append_ber_int32_le, -1);
    rb_define_method(mod_native, "append_ber_int16_be!", rb_append_ber_int16_be, -1);
    rb_define_method(mod_native, "append_ber_int24_be!", rb_append_ber_int24_be, -1);
    rb_define_method(mod_native, "append_ber_int32_be!", rb_append_ber_int32_be, -1);
    rb_define_method(mod_native, "append_int16_ber_le!", rb_append_int16_ber_le, -1);
    rb_define_method(mod_native, "append_int24_ber_le!", rb_append_int24_ber_le, -1);
    rb_define_method(mod_native, "append_int32_ber_le!", rb_append_int32_ber_le, -1);
    rb_define_method(mod_native, "append_int16_ber_be!", rb_append_int16_ber_be, -1);
    rb_define_method(mod_native, "append_int24_ber_be!", rb_append_int24_ber_be, -1);
    rb_define_method(mod_native, "append_int32_ber_be!", rb_append_int32_ber_be, -1);

    rb_extend_object(mod_native, mod_native);
}
