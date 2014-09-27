require "sinatra"

if development?
  require "sinatra/reloader"
end

require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "flashcards"
)

class Deck < ActiveRecord::Base
  has_many(:cards)
end

class Card < ActiveRecord::Base
end

get "/" do
  @decks = Deck.all
  erb :home
end

get "/decks/new" do
  erb :new_deck
end

post "/decks" do
  new_deck_name = params[:deck][:name]
  Deck.create({name: new_deck_name})
  redirect to "/"
end

get "/decks/:id" do
  @deck = Deck.find(params[:id])
  erb :decks
end

delete "/decks/:id" do
  deck = Deck.find(params[:id])
  deck.destroy
  redirect to "/"
end

get "/decks/:id/edit" do
  @deck = Deck.find(params[:id])
  erb :edit_deck 
end

patch "/decks/:id" do
  deck = Deck.find(params[:id])
  deck.update(name: params[:deck][:name])
  redirect to "/decks/#{params[:id]}" 
end

get "/decks/:id/cards/new" do
  @deck = Deck.find(params[:id])
  erb :new_card
end

post "/decks/:id/cards" do
  deck = Deck.find(params[:id])
  deck.cards.create(front: params[:card][:front])
  deck.cards.create(back: params[:card][:back])
  redirect to "/decks/#{params[:id]}"
end

get "/decks/:id/cards" do
  @deck = Deck.find(params[:id])
  erb :cards
end

get "/decks/:deck_id/cards/:card_id/edit" do
  @deck = Deck.find(params[:deck_id])
  @card = Card.find(params[:card_id])
  erb :edit_card
end

patch "/decks/:deck_id/cards/:card_id" do
  card = Card.find(params[:card_id])
  card.update(front: params[:card][:front])
  card.update(back: params[:card][:back])
  redirect to "/decks/#{params[:deck_id]}/cards"
end

delete "/decks/:deck_id/cards/:card_id" do
  card = Card.find(params[:card_id])
  card.destroy
  redirect to "/decks/#{params[:deck_id]}/cards"
end



