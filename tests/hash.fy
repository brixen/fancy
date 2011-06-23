FancySpec describe: Hash with: {
  it: "should be empty on initialization" for: 'empty? when: {
    hash = <[]>
    hash size is == 0
    hash empty? is == true
  }

  it: "should be empty on initialization via Hash#new" for: 'size when: {
    hash = Hash new
    hash size is == 0
    hash empty? is == true
  }

  it: "should contain one entry" when: {
    hash = <['foo => "bar"]>
    hash size is == 1
    hash empty? is == false
  }

  it: "should contain 10 square values after 10 insertions" for: 'at: when: {
    hash = Hash new
    10 times: |i| {
      hash at: i put: (i * i)
    }

    10 times: |i| {
      hash at: i . is == (i * i)
    }
  }

  it: "should override the value for a given key" for: 'at: when: {
    hash = <['foo => "bar"]>
    hash at: 'foo . is == "bar"
    hash at: 'foo put: 'foobarbaz
    hash at: 'foo . is == 'foobarbaz
  }

  it: "should return all keys" for: 'keys when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    hash keys is =? ['foo, 'bar, 'foobar]
  }

  it: "should return all values" for: 'values when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    hash values is =? ["bar", "baz", 112.21]
  }

  it: "should return value by the []-operator" for: "[]" when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    hash['foo] is == "bar"
    hash['bar] is == "baz"
    hash['foobar] is == 112.21
  }

  it: "should return nil if the key isn't defined" for: '[] when: {
    <['foo => "bar"]> ['bar] . is == nil
    <[]> ['foobar] . is == nil
    <['foo => "bar"]> [nil] . is == nil
  }

  it: "should call the Block for each key and value" for: 'each: when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    hash each: |key val| {
      val is == (hash[key])
    }
  }

  it: "should call the Block with each key" for: 'each_key: when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    count = 0
    hash each_key: |key| {
      key is == (hash keys[count])
      count = count + 1
    }
  }

  it: "should call the Block with each value" for: 'each_value: when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    count = 0
    hash each_value: |val| {
      val is == (hash values[count])
      count = count + 1
    }
  }

  it: "should call most Enumerable methods with each pair" when: {
    hash = <['hello => "world", 'fancy => "is cool"]>

    hash map: |pair| { pair[0] } . is =? ['hello, 'fancy] # order does not matter

    hash select: |pair| { pair[1] to_s includes?: "c" } .
      is == [['fancy, "is cool"]]

    hash reject: |pair| { pair[0] to_s includes?: "l" } .
      map: 'second . is == ["is cool"]
  }

  it: "should return an Array of the key-value pairs" for: 'to_a when: {
    <['foo => "bar", 'bar => "baz"]> to_a is =? [['foo, "bar"], ['bar, "baz"]]
  }

  it: "should return multiple values if given an array of keys" for: '[] when: {
    hash = <['foo => 1, 'bar => "foobar", 'baz => 42, "hello world" => "hello!"]>
    a, b, c = hash values_at: ('foo, 'bar, "hello world")
    a is == 1
    b is == "foobar"
    c is == "hello!"
  }

  it: "should include a key" for: 'includes?: when: {
    h = <['foo => "bar", 'bar => "baz"]>
    h includes?: 'foo is == true
    h includes?: 'bar is == true
    h includes?: "foo" is == false
    h includes?: "bar" is == false
    h includes?: nil is == false
  }
}
