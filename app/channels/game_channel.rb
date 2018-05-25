require 'rest-client'
require 'json'




class GameChannel < ApplicationCable::Channel
  # @@count = 0


  def subscribed
    # puts "SOMEONE SUBSCRIBED GAME!!!!!!!\n"
    # puts params
    @game = Game.find(params[:id])
    stream_for "game-#{@game.id}"
    # puts 'HERE IS THE GAME', @game
    if @game.player2
      # if !@game.target
      #   @game.newGame()
      # end
      sleep(1)
      GameChannel.broadcast_to("game-#{@game.id}", {type: 'new_subscriber', game: @game, isPlayer: params[:username] === @game.player2})
    end
  end



  def test
    puts 'TEST COMPLETE'
  end

  def increment_timer(data)
    @game = Game.find(data['game_id'])
    @game.timer += 1
    num_guesses = 1
    if @game.timer >= 100
      GameChannel.broadcast_to("game-#{data['game_id']}", {type: 'time_up'})
    elsif @game.timer >= 60
      num_guesses = 20
    elsif @game.timer >= 45
      num_guesses = 10
    elsif @game.timer >= 30
      num_guesses = 5
    end
    guesses1 = fetchStuff(data['vectors'][@game.player1], num_guesses)
    guesses2 = fetchStuff(data['vectors'][@game.player2], num_guesses)
    if (guesses1.include?(@game.target))
      guess1 = @game.target
    else
      guess1 = guesses1[0]
    end
    if (guesses2.include?(@game.target))
      guess2 = @game.target
    else
      guess2 = guesses2[0]
    end

    GameChannel.broadcast_to("game-#{data['game_id']}", {type: 'increment_timer', data:{guess1:guess1,guess2:guess2, timer: @game.timer}})
    puts 'NEW GUESSES1', guesses1.inspect
    puts 'NEW GUESSES2', guesses2.inspect
    if (guesses1.include?(@game.target))
      @game.player1_score += 1
      GameChannel.broadcast_to("game-#{data['game_id']}", {type: 'game_over', winnerName:@game.player1})
    end
    if (guesses2.include?(@game.target))
      @game.player2_score += 1
      GameChannel.broadcast_to("game-#{data['game_id']}", {type: 'game_over', winnerName:@game.player2})
    end
    @game.save

  end



  def drawing(data)
    
    GameChannel.broadcast_to("game-#{data['game_id']}", {type:'drawing', data: data})
  end

  def end_path(data)
    GameChannel.broadcast_to("game-#{data['game_id']}", {type:'end_path', data: data})
  end

  def clear_canvas(data)
    GameChannel.broadcast_to("game-#{data['game_id']}", {type:'clear_canvas', data: data})
    @game = Game.find(data['game_id'])

  end

  def play_again(data)
    @game = Game.find(data['game_id'])
    if !@game.will_rematch
      @game.will_rematch = true
      @game.save
    else
      @game.set_target()
      @game.timer = 0
      @game.will_rematch = false
      @game.save 
      GameChannel.broadcast_to("game-#{data['game_id']}", {type: 'play_again', data: {target: @game.target}})
    end
  end

  def leave_channel(data)
    # byebug
    GameChannel.broadcast_to("game-#{data['game_id']}", {type:'opponent_left', username: data['username']})
    @game = Game.find(data['game_id'])
    @game.destroy
  end

  def unsubscribed
	# puts "SOMEONE UNSUBSCRIBED GAME!!!!!!!\n"
	# @@count -= 1
    # GameChannel.broadcast_to('Game', [@@count])
  end

  private 



  def fetchStuff(vectors, num_guesses=1)
    if vectors[0] == []
      return ['']
    end
    url = 'https://inputtools.google.com/request?ime=handwriting&app=quickdraw&dbg=1&cs=1&oe=UTF-8'
    headers = {
               'Content-Type':'application/json'
             }
    data = {'input_type':0,
               'requests':[
                {'language':'quickdraw',
                'writing_guide':{'width':1200,'height':260},
                'ink':[vectors]
                # 'ink': [[[431.25,431.25,430.25,426.25,420.25,412.25,399.25,382.25,367.25,352.25,337.25,322.25,304.25,292.25,284.25,269.25,262.25,255.25,249.25,243.25,235.25,228.25,218.25,206.25,195.25,184.25,176.25,170.25,163.25,156.25,153.25,150.25,149.25,149.25,149.25,149.25,149.25,154.25,161.25,168.25,176.25,184.25,191.25,202.25,215.25,230.25,259.25,280.25,303.25,323.25,346.25,367.25,387.25,405.25,421.25,436.25,448.25,455.25,463.25,468.25,473.25,480.25,482.25,488.25,492.25,495.25,498.25,499.25,501.25,502.25,502.25,502.25,502.25,501.25,499.25,496.25,493.25,490.25,487.25,481.25,477.25,473.25,468.25,460.25,452.25,443.25,433.25,427.25,420.25,414.25,410.25,406.25,403.25,400.25,397.25,390.25,385.25,377.25,372.25,368.25,365.25,362.25,361.25,136.25,136.25,146.25,158.25,184.25,212.25,249.25,317.25,348.25,374.25,392.25,405.25,414.25,422.25,427.25,431.25,432.25,433.25,434.25,435.25],[127.96875,127.96875,127.96875,127.96875,127.96875,126.96875,123.96875,120.96875,115.96875,111.96875,106.96875,101.96875,96.96875,94.96875,94.96875,94.96875,94.96875,94.96875,94.96875,96.96875,97.96875,99.96875,104.96875,110.96875,118.96875,126.96875,133.96875,139.96875,145.96875,153.96875,157.96875,161.96875,165.96875,170.96875,175.96875,180.96875,189.96875,199.96875,210.96875,223.96875,234.96875,244.96875,251.96875,257.96875,263.96875,270.96875,277.96875,281.96875,284.96875,284.96875,284.96875,283.96875,279.96875,275.96875,271.96875,268.96875,264.96875,261.96875,259.96875,256.96875,254.96875,251.96875,249.96875,245.96875,241.96875,238.96875,233.96875,229.96875,224.96875,219.96875,214.96875,210.96875,206.96875,202.96875,199.96875,194.96875,191.96875,187.96875,183.96875,177.96875,173.96875,169.96875,166.96875,161.96875,157.96875,150.96875,143.96875,137.96875,129.96875,123.96875,118.96875,115.96875,113.96875,112.96875,111.96875,111.96875,111.96875,111.96875,111.96875,111.96875,111.96875,111.96875,111.96875,88.96875,88.96875,88.96875,88.96875,88.96875,88.96875,88.96875,89.96875,90.96875,91.96875,92.96875,94.96875,95.96875,96.96875,98.96875,99.96875,99.96875,100.96875,100.96875,100.96875],[2275,2276,2287,2303,2321,2337,2353,2370,2387,2404,2419,2437,2453,2470,2487,2503,2520,2537,2554,2571,2586,2603,2620,2636,2653,2669,2687,2703,2719,2737,2752,2770,2786,2803,2820,2837,2854,2870,2887,2904,2921,2937,2954,2970,2988,3003,3021,3036,3053,3070,3087,3103,3119,3137,3154,3170,3186,3204,3220,3237,3254,3271,3286,3304,3319,3337,3354,3370,3388,3404,3420,3437,3453,3470,3486,3503,3520,3536,3553,3571,3586,3603,3620,3637,3653,3671,3687,3703,3719,3736,3753,3771,3786,3803,3820,3836,3853,3870,3886,3903,3919,3937,3953,11398,11398,11415,11432,11448,11465,11481,11514,11531,11549,11564,11581,11598,11615,11631,11648,11664,11681,11698,11714]]]
                }
               ]
              }
    # data = {"input_type":0,"requests":[{"language":"quickdraw","writing_guide":{"width":1200,"height":260},"ink":[[[431.25,431.25,430.25,426.25,420.25,412.25,399.25,382.25,367.25,352.25,337.25,322.25,304.25,292.25,284.25,269.25,262.25,255.25,249.25,243.25,235.25,228.25,218.25,206.25,195.25,184.25,176.25,170.25,163.25,156.25,153.25,150.25,149.25,149.25,149.25,149.25,149.25,154.25,161.25,168.25,176.25,184.25,191.25,202.25,215.25,230.25,259.25,280.25,303.25,323.25,346.25,367.25,387.25,405.25,421.25,436.25,448.25,455.25,463.25,468.25,473.25,480.25,482.25,488.25,492.25,495.25,498.25,499.25,501.25,502.25,502.25,502.25,502.25,501.25,499.25,496.25,493.25,490.25,487.25,481.25,477.25,473.25,468.25,460.25,452.25,443.25,433.25,427.25,420.25,414.25,410.25,406.25,403.25,400.25,397.25,390.25,385.25,377.25,372.25,368.25,365.25,362.25,361.25,136.25,136.25,146.25,158.25,184.25,212.25,249.25,317.25,348.25,374.25,392.25,405.25,414.25,422.25,427.25,431.25,432.25,433.25,434.25,435.25],[127.96875,127.96875,127.96875,127.96875,127.96875,126.96875,123.96875,120.96875,115.96875,111.96875,106.96875,101.96875,96.96875,94.96875,94.96875,94.96875,94.96875,94.96875,94.96875,96.96875,97.96875,99.96875,104.96875,110.96875,118.96875,126.96875,133.96875,139.96875,145.96875,153.96875,157.96875,161.96875,165.96875,170.96875,175.96875,180.96875,189.96875,199.96875,210.96875,223.96875,234.96875,244.96875,251.96875,257.96875,263.96875,270.96875,277.96875,281.96875,284.96875,284.96875,284.96875,283.96875,279.96875,275.96875,271.96875,268.96875,264.96875,261.96875,259.96875,256.96875,254.96875,251.96875,249.96875,245.96875,241.96875,238.96875,233.96875,229.96875,224.96875,219.96875,214.96875,210.96875,206.96875,202.96875,199.96875,194.96875,191.96875,187.96875,183.96875,177.96875,173.96875,169.96875,166.96875,161.96875,157.96875,150.96875,143.96875,137.96875,129.96875,123.96875,118.96875,115.96875,113.96875,112.96875,111.96875,111.96875,111.96875,111.96875,111.96875,111.96875,111.96875,111.96875,111.96875,88.96875,88.96875,88.96875,88.96875,88.96875,88.96875,88.96875,89.96875,90.96875,91.96875,92.96875,94.96875,95.96875,96.96875,98.96875,99.96875,99.96875,100.96875,100.96875,100.96875],[2275,2276,2287,2303,2321,2337,2353,2370,2387,2404,2419,2437,2453,2470,2487,2503,2520,2537,2554,2571,2586,2603,2620,2636,2653,2669,2687,2703,2719,2737,2752,2770,2786,2803,2820,2837,2854,2870,2887,2904,2921,2937,2954,2970,2988,3003,3021,3036,3053,3070,3087,3103,3119,3137,3154,3170,3186,3204,3220,3237,3254,3271,3286,3304,3319,3337,3354,3370,3388,3404,3420,3437,3453,3470,3486,3503,3520,3536,3553,3571,3586,3603,3620,3637,3653,3671,3687,3703,3719,3736,3753,3771,3786,3803,3820,3836,3853,3870,3886,3903,3919,3937,3953,11398,11398,11415,11432,11448,11465,11481,11514,11531,11549,11564,11581,11598,11615,11631,11648,11664,11681,11698,11714]]]}]}
    response = RestClient.post(url, data.to_json, headers=headers)
    result = JSON.parse(response)
    
    return result[1][0][1].take(num_guesses)
  end
end
