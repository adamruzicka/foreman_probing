class CreateForemanProbingPorts < ActiveRecord::Migration
  def change
    create_table :foreman_probing_ports do |t|
      t.integer :number
      t.string :protocol
      t.string :state
      t.timestamps :null => false
      t.integer :probing_facet_id, :index => true
    end

    add_index :foreman_probing_ports, [:number, :protocol]
  end
end
