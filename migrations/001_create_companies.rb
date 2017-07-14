Sequel.migration do
  up do
    create_table :companies do
      primary_key :id
      String :name
    end
  end

  down do
    drop_table :companies
  end
end
