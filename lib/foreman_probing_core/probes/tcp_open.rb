module ForemanProbingCore
  module ServiceProbes

    class TCPOpen < TCPProbe

      COMMON_PORTS = [22, 80, 443]

      def nmap_flags
        %w(-sT)
      end
    end

  end
end
