module ActiveResource
  
  # To be included by ActiveResource::Base.  Provides +named_scope+ functionality
  # similar to (but not quite as rich as) ActiveRecord's.
  #
  # The options supported in a scope are <tt>:from</tt> and <tt>:params</tt>.
  # The <tt>:from</tt> value should be a +Symbol+ or +String+ and represents
  # a subdirectory in the resource.  Later <tt>:from</tt> values will replace
  # earlier ones.  The <tt>:params</tt> value should be a +Hash+ and represents
  # additional query parameters.  Later <tt>:params</tt> values will be merged
  # with earlier ones.
  #
  # == Example Usage:
  #   
  #   class Book < ActiveResource::Base
	#     self.site = 'http://library.alexandria.org/'
	#     named_scope :limit, lambda { |n| { :params => { :limit => n } } }
	#     named_scope :by_author, lambda { |author| { :params => { :author => author } } }
	#     named_scope :out_of_print, lambda { { :from => :out_of_print } }
	#     named_scope :rare, lambda { { :from => :rare } }
	#   end
	#   
	#   # same as Book.find(:all, :params => { :author => 'Zinn' }):
	#   Book.by_author('Zinn')
	#   # => GET /books.xml?author=Zinn
	#   
	#   # same as Book.find(:all, :params => { :author => 'Scarry', :limit => 2 }):
	#   Book.by_author('Scarry').limit(2) 
	#   # => GET /books.xml?author=Scarry&limit=2
	#   
	#   # same as Book.find(:all, :from => :out_of_print, :params => { :limit => 10 }):
	#   Book.out_of_print.limit(10)
	#   # => GET /books/out_of_print.xml?limit=10
	#
	#   # later :from values overwrite earlier ones:
	#   Book.out_of_print.rare
	#   # => GET /books/rare.xml
	#
	#   # later :params values are merged with earlier ones:
	#   Book.author('Douglas Adams').limit(10).limit(2)
	#   # => GET /books.xml?author=Douglas+Adams&limit=2
  module NamedScope
    
    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end
    
    module InstanceMethods
    end
    
    module ClassMethods
      
      # Define a new named scope.
      #
      # == Parameters
      #
      # +name+: the name of the Scope. A Symbol. Required.
      #
      # +options+: a Hash or Proc (lambda) to evaluate for the scope. Required.
      def named_scope(name, options)
        name = name.to_sym
        named_scopes[name] = ActiveResource::NamedScope::ScopePrototype.new(name, options)
        (class << self; self end).instance_eval do
          define_method name do |*args|
            named_scopes[name].call(self, *args)
          end
        end
      end
      
      def named_scopes
        read_inheritable_attribute(:scopes) || write_inheritable_attribute(:scopes, {})
      end
      
    end
    
    class ScopePrototype
      
      attr_reader :name, :content
      
      def initialize(name, content)
        @name, @content = name, content
      end
      
      def call(base_scope, *args)
        options = case @content
        when Hash
          @content.dup
        when Proc
          @content.call(*args)
        end
        Scope.new(base_scope, options)
      end
      
    end
    
    class Scope
      
      def initialize(base_scope, options)
        @base_scope = base_scope
        @options = deep_merge(base_options, options)
      end
      
      def proxy_options
        @options
      end
      
      # Object defines a default +to_a+ in Ruby 1.8, but it is deprecated.
      def to_a
        found
      end
      
      def method_missing(method, *args, &block)
        if (scope_prototype = resource_class.named_scopes[method])
          return scope_prototype.call(self, *args)
        elsif found.respond_to?(method)
          return found.send(method, *args, &block)
        end
        super(method, *args)
      end
      
      def respond_to?(method)
        super(method) || resource_class.named_scopes[method] || found.respond_to?(method)
      end
      
      protected
      
      def base_scope
        @base_scope
      end
      
      private
      
      # Merges Hash +b+ into Hash +a+, marging instead of replacing any included Hash stored under :params.
      #
      # Returns a new Hash.
      def deep_merge(a, b)
        params = {}.merge(a[:params] || {}).merge(b[:params] || {})
        result = a.merge(b)
        result.merge!({ :params => params }) unless params.empty?
        result
      end
      
      def base_options
        @base_scope.respond_to?(:proxy_options) ? @base_scope.proxy_options : {}
      end
      
      def found
        @found ||= resource_class.find(:all, proxy_options).tap(&:freeze)
      end
      
      def resource_class
        @resource_class ||= begin
          result = @base_scope
          result = result.base_scope while result.kind_of?(Scope)
          result
        end
      end
      
    end
    
    
  end
  
end