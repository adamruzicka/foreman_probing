module ForemanProbing
  class Targeting::Search < ::ForemanProbing::Targeting
    # def initialize(search_query, hosts = nil)
    #   @search_query = search_query
    #   @hosts = hosts
    # end

    def targets
      @hosts ||= resolve_hosts!
      @targets ||= @hosts.map { |host| host.interfaces.map(&:ip) }.flatten
    end

    def target_kind
      'host'
    end

    def resolve_hosts!
      # @hosts = Host.authorized(RESOLVE_PERMISSION, Host)
      #              .search_for(@search_query)
      ::Host.authorized.search_for(raw_targets)
    end
  end
end
