FancySpec describe: Object with: |it| {
  it should: "dynamically evaluate a message-send with no arguments" when: {
    obj = 42;
    obj send: "to_s" . should == "42"
  };

  it should: "dynamically evaluate a message-send with a list of arguments" when: {
    obj = "hello, world";
    obj send: "from:to:" params: [0,4] . should == "hello"
  };

  it should: "dynamically define slotvalues" when: {
    obj = Object new;
    obj get_slot: :foo . should == nil;
    obj set_slot: :foo value: "hello, world";
    obj get_slot: :foo . should == "hello, world"
  };

  it should: "return its class" when: {
    nil class should == NilClass;
    true class should == TrueClass;
    "foo" class should == String;
    :bar class should == Symbol;
    { :a_block } class should == Block
  };

  it should: "call unkown_message:with_params: when calling an undefined method" when: {
    def class UnknownMessage {
      def unknown_message: message with_params: params {
        "Got: " ++ message ++ " " ++ params
      }
    };

    obj = UnknownMessage new;
    obj this_is_not_defined: "It's true!" . should == "Got: this_is_not_defined: It's true!"
  };

  it should: "return a correct string representation" when: {
    3 to_s should == "3";
    :foo to_s should == "foo";
    nil to_s should == ""
  };

  it should: "return a correct array representation" when: {
    nil to_a should == [];
    :foo to_a should == [:foo];
    <[:foo => "bar", :bar => "baz"]> to_a should == [[:bar, "baz"], [:foo, "bar"]]
  };

  it should: "return a correct number representation" when: {
    nil to_num should == 0;
    :foo to_num should == 0;
    3 to_num should == 3;
    3.28437 to_num should == 3.28437
  };

  it should: "have no metadata initially" when: {
    o = Object new;
    o meta should == nil
  };

  it should: "set the metadata correctly" when: {
    o = Object new;
    o meta: "foobar";
    o meta should == "foobar"
  };

  it should: "be an Object of the correct Class (or Superclass)" when: {
    Object new is_a?: Object . should == true;
    "foo" is_a?: String . should == true;
    "foo" is_a?: Object . should == true;
    1123 is_a?: Number . should == true;
    1123 is_a?: Object . should == true;
    132.123 is_a?: Number . should == true;
    132.123 is_a?: Object . should == true
  };

  it should: "correctly assign multiple values at once" when: {
    x, y, z = 1, 10, 100;
    x should == 1;
    y should == 10;
    z should == 100;

    x, y, z = :foo, :bar;
    x should == :foo;
    y should == :bar;
    z should == nil;

    x = :foo;
    y = :bar;
    x, y = y, x;
    x should == :bar;
    y should == :foo
  };

  it should: "undefine a singleton method" when: {
    def self a_singleton_method {
      "a singleton method!"
    };
    self a_singleton_method should == "a singleton method!";
    self undefine_singleton_method: :a_singleton_method . should == true;
    try {
      self a_singleton_method should == nil # should not get here
    } catch MethodNotFoundError => e {
      e method_name should == "a_singleton_method"
    }
  }
}
