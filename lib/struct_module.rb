# coding: utf-8
require "struct_module/version"

module StructModule
  class << self
    def generate_module(attrs)
      Module.new{|mod|
        @_members = attrs

        include Enumerable

        def self.included(base)
          # FIXME!! no attr_accessor but using some container
          base.class_eval <<-END
            attr_accessor #{StructModule.args_to_symbollist(@_members)}
            def initialize(#{StructModule.args_to_argstring(@_members)})
              #{StructModule.args_to_assignstring(@_members)}
            end
            def self.members
              [#{StructModule.args_to_symbollist(@_members)}]
            end
          END
        end

        def [](attr)
          instance_variable_get "@#{attr}"
        end

        def []=(attr, value)
          instance_variable_set "@#{attr}", value
        end

        def each # FIXME!!!
          return to_enum(:each) unless block_given?
          self.class.members.each do |member|
            yield self[member]
          end
        end

        def each_pair
          return to_enum(:each_pair) unless block_given?
          self.class.members.each do |member|
            yield [member, self[member]]
          end
        end

        def ==(other)
          return false unless self.class == other.class
          self.class.members.all?{|m| self[m] == other[m] } # XXX: or generate in class_eval?
        end

        def eql?(other)
          self.class.members.all?{|m| self[m].eql? other[m] } # XXX: or generate in class_eval?
        end

        def members
          self.class.members
        end

        def length
          members.length
        end
        alias size length

        def values
          each.to_a
        end
        alias to_a values

        # FIXME: to raise IndexError if invalid args
        def values_at(*args)
          to_a.values_at(*args)
        end
      }
    end

    def args_to_symbollist(args)
      args.map{|name| ":#{name}"}.join(', ')
    end

    def args_to_argstring(args)
      args.map{|name| "#{name} = nil"}.join(', ')
    end

    def args_to_assignstring(args)
      args.map{|name| "@#{name} = #{name}"}.join('; ')
    end
  end

end

def StructModule(*args)
  StructModule.generate_module(args)
end

__END__

# sample
class C
  include StruceModule(:foo, :bar)
end

c = C.new        #=> #<C:0x007ff22a3acf68 @bar=nil, @foo=nil>
c.foo            #=> nil
c.foo = 1        #=> 1
c.foo            #=> 1
c2 = C.new(2, 3) #=> #<C:0x007ff22a4044c0 @bar=3, @foo=2>
c2.bar = 4       #=> 4
C.members        #=> [:foo, :bar]




