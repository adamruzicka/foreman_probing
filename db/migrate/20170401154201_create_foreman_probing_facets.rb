class CreateForemanProbingFacets < ActiveRecord::Migration[4.2]
  def change
    create_table :foreman_probing_probing_facets do |t|
      t.integer :host_id
      t.string :status
      t.timestamps
    end
  end
end
