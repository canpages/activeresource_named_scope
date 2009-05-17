require File.join(File.dirname(__FILE__), 'test_helper')
require 'active_resource/named_scope'

class NamedScopeTest < Test::Unit::TestCase

  context 'an ActiveResource class' do
    
    setup do
      @class = Class.new do
        def self.name; 'Book'; end
        include ActiveResource::NamedScope
      end
    end
    
    context 'defining a new named scope' do
      
      context 'with a name and Hash' do
       
        setup do
          @class.named_scope :rare, { :from => :rare }
        end
        
        should "add the named scope to the class's list of named scopes" do
          assert_not_nil @class.named_scopes[:rare]
          assert @class.named_scopes[:rare].kind_of?(ActiveResource::NamedScope::ScopePrototype)
        end
        
        should 'use the given Hash for the proxy options' do
          assert_equal({ :from => :rare}, @class.rare.proxy_options)
        end
        
      end
      
      context 'with a name and Proc' do
        
        setup do
          @class.named_scope :with_author, lambda { |author| { :params => { :author => author } } }
        end
        
        should "add the named scope to the class's list of named scopes" do
          assert_not_nil @class.named_scopes[:with_author]
        end
        
        should 'evaluate the Proc for the proxy options' do
          assert_equal({ :params => { :author => 'Pirsig' } }, @class.with_author('Pirsig').proxy_options)
        end
        
      end
      
    end
    
    context 'with some named scopes' do
      
      setup do
        @class.named_scope :rare, { :from => :rare }
        @class.named_scope :out_of_print, { :from => :out_of_print }
        @class.named_scope :with_author, lambda { |author| { :params => { :author => author } } }
        @class.named_scope :limit, lambda { |limit| { :params => { :limit => limit } } }
      end
      
      should 'return the results of a find(:all) when a chain of named scopes is evaluated' do
        result = []
        @class.expects(:find).returns(result)
        assert_equal result, @class.limit(20).to_a
      end
      
      should 'not make a find call in the middle of chained named scopes' do
        @class.expects(:find).once
        @class.rare.out_of_print.with_author('Silverstein').limit(10).to_a
      end
      
      should 'overwrite earlier :from values with later ones' do
        @class.expects(:find).with(:all, { :from => :out_of_print })
        @class.rare.out_of_print.to_a
      end
      
      should 'merge :params values' do
        @class.expects(:find).with(:all, { :params => { :author => 'Plato', :limit => 5 } })
        @class.with_author('Plato').limit(5).to_a
      end
      
      should 'overwrite earlier values in the :params hash with later ones' do
        @class.expects(:find).with(:all, { :params => { :limit => 2 } })
        @class.limit(4).limit(2).to_a
      end
      
    end
    
    context 'the result of a named scope evaluation' do
      
      setup do
        @class.named_scope(:foo, {})
        @x = Object.new
        @y = Object.new
        @class.stubs(:find).returns([@x, @y])
      end
      
      should 'support :to_a' do
        assert_equal [@x, @y], @class.foo.to_a
      end
      
      should 'support :each with a block' do
        @x.expects(:to_s)
        @y.expects(:to_s)
        @class.foo.each(&:to_s)
      end
      
      should 'support :first' do
        assert_equal @x, @class.foo.first
      end
      
      should 'support :last' do
        assert_equal @x, @class.foo.first
      end
      
      should 'support :any? without a block' do
        assert @class.foo.any?
      end
      
      should 'support :any? with a block' do
        assert  @class.foo.any? { |z| z == @y }
        assert !@class.foo.any? { |z| z == 7  }
      end
      
      should 'support :all? with a block' do
        assert  @class.foo.all? { |z| !z.nil? }
        assert !@class.foo.all? { |z| z == @y }
      end
      
      should 'support :length' do
        assert_equal 2, @class.foo.length
      end
      
    end
    
  end
  
end