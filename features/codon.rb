$: << 'lib'

require 'bio-alignment'
require 'bigbio'
include Bio::BioAlignment # Namespace

Given /^I read an MSA nucleotide FASTA file in the test\/data folder$/ do
  aln = Alignment.new
  fasta = FastaReader.new('test/data/fasta/codon/codon-alignment.fa')
  fasta.each do | rec |
    aln.sequences << CodonSequence.new(rec.id, rec.seq)
  end
  p aln
end

Given /^I iterate the sequence records$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I check the alignment$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^it should contain codons$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^it should translate to an amino acid MSA$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^it should write a nucleotide alignment$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^it should write an amino acid alignment$/ do
  pending # express the regexp above with the code you wish you had
end


