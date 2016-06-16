#ifndef RUBY_HUMIDIFIER
#define RUBY_HUMIDIFIER

#include <ctype.h>
#include <ruby.h>

static void filter(char* dest, const char* source);
static void format_substring(char* substr, const int substr_idx, const int capitalize);
static void preprocess(char* str);
static VALUE underscore(VALUE self, VALUE str);

void Init_humidifier();

#endif
