class Player
  include Comparable

  HANDS = ['r', 'p', 's']
  attr_reader :name, :hand

  def <=>(another)
    if self.hand == 'r' && another.hand == 's' || self.hand == 'p' && another.hand == 'r' || self.hand == 's' && another.hand == 'p'
      1
    elsif self.hand == another.hand
      0
    else
      -1
    end
  end
end

class Human < Player
  def pick_hand
    loop do  
      puts "\nPlease select one: (r/p/s)"
      @hand = gets.chomp.downcase
      break if Player::HANDS.include?(hand)
    end
  end

  def initialize(player_name = nil)
    @name = player_name ? player_name : get_name
  end

  def get_name
    system 'clear' or system 'cls'
    print "Enter your name: "
    gets.chomp
  end
end

class Computer < Player
  def initialize
    @name = "The Great Computer"
  end

  def pick_hand
    @hand = HANDS.sample
  end
end

class Game
  attr_reader :human, :computer

  def initialize(player_name = nil)
    @human = player_name ? Human.new(player_name) : Human.new
    @computer = Computer.new
  end

  def compare_hands
    if human == computer
      "It's a tie!"
    elsif human > computer
      human
    else human < computer
      computer
    end
  end
  
  def play
    [human, computer].each {|player| player.pick_hand}
    winner = compare_hands
    puts winner == "It's a tie!" ? winner : game_recap(winner)
    puts "#{winner.name} wins!" if defined?(winner.name)
    replay
  end

  def game_recap(winner)
    case winner.hand
    when 'r' then "Rock smashes scissors!"
    when 'p' then "Paper wraps rock!"
    when 's' then "Scissors cuts paper!"
    end
  end

  def replay
    continue = nil
    loop do
      puts "\nWould you like to play again? (Y/N)"
      continue = gets.chomp.downcase
      break continue if ['y', 'n'].include?(continue)
    end
    Game.new(human.name).play if continue == 'y'
  end
end

puts "Play Rock Paper Scissors!"
Game.new.play