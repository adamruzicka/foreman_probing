require 'foreman_tasks_core/runner'
require 'foreman_tasks_core/runner/command_runner'

module ForemanProbingCore
  module Actions
    class CommandRunner < ForemanTasksCore::Runner::CommandRunner
      def initialize(*command)
        super
        @command = command
      end

      def start
        initialize_command(*@command)
      end
    end

    class UseProbe < ForemanTasksCore::Runner::Action
      def initiate_runner
        if input.fetch('options', {})['subnet_discovery']
          input['local_addresses'] = get_local_addrs
          input['targets'] = input['local_addresses'].keys
        end
        output[:targets] = input[:targets]
        output[:local_addresses] = input[:local_addresses] if input.key? :local_addresses
        CommandRunner.new(*probe.command)
      end

      def finish_run(update)
        super
        output[:facts] = process_output(output[:result])
        output.delete(:result)
      end

      private

      def process_output(output)
        stdout, stderr = output.partition { |out| out[:output_type] == 'stdout' }
        if stderr.any?
          raise stderr.map { |out| out[:output] }.join('')
        else
          output = stdout.map { |out| out[:output] }.join('')
          probe.parse_result(output)
        end
      end

      def probe
        @probe ||= probe_class.new(input[:targets],
                                   input[:ports],
                                   input[:options])
      end

      def probe_class
        case input[:scan_type].downcase
        when 'tcp'
          ForemanProbingCore::Probes::TCP
        when 'udp'
          ForemanProbingCore::Probes::UDP
        when 'icmp'
          ForemanProbingCore::Probes::ICMP
        else
          raise "Unknown scan_type '#{input[:scan_type]}'"
        end
      end

      def get_local_addrs
        locals = Socket.getifaddrs.select { |ifaddr| ifaddr.addr && ifaddr.addr.ipv4_private? }
        locals.reduce({}) do |acc, ifaddr|
          # TODO: This is ugly
          cidr = 32 - ifaddr.netmask.ip_address.to_i.to_s(2).count('1')

          acc.merge("#{ifaddr.addr.ip_address}/#{cidr}" => { :addr => ifaddr.addr.ip_address,
                                                             :netmask => ifaddr.netmask.ip_address,
                                                             :cidr => cidr })
        end
      end

    end
  end
end
