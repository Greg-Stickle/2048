require 'gosu'

class G2048 < Gosu::Window
	def initialize
		super(400,400)
		@board = Array.new(4) {Array.new(4,0)}
		@board[0][1] = 2
		@board[0][2] = 2
		@board[1][0] = 2
		@board[1][2] = 2
		for x in 0...4
			for y in 0...4
				print "#{@board[x][y]} "
			end
			puts ""
		end
		@direction = nil
		@count = 0
	end

	def draw_board
		for x in 0...4
			for y in 0...4
				print "#{@board[x][y]} "
			end
			puts ""
		end
	end

	def draw

	end

	def update
		move(@direction)
		@direction = nil
		if @count > 10
			puts "----------------"
			draw_board
			@count = 0
		end
		@count +=1
	end

	def button_down(id)
		@direction = "left" if id == Gosu::KbLeft
		@direction = "right" if id == Gosu::KbRight
		@direction = "up" if id == Gosu::KbUp
		@direction = "down" if id == Gosu::KbDown
		if id == Gosu::KbR && button_down?(Gosu::KbLeftControl)
			@board = Array.new(4) {Array.new(4,0)}
		end
	end

	def move(direction)
		return if direction == nil
		if direction == "right"
			for row in 0...4 
				for column in 0...4
					3.times do
						if @board[row][column] == 0
							@board[row].delete_at(column)
							@board[row].unshift(0)
						else
							if @board[row][column] == @board[row][column-1]
								@board[row][column-1] *= 2
								@board[row].delete_at(column)
								@board[row].unshift(0)
						end
					end
				end
			end
		elsif direction == "left"
			for row in 0...4 
				for column in 0...4
					3.times do
						if @board[row][column] == 0
							@board[row].delete_at(column)
							@board[row].push(0)
						end
					end
				end
			end
		elsif direction == "up"
			for row in 0...4 
				for column in 0...4
					3.times do
						if @board[row][column] == 0
							@board[column].delete_at(row)
							@board[column].push(0)
						end
					end
				end
			end
		elsif direction == "down"
		end
	end
end
window = G2048.new
window.show