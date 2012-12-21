# StructModule

like Struct, but module

## Installation

Add this line to your application's Gemfile:

    gem 'struct_module'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install struct_module

## Usage

```ruby
requrie 'struct_module'

class C
  include StructModule(:foo, :bar)
end

c = C.new(1, 2)
c.foo # => 1
c.bar # => 2
c.foo = 30
c.foo # => 30
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
