module ForemanProbing
  module ForemanTasksTaskExtensions
    extend ActiveSupport::Concern

    included do
      has_one :scan, :dependent => :nullify, :foreign_key => 'task_id', :class_name => '::ForemanProbing::ScanHost'
    end
  end
end
