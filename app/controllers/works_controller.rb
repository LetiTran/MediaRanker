class WorksController < ApplicationController

  before_action :find_work, only: [:show, :edit, :update, :destroy]
  before_action :find_active_user

  def index
    work = Work.all
    @albums = work.sorted_list("album")
    @movies = work.sorted_list("movie")
    @books = work.sorted_list("book")
  end

  def show
  end

  def new
    @work = Work.new()
  end

  def create
    @work = Work.new(work_params)

    if @work.save
      flash[:sucess] = "#{@work.title} saved"
      redirect_to works_path
    else
      flash.now[:alert] = "Media was not save."
      render :new
    end
  end

  def edit
    # @work = Work.find_by(id: params[:id])
  end

  def update
    # @work = Work.find_by(id: params[:id])
    if !@work.nil?
      if @work.update(work_params)
        flash[:sucess] = "Successfully updated #{@work.category} #{@work.title}"
        redirect_to work_path(@work.id)
      else
        flash.now[:alert] = "Media was not save."
        render :edit
      end
    else
      redirect_to works_path
    end
  end

  def destroy
    if @work
      @work.votes.each do |vote|
        vote.destroy
      end
      @work.destroy
      flash[:sucess] = "Successfully destroyed #{@work.category} #{@work.title} "
    else
      flash[:alert] = "Work does not exist"
    end
    redirect_to root_path
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end

  def find_work
    # a method to DRY other methods
    # see line with before_action at top of file.
    @work = Work.find_by_id(params[:id])
  end

end
