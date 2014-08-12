class LogsController < ApplicationController
  before_action :set_log, only: [:show, :edit, :update, :destroy]

  # GET /logs
  def index
    @logs = Log.my(current_user).all
  end

  # GET /logs/1
  def show
    @logs = Log.my(current_user).all
    @log_entries = @log.log_entries
  end

  # GET /logs/new
  def new
    @log = Log.my(current_user).new
  end

  # GET /logs/1/edit
  def edit
  end

  # POST /logs
  def create
    @log = Log.my(current_user).new(log_params)

    if @log.save
      redirect_to @log, notice: 'Log was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /logs/1
  def update
    if @log.update(log_params)
      redirect_to @log, notice: 'Log was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /logs/1
  def destroy
    @log.destroy
    redirect_to logs_url, notice: 'Log was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = Log.my(current_user).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def log_params
      params.require(:log).permit(:name, :remarks, :administrative_area_level_3, :administrative_area_level_2, :administrative_area_level_1, :country, :street_address, :lon, :lat)
    end
end
