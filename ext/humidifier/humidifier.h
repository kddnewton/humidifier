#ifndef RUBY_HUMIDIFIER
#define RUBY_HUMIDIFIER

#include <ctype.h>
#include <ruby.h>

static VALUE camelize(VALUE self, VALUE str);

static void underscore_format(char* substr, const int substr_idx, const int capitalize);
static void underscore_preprocess(char* str);
static VALUE underscore(VALUE self, VALUE str);

void Init_humidifier();

#endif
