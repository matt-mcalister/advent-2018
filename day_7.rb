require 'pry'

class Order

  attr_accessor :acc
  attr_writer :on_deck

  def on_deck
    @on_deck.sort
  end

  def next_letter
    self.on_deck.find {|l| !Step.all[l].added && Step.all[l].prerequisites_met?}
  end

  def beginning_letters
    Step.all.keys.select {|l| Step.all[l].is_beginning }.sort
  end

  def to_string
    self.acc = self.beginning_letters.first
    self.on_deck = self.beginning_letters[1..-1] + Step.all[self.beginning_letters.first].next.map {|s| s.letter}
    until self.acc.length == Step.all.keys.length
      self.add_next_letter
    end
  end

  def add_next_letter
    new_letter = self.next_letter
    self.acc += new_letter
    Step.all[new_letter].added = true
    index = self.on_deck.index(new_letter)
    self.on_deck.delete_at(index)
    self.on_deck += Step.all[new_letter].next.map {|s| s.letter}
  end

end

class Step
  attr_reader :parents, :letter, :next, :order
  attr_accessor :is_beginning, :added

  @@all = {}

  def initialize(letter, order)
    @added = false
    @parents = []
    @order = order
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

  def prerequisites_met?
    self.parents.all? {|s| self.order.acc.include?(s.letter)}
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

input = [
  "Step L must be finished before step A can begin.",
  "Step P must be finished before step F can begin.",
  "Step V must be finished before step U can begin.",
  "Step F must be finished before step S can begin.",
  "Step A must be finished before step J can begin.",
  "Step R must be finished before step K can begin.",
  "Step Z must be finished before step T can begin.",
  "Step G must be finished before step W can begin.",
  "Step H must be finished before step K can begin.",
  "Step T must be finished before step U can begin.",
  "Step K must be finished before step B can begin.",
  "Step C must be finished before step Y can begin.",
  "Step W must be finished before step N can begin.",
  "Step E must be finished before step M can begin.",
  "Step N must be finished before step J can begin.",
  "Step B must be finished before step S can begin.",
  "Step O must be finished before step D can begin.",
  "Step X must be finished before step D can begin.",
  "Step M must be finished before step Q can begin.",
  "Step S must be finished before step J can begin.",
  "Step U must be finished before step Y can begin.",
  "Step I must be finished before step J can begin.",
  "Step D must be finished before step J can begin.",
  "Step Q must be finished before step Y can begin.",
  "Step J must be finished before step Y can begin.",
  "Step Z must be finished before step D can begin.",
  "Step K must be finished before step E can begin.",
  "Step U must be finished before step J can begin.",
  "Step I must be finished before step Y can begin.",
  "Step A must be finished before step B can begin.",
  "Step B must be finished before step Q can begin.",
  "Step Z must be finished before step S can begin.",
  "Step F must be finished before step E can begin.",
  "Step B must be finished before step I can begin.",
  "Step C must be finished before step S can begin.",
  "Step O must be finished before step S can begin.",
  "Step V must be finished before step O can begin.",
  "Step C must be finished before step B can begin.",
  "Step G must be finished before step M can begin.",
  "Step O must be finished before step Y can begin.",
  "Step H must be finished before step N can begin.",
  "Step D must be finished before step Y can begin.",
  "Step Z must be finished before step O can begin.",
  "Step K must be finished before step W can begin.",
  "Step M must be finished before step Y can begin.",
  "Step O must be finished before step J can begin.",
  "Step P must be finished before step E can begin.",
  "Step C must be finished before step Q can begin.",
  "Step I must be finished before step D can begin.",
  "Step F must be finished before step I can begin.",
  "Step W must be finished before step B can begin.",
  "Step W must be finished before step M can begin.",
  "Step N must be finished before step D can begin.",
  "Step Z must be finished before step M can begin.",
  "Step M must be finished before step U can begin.",
  "Step R must be finished before step I can begin.",
  "Step S must be finished before step Y can begin.",
  "Step L must be finished before step B can begin.",
  "Step S must be finished before step D can begin.",
  "Step R must be finished before step G can begin.",
  "Step U must be finished before step D can begin.",
  "Step C must be finished before step N can begin.",
  "Step R must be finished before step T can begin.",
  "Step K must be finished before step U can begin.",
  "Step W must be finished before step E can begin.",
  "Step H must be finished before step E can begin.",
  "Step X must be finished before step M can begin.",
  "Step G must be finished before step I can begin.",
  "Step C must be finished before step U can begin.",
  "Step N must be finished before step B can begin.",
  "Step X must be finished before step S can begin.",
  "Step G must be finished before step H can begin.",
  "Step T must be finished before step X can begin.",
  "Step P must be finished before step N can begin.",
  "Step B must be finished before step Y can begin.",
  "Step S must be finished before step Q can begin.",
  "Step C must be finished before step E can begin.",
  "Step F must be finished before step D can begin.",
  "Step H must be finished before step J can begin.",
  "Step B must be finished before step U can begin.",
  "Step B must be finished before step J can begin.",
  "Step P must be finished before step I can begin.",
  "Step N must be finished before step X can begin.",
  "Step M must be finished before step J can begin.",
  "Step X must be finished before step I can begin.",
  "Step L must be finished before step P can begin.",
  "Step T must be finished before step B can begin.",
  "Step T must be finished before step K can begin.",
  "Step D must be finished before step Q can begin.",
  "Step W must be finished before step X can begin.",
  "Step A must be finished before step Y can begin.",
  "Step G must be finished before step D can begin.",
  "Step R must be finished before step Z can begin.",
  "Step U must be finished before step Q can begin.",
  "Step G must be finished before step O can begin.",
  "Step G must be finished before step Q can begin.",
  "Step G must be finished before step Y can begin.",
  "Step P must be finished before step Y can begin.",
  "Step I must be finished before step Q can begin.",
  "Step F must be finished before step C can begin.",
  "Step L must be finished before step K can begin."
]



def run(arr)
  order = Order.new
  arr.each do |instruction|
    split_instr = instruction.split(" must be finished before step ")
    first_letter = split_instr.first.split("Step ")[-1]
    next_letter = split_instr.last.split(" can begin.")[0]

    step_node = Step.all[first_letter] || Step.new(first_letter, order)
    next_node = Step.all[next_letter] || Step.new(next_letter, order)
    next_node.parents << step_node
    next_node.is_beginning = false
    step_node.add_next(next_node)
  end
  order.to_string
  puts "ANSWER TO NUMBER 1: #{order.acc}"
end

run(input)
