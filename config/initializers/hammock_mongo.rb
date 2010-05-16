module HammockMongo
  def self.included base
    base.send :extend, HammockMongo::ClassMethods
    base.class_eval {
      before_create :set_new_before_save
    }
  end

  module ClassMethods
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def find_or_new_with(find_attributes, create_attributes = {}, should_adjust = false)
      if record = where(find_attributes).first
        returning record do
          record.attributes = create_attributes if should_adjust
        end
      else
        new create_attributes.merge(find_attributes)
      end
    end

    def find_or_create_with(find_attributes, create_attributes = {}, should_adjust = false)
      if record = find_or_new_with(find_attributes, create_attributes, should_adjust)
        logger.error "Create failed. #{record.errors.inspect}" if record.new_record? && !record.save
        logger.error "Adjust failed. #{record.errors.inspect}" if should_adjust && !record.update_attributes(create_attributes)
        record
      end
    end
  end

  def new_before_save?
    @new_before_save
  end

  def set_new_before_save
    @new_before_save = new_record?
  end

end
