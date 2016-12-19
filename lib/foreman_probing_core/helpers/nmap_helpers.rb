require 'nokogiri'

module ForemanProbingCore
  module Helpers
    module NmapHelper

      if ForemanProbingCore.can_use_nmap?

        def nmap_probe
          command = ['nmap', nmap_arguments, nmap_flags, @host, with_ports(ports)].flatten
          result = {}
          status = nil
          Open3.popen3(command) do |_stdin, stdout, stderr, wait_thr|
            wait_thr.join
            result[:out] = stdout.read
            result[:err] = stderr.read
            status = wait_thr.value
          end
          @result = if status.success?
            process_result(xml_to_hash(result[:out]))
          else
            parse_error(result[:err])
          end
        end

        private

        def nmap_flags 
          raise NotImplementedError
        end

        def nmap_arguments
          %w(-oX -)
        end

        def process_result(hash)
          raise NotImplementedError
        end

        def xml_to_hash(output)
          dom = Nokogiri.parse(output)
          dom.xpath('/nmaprun/host').map do |host|
            status = reduce_attributes(host.xpath('status').first)
            address = reduce_attributes(host.xpath('address').first)
            hostnames = host.xpath('hostnames').map { |hostname| reduce_attributes(hostname) }
            ports = host.xpath('ports/port').map do |port|
              inner = port.children.reduce({}) do |acc, cur|
                acc.merge(cur.name => reduce_attributes(cur))
              end
              reduce_attributes(port).merge(inner)
            end
            {
              :address => address,
              :status  => status,
              :hostnames => hostnames,
              :ports => ports
            }
          end
        end

        def reduce_attributes(dom)
          Hash[dom.keys.zip(dom.values)]
        end

        def with_ports(ports)
          return '' if ports.empty?
          "-p #{ports.join(',')}"
        end

      end

    end
  end
end