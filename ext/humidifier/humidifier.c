#include <humidifier.h>

VALUE camelize(VALUE self, VALUE str)
{
  VALUE converted_str = str;
  if (TYPE(str) == T_SYMBOL) {
    converted_str = rb_sym_to_s(str);
  }

  char *orig_str = rb_string_value_cstr(&converted_str);
  char new_str[strlen(orig_str)];

  char prev;
  int orig_idx = 0, new_idx = 0;

  new_str[0] = toupper(orig_str[0]);
  for (orig_idx = 1, new_idx = 1; orig_str[orig_idx] != '\0'; orig_idx++) {
    if (prev == '_') {
      new_str[new_idx++] = toupper(orig_str[orig_idx]);
    }
    else if (orig_str[orig_idx] != '_') {
      new_str[new_idx++] = orig_str[orig_idx];
    }
    prev = orig_str[orig_idx];
  }

  if (strncmp(new_str, "Aws", 3) == 0) {
    strncpy(new_str, "AWS", 3);
  }

  return rb_str_new(new_str, new_idx);
}

void Init_humidifier()
{
  VALUE Humidifier = rb_define_module("Humidifier");
  VALUE Utils = rb_define_module_under(Humidifier, "Utils");
  rb_define_singleton_method(Utils, "camelize", camelize, 1);
}
