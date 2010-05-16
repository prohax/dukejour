module HammockMongo
  def logger
    @logger ||= Logger.new(STDOUT)
  end

  def find_or_new_with(find_attributes, create_attributes = {})
    if record = find(:first, :conditions => find_attributes)
      record
    else
      new create_attributes.merge(find_attributes)
    end
  end

  def find_or_create_with(find_attributes, create_attributes = {}, should_adjust = false)
    if record = find_or_new_with(find_attributes, create_attributes)
      logger.error "Create failed. #{record.errors.inspect}" if record.new_record? && !record.save
      logger.error "Adjust failed. #{record.errors.inspect}" if should_adjust && !record.update_attributes(create_attributes)
      record
    end
  end
end
