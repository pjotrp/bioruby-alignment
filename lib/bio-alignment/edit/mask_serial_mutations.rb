require 'bio-alignment/edit/edit_rows'

module Bio
  module BioAlignment

    module MaskSerialMutations
      include MarkRows

      # edit copied alignment and mark elements if they are a continuous of
      # unique mutations in the alignment. The default is at least 5 mutations
      # in a row.
      def mark_serial_mutations min_serial=5
        mark_row_elements { |row,rownum| 
          # if an element is unique, mask it
          row.each_with_index do |e,colnum|
            e.state = ElementMaskedState.new
            column = columns[colnum]
            e.state.mask! if column.count{|e2| !e2.gap? and e2 == e } == 1
            # print e,',',e.state,';'
          end
          # now make sure there are at least 5 in a row, otherwise
          # start unmasking. First group all elements
          group = []
          row.each_with_index do |e,colnum|
            next if e.gap?
            if e.state.masked?
              group << e
            else
              if group.length <= min_serial
                # the group is too small
                group.each do | e2 |
                  e2.state.unmask!
                end
              end
              group = []
            end
          end
          row  # return changed sequence
        }
      end

    end
  end
end
