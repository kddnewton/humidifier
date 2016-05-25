#include <humidifier.h>

// copies from the source string to the destination string after passing through a character whitelist filter
// note that this is exclusively built for AWS::CloudFormation::Interface, so if AWS ever fixes their docs this can
// be replaced by strcpy
static void filter(char* dest, const char* source)
{
  int source_idx, dest_idx;

  for (source_idx = 0, dest_idx = 0; source[source_idx] != '\0'; source_idx++) {
    if (source[source_idx] != ':') {
      dest[dest_idx++] = source[source_idx];
    }
  }
  dest[dest_idx] = '\0';
}

// takes a substring from underscore_preprocess like EC2T or AWST and converts it to Ec2T or AwsT
static void format_substring(char* substr, const int substr_idx, const int capitalize)
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
// simpler and just look for capitals
static void preprocess(char* str)
{
  char substr[strlen(str)];
  int idx, substr_idx;

  for (idx = 0, substr_idx = 0; str[idx] != '\0'; idx++) {
    if (isupper(str[idx])) {
      substr[substr_idx++] = str[idx];

      if (str[idx + 1] == '\0') {
        format_substring(substr, substr_idx, 0);
        memcpy(str + (idx - substr_idx) + 1, substr, substr_idx);
      }
    }
    else if (isdigit(str[idx]) || (substr_idx != 0)) {
      if (substr_idx != 1) {
        format_substring(substr, substr_idx, islower(str[idx]));
        memcpy(str + (idx - substr_idx), substr, substr_idx);
      }
      substr_idx = 0;
    }
  }
}

// takes a string and returns a downcased version where capitals are now separated by underscores
static VALUE underscore(VALUE self, VALUE str)
{
  if (TYPE(str) == T_NIL) return Qnil;

  char *str_value = rb_string_value_cstr(&str);
  char orig_str[strlen(str_value) + 1];

  filter(orig_str, str_value);
  preprocess(orig_str);

  // manually null-terminating the string because on Fedora for strings of length 16 this breaks otherwise
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
