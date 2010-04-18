puts 'monkey patching'
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
      when 0...3600;                     value /= 60;            unit = 'minute'
      when 3600...(3600*24);             value /= 3600;          unit = 'hour'
      when (3600*24)...(3600*24*7);      value /= (3600*24);     unit = 'day'
      when (3600*24*7)...(3600*24*30);   value /= (3600*24*7);   unit = 'week'
      when (3600*24*30)...(3600*24*365); value /= (3600*24*30);  unit = 'month'
      else                               value /= (3600*24*365); unit = 'year'
      end

      value = 1 if value == 0
      "#{value.commas} #{unit}#{'s' unless value == 1}#{' ago' if past}"
    end
  end
end
