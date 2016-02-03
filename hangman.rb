require 'pstore'
store = PStore.new("storagefile")

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

	def check_guess(w)
  		if @actual_word.include?(w) == true
  			update_game(w)
  			
  		else
  			@wrong_guesses.push(w)
  			@death_count += 1
  			
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

	#def game_loop
  	
  		#while @dead == false
  		 # puts @wrong_guesses.join
  		  #puts @vis_word
  		 # print "Guess a letter: "
  		 # @guess = gets.chomp
  		 # check_guess(@guess)
  		 # if @vis_word == @actual_word
  		#	puts "You win"
  		 # end
  		 # if death_count == 6
  		#	@dead = true
  		#	puts "You Lose"
  		#	puts "The word was #{@actual_word}"
  		 # end
  		#end
  	#end
  	def check_win
		if @vis_word == @actual_word
  			puts "You win"
  			exit
  		end
  	end
  	def check_loss
  		if @death_count == 6
  			puts "You Lose"
  			puts "The word was #{@actual_word}"
  			@dead = true
  		end
  	end

  	
end

game_over = false

print "start a new game or load and existing game: "
input = gets.chomp
if input == "new"
	hangman = Game.new

elsif input == "load"
	hangman = Game.new
	store.transaction do
		hangman = store[:games]
	end
	puts "im loaded"
		
end

while game_over == false
	puts hangman.wrong_guesses.join
  	puts hangman.vis_word
	print "Guess a letter: "
	input = gets.chomp
	if input == "save"
		store.transaction do
			store[:games] ||= hangman
			
		end
	end
	hangman.check_guess(input)
	hangman.check_win
	hangman.check_loss
	game_over = hangman.dead
end



