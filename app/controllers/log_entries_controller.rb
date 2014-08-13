class LogEntriesController < ApplicationController
  before_action :set_log_entry, only: [:show, :edit, :update, :destroy]
  before_action :set_log
  before_action :set_mhz_search_result, only: [:new, :create]

  # GET /log_entries/new
  def new
    @log_entry = LogEntry.my(current_user).new(mhz: Uke::Unifier::frq_string(params[:mhz]))
  end

  # GET /log_entries/1/edit
  def edit
  end

  # POST /log_entries
  def create
    @log_entry = LogEntry.my(current_user).new(log_entry_params)
    @log_entry.log = @log

    if @log_entry.save
      redirect_to @log, notice: 'Log entry was successfully created.'
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
    redirect_to @log, notice: 'Log entry was successfully destroyed.'
  end

  private

    def set_mhz_search_result
      mhz = params[:mhz] || params[:log_entry][:mhz]

      @bandplan = Bandplan.find_by_mhz mhz

      finder = Uke::Finder.new
      finder.q = mhz
      finder.location = OpenStruct.new({longitude: @log.lon, latitude: @log.lat})
      @stations = finder.by_frq_order_by_distance
      @stations = [] if @stations.nil?
    end

    def set_log
      @log = Log.my(current_user).find(params[:log_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_log_entry
      @log_entry = LogEntry.my(current_user).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def log_entry_params
      params.require(:log_entry).permit(:description, :level, :mhz, :related_frequency_assignment_id, :net, :administrative_area_level_3, :administrative_area_level_2, :administrative_area_level_1, :country, :street_address, :lon, :lat)
    end
end
