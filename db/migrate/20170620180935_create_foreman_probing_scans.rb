class CreateForemanProbingScans < ActiveRecord::Migration[4.2]
  def change
    create_table :foreman_probing_scans do |t|
      t.belongs_to :smart_proxy, :index => true
      t.string :scan_type
      t.string :raw_ports
      t.string :task_id
    end

    create_table :foreman_probing_scan_hosts do |t|
      t.integer :scan_id, :index => true
      t.integer :host_id, :index => true
    end
  end
end
