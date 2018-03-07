class CreateForemanProbingTargetings < ActiveRecord::Migration[4.2]
  def change
    create_table :foreman_probing_targetings do |t|
      t.string :type, index: true, null: false
      t.string :raw_targets, index: true
      t.belongs_to :scan, index: true
    end
  end
end
