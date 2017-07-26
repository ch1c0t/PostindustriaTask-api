class Company < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:name, :quota]

    if errors.empty?
      validates_type [Float, Integer], :quota
      validates_max_length 255, :name
      validates_unique :name
      errors.add :quota, 'cannot be 0' if quota == 0
    end
  end

  # _state -- an instance of JSON::Ext::Generator::State sometimes may be passed.
  def to_json _state = nil
    values.to_json
  end
end
