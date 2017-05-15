class LongestWordController < ApplicationController

  def game
    session[:star_time] = Time.now.to_s
    session[:grid] = generate_grid(9)
  end

  def score
    grid = session[:grid]
    star_time = DateTime.parse(session[:star_time])
    end_time = Time.now
    @answer = params[:results].upcase
    @time_to_answer = end_time - star_time
    @translation = translation(@answer)
    @player_score = 0
    session[:score] = []
    attempt_check = included?(@answer, grid)

    if attempt_check == true && @translation != @answer
      @message = "well done"
      @player_score = player_score(@answer.length, @time_to_answer)
      @translation = translation(@answer)
    elsif attempt_check == true && @translation == @answer
      @message = "not an english word"
      @translation = @answer
    else
      @message = "not in the grid"
      @translation = @answer
    end
  end

  private

  def included?(guess, grid)
    guess.split("").all? do |letter|
      guess.count(letter) <= grid.count(letter)
    end
  end

  def generate_grid(grid_size)
    # Generate random grid of letters
    letters = ("A".."Z").to_a
    ramdom_letters = []
    grid_size.times { ramdom_letters << letters.sample }
    return ramdom_letters
  end

  def translation(word)
    # take a string as argument and return is french translation
    begin
      Timeout.timeout(5) do
        key = "416dbf55-283c-4d53-bb87-fe10ba1c7b9a"
        path = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{key}&input=#{word}"
        open_api = open(path).read
        translate = JSON.parse(open_api)
        return (translate['outputs'][0]['output']).to_s
      end
    rescue
      return "Erreur Api"
    end
  end

  def player_score(word_lenght, time)
  (word_lenght * 100) / time.to_i
end
end
