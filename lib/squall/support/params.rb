module Squall
  class Params
    # Required
    attr_accessor :valid

    # Optional
    attr_accessor :optional

    def initialize
      @valid    = []
      @optional = []
    end

    def required(*options)
      @valid = options.flatten.map { |o| o.to_sym}
      @valid.uniq!
      @optional.concat @valid
      @optional.uniq!
      self
    end

    def accepts(*options)
      @optional.concat options.flatten.map { |o| o.to_sym}
      @optional.uniq!
      self
    end

    def validate!(*options)
      validate_required!(*options) unless @valid.empty?
      validate_optionals!(*options) unless @optional.empty?
    end

    def validate_required!(*options)
      options = options.first.keys if options.first.respond_to?(:keys)
      options.map! { |o| o.respond_to?(:to_sym) ? o.to_sym : o }
      delta = (@valid - options)
      raise ArgumentError, "Missing required params: #{delta.join(',')}" if delta.any?
      true
    end

    def validate_optionals!(*options)
      options = options.first.keys if options.first.respond_to?(:keys)
      options.map! { |o| o.respond_to?(:to_sym) ? o.to_sym : o }
      options.each do |key|
        raise ArgumentError, "Unknown params: #{key}" unless @optional.include?(key)
      end
      true
    end
  end
end
