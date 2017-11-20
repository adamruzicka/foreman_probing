require 'open3'
require 'nmap/xml'

module ForemanProbingCore
  module Helpers
    module NmapHelper
      def nmap_probe
        sudo_prefix = self.scan_type == 'udp' ? ['sudo'] : []
        command = [sudo_prefix, 'nmap', nmap_ipv6_flag, nmap_arguments, nmap_flags, hosts, with_ports(@ports)].flatten
        result = {}
        status = nil
        puts "Executing: #{command.join(' ')}"
        Open3.popen3(*command) do |_stdin, stdout, stderr, wait_thr|
          wait_thr.join
          result[:out] = stdout.read
          result[:err] = stderr.read
          status = wait_thr.value
        end
        if status.success?
          process_result(xml_to_hash(result[:out]))
        else
          raise result[:err]
        end
      end

      private

      def hosts
        @hosts.map(&:to_s)
      end

      def nmap_flags
        raise NotImplementedError
      end

      def nmap_arguments
        %w(-oX -)
      end

      def nmap_ipv6_flag
        # @hosts.first.ipv6? ? '-6' : ''
        ''
      end

      # By default just return whatever is passed in
      # Can be used as an extension point
      def process_result(hash)
        hash
      end

      def xml_to_hash(output)
        xml = ::Nmap::XML.parse(output)
        xml.hosts.map do |host|
          ports = host.ports.reduce({}) do |acc, port|
            service = %w(confidence extra_info fingerprint hostname protocol product version).reduce({}) do |acc, key|
              acc.merge(key => port.service.public_send(key.to_sym))
            end
            service[:ssl] = port.service.ssl?
            service[:method] = port.service.fingerprint_method
            record = {
              port.number =>
              {
                :service => { port.service.name => service },
                :state => port.state,
                :reason => port.reason,
                :scripts => port.scripts
              }
            }
            acc.merge(port.protocol => acc.fetch(port.protocol, {}).merge(record))
          end
          {
            :_type     => :foreman_probing,
            :addresses => factify_addresses(lookup_addresses(host.addresses.map(&:to_h))),
            :hostnames => host.hostnames.map(&:to_h),
            :ports     => ports,
            :status    => host.status.to_h
          }
        end
      end

      def with_ports(ports)
        return '' if ports.empty? || nmap_flags.include?("-sn")
        "-p #{ports.join(',')}"
      end

      def factify_addresses(addresses)
        addresses.reduce({}) do |acc, address|
          type = address.delete(:type)
          addr = address.delete(:addr)
          acc.update(type => { addr => address })
        end
      end

      def lookup_addresses(addresses)
        @neighbour_cache ||= ForemanProbingCore::NeighbourCache.new.tap(&:cache!)
        ips = addresses.map { |address| address[:addr] }
        macs = ips.map do |ip|
          @neighbour_cache.mac_for_ip(ip)
        end.compact
        new_ips = macs.map do |mac|
          @neighbour_cache.ips_for_mac(mac).select { |ip| !ips.include? ip }.map do |ip|
            { :type => IPAddr.new(ip).ipv4? ? 'ipv4' : 'ipv6', :addr => ip, :vendor => nil }
          end
        end
        addresses + new_ips.flatten + macs.flatten.map { |mac| { :type => 'hwaddr', :addr => mac, :vendor => nil } }
      end
    end
  end
end
