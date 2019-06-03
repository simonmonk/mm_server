class BookKeepingCategoriesController < ApplicationController
  before_action :set_book_keeping_category, only: [:show, :edit, :update, :destroy]

  # GET /book_keeping_categories
  # GET /book_keeping_categories.json
  def index
    @book_keeping_categories = BookKeepingCategory.all
  end

  # GET /book_keeping_categories/1
  # GET /book_keeping_categories/1.json
  def show
  end

  # GET /book_keeping_categories/new
  def new
    @book_keeping_category = BookKeepingCategory.new
  end

  # GET /book_keeping_categories/1/edit
  def edit
  end

  # POST /book_keeping_categories
  # POST /book_keeping_categories.json
  def create
    @book_keeping_category = BookKeepingCategory.new(book_keeping_category_params)

    respond_to do |format|
      if @book_keeping_category.save
        format.html { redirect_to @book_keeping_category, notice: 'Book keeping category was successfully created.' }
        format.json { render :show, status: :created, location: @book_keeping_category }
      else
        format.html { render :new }
        format.json { render json: @book_keeping_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_keeping_categories/1
  # PATCH/PUT /book_keeping_categories/1.json
  def update
    respond_to do |format|
      if @book_keeping_category.update(book_keeping_category_params)
        format.html { redirect_to @book_keeping_category, notice: 'Book keeping category was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_keeping_category }
      else
        format.html { render :edit }
        format.json { render json: @book_keeping_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_keeping_categories/1
  # DELETE /book_keeping_categories/1.json
  def destroy
    @book_keeping_category.destroy
    respond_to do |format|
      format.html { redirect_to book_keeping_categories_url, notice: 'Book keeping category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_keeping_category
      @book_keeping_category = BookKeepingCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_keeping_category_params
      params.require(:book_keeping_category).permit(:name, :code)
    end
end
