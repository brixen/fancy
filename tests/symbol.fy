FancySpec describe: Symbol with: {
  it: "is usable like a block for Enumerable methods" with: 'call: when: {
    [1,2,3,4,5] map: 'squared .
      is: [1,4,9,16,25]

    ["hello", "world"] map: 'upcase .
      is: ["HELLO", "WORLD"]

    [1,2,3,4,5] select: 'even? .
      is: [2,4]
  }

  it: "evaluates itself within the current scope" with: 'eval when: {
    x = 10
    'x eval is: x
  }

  it: "sends itself to the sender in its context" with: 'call when: {
    def foo {
      "foo"
    }
    def bar {
      "bar"
    }
    x = false
    if: x then: 'foo else: 'bar . is: "bar"
    x = true
    if: x then: 'foo else: 'bar . is: "foo"
  }

  it: "returns its arity correctly (when interpreted as a method name)" with: 'arity when: {
    'foo arity is: 1
    'foo_bar_baz arity is: 1
    ('+, '-, '*, '/) each: @{ arity is: 2 }
    'foo: arity is: 2
    'foo:bar: arity is: 3
    'foo:bar:baz: arity is: 4
  }

  it: "returns self" with: 'to_sym when: {
    'foo to_sym is: 'foo
    'bar to_sym is: 'bar
  }

  it: "returns itself as a Block" with: 'to_block when: {
    b = 'inspect to_block
    b call: [2] . is: "2"
    b call: ["foo"] . is: "\"foo\""

    str = "hello, world yo!\"foo\""
    b call: [str] . is: $ @{ inspect } call: [str]

    add = '+ to_block
    { add call: [2] } raises: ArgumentError
    add call: [0,1] . is: 1
    add call: [2,3] . is: 5
    { add call: [2,3,4] } raises: ArgumentError
  }
}
