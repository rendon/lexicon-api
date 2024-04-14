class CreateLexemes < ActiveRecord::Migration[7.1]
  def change
    create_table :lexemes do |t|
      t.string :name
      t.string :definition
      t.string :source

      t.timestamps
    end
    add_index :lexemes, :name, unique: true
  end
end
