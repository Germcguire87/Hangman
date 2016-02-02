class WordHandler
   attr_accessor :dictionary
   attr_accessor :word
  
  def initialize
  	@dictionary = File.read("5desk.txt")
   	@dictionary = @dictionary.split("\n")
    @word = ""
  end
  
  def pick_word
  	valid = false
  	
  	while valid == false
  	  num = rand(0..@dictionary.length)
  	  @word = @dictionary[num]
  	  if @word.length >= 5 && @word.length <= 12
  	    valid = true
  	    
  	  end
  	end


  	return @word
  
  end

  def dashed_word(word)
  	word = word.gsub(/[A-Za-z]/, "_")
  	return word
  end
end



class Game
  attr_accessor :vis_word
  attr_accessor :actual_word
  attr_accessor :dead
  attr_accessor :guess
  attr_accessor :death_count
  attr_accessor :wrong_guesses

  def initialize
  	setup = WordHandler.new
  	@actual_word = setup.pick_word
  	@vis_word = setup.dashed_word(@actual_word)
  	@dead = false
  	@death_count = 0
  	@wrong_guesses = []
  
  end

  def check_guess
  	print "Guess a letter"
  	@guess = gets.chomp

  	if @actual_word.include?(@guess) == true
  		update_game(@guess)
  		return true
  	else
  		@wrong_guesses.push(@guess)
  		@death_count += 1
  		return false
  	end
  end
  

  def update_game(letter)
  	  act_word = @actual_word.split(//)
  	  vis_word = @vis_word.split(//)
  	  index = []
  	  
  	  act_word.each_with_index do |val, i|
  	  	if val == letter
  	  		index.push(i)
  	  	end
  	  end
      
      index.each do |x|
  	  	vis_word[x] = letter
  	  end
  	  @vis_word = vis_word.join
  end	


 








  def game_loop
  	
  	while @dead == false
  		puts @wrong_guesses
  		puts @vis_word
  		check_guess
  		if @vis_word == @actual_word
  			puts "You win"
  		end
  		if death_count == 6
  			@dead = true
  			puts "You Lose"
  		end
  	end

  	
  	

  end




end

hangman = Game.new

hangman.game_loop