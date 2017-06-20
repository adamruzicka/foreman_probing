module ForemanProbing
  class ScansController < ::ApplicationController

    def new
      @scan = ForemanProbing::Scan.new
    end

    def create
      composer = ScanComposer.new_from_params(params[:foreman_probing_scan])
      @scan = ForemanProbing::Scan.new
      @scan.targeting = composer.targeting
      @scan.smart_proxy = composer.proxy
      @scan.scan_type = composer.probe
      @scan.save!
      task = ForemanTasks.async_task(::Actions::ForemanProbing::PerformScan,
                                     @scan,
                                     composer.ports)
      @scan.task = task
      @scan.save!
      set_auto_refresh
      redirect_to @scan
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
