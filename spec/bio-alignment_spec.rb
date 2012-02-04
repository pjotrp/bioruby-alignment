require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'bigbio'
include Bio::BioAlignment # Namespace

describe "BioAlignment::CodonSequence" do
  it "should support different codon tables" do
    seq = CodonSequence.new("test", "atgcccagacgattgg")
    seq[0].to_aa.should == "M"
    seq[2].to_s.should == "aga"
    seq[2].to_aa.should == "R"

    seq5 = CodonSequence.new("test", "atgcccagacgattgg", :codon_table => 5)
    seq5[2].codon_table.should == 5
    seq5[0].to_aa.should == "M"
    seq5[2].to_s.should == "aga"
    seq5[2].to_aa.should == "S"

    seq2 = CodonSequence.new("test", "atgcccagacgattgg", :codon_table => 2)
    seq2[2].codon_table.should == 2
    seq2[0].to_aa.should == "M"
    seq2[2].to_aa.should == "*"
  end
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

