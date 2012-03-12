require 'bio-alignment/edit/edit_rows'

module Bio
  module BioAlignment

    module MaskIslands
      include MarkRows

      class IslandElementState < ElementMaskedState
        attr_accessor :unique
        def to_s
          super + (@unique?'U':' ')
        end
      end

      # Drop all 'islands' in a sequence with low consensus, that show a gap
      # larger than 'min_gap_size' (default 3) on both sides, and are shorter
      # than 'max_island_size' (default 30). An island larger than 30 elements
      # is arguably no longer an island, and low consensus stretches may be
      # loops - it is up to the alignment procedure to get that right. We also
      # allow for micro deletions inside an alignment (1 or 2 elements).
      # The island consensus is calculated by column. If more than 50% of the
      # island shows consensus, the island is retained. Consensus for each
      # element is defined as the number of matches in the column (default 1).
      def mark_islands
        mark_row_elements { |row,rownum|
          # first set state and find unique elements (i.e. consensus)
          row.each_with_index do |e,colnum|
            e.state = IslandElementState.new
            column = columns[colnum]
            e.state.unique = (column.count{|e2| !e2.gap? and e2 == e } == 1)
            # p [e,e.state,e.state.unique]
          end
          # group elements into islands (split on gap) and mask
          gap = []
          island = []
          in_island = true
          row.each do |e|
            if not in_island
              if e.gap?
                gap << e
              else
                island << e
                in_island = true
                gap = []
              end
            else # in_island
              if not e.gap?
                island << e
                gap = []
              else
                gap << e
                if gap.length > 2
                  in_island = false
                  mark_island(island)
                  # print_island(island)
                  island = []
                end
              end
            end
          end
          if in_island
            mark_island(island)
            # print_island(island) if island.length > 0
          end
          # row.each_with_index do |e,colnum|
          #   e.state = ElementState.new
          #   column = columns[colnum]
          #   e.state.mask! if column.count{|e2| !e2.gap? and e2 == e } == 1
          #   # print e,',',e.state,';'
          # end
          # now make sure there are at least 5 in a row, otherwise
          # start unmasking. First group all elements
          # group = []
          # row.each_with_index do |e,colnum|
          #   next if e.gap?
          #   if e.state.masked?
          #     group << e
          #   else
          #     if group.length <= min_serial
          #       # the group is too small
          #       group.each do | e2 |
          #         e2.state.unmask!
          #       end
          #     end
          #     group = []
          #   end
          # end
          row  # return changed sequence
        }
      end

    private

      def mark_island island
        return if island.length < 2
        unique = 0
        island.each do |e|
          unique += 1 if e.state.unique == true
        end
        consensus = 1.0 - unique.to_f / island.length
        # p unique, consensus
        if consensus < 0.5
          island.each do |e|
            e.state.mask!
          end
        end
      end

      def print_island island
        p island.map {|e2| e2.to_s + ':' + e2.state.to_s }.join(",")
      end
    end
  end
end
