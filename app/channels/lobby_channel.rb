

class LobbyChannel < ApplicationCable::Channel
  # @@count = 0

  def subscribed
    puts "SOMEONE SUBSCRIBED!!!!!!!\n"
    # @@count += 1
    stream_for 'lobby'
    LobbyChannel.broadcast_to('lobby', Game.all)
  end

  def test
    puts 'TEST COMPLETE'
  end

  def received(data)
  	puts "SOMEONE SENT DATA!!!!!!!\n"
  	puts data
  	puts "END DATA\n"
  	# LobbyChannel.broadcast_to('lobby', User.all)
  end

  def unsubscribed
	puts "SOMEONE UNSUBSCRIBED!!!!!!!\n"
	# @@count -= 1
    # LobbyChannel.broadcast_to('lobby', [@@count])
  end
end
