module Bio
  module BioAlignment
    module TextOutput
      
      def TextOutput::to_text seq, style
        res = ""
        res += Coerce::fetch_id(seq).to_s + "\t"
        res += if seq.kind_of?(CodonSequence) and style == :codon
                 seq.to_s
               else
                 Coerce::fetch_seq_string(seq)
               end
        res+"\n"
      end

    end
  end
end
