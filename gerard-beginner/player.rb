class Hero
  attr_accessor :warrior, :state, :last_health
  def initialize
    @state = :walk
    @last_health = 20
  end

  def under_attack?
    last_health > warrior.health
  end

  def hurting?
    warrior.health < 20
  end

  def in_next_cell
    cell = warrior.feel
    if cell.empty?
      :nothing
    elsif cell.captive?
      :captive
    else
      :enemy
    end
  end

  def next_state
    case in_next_cell
    when :nothing
      if hurting? and not under_attack?
        :rest
      else
        :walk
      end
    when :enemy
      :attack
    when :captive
      :rescue
    end
  end

  def make_a_move
    new_state = next_state

    case new_state
    when :walk   then warrior.walk!
    when :rest   then warrior.rest!
    when :attack then warrior.attack!
    when :rescue then warrior.rescue!
    end

    @state = next_state
    @last_health = warrior.health
  end
end

class Player
  def play_turn(warrior)
    @hero ||= Hero.new
    @hero.warrior = warrior

    @hero.make_a_move
  end
end
