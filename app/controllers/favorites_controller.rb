class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :favorite_params
  def create

    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save
  end

  def destroy

    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
  end

    def favorite_params
    @book = Book.find(params[:book_id])
  end
end
