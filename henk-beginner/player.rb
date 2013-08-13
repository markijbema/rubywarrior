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
    while warrior.health < 20 and not warrior.health_decreased?
      warrior.rest!
    end
  end

  attr_accessor :warrior
end

WarriorWrapper = Struct.new(:warrior) do
  def initialize *args
    super
    @last_health = 20
  end
  def feel
    warrior.feel
  end
  def health
    warrior.health
  end
  def attack!
    warrior.attack!
    yield_control
  end
  def rest!
    warrior.rest!
    yield_control
  end
  def walk! *args
    warrior.walk! *args
    yield_control
  end

  def yield_control
    @last_health = warrior.health
    Fiber.yield
  end

  def health_decreased?
    @health_decreased
  end

  def update warrior
    @health_decreased = warrior.health < @last_health
    self.warrior = warrior
  end
end

class Player
  def setup
    return if @setup_finished

    @henk = Henk.new
    @wrapper = WarriorWrapper.new
    @henk.warrior = @wrapper
    @fiber = Fiber.new { @henk.run }

    @setup_finished = true
  end

  def play_turn(warrior)
    setup
    @wrapper.update warrior
    @fiber.resume
  end
end
