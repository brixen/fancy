def class AST {
  def class Identifier : Node {
    """
    Represents identifiers, like local variables, method & class names
    etc. in Fancy.
    """

    read_slots: ['name]
    @@name_conversions = <["||" => "or",
                          "&&" => "and",
                          "!=" => "not_equal",
                          "++" => "plusplus",
                          "class" => "_class"]>

    def initialize: name {
      @name = name
    }

    def Identifier from_sexp: sexp {
      Identifier new: $ sexp second
    }

    def to_s {
      "<Identifier: '" ++ @name ++ "'>"
    }

    def to_ruby_sexp: out {
      out print: "[:ident, "
      out print: (@name to_s inspect)
      out print: "]"
    }

    def rubyfy {
      namespaced_parts = @name to_s split: "::"
      namespaced_parts = namespaced_parts map: |n| { n to_s split: ":" . select: |x| { x empty? not } . join: "___" }
      name = namespaced_parts join: "::"
      @@name_conversions[name] if_do: |new_val| {
        new_val
      } else: {
        name
      }
    }
  }
}