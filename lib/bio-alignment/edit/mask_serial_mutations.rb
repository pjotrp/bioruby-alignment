require 'bio-alignment/edit/edit_rows'

module Bio
  module BioAlignment

    module MaskSerialMutations
      include MarkRows

      # edit copied alignment and mark elements
      def mark_serial_mutations 
        mark_row_elements { |row,rownum| 
          # if an element is unique, mask it
          row.each_with_index do |e,colnum|
            e.state = ElementState.new
            column = columns[colnum]
            e.state.mask! if column.count{|e2| !e2.gap? and e2 == e } == 1
            # print e,',',e.state,';'
          end
          # now make sure there are at least 5 in a row, otherwise
          # start unmasking
          row.each_with_index do |e,colnum|
          end
          row  # return changed sequence
        }
      end

    end
  end
end
