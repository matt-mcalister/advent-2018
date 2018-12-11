def Node
  
  attr_reader :num_children, :num_metadata

  def initialize(num_children, num_metadata)
    @num_children = num_children
    @num_metadata = num_metadata
  end

end
