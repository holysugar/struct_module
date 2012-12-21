require 'minitest/spec'
require 'minitest/autorun'

require 'struct_module'

describe StructModule do

  describe "class including StructModule(:foo, :bar)" do
    before do
      @subject = StructModule(:foo, :bar)
      @klass = Class.new
      @klass.send(:include, @subject)
    end

    it "rewrites initialize and it's all arguments are optional" do
      @klass.method(:initialize).arity.must_equal -1
    end

    describe ".new" do
      it "initialize default value is nil" do
        object = @klass.new
        object.foo.must_be_nil
        object.bar.must_be_nil
      end

      it "first arguments set foo, second set bar" do
        object = @klass.new('first', 'second')
        object.foo.must_equal 'first'
        object.bar.must_equal 'second'
      end

      it "foo is defined as accessor" do
        object = @klass.new
        object.foo = 'assigned'
        object.foo.must_equal 'assigned'
      end
    end

    describe ".members" do
      it "is attributes array reserving order" do
        @klass.members.must_equal [:foo, :bar]
      end
    end

    describe "#[](member)" do
      it "returns value same as accessor" do
        object = @klass.new('first', 'second')
        object[:foo].must_equal 'first'
      end
    end

    describe "#[]=(member, value)" do
      it "set value same as accessor" do
        object = @klass.new('first', 'second')
        object[:foo] = 'newvalue'
        object.foo.must_equal 'newvalue'
      end

      it 'returns assigned value' do
        object = @klass.new('first', 'second')
        (object[:foo] = 'newvalue').must_equal 'newvalue'
      end
    end

    it "includes Enumerable" do
      @klass.must_include Enumerable
    end

    describe "#each" do
      it "returns Enumerator without block" do
        object = @klass.new('first', 'second')
        object.each.must_be_instance_of Enumerator
      end

      it "iterates values" do
        object = @klass.new('first', 'second')
        object.each.to_a.must_equal ['first', 'second']
      end
    end

    describe "#each_pair" do
      it "returns Enumerator without block" do
        object = @klass.new('first', 'second')
        object.each_pair.must_be_instance_of Enumerator
      end

      it "iterates key(symbol) and values" do
        object = @klass.new('first', 'second')
        object.each_pair.to_a.must_equal [[:foo, 'first'], [:bar, 'second']]
      end
    end

    describe "#hash" do
      # implement me
    end

    describe "#length and #size" do
      it "returns # of members" do
        @klass.new.length.must_equal 2
        @klass.new.size.must_equal 2
      end
    end

    describe "#members" do
      it "is attributes array reserving order" do
        @klass.new.members.must_equal [:foo, :bar]
      end
    end

    describe "#values and #to_a" do
      it "returns values array" do
        object = @klass.new('first', 'second')
        object.values.must_equal ['first', 'second']
        object.to_a.must_equal ['first', 'second']
      end
    end

    describe "#values_at" do
      describe "given integer arguments" do
        it "returns values as given index" do
          object = @klass.new('first', 'second')
          object.values_at(1).must_equal ['second']
          object.values_at(1, 0).must_equal ['second', 'first']
        end
        #it "when too large index given, raises IndexError" do
        #  object = @klass.new('first', 'second')
        #  proc{ object.values_at(2) }.must_raise IndexError
        #end
      end
      describe "also given range arguments" do
        it "returns values as given index" do
          object = @klass.new('first', 'second')
          object.values_at(0, 0..1).must_equal ['first', 'first', 'second']
          object.values_at(0..1, 0..1).must_equal ['first', 'second', 'first', 'second']
        end
      end
    end

    describe "#==" do
      it "when all attrs are ==, returns true" do
        (@klass.new(1)   == @klass.new(1)).must_equal true
        (@klass.new(1)   == @klass.new(2)).must_equal false
        (@klass.new([1]) == @klass.new([1])).must_equal true
      end
    end

    describe "#eql?" do
      it "when all attrs are eql?, returns true" do
        o = Object.new
        def o.eql?(other); false; end
        (@klass.new(1).eql? @klass.new(1)).must_equal true
        (@klass.new(1).eql? @klass.new(2)).must_equal false
        (@klass.new(o).eql? @klass.new(o)).must_equal false
      end
    end



  end
end

