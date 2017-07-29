class User < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:name, :email, :company_id]

    if errors.empty?
      validates_max_length 255, :name
      validates_max_length 255, :email
      validates_unique :email
    end
  end

  # _state -- an instance of JSON::Ext::Generator::State sometimes may be passed.
  def to_json _state = nil
    values.to_json
  end
end
