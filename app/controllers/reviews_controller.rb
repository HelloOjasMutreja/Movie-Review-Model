class ReviewsController < ApplicationController
    before_action :set_book
    before_action :set_review, only: %i[ edit, update, destroy]
    before_action :authenticate_user!, only: %i[ new, edit ]

    def new
        @review = Review.new
    end

    def create
        @review = Review.new(review_params)
        @review.book_id = @book.id
        @review.user_id = current_user.id

        respond_to do |format|
            if @review.save
              format.html { redirect_to book_url(@book), notice: "Review was successfully created." }
              format.json { render :show, status: :created, location: @book }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @review.errors, status: :unprocessable_entity }
            end
        end
    end

    def edit
        @review = Review.find(params[:id])        
    end

    def update
        @review = Review.find(params[:id])
            respond_to do |format|
                if @review.update(review_params)
                    format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
                    format.json { render :show, status: :ok, location: @book }
                else
                    render 'edit'
                end
            end
        end
    end

    def destroy
        @review.destroy

        respond_to do |format|
            format.html { redirect_to books_url, notice: "Review was successfully destroyed." }
            format.json { head :no_content }
        end
    end

    private

        def review_params
            params.require(:review).permit(:rating, :comment)            
        end

        def set_book
            @book = Book.find(params[:book_id])
        end
