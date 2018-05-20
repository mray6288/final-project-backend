

class GameChannel < ApplicationCable::Channel
  @@count = 0

  def subscribed
  	# @game = Game.find_by(id: params[:game])
    # stream_for @game
    puts "SOMEONE SUBSCRIBED!!!!!!!\n"
    @@count += 1
    stream_for 'lobby'
    GameChannel.broadcast_to('lobby', [@@count])
  end

  def received(data)
  	puts "SOMEONE SENT DATA!!!!!!!\n"
  	GameChannel.broadcast_to('lobby', User.all)
  end

  def unsubscribed
	puts "SOMEONE UNSUBSCRIBED!!!!!!!\n"
	@@count -= 1
    GameChannel.broadcast_to('lobby', [@@count])
  end
end
