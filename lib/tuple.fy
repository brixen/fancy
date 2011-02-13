class Tuple {
  """
  Tuples are fixed-size containers providing index-based access to its
  elements.
  """

  include: FancyEnumerable

  def [] idx {
    """
    Forwards to @Tuple#at:@.
    """

    at: idx
  }

  def first {
    "Returns the first element in the Tuple."
    at: 0
  }

  def second {
    "Returns the second element in the Tuple."
    at: 1
  }

  def third {
    "Returns the third element in the Tuple."
    at: 2
  }

  def fourth {
    "Returns the fourth element in the Tuple"
    at: 3
  }

  def each: block {
    self size times: |i| {
      block call: [self at: i]
    }
  }

  def == other {
    """
    @other Other @Tuple@ to compare @self with.
    @return @true, if tuples are equal element-wise, @false otherwise.

    Compares two @Tuple@s with each other.
    """

    if: (other is_a?: Tuple) then: {
      if: (self size == (other size)) then: {
        self size times: |i| {
          unless: (self[i] == (other[i])) do: {
            return false
          }
        }
        return true
      }
    }
    return false
  }

  def inspect {
    str = "("
    self each: |v| {
      str = str ++ v
    } in_between: {
      str = str ++ ", "
    }
    str = str ++ ")"
    str
  }

  def Tuple === obj {
    """
    Matches @Tuple@ class against an object.
    If the given object is a Tuple instance, return a Tuple object.

    @obj Object to be matched against
    @return Tuple instance containing the values of @obj to be used in pattern matching.
    """

    if: (obj is_a?: Tuple) then: {
      [obj] + (obj map: 'identity)
    }
  }
}