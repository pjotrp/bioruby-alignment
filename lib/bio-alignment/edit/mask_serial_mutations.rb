require 'bio-alignment/edit/edit_rows'

module Bio
  module BioAlignment

    module MaskSerialMutations
      include MarkRows
   
      def mark_serial_mutations 
        mark_row_elements { |row| 
          row.each { |e| 
            p e
          }
          # num = row.count { |e| e.gap? }
          # if (num.to_f/row.length) > 1.0-percentage/100.0
          #   state.delete!
          # end
          # state
        }
      end

    end
  end
end
