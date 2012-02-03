require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'bigbio'
include Bio::BioAlignment # Namespace

describe "BioAlignment::CodonSequence" do
  it "should support different codon tables"
end

describe "BioAlignment::Alignment" do

  it "should allow for adding FastaRecords that contain and id and seq" do
    aln = Alignment.new
    fasta = FastaReader.new('test/data/fasta/codon/codon-alignment.fa')
    fasta.each do | rec |
      aln.sequences << rec
    end
    aln.sequences.first.id.should == "ZK909.2e"
    aln.sequences.first.seq[0..15].should == "atgcccactcgattgg"
  end

  it "should allow CodonSequence as an input" do
    aln = Alignment.new
    fasta = FastaReader.new('test/data/fasta/codon/codon-alignment.fa')
    fasta.each do | rec |
      aln.sequences << CodonSequence.new(rec.id, rec.seq)
    end
    aln.sequences.first.id.should == "ZK909.2e"
    aln.sequences.first.to_s[0..46].should == "atg ccc act cga ttg gat att gtt gga aac ctt cag"
    # sequence, however, is no String!
    aln.sequences.first.seq[2] == Codon.new('act')
    # and elements may carry a pay load, here an amino acid value
    aln.sequences.first.seq[0].to_aa.should == "M"
    aln.sequences.first.seq[2].to_aa.should == "T"
  end

end

