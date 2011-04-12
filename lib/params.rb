class Params
  attr_accessor :valid
  
  def initialize
    @valid = {}
  end

  def required(*options)
    @valid = options.flatten.map { |o| o.to_sym}
    self
  end
  
  def validate!(*options)
    options = options.first.keys if options.first.respond_to?(:keys)
    options.map! { |o| o.to_sym }
    delta = (@valid - options)
    raise ArgumentError, "Missing required params: #{delta.join(',')}" if delta.any?
  end
end