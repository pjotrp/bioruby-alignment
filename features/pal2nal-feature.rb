require 'bigbio'

Given /^I have an amino acid alignment$/ do
  @aln = Alignment.new
  fasta = FastaReader.new('test/data/fasta/codon/aa-alignment.fa')
  fasta.each do | rec |
    @aln.sequences << Sequence.new(rec.id, rec.seq)
  end
end

Given /^I have matching nucleotide sequences$/ do
  @aln2 = Alignment.new
  fasta = FastaReader.new('test/data/fasta/codon/nt.fa')
  fasta.each do | rec |
    @aln2.sequences << Sequence.new(rec.id, rec.seq)
  end
end

Then /^I should be able to generate a codon alignment$/ do
  fasta = FastaWriter.new('test/data/regression/pal2nal.fa')
  @aln.each_with_index do | aaseq, i |
    ntseq = @aln2.sequences[i]
    aaseq.id.should == ntseq.id
    codonseq = CodonSequence.new(ntseq.id, ntseq.seq)

    codon_pos = 0
    result = []
    aaseq.each do | aa |
      result <<
        if aa.gap?
          '---'
        else
          codon_pos += 1
          codonseq[codon_pos-1].to_s
        end
    end
    fasta.write(aaseq.id, result.join(''))
  end
end

Then /^I should be able to generate a codon alignment directly with pal2nal$/ do
  # pal2nal = @aln.pal2nal(@aln1)
  pending
end
