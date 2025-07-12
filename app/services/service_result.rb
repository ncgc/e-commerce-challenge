class ServiceResult
  attr_reader :value, :errors

  def initialize(success, value = nil, errors = [])
    @success = success
    @value = value
    @errors = Array(errors) # Ensure errors is always an array
  end

  def success?
    @success
  end

  def failure?
    !@success
  end

  def self.success(value)
    new(true, value)
  end

  def self.failure(errors)
    new(false, nil, errors)
  end
end
