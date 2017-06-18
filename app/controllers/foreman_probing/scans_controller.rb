module ForemanProbing
  class ScansController < ::ApplicationController

    def new
      @scan = ForemanProbing::Scan.new
    end

    def create
      composer = ScanComposer.new_from_params(params[:foreman_probing_scan])
      task = ForemanTasks.async_task(::Actions::ForemanProbing::PerformScan,
                                     composer.proxy,
                                     composer.targeting,
                                     composer.probe,
                                     composer.ports)
      redirect_to task
    end

  end
end
