class Numeric
  def commas
    if self < 1000
      self
    else
      whole, fract = self.to_s.split('.')
      [ whole.reverse.scan(/\d{1,3}/).join(',').reverse, fract ].squash.join('.')
    end
  end

  # Round the value to num significant figures
  def sigfigs num, opts = {}
    shift = 10 ** (num - self.floor.to_s.length) # preserve this many digits after the decimal place, ** 10 for scaling
    val = (self * shift).round * 1.0 / shift # shift decimal place, chop off remainder, shift back
    val = val.floor if opts[:drop_trailing_zeros] && (val == val.floor) # drop '.0' if requested and present
    val # done
  end

  def xsecs
    value = self.abs
    past = (self < 0)

    if value == 0
      'now'
    elsif value === (1...60)
      "less than a minute#{' ago' if past}"
    else
      case value / 20
        when 0...3600;
          value /= 60;            unit = 'minute'
        when 3600...(3600*24);
          value /= 3600;          unit = 'hour'
        when (3600*24)...(3600*24*7);
          value /= (3600*24);     unit = 'day'
        when (3600*24*7)...(3600*24*30);
          value /= (3600*24*7);   unit = 'week'
        when (3600*24*30)...(3600*24*365);
          value /= (3600*24*30);  unit = 'month'
        else
          value /= (3600*24*365); unit = 'year'
      end

      value = 1 if value == 0
      "#{value.commas} #{unit}#{'s' unless value == 1}#{' ago' if past}"
    end
  end
end

class Object
  alias :L :lambda
end

#FROM HAMMOCK

if defined?(ActiveRecord::Base)
  class ActiveRecord::Base
    before_create :set_new_or_deleted_before_save

    def adjust attrs
      attrs.each {|k, v| send "#{k}=", v }
      save false
    end

    def adjust_attributes attrs
      self.attributes = attrs
      changed.empty? || update_attributes(attrs)
    end

    def new_or_deleted_before_save?
      @new_or_deleted_before_save
    end

    def set_new_or_deleted_before_save
      @new_or_deleted_before_save = new_record? || send_if_respond_to(:deleted?)
    end

    def description
      new_record? ? "new_#{base_model}" : "#{base_model}_#{id}"
    end

    def base_model
      self.class.base_model
    end  
  end

  class << ActiveRecord::Base
    def find_or_new_with(find_attributes, create_attributes = {})
      finder = respond_to?(:find_with_destroyed) ? :find_with_destroyed : :find

      if record = send(finder, :first, :conditions => find_attributes.tap { |a| a.delete(:deleted_at) })
        # Found the record, so we can return it, if:
        # (a) the record can't have a stored deletion state,
        # (b) it can, but it's not actually deleted,
        # (c) it is deleted, but we want to find one that's deleted, or
        # (d) we don't want a deleted record, and undestruction succeeds.
        if (finder != :find_with_destroyed) || !record.deleted? || create_attributes[:deleted_at] || record.restore
          record
        end
      else
        creating_class = if create_attributes[:type].is_a?(ActiveRecord::Base)
          create_attributes.delete(:type)
        else
          self
        end
        creating_class.new create_attributes.merge(find_attributes)
      end
    end

    def find_or_create_with(find_attributes, create_attributes = {}, should_adjust = false)
      if record = find_or_new_with(find_attributes, create_attributes)
        log "Create failed. #{record.errors.inspect}", :skip => 1 if record.new_record? && !record.save
        log "Adjust failed. #{record.errors.inspect}", :skip => 1 if should_adjust && !record.adjust_attributes(create_attributes)
        record
      end
    end

    def base_model
      base_class.to_s.underscore
    end
  end
end

class Time
  def to_i_msec
    (to_f * 1000).floor
  end
end

class String
  def normalize
    mb_chars.normalize(:kd).gsub(/[^\x00-\x7f]/n, '').to_s
  end

  def normalize_for_display
    mb_chars.normalize(:kd).
      gsub('¾', 'ae').
      gsub('?', 'd').
      gsub(/[^\x00-\x7f]/n, '').to_s
  end
end

class Array
  def hash_by *methods, &block
    hsh = Hash.new {|h, k| h[k] = [] }
    this_method = methods.shift

    # First, hash this array into +hsh+.
    each {|i| hsh[this_method == :self ? i : i.send(this_method)] << i }

    if methods.empty?
      # If there are no methods remaining, yield this group to the block if required.
      hsh.each_pair {|k, v| hsh[k] = yield(hsh[k]) } if block_given?
    else
      # Recursively hash remaining methods.
      hsh.each_pair {|k, v| hsh[k] = v.hash_by(*methods, &block) }
    end

    hsh
  end

  def squash
    dup.squash!
  end

  def squash!
    delete_if &:blank?
  end
end
