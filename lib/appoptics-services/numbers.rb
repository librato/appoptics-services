require 'active_support/all'

module AppOptics
  module Services
    class Numbers
      def self.format_for_threshold(threshold, number, tolerance=2)
        threshold_decimals = number_decimal_places(threshold)
        number_decimals = number_decimal_places(number)

        if !threshold_decimals || !number_decimals
          return number_with_delimiter(number)
        end

        if (number_decimals - tolerance) <= threshold_decimals
          return number_with_delimiter(number)
        end

        # here we have more decimals in the number than the threshold
        # number:    3.14159
        # threshold: 3.14

        factor = (10**(threshold_decimals+tolerance)).to_f
        number_with_delimiter((number * factor).truncate / factor)
      end

      def self.number_decimal_places(number)
        segments = number.to_s.split('.')
        if segments.length != 2
          return 0
        end
        segments[1].length
      end

      # File actionpack/lib/action_view/helpers/number_helper.rb, line 199
      def self.number_with_delimiter(number, options = {})
        options.symbolize_keys!

        begin
          Float(number)
        rescue ArgumentError, TypeError
          if options[:raise]
            raise InvalidNumberError, number
          else
            return number
          end
        end

        options = options.reverse_merge({ delimiter: ',', separator: '.' })

        parts = number.to_s.to_str.split('.')
        parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")
        parts.join(options[:separator]).html_safe
      end
    end
  end
end
