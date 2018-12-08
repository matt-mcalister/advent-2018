require 'pry'

class Order

  def beginning
    beginning_letter = Step.all.keys.find {|l| Step.all[l].is_beginning }
    Step.all[beginning_letter]
  end

  def to_string
    # 
  end

end

class Step
  attr_reader :letter, :next, :order
  attr_accessor :is_beginning

  @@all = {}

  def initialize(letter, instruction)
    @letter = letter
    @next = []
    @is_beginning = true
    @@all[letter] = self
  end

  def add_next(next_node)
    @next << next_node
    @next = self.next.sort_by {|s| s.letter}
  end

  def self.all
    @@all
  end
end

test = [
  "Step C must be finished before step A can begin.",
"Step C must be finished before step F can begin.",
"Step A must be finished before step B can begin.",
"Step A must be finished before step D can begin.",
"Step B must be finished before step E can begin.",
"Step D must be finished before step E can begin.",
"Step F must be finished before step E can begin.",
]


def run(arr)
  order = Order.new
  arr.each do |instruction|
    split_instr = instruction.split(" must be finished before step ")
    first_letter = split_instr.first.split("Step ")[-1]
    next_letter = split_instr.last.split(" can begin.")[0]
    step_node = Step.all[first_letter] || Step.new(first_letter, order)
    next_node = Step.all[next_letter] || Step.new(next_letter, order)
    next_node.is_beginning = false
    step_node.add_next(next_node)
  end

  binding.pry
end

run(test)
