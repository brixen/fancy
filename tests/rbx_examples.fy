#
# A fancyspec that uses System#pipe: to check all .fyc files on rbx/examples
# output the expected string.
#
# Yeah, It's ugly, but we just need a way to ensure we don't have regressions
# we hope to compile fancy really soon, in the mean time (and until we create
# world class specs) this should do it.
#
# I feel nasty.

FancySpec describe: "rbx/examples" with: {

  def example: file should_output: expected {
    it: file when: {
      out = System pipe: ("bin/fancy -rbx rbx/examples/" ++ file ++ ".fy")
      out should == expected
    }
  }

  example: 'hello should_output: ["Hello from Fancy, Rubinius!!", "367.2323", "20"]

  example: 'strings should_output: ["foo", "bar", "baz", "hello \t world"]

  example: 'methods should_output: ["Hello World", "Hello, World!"]

  example: 'implicit_return should_output: ["Hello!"]

  example: 'blocks should_output: ["0", "1", "1", "2", "3", "4",
                                   "in while_true, with x = 0",
                                   "in while_true, with x = 1",
                                   "in while_true, with x = 2",
                                   "in while_true, with x = 3",
                                   "x is: 1",
                                   "y is: 2", "3"]

  example: 'classes should_output: ["Person with name: Christopher"]

  example: 'nested_classes should_output: ["foo got: yay!"]

  example: 'include should_output: ["Hello World"]

  example: 'inherit should_output: ["Hello World"]


  example: 'singleton_methods should_output: ["in singleton_method",
                                              "foobar: 1",
                                              "foobar: 2",
                                              "foobar: 3",
                                              "[]"]

  example: 'require should_output: ["Hello from Fancy, Rubinius!!",
                                    "367.2323",
                                    "20",
                                    "Now executing from require.fy!"]

  example: 'hashes should_output: ["<[:baz => 42.49, :foo => :bar, :bar => :baz]>"]
}
