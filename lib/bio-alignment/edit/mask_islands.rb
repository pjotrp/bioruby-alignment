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

      # Drop all 'islands' in a sequence with low consensus, i.e. islands that
      # show a gap larger than 'min_gap_size' (default 3) on both sides, and
      # are shorter than 'max_island_size' (default 30). An island larger than
      # 30 elements is arguably no longer an island, and low consensus
      # stretches may be loops - it is up to the alignment procedure to get
      # that right. We also allow for micro deletions inside an alignment (1 or
      # 2 elements).  The island consensus is calculated by column. If more
      # than 50% of the island shows consensus, the island is retained.
      # Consensus for each element is defined as the number of matches in the
      # column (default 1).
      def mark_islands
        logger = Bio::Log::LoggerPlus['bio-alignment']
        count_marked_islands = 0
        count_marked_elements = 0

        # Traverse each row in the alignment
        mark_row_elements { |row,rownum|
          # for each element create a state object, and find unique elements (i.e. consensus) across a column
          row.each_with_index do |e,colnum|
            e.state = IslandElementState.new
            column = columns[colnum]
            e.state.unique = (column.count{|e2| !e2.gap? and e2 == e } == 1)
            # p [e,e.state,e.state.unique]
          end
          # at this stage all elements of the row have been set to unique,
          # which are unique. Now group elements into islands (split on gap)
          # and mask
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
                  ci, ce = mark_island(island)
                  count_marked_islands += ci
                  count_marked_elements += ce
                  # print_island(island)
                  island = []
                end
              end
            end
          end
          if in_island
            ci, ce = mark_island(island)
            count_marked_islands += ci
            count_marked_elements += ce
            # print_island(island) if island.length > 0
          end
        }
        logger.info("#{count_marked_islands} islands marked (#{count_marked_elements} elements)")
        self
      end

    private
    
      # Check a list of elements that form an island. First count the number
      # of elements marked as being unique. If the island is more than 50%
      # unique (i.e. less than 50% consensus with the rest if the alignment) 
      # all island elements are marked for masking. Returns the number of
      # islands and elements marked as a tuple
      def mark_island island
        return 0,0 if island.length < 2
        unique = 0
        count_islands = 0
        count_elements = 0
        island.each do |e|
          unique += 1 if e.state.unique == true
        end
        consensus = 1.0 - unique.to_f / island.length
        # p unique, consensus
        if consensus < 0.5
          island.each do |e|
            e.state.mask!
          end
          count_islands += 1
          count_elements += island.size
        end
        return count_islands, count_elements
      end

      def print_island island
        p island.map {|e2| e2.to_s + ':' + e2.state.to_s }.join(",")
      end
    end
  end
end
