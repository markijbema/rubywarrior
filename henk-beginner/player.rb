class Henk
  def initialize
  end

  def run
    while warrior.feel.empty?
      warrior.walk!
    end
  end

  attr_accessor :warrior
end

WarriorWrapper = Struct.new(:warrior) do
  def walk!
    warrior.walk!
    Fiber.yield
  end

  def feel
    warrior.feel
  end
end

class Player
  def play_turn(warrior)
    @henk ||= Henk.new
    @henk.warrior = WarriorWrapper.new(warrior)
    @fiber ||= Fiber.new do
      @henk.run
    end
    @fiber.resume
  end
end
