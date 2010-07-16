#include "regexp.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  Regexp::Regexp(const string &pattern) : FancyObject(RegexpClass), _pattern(pattern)
  {
  }

  FancyObject* Regexp::equal(FancyObject* other) const
  {
    if(!IS_REGEX(other))
      return nil;

    Regexp* other_regex = (Regexp*)other;
    if(_pattern == other_regex->_pattern)
      return t;
    return nil;
  }

  string Regexp::to_s() const
  {
    return "r{" + _pattern + "}";
  }

  FancyObject* Regexp::match(FancyString* string) const
  {
    // if match -> return t else nil
    // TODO: implement Regexp matching! (via boost::regex?)
    return nil;
  }

}
