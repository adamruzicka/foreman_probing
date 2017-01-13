module ForemanProbing
  class ScansController < ::ApplicationController

    def index
    end

    def show
    end

    def new
      @scan = ForemanProbing::Scan.new
    end

    def create
      composer = ScanComposer.scan_from_params(params[:foreman_probing_scan])
      ForemanTasks.sync_task(::ForemanProbingCore::Actions::UseProbe,
                             composer.targeting.targets,
                             composer.probe,
                             composer.ports
                             )
    end

  end
end