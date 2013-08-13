Thread::abort_on_exception = true

class Henk
  def run
    while true
      walk!
      attack!
      recover!
    end
  end

  def walk!
    warrior.walk! while warrior.feel.empty?
  end

  def attack!
    warrior.attack! until warrior.feel.empty?
  end

  def recover!
    while warrior.health < 20
      last_health = warrior.health
      warrior.rest!
      break if warrior.health < last_health
    end
  end


  attr_accessor :warrior
end

WarriorWrapper = Struct.new(:warrior) do
  def feel
    warrior.feel
  end
  def health
    warrior.health
  end
  def attack!
    warrior.attack!
    Fiber.yield
  end
  def rest!
    warrior.rest!
    Fiber.yield
  end
  def walk! *args
    warrior.walk! *args
    Fiber.yield
  end
end

class Player
  def play_turn(warrior)
    @henk ||= Henk.new
    @henk.warrior = WarriorWrapper.new warrior
    @fiber ||= Fiber.new do
      @henk.run
    end
    @fiber.resume
  end
end
