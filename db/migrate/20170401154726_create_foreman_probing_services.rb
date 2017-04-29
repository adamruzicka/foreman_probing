class CreateForemanProbingServices < ActiveRecord::Migration
  def change
    create_table :foreman_probing_services do |t|
      t.integer :port_id, :index => true
      t.string  :name
      t.string  :method
      t.integer :confidence
    end
  end
end
