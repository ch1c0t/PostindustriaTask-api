Sequel.migration do
  up do
    alter_table :companies do
      add_column :quota, Float
    end
  end

  down do
    alter_table :companies do
      drop_column :quota
    end
  end
end
