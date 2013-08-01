class Hero
  attr_accessor :warrior, :state, :last_health, :direction

  def initialize
    @state = :go_to_start
    @last_health = 20
    @direction = :backward
  end

  def other_direction
    direction == :forward ? :backward : :forward
  end

  def under_attack?
    last_health > warrior.health
  end

  def hurting?
    warrior.health < 20
  end

  def in_danger?
    warrior.health < 10
  end

  def in_next_cell
    cell = warrior.feel(direction)
    if cell.empty?
      :nothing
    elsif cell.captive?
      :captive
    elsif cell.wall?
      :wall
    else
      :enemy
    end
  end

  def next_state
    if hurting?
      case state
      when :retreat, :rest
        if under_attack?
          return :retreat
        else
          return :rest
        end
      end
    end

    case in_next_cell
    when :nothing
      if in_danger?
        if under_attack?
          :retreat
        else
          :rest
        end
      else
        :walk
      end
    when :enemy   then :attack
    when :captive then :rescue
    when :wall    then :turn_around_and_retry
    end

  end
  def make_a_move
    done = false
    until done
      new_state = next_state
      case new_state
      when :walk
        warrior.walk!(direction)
        done = true
      when :retreat
        warrior.walk!(other_direction)
        done = true
      when :rest
        warrior.rest!
        done = true
      when :attack
        warrior.attack!(direction)
        done = true
      when :rescue
        warrior.rescue!(direction)
        done = true
      when :turn_around_and_retry
        @direction = :forward
      end
      @state = new_state
    end

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
