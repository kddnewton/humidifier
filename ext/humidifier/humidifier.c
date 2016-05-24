#include <humidifier.h>

// takes a substring from underscore_preprocess like EC2T or AWST and converts it to Ec2T or AwsT
static void underscore_format(char* substr, const int substr_idx, const int capitalize)
{
  int idx;

  for (idx = 0; idx < substr_idx; idx++) {
    if (idx == 0) {
      substr[idx] = toupper(substr[idx]);
    }
    else if ((idx != substr_idx - 1) || capitalize == 0) {
      substr[idx] = tolower(substr[idx]);
    }
  }
}

// finds occurences of EC2Thing or AWSThing and makes them into Ec2Thing and AwsThing so that underscore can be
// simpler and just look for capitals - note: using memcpy instead of strncpy because for some reason on Fedora
// things break for strings with length % 16 == 0
static void underscore_preprocess(char* str)
{
  char substr[strlen(str)];
  int idx, substr_idx;

  for (idx = 0, substr_idx = 0; str[idx] != '\0'; idx++) {
    if (isupper(str[idx])) {
      substr[substr_idx++] = str[idx];

      if (str[idx + 1] == '\0') {
        underscore_format(substr, substr_idx, 0);
        memcpy(str + (idx - substr_idx) + 1, substr, substr_idx);
      }
    }
    else if (isdigit(str[idx]) || (substr_idx != 0)) {
      if (substr_idx != 1) {
        underscore_format(substr, substr_idx, islower(str[idx]));
        memcpy(str + (idx - substr_idx), substr, substr_idx);
      }
      substr_idx = 0;
    }
  }
}

static VALUE underscore(VALUE self, VALUE str)
{
  if (TYPE(str) == T_NIL) return Qnil;

  char *str_value = rb_string_value_cstr(&str);
  char orig_str[strlen(str_value)];

  strcpy(orig_str, str_value);
  underscore_preprocess(orig_str);
  orig_str[strlen(str_value)] = '\0';

  char new_str[strlen(orig_str) * 2];
  char prev;
  int orig_idx, new_idx;

  for (orig_idx = 0, new_idx = 0; orig_str[orig_idx] != '\0'; orig_idx++) {
    if (orig_idx != 0 && isupper(orig_str[orig_idx])) {
      new_str[new_idx++] = '_';
    }
    new_str[new_idx++] = tolower(orig_str[orig_idx]);
    prev = tolower(orig_str[orig_idx]);
  }

  return rb_str_new(new_str, new_idx);
}

void Init_humidifier()
{
  VALUE Humidifier = rb_define_module("Humidifier");
  VALUE Utils = rb_define_module_under(Humidifier, "Utils");
  rb_define_singleton_method(Utils, "underscore", underscore, 1);
}
