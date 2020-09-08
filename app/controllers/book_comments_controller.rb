class BookCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    @book_comment = @book.book_comments.build(book_comment_params)
    @book_comment.user_id = current_user.id
    @book_comments = @book.book_comments
    @book_comment.save
    flash[:success] = "Comment was successfully created."
  end

  def destroy
    @book = Book.find(params[:book_id])
    @book_comments = @book.book_comments
    book_comment = current_user.book_comments.find_by(id: params[:id], book_id: @book.id)

    book_comment.destroy
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment,:book_id,:user_id)
  end

end
