module ForemanProbing
  class ScansController < ::ApplicationController

    def index
      @scans = resource_base.order(:id => 'desc').paginate(:page => params[:page])
    end

    def new
      @scan = ForemanProbing::Scan.new
      @scan.target_kind = params.fetch(:target_kind, 'direct')
      @scan.search_query = params[:search_query]
      @scan.targeting = ::ForemanProbing::Targeting.new
    end

    def create
      @composer = ScanComposer.new_from_params(params[:foreman_probing_scan])
      @scan = @composer.compose!
      @scan.save!
      task = ForemanTasks.async_task(::Actions::ForemanProbing::PerformScan,
                                     @scan,
                                     @scan.ports)
      @scan.task = task
      @scan.save!
      set_auto_refresh
      redirect_to @scan
    end

    def rerun
      composer = ScanComposer.new_from_scan(ForemanProbing::Scan.find(params['id']))
      @scan = composer.compose!

      render :action => 'new'
    end

    def show
      @scan = ::ForemanProbing::Scan.find(params['id'])
      set_auto_refresh
    end

    private

    def set_auto_refresh
      @auto_refresh = @scan.task.try(:pending?)
    end

  end
end
