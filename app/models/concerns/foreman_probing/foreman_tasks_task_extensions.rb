module ForemanProbing
  module ForemanTasksTaskExtensions
    def self.prepended(base)
      base.instance_eval do
        has_one :scan, :dependent => :nullify, :foreign_key => 'task_id', :class_name => '::ForemanProbing::ScanHost'
      end
    end
  end
end
