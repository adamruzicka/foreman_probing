module ForemanProbing
  class Scan < ActiveRecord::Base

    belongs_to :task, :class_name => '::ForemanTasks::Task'
    has_one :targeting
    has_one :scan_host
    has_many :hosts, :through => :scan_host
    belongs_to :smart_proxy

    attr_accessor :direct, :subnet, :host, :tcp, :udp, :icmp, :use_nmap

    def ports
      if @ports.nil?
        return [] if raw_ports.nil?
        ranges = raw_ports.split(',')
        ports = ranges.map do |range|
          range.split('-').map do |from, to|
            to.nil? ? from : (from..to).entries
          end
        end
        @ports = ports.flatten.map(&:chomp).map(&:to_i)
      end
      @ports
    end

    def available_scan_types
      ['TCP', 'UDP', 'ICMP']
    end

    def target_kinds
      ['Direct', 'Subnet', 'Host', 'Proxy']
    end

  end
end
