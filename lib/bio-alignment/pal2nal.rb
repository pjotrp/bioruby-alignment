# pal2nal (protein alignment to nucleotide alignment) implementation in Ruby

module Bio
  module BioAlignment
    module Pal2Nal

      # Protein to nucleotide alignment, using a codon table for testing. If :do_validate is
      # false, translation for validation is skipped (note CodonSequence translation is lazy).
      def pal2nal nt_aln, options = { :codon_table => 1, :do_validate => true }
        do_validate = options[:do_validate]
        aa_aln = self
        codon_aln = Alignment.new
        aa_aln.each_with_index do | aaseq, i |
          ntseq = nt_aln.sequences[i]
          raise "pal2nal sequence IDs do not match (for #{aaseq.id} != #{ntseq.id})" if aaseq.id != ntseq.id
          raise "pal2nal sequence size does not match (for #{aaseq.id}'s #{aaseq.to_s.size}!= #{ntseq.to_s.size * 3})" if aaseq.id != ntseq.id
          # create a Codon sequence out of the nucleotide sequence (no gaps)
          codonseq = CodonSequence.new(ntseq.id, ntseq.seq, options)

          codon_pos = 0
          result = []

          # now fill the result array by finding codons and gaps, and testing for valid amino acids
          aaseq.each do | aa |
            result <<
              if aa.gap?
                '---' # inject codon gap
              else
                codon = codonseq[codon_pos]
                # validate codon translates to amino acid
                raise "codon does not match amino acid (for #{aaseq.id}, position #{codon_pos}, #{codon} translates to #{codon.to_aa} instead of #{aa.to_s})" if do_validate and codon.to_aa != aa.to_s
                codon_pos += 1
                codon.to_s
              end
          end
          # the new result is transformed to a gapped CodonSequence
          codon_seq = CodonSequence.new(aaseq.id, result.join(''), options)
          codon_aln.sequences << codon_seq
        end
        codon_aln
      end
    end
  end
end
