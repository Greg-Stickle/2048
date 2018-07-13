require 'gosu'
class Test < Gosu::Window
	def initialize
		super(440,440)
		self.caption = "2048"
		@board = Array.new(4) {Array.new(4,0)}
		@oldBoard = []
		@temp = Array.new(4,0)
		@font = Gosu::Font.new(64)
		@newTile = [2,2,2,2,2,2,2,4,4,4]
		spawnTile
		@direction = nil
		@alive = true
	end
	
	#Drawing system
	#Draws a new board each frame
	def draw
		if @alive == true
			for row in 0...4
				for column in 0...4
					x1 = 22 + column * 100
					y1 = 22 + row * 100
					x2 = x1 + 96
					y2 = y1
					x3 = x2
					y3 = y2 + 96
					x4 = x1
					y4 = y3

					c = Gosu::Color.argb(0xaa404040)
					@font = Gosu::Font.new(64)
					case @board[row][column]
					when 4
						c = Gosu::Color.argb(0xaa808080)
					when 8
						c = Gosu::Color.argb(0xaa808000)
					when 16
						c = Gosu::Color.argb(0xaaa08000)
					when 32
						c = Gosu::Color.argb(0xaac04000)
					when 64
						c = Gosu::Color.argb(0xaae02000)
					when 128
						c = Gosu::Color.argb(0xbbc0c000)
						@font = Gosu::Font.new(56)
					when 256
						c = Gosu::Color.argb(0xccc4c400)
						@font = Gosu::Font.new(56)
					when 512
						c = Gosu::Color.argb(0xddcaca00)
						@font = Gosu::Font.new(56)
					end
					draw_quad(x1, y1, c, x2, y2, c, x3, y3, c, x4, y4, c, 1)
					x_center = x1 + 48
					x_text = x_center - @font.text_width("#{@board[row][column]}") / 2
					y_text = y1 + 16
					@font.draw("#{@board[row][column] if @board[row][column] != 0}", x_text, y_text, 2)
				end
			end
		else
			c = Gosu::Color.argb(0xaaaaaaaa)
			draw_quad(0,0,c,440,0,c,440,440,c,0,440,c,3)
		end
	end

	#Simple update loop
	def update
		oldBoard = checkBoard
		if move(@direction) == true 
			newBoard = checkBoard
			if newBoard != oldBoard
				spawnTile
			end
		end
		@direction = nil
	end

	#Method to spawn tiles on the board
	#Randomizes the location to place the new tile in
	#Deletes the now filled zero tile from the zero array
	def spawnTile
		value = @newTile.shuffle!.first
		zeros = checkBoard
		if zeros.empty?
			@alive = false 
			return
		end
		index = rand(0...zeros.length)
		index -= 1 if index % 2 != 0
		@board[zeros[index]][zeros[index + 1]] = value
		zeros.delete_at(index)
		zeros.delete_at(index)
	end	

	#Win condition check
	def checkWin
		for x in 0...4
			for y in 0...4
				if @board[x][y] == 2048
					return true
				end
			end
		end
		return false
	end

	#Checks for any zeros left on the board
	#Used in:
	#Spawning of tiles
	#End-game condition
	def checkBoard
		zeros = Array.new
		for x in 0...4
			for y in 0...4
				if @board[x][y] == 0
					zeros.push(x)
					zeros.push(y)
				end
			end
		end
		return zeros
	end

	#Directional input
	def button_down(id)
		@direction = "left" if id == Gosu::KbLeft
		@direction = "right" if id == Gosu::KbRight
		@direction = "up" if id == Gosu::KbUp
		@direction = "down" if id == Gosu::KbDown
		if id == Gosu::KbR && button_down?(Gosu::KbLeftControl)
			@board = Array.new(4) {Array.new(4,0)}
			@temp = Array.new(4,0)
			spawnTile
		end
		if id == Gosu::KbA
			@board = @oldBoard
		end
	end

	def swap(array, swapped)
		#Deletes any empty tiles.
		array.delete_if {|x| x == 0} 
		#Determines amount of tiles needed to be filled.
		fillCount = 4 - array.count 
		#pushes zeros to the front of the array
		if swapped
			fillCount.times do 
				array.push(0)
			end
			#Combining tiles block
			for x in 0...4 
				if array[x] == array[x+1]
					array[x+1] *= 2
					array.delete_at(x)
					array.push(0)
				end
			end
		else
			fillCount.times do 
				array.unshift(0)
			end
			for x in [3,2,1,0]
				if array[x] == array[x-1]
					array[x-1] *= 2
					array.delete_at(x)
					array.unshift(0)
				end
			end
		end
		return array
	end

	def move(direction)
		return false if direction == nil
		#saves the previous board
		@oldBoard = @board
		#Section on breaking up the square into seperate arrays
		#Done so my swapping operation can be done to my board in
		#any orientation. 
		#Only direction of the move is needed
		if direction == "right"
			for row in 0...4
				for column in 0...4
					@temp[column] = @board[row][column]
				end
				@temp = swap(@temp, false)
				for column in 0...4
					@board[row][column] = @temp[column]
				end
			end
		elsif direction == "left"
			for row in 0...4
				for column in 0...4
					@temp[column] = @board[row][column]
				end
				@temp = swap(@temp, true)
				for column in 0...4
					@board[row][column] = @temp[column]
				end	
			end
		elsif direction == "up"
			for row in 0...4
				for column in 0...4
					@temp[column] = @board[column][row]
				end
				@temp = swap(@temp, true)
				for column in 0...4
					@board[column][row] = @temp[column]
				end				
			end
		elsif direction == "down"
			for row in 0...4
				for column in 0...4
					@temp[column] = @board[column][row]
				end
				@temp = swap(@temp, false)
				for column in 0...4
					@board[column][row] = @temp[column]
				end
			end
		end
		return true 
	end
end

window = Test.new
window.show