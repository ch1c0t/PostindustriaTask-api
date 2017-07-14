Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      foreign_key :company_id, :companies
      String :name
      String :email
    end
  end

  down do
    drop_table :users
  end
end
