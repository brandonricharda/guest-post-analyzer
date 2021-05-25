class CreateBatches < ActiveRecord::Migration[6.1]
  def change
    create_table :batches do |t|

      t.timestamps
    end
  end
end
