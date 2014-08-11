class LogEntriesController < ApplicationController
  before_action :set_log_entry, only: [:show, :edit, :update, :destroy]
  before_action :set_log

  # GET /log_entries
  def index
    @log_entries = LogEntry.my(current_user).all
  end

  # GET /log_entries/1
  def show
  end

  # GET /log_entries/new
  def new
    @log_entry = LogEntry.my(current_user).new(mhz: params[:mhz])

    finder = Uke::Finder.new
    finder.q = params[:mhz]
    finder.location = OpenStruct.new({longitude: @log.lon, latitude: @log.lat})
    @stations = finder.by_frq_order_by_distance
  end

  # GET /log_entries/1/edit
  def edit
  end

  # POST /log_entries
  def create
    @log_entry = LogEntry.my(current_user).new(log_entry_params)

    if @log_entry.save
      redirect_to @log_entry, notice: 'Log entry was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /log_entries/1
  def update
    if @log_entry.update(log_entry_params)
      redirect_to @log_entry, notice: 'Log entry was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /log_entries/1
  def destroy
    @log_entry.destroy
    redirect_to log_entries_url, notice: 'Log entry was successfully destroyed.'
  end

  private
    def set_log
      @log = Log.my(current_user).find(params[:log_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_log_entry
      @log_entry = LogEntry.my(current_user).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def log_entry_params
      params.require(:log_entry).permit(:description, :level)
    end
end
