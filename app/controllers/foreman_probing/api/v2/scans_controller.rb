module ForemanProbing
  module Api::V2
    class ScansController < ::Api::V2::BaseController
      include ::Api::Version2
      include ::Foreman::Renderer

      resource_description do
        resource_id 'foreman_probing'
        api_version 'v2'
        api_base_url '/foreman_probing/api'
      end

      before_action :find_resource, :only => %w{show rerun}

      def resource_class
        ForemanProbing::Scan
      end

      api :GET, '/scans', N_('List scans')
      param_group :search_and_pagination, ::Api::V2::BaseController
      def index
        @scans = resource_scope.order(:id => 'desc').paginate(:page => params[:page])
      end

      api :POST, '/scans', N_('Create a scan')
      param :targeting_type, String, :required => true,
        :desc => N_('Type of targeting, one of %') % ForemanProbing::ScanComposer::TARGETING_TYPES
      param :scan_type, String, :required => true, :desc => N_('Type of the scan, one of %s') % %w{TCP UDP ICMP}
      param :ports, String, :desc => N_('The ports to probe')
      param :proxy_id, :identifier, :required => true, :desc => N_('The smart proxy to run the scan from')
      param :direct, String, :desc => N_('')
      param :subnet_id, :identifier, :desc => N_('ID of subnet to scan')
      param :search_query, String, :desc => N_('Scan hosts matching the search query')
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
        @scan.save!
        task = ForemanTasks.async_task(::Actions::ForemanProbing::PerformScan,
                                       @scan,
                                       @scan.ports)
        @scan.task = task
        @scan.save!
        render :action => 'show'
      end

      api :GET, '/scans/:id', N_('Show scan')
      param :id, :identifier, :required => true
      def show; end
    end
  end
end
