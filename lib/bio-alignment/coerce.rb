module Bio
  module BioAlignment
    module Coerce
      # Make BioRuby's entry_id compatible with id
      def Coerce::fetch_id seq
        if seq.respond_to?(:id)
          seq.id
        else
          seq.entry_id
        end
      end

      # Coerce BioRuby's sequence objects to return the sequence itself
      def Coerce::fetch_seq seq
        if seq.respond_to?(:seq)
          seq.seq
        else
          seq
        end
      end

      # Coerce sequence objects into a string
      def Coerce::fetch_seq_string seq
        s = fetch_seq(seq)
        if s.respond_to?(:join)
          s.join
        else
          s.to_s
        end
      end
    end
  end
end

