class Game
  def initialize
    @human = Human.new
    @computer = Computer.new
    @game_board = Board.new
  end

  def play
    loop do
      @game_board.update_current_board(@human.select_square(@game_board.square_index), :x)
      @game_board.update_display
      break if @game_board.check_winner?(:x)
      @game_board.update_current_board(@computer.select_square(@game_board.current_board), :o)
      @game_board.update_display
      break if @game_board.check_winner?(:o)
    end
    display_winner_message
    replay
  end

  def display_winner_message
    puts
    sleep 1
    if @game_board.winner == :x
      puts "Congratulations! You won!"
      sleep 1
      puts "\nOn easy...\n\n"
      sleep 1
    elsif @game_board.winner == :o
      puts "You lost at tic-tac-toe... that's embarrasing.\n\n"
      sleep 1
    else
      puts "Tied. Try it on easy if you feel like winning...\n\n"
      sleep 1
      if @computer.difficulty == "easy"
        sleep 1
        puts "Oh wait... you are on easy... ouch\n\n"
        sleep 1
      end
    end
  end

  def replay
    continue = nil
    loop do
      puts "Would you like to play again? (Y/N)"
      continue = gets.chomp.downcase
      ['y', 'n'].include?(continue) ? break : next
    end
    Game.new.play if continue == 'y'
  end
end


class Board
  WINNING_COMBOS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

  DISPLAY_TEMPLATE = { x: ['   .   .   ', '    \ /    ', '     /     ', '    / \    ', '   .   .   '],
                     o: ['   .--.    ', '  :    :   ', '  |    |   ', '  :    ;   ', '   `--\'    '],
                     b: [' ' * 11, ' ' * 11, ' ' * 11, ' ' * 11, ' ' * 11] }
  
  attr_reader :current_board, :square_index, :winner

  def initialize
    @current_board = initialize_board
    @square_index = %w(1 2 3 4 5 6 7 8 9)
    @winner = nil
    update_display
  end

  def initialize_board
    starting_board = {}
    (1..9).each {|position| starting_board[position] = :b}
    starting_board
  end

  def update_display
    system 'clear' or system 'cls'
    i = 1
    puts
    loop do
      j = 0
      5.times do
        puts "#{DISPLAY_TEMPLATE[@current_board[i]][j]}|#{DISPLAY_TEMPLATE[@current_board[i+1]][j]}"\
             "|#{DISPLAY_TEMPLATE[@current_board[i+2]][j]}"
        j += 1
      end
      break if i > 4
      puts "-----------+-----------+-----------"
      i += 3
    end
    spacer = ' ' * 15
    puts
    puts "Select an available location between 1 and 9"
    puts format("\n%s %s | %s | %s\n%s---+---+---\n%s %s | %s | %s\n%s---+---+---\n%s %s | %s | %s\n",
                spacer, @square_index[0], @square_index[1], @square_index[2], spacer, spacer, @square_index[3], @square_index[4], @square_index[5], spacer, spacer,
                @square_index[6], @square_index[7], @square_index[8])
  end

  def check_winner?(x_or_o)
    player_numbers = @current_board.select { |num, sq| sq == x_or_o }.keys
    WINNING_COMBOS.any? do |combo|
      @winner = x_or_o if combo.all? { |combo_num| player_numbers.include?(combo_num) }
    end
    @winner = :tie unless @current_board.values.any? { |num| num == :b } || @winner != nil
    @winner
  end

  def update_current_board(square, x_or_o)
    @current_board[square] = x_or_o
    @square_index.map! {|num| num == square.to_s ? " " : num }
  end

end

class Human
  def select_square(square_index)
    loop do
      # User selects square
      selection = gets.chomp
      # Check validity of choice
      if square_index.include?(selection)
        return selection.to_i
      else
        if (1..9).include?(selection.to_i)
          puts "\nThat square has been taken. Please select another square"
        else
          puts "\nThat is not a valid selection. Please select a number between 1 and 9."
        end
      end
    end
  end
end

class Computer
  WINNING_COMBOS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

  attr_reader :difficulty

  def initialize
    @difficulty = get_difficulty
  end

  def get_difficulty
    loop do 
      system 'clear' or system 'cls'
      puts "Please select a difficulty level: (easy/hard)"
      difficulty_input = gets.chomp.downcase
      difficulty_input = nil unless ["easy", "hard"].include?(difficulty_input)
      return difficulty_input if difficulty_input
    end
  end

  def select_square(current_board)
    sleep 1
    return current_board.select { |num, sq| sq == :b }.keys.sample if @difficulty == "easy"
    user_numbers = current_board.select { |num, sq| sq == :x }.keys
    computer_numbers = current_board.select { |num, sq| sq == :o }.keys
    # Check for critical offensive square
    computer_spot = find_critical_square(computer_numbers, user_numbers)
    # Check for critical defensive square
    computer_spot ||= find_critical_square(user_numbers, computer_numbers)
    # Determine best square if none critical
    computer_spot ||= find_best_square(user_numbers, computer_numbers)
    # Starting possibilities
    computer_spot ||= 5 if current_board[5] == :b
    computer_spot ||= current_board.select { |num, sq| [1, 3, 7, 9].include?(num) && sq == :b }.keys.sample\
                      unless current_board.select { |num, sq| [1, 3, 7, 9].include?(num) && sq == :b }.keys.empty?
    computer_spot ||= current_board.select { |num, sq| sq == :b }.keys.sample
  end

  def find_critical_square(p1_numbers, p2_numbers)
    WINNING_COMBOS.each do |combo|
      i = 0
      strategic_square = nil
      combo.each do |sq|
        if p1_numbers.include?(sq)
          i += 1
        else
          strategic_square = sq unless p2_numbers.include?(sq)
        end
      end
      return strategic_square if strategic_square && i == 2
    end
    nil
  end
  
  def find_best_square(user_numbers, computer_numbers)
    users_winning_combos = WINNING_COMBOS.select do |combo|
      combo.all? { |sq| !computer_numbers.include?(sq) } && combo.any? { |sq| user_numbers.include?(sq) }
    end
    computers_winning_combos = WINNING_COMBOS.select do |combo|
      combo.all? { |sq| !user_numbers.include?(sq) } && combo.any? { |sq| computer_numbers.include?(sq) }
    end
    fork_opportunities = find_fork_opportunities(users_winning_combos, user_numbers)
    # If two fork opportunities avoid block, play offense / if one opportunity block
    if fork_opportunities.length == 2
      computers_winning_combos.flatten.select { |num| !computer_numbers.include?(num) && !fork_opportunities.include?(num) }.sample
    elsif fork_opportunities.length > 1
      fork_opportunities.select { |num|  computers_winning_combos.flatten.include?(num) }.sample
    else
      fork_opportunities[0]
    end
  end

  def find_fork_opportunities(users_winning_combos, user_numbers)
    fork_opportunities = []
    users_winning_combos.each do |combo|
      combo.each do |num|
        i = 0
        users_winning_combos.each do |combo_reference|
          i += 1 if combo_reference.include?(num) && !user_numbers.include?(num)
        end
        if i > 1
          fork_opportunities << num unless fork_opportunities.include?(num)
        end
      end
    end
    fork_opportunities
  end
end

Game.new.play