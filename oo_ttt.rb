module GameEvaluation
  WINNING_COMBOS = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

  def moves_for(current_board, symbol)
    current_board.each_index.select { |idx| current_board[idx] == symbol }
  end
end

class Game
  attr_accessor :winner
  attr_reader :human, :computer, :game_board
   
  def initialize
    @human = Human.new
    @computer = Computer.new
    @game_board = Board.new
    @winner = nil
  end

  def play
    loop do
      loop do
        game_board.update_current_board(get_human_choice)
        break if self.winner = game_board.check_winner(:x)
        game_board.update_current_board(get_computer_choice)
        break if self.winner = game_board.check_winner(:o)
      end

      display_winner_message
      break if replay?
      initialize
    end
  end

  def get_human_choice
    square = human.select_square(game_board.current_board) - 1
    symbol = :x
    [square, symbol]
  end

  def get_computer_choice
    square = computer.select_square(game_board.current_board)
    symbol = :o
    [square, symbol]
  end

  def replay?
    puts "Enter 'y' if you would like to play again"
    gets.chomp.downcase != 'y'
  end

  def display_winner_message
    puts
    sleep 1
    if winner == :x
      puts "Congratulations! You won!"
      sleep 1
      puts "\nOn easy...\n\n"
      sleep 1
    elsif winner == :o
      puts "You lost at tic-tac-toe... that's embarrasing.\n\n"
      sleep 1
    else
      puts "Tied. Try it on easy if you feel like winning...\n\n"
      sleep 1
      if computer.difficulty == "easy"
        sleep 1
        puts "Oh wait... you were playing on easy... ouch\n\n"
        sleep 1
      end
    end
  end
end


class Board
  include GameEvaluation

  DISPLAY_TEMPLATE = { x: ['   .   .   ', '    \ /    ', '     /     ', '    / \    ', '   .   .   '],
                     o: ['   .--.    ', '  :    :   ', '  |    |   ', '  :    ;   ', '   `--\'    '],
                     b: [' ' * 11, ' ' * 11, ' ' * 11, ' ' * 11, ' ' * 11] }
  
  attr_reader :current_board

  def initialize
    @current_board = initialize_board
    update_display
  end

  def initialize_board
    starting_board = []
    (0..8).each {|position| starting_board[position] = :b}
    starting_board
  end

  def update_current_board(selected_square_info)
    current_board[selected_square_info[0]] = selected_square_info[1]
    update_display
  end

  def update_display
    system 'clear' or system 'cls'
    print_main_board
    puts "Select an available location between 1 and 9\n\n"
    print_ui_board
  end

  def print_main_board
    puts
    printing_array = [current_board.values_at(0..2),
                      current_board.values_at(3..5),
                      current_board.values_at(6..8)]
    printing_array.each_with_index do |row_array, row_index|
      print_row(row_array)
      puts "-----------+-----------+-----------" unless row_index == 2
    end
    puts
  end

  def print_row(row_array)
    5.times do |i|
      row_array.each_with_index do |square_value, square_index|
        print DISPLAY_TEMPLATE[square_value][i]
        print square_index == 2 ? "\n" : "|"
      end
    end
  end

  def print_ui_board
    current_board.each_with_index do |square_value, square_index|
      print square_value == :b ? " #{(square_index + 1)} " : "   "
      print [2, 5, 8].include?(square_index) ? "\n" : "|"
      print "---+---+---\n" if [2, 5].include?(square_index)
    end
  end

  def check_winner(x_or_o)
    player_squares = moves_for(current_board, x_or_o)
    WINNING_COMBOS.any? do |combo|
      return x_or_o if combo.all? { |combo_num| player_squares.include?(combo_num) }
    end
    :tie unless current_board.any? { |square_value| square_value == :b }
  end
end

class Human
  def select_square(current_board)
    loop do
      user_selection = gets.chomp.to_i
      return user_selection if (1..9).include?(user_selection) && current_board[user_selection - 1] == :b 
      if (1..9).include?(user_selection)
        puts "\nThat square has been taken. Please select another square"
      else
        puts "\nThat is not a valid selection. Please select a number between 1 and 9."
      end
    end
  end
end

class Computer
  include GameEvaluation

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
    empty_squares = moves_for(current_board, :b)
    human_squares = moves_for(current_board, :x)
    computer_squares = moves_for(current_board, :o)
    return empty_squares.sample if difficulty == "easy"
    ai_square_selection(empty_squares, human_squares, computer_squares)
  end

  def ai_square_selection(empty_squares, human_squares, computer_squares)
    ai_selection = find_winning_square(computer_squares, human_squares)
    ai_selection ||= find_winning_square(human_squares, computer_squares)
    ai_selection ||= find_best_square(human_squares, computer_squares)
    ai_selection ||= 4 if empty_squares.include?(4)
    ai_selection ||= empty_squares.select { |num| [0, 2, 6, 8].include?(num) }.sample
    ai_selection ||= empty_squares.sample
  end

  def find_winning_square(p1_squares, p2_squares)
    WINNING_COMBOS.each do |combo|
      player_squares_in_combo = combo.select { |sq| p1_squares.include?(sq) }.length
      return (combo - p1_squares)[0] if player_squares_in_combo == 2 && (combo - p2_squares) == combo
    end
    nil
  end
  
  def find_best_square(human_squares, computer_squares)
    humans_winning_combos = determine_winning_combos(human_squares, computer_squares)
    computers_winning_combos = determine_winning_combos(computer_squares, human_squares)
    fork_opportunities = find_fork_opportunities(humans_winning_combos, human_squares)
    best_square_based_on_forks(computer_squares, computers_winning_combos, fork_opportunities)
  end
  
  def determine_winning_combos(p1_squares, p2_squares)
    WINNING_COMBOS.select do |combo|
      combo.all? { |combo_sq| !p2_squares.include?(combo_sq) } && combo.any? { |combo_sq| p1_squares.include?(combo_sq) }
    end
  end
  
  def best_square_based_on_forks(computer_squares, computers_winning_combos, fork_opportunities)
    if fork_opportunities.length == 2
      computers_winning_combos.flatten.select { |combo_sq| !(computer_squares + fork_opportunities).include?(combo_sq) }.sample
    elsif fork_opportunities.length > 1
      fork_opportunities.select { |fork_sq|  computers_winning_combos.flatten.include?(fork_sq) }.sample
    else
      fork_opportunities[0]
    end
  end

  def find_fork_opportunities(humans_winning_combos, human_squares)
    fork_opportunities = []
    humans_winning_combos.each do |combo|
      combo.each do |sq|
        fork_opportunities << sq if winning_combos_overlap_at_square?(humans_winning_combos, human_squares, sq, fork_opportunities)
      end
    end
    fork_opportunities
  end

  def winning_combos_overlap_at_square?(humans_winning_combos, human_squares, sq, fork_opportunities)
    combos_with_sq = 0
    humans_winning_combos.each do |combo_reference|
      combos_with_sq += 1 if (combo_reference - human_squares).include?(sq)
    end
    if combos_with_sq > 1
      return true unless fork_opportunities.include?(sq)
    end
    false
  end
end

Game.new.play