module ForemanProbing
  module Targeting
    class Abstract

      def targets
        raise NotImplementedError
      end
    end

    class Direct < Abstract

      attr_accessor :ip, :netmask

      def targets
        @targets ||= IPAddr.new("#{ip}/#{netmask}").to_range.entries
      end
    end

    class Subnet < Abstract

      # belongs_to :subnet

      def targets
        @targets ||= subnet.ipaddr.to_range.entries
      end
    end

    class Host < Abstract

      attr_accessor :search_query

    # Use intermediate object? HostTargeting - SOMETHING - Host and use has_many_through
    # has_many :hosts

    def targets
      @targets ||= hosts.map { |host| host.interfaces.map(&:ip) }
    end

    def resolve_hosts!
      self.hosts = Host.authorized(RESOLVE_PERMISSION, Host)
      .search_for(search_query)
    end
  end
end
end