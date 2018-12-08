require 'pry'

class Order

end

class Step
  attr_reader :letter, :next, :order

  @@all = {}

  def initialize(letter, instruction)
    @letter = letter
    @next = []
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

    letter = split_order.first.split("Step ").last
    next = split_order.last.split(" can begin.").first
    step_node = Step.all[letter] || Step.new(letter, order)
    next_node = Step.all[next] || Step.new(next_node, order)
    step_node.add_next(next_node)
  end
end

run(test)
