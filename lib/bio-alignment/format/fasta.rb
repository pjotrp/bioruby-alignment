module Bio
  module BioAlignment
    module FastaOutput
      def FastaOutput::to_fasta seq
        buf = ">"
        buf += seq.id+"\n"
        buf += if seq.kind_of?(CodonSequence) 
                 seq.to_nt
               else
                 seq.to_s
               end
        buf+"\n"
      end
    end
  end
end

