#ifndef RUBY_HUMIDIFIER
#define RUBY_HUMIDIFIER

#include <ctype.h>
#include <ruby.h>

VALUE camelize(VALUE self, VALUE str);
void Init_humidifier();

#endif
