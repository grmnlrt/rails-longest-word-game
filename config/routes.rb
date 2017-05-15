Rails.application.routes.draw do
  get 'game', to: 'longest_word#game', as: 'game'
  get 'score', to: 'longest_word#score', as: 'score'
end
