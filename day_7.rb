require 'pry'

class Order

  attr_accessor :acc, :seconds, :workers
  attr_writer :on_deck

  def initialize(num_workers)
    @workers = Array.new(num_workers)
    @seconds = -1
    @acc = ""
  end

  def on_deck
    @on_deck.sort.uniq
  end

  def next_letter
    self.on_deck.find {|l| !Step.all[l].start_time && !Step.all[l].added && Step.all[l].prerequisites_met?}
  end

  def beginning_letters
    Step.all.keys.select {|l| Step.all[l].is_beginning }.sort
  end

  def to_string
    self.on_deck = self.beginning_letters
    until self.acc.length == Step.all.keys.length
      self.check_letter_completion
    end
  end

  def must_debug?
    self.workers.any? {|l| !l.nil? && (self.acc.include?(l) || self.on_deck.include?(l))} || (!!self.next_letter && self.workers.any?{|w| w.nil?})
  end

  def check_letter_completion
    self.seconds += 1
    self.workers = self.workers.map do |l|
      if l.nil? || Step.all[l].complete?

        self.add_next_letter(l)
        letter = self.next_letter
        if !!Step.all[letter]
          Step.all[letter].start_time = self.seconds
          self.on_deck -= [letter]
        end
        letter
      else
        l
      end
    end
    self.on_deck -= self.workers
    puts "TIME: #{self.seconds}, IN PROGRESS: #{self.workers.map {|l| l.nil? ? "." : l}}, DONE: #{self.acc}"
  end

  def add_next_letter(letter)
    if !letter.nil?
      self.acc += letter
      Step.all[letter].added = true
      self.on_deck += Step.all[letter].next.map {|s| s.letter}
      self.on_deck -= self.workers
    end
  end

end

class Step
  attr_reader :parents, :letter, :next, :order
  attr_accessor :is_beginning, :added, :start_time
  @@time = {
    "A" => 1,
    "B" => 2,
    "C" => 3,
    "D" => 4,
    "E" => 5,
    "F" => 6,
    "G" => 7,
    "H" => 8,
    "I" => 9,
    "J" => 10,
    "K" => 11,
    "L" => 12,
    "M" => 13,
    "N" => 14,
    "O" => 15,
    "P" => 16,
    "Q" => 17,
    "R" => 18,
    "S" => 19,
    "T" => 20,
    "U" => 21,
    "V" => 22,
    "W" => 23,
    "X" => 24,
    "Y" => 25,
    "Z" => 26
  }

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

  def complete?
    self.order.seconds - self.start_time >= Step.time[self.letter] + 60
  end

  def add_next(next_node)
    @next << next_node
    @next = self.next.sort_by {|s| s.letter}
  end

  def self.all
    @@all
  end

  def self.time
    @@time
  end

  def prerequisites_met?
    self.parents.all? {|s| self.order.acc.include?(s.letter) || self.order.workers.any? {|l| l == s.letter && Step.all[l].complete?}}
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



def run(arr, num_workers)
  order = Order.new(num_workers)
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
  # binding.pry
  puts "ANSWER TO NUMBER 2 (accumulated string): #{order.acc}"
  puts "ANSWER TO NUMBER 2: #{order.seconds}"
end

run(input, 6)
