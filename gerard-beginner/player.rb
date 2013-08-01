class Player
  def play_turn(warrior)
    @state ||= :walk
    @last_health ||= warrior.health

    under_attack = @last_health > warrior.health
    @last_health = warrior.health

    hurting = warrior.health < 20

    if warrior.feel.empty?
      if hurting and not under_attack
        @state = :rest
      else
        @state = :walk
      end
    else
      @state = :attack
    end

    case @state
    when :walk   then warrior.walk!
    when :rest   then warrior.rest!
    when :attack then warrior.attack!
    end
  end
end
