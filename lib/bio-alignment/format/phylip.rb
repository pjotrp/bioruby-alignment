module Bio
  module BioAlignment
    module PhylipOutput
      # Calculate header info from alignment and return as string
      def PhylipOutput::header alignment
        "#{alignment.size} #{alignment[0].length}\n"
      end

      # Output sequence PAML style and return as a multi-line string
      def PhylipOutput::to_paml seq, size=60
        buf = seq.id+"\n"
        coding = if seq.kind_of?(CodonSequence) 
                 seq.to_nt
               else
                 seq.to_s
               end
        coding.scan(/.{1,#{size}}/).each do | section |
          buf += section + "\n"
        end
        buf
      end
    end
  end
end

