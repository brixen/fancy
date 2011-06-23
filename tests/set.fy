FancySpec describe: Set with: {
  it: "should only keep unique values" for: "[]" when: {
    s = Set new
    s << 'foo
    s << 'foo
    s size is == 1
    s is == (Set[['foo]])
    s should_not == ['foo] # Sets and Arrays differ
  }

  it: "should be empty" for: 'empty? when: {
    s = Set new
    s empty? is == true
    s = Set[[]]
    s empty? is == true
  }

  it: "should not be empty" for: 'empty? when: {
    s = Set new
    s << 1
    s empty? is == false
    s = Set[[1,2,3]]
    s empty? is == false
  }

  it: "should have the correct size" for: 'size when: {
    s = Set new
    s size is == 0
    s << 'foo
    s size is == 1
    10 times: {
      s << 'bar # only inserted once
    }
    s size is == 2
  }

  it: "should be equal to another set" for: '== when: {
    s1 = Set new
    s2 = Set new
    s1 == s2 is == true

    s1 = Set[[1,2,3]]
    s2 = Set[[3,2,1]]
    s1 == s2 is == true

    s1 << 1 # should have no effect
    s2 << 3
    s2 == s1 is == true
  }

  it: "should include a value" for: 'includes?: when: {
    s = Set[[1,2,3,"foo", 'bar, 10.0, 10.1]]
    s includes?: 1 is == true
    s includes?: 2 is == true
    s includes?: 3 is == true
    s includes?: "foo" is == true
    s includes?: 'bar is == true
    s includes?: 10.0 is == true
    s includes?: 10.1 is == true
    s includes?: 'hello is == false
    s includes?: nil is == false
  }

  it: "should call a Block with each value" for: 'each: when: {
    s = Set[[1,2,3,4]]
    sum = 0
    s each: |val| {
      sum = sum + val
      s includes?: val is == true
    }
   sum is == (s sum)
  }
}
