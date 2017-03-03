require 'open3'
require 'nmap/xml'

module ForemanProbingCore
  module Helpers
    module NmapHelper
      def nmap_probe
        command = ['nmap', nmap_ipv6_flag, nmap_arguments, nmap_flags, hosts, with_ports(@ports)].flatten
        result = {}
        status = nil
        Open3.popen3(*command) do |_stdin, stdout, stderr, wait_thr|
          wait_thr.join
          result[:out] = stdout.read
          result[:err] = stderr.read
          status = wait_thr.value
        end
        if status.success?
          process_result(xml_to_hash(result[:out]))
        else
          parse_error(result[:err])
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
        @hosts.first.ipv6? ? '-6' : ''
      end

      # By default just return whatever is passed in
      # Can be used as an extension point
      def process_result(hash)
        hash
      end

      def xml_to_hash(output)
        xml = ::Nmap::XML.parse(output)
        xml.hosts.map do |host|
          ports = host.ports.map do |port|
            service = %w(extra_info fingerprint hostname name protocol version).reduce({}) do |acc, key|
              acc.merge(key => port.service.public_send(key.to_sym))
            end
            service[:ssl] = port.service.ssl?
            service[:method] = port.service.fingerprint_method
            port = {
              :service => service,
              :number => port.number,
              :protocol => port.protocol,
              :state => port.state,
              :reason => port.reason
            }
          end
          {
            :_type => :foreman_probing,
            :addresses => lookup_addresses(host.addresses.map(&:to_h)),
            :hostnames => host.hostnames.map(&:to_h),
            :ports     => ports,
            :status    => host.status.to_h
          }
        end
      end

      def with_ports(ports)
        return '' if ports.empty?
        "-p #{ports.join(',')}"
      end

      def lookup_addresses(addresses)
        macs = addresses.map do |address|
          mac_lookup(address[:addr])
        end
        addresses + macs.flatten.map { |mac| { :type => 'hwaddr', :addr => mac, :vendor => nil } }
      end

      def mac_lookup(ip)
        generate_cache! if @arp_cache.nil?
        @arp_cache.select { |record| record[:ip] == ip }.map { |record| record['lladdr'] }
      end

      def ip_lookup(mac)
        generate_cache! if @arp_cache.nil?
        @arp_cache.select { |record| record['lladdr'] == mac }.map { |record| record[:ip] }
      end

      def generate_cache!
        @arp_cache = `ip neigh show`.lines.map do |line|
          fields = line.chomp.split(/\s+/)
          hash = { :ip => fields.shift }
          fields.each_slice(2) do |k, v|
            if v
              hash[k] = v
            else
              hash[:state] = k
            end
          end
          hash
        end
      end
    end
  end
end
