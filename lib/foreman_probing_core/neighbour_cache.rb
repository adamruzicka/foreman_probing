module ForemanProbingCore
  class NeighbourCache
    def initialize
      @cache = []
    end

    def ips_for_mac(mac)
      @cache.select { |record| record['lladdr'] == mac }.map { |record| record[:ip] }
    end

    def mac_for_ip(ip)
      @cache.select { |record| record[:ip] == ip }.map { |record| record['lladdr'] }.first
    end

    def cache!
      @cache = `ip neigh show`.lines.map do |line|
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

    def clean!
      @cache = {}
    end
  end
end
