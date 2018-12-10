require 'pry'

class Order

  def beginning_letters
    Step.all.keys.select {|l| Step.all[l].is_beginning }.sort
  end

  def to_string
    self.beginning_letters.reduce("") {|acc, l| acc + Step.all[l].to_string}
  end

end

class Step
  attr_reader :parents, :letter, :next, :order
  attr_accessor :is_beginning

  @@all = {}

  def initialize(letter, instruction)
    @parents = []
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

  def to_string
    self.next.reduce(self.letter) do |acc, step_obj|
      conflict_nodes = step_obj.next.select {|s| acc.include?(s.letter)}
      if conflict_nodes.length > 0
        puts "ACC: #{acc}"
        puts "SELF: #{self.letter}"
        puts "STEP: #{step_obj.letter}"
        puts "CONFLICT NODES: #{conflict_nodes.map{|n| n.letter}}"
        puts "************"
        self.resolve_merge(step_obj, conflict_nodes, acc)
      else
        acc + step_obj.to_string
      end
    end
  end

  def resolve_merge(step_obj, conflict_nodes, acc_str = "")
    # step_obj is a 'next' node for self. It conflicts with another one of self's next nodes
      # step_obj will always have lower status alphabetically than self's other next nodes
    # acc_string is the accumulated string so far in the to_string method
      # acc_string includes at least one step that orccurs after step_obj

    # find letter that should be replaced with step_obj
    conflict_nodes.reduce(acc_str) {|acc, conf| acc.gsub(conf.letter, step_obj.to_string)}
    # this method should return the resolved merge of these two step objs in the acc_str
  end

  def compare_branches(conflicting_node)
    # self and conflicting_node are siblings
    # look at children of self and conflicting_node
    # find where they have a child node in common
    # place in alphabetical priority, with common node occuring last
    # For example:
    #                C
    #               / \
    #              D   A
    #               \ /
    #                E
    # should resolve to: "CADE", with D and A being "self" and "conflicting_node"
    # For example:
    #                C
    #               / \
    #              D   A
    #             / \   \
    #            F   B   Q
    #             \   \ /
    #              \__E
    # should resolve to: "CAQDBFE", with D and A being "self" and "conflicting_node"
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
  o_string = order.to_string
  puts Step.all.keys.count
  puts o_string.length
  puts o_string
end

run(input)
