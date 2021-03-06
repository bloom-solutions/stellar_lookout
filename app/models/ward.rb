class Ward < ActiveRecord::Base

  scope :watching, ->(operation) do
    addresses = Operation::ADDRESS_FIELDS.map do |field|
      operation.body[field.to_s]
    end.compact
    where(address: addresses)
  end

end
