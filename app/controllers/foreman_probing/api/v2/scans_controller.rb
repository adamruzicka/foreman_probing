module ForemanProbing
  module Api::V2
    class ScansController < ::Api::V2::BaseController
      include ::Api::Version2
      include ::Foreman::Renderer

      before_action :find_resource, :only => %w{show rerun}

      api :GET, '/scans', N_('List scans')
      param_group :search_and_pagination, ::Api::V2::BaseController
      def index
        @scans = resource_base.order(:id => 'desc').paginate(:page => params[:page])
      end

      param_group :scan do
        # TODO: Fillme
        param :targeting_type, String, :required => true
        param :scan_type, String, :required => true
        param :ports, String, :desc => N_('The ports to probe')
        param :probe, String, :required => true, :desc => N_('Type of the scan, one of %s') % %w{TCP UDP ICMP}
        param :proxy_id, String, :required => true, :desc => N_('The smart proxy to run the scan from')
      end
      
      api :POST, '/scans', N_('Create a scan')
      param_group :scan, :as => :create
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

      api :POST, '/scans/:id', N_('Rerun scan')
      param :id, :identifier, :required => true
      def rerun
        composer = ScanComposer.new_from_scan(ForemanProbing::Scan.find(params['id']))
        @scan = composer.compose!

        render :action => 'new'
      end

      api :GET, '/scans/:id', N_('Show scan')
      param :id, :identifier, :required => true
      def show; end
    end
  end
end
