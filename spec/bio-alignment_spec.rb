require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'bigbio'
include Bio::BioAlignment # Namespace

describe "BioAlignment" do
  it "should allow for adding FastaRecords that contain and id and seq" do
    aln = Alignment.new
    fasta = FastaReader.new('test/data/fasta/codon/codon-alignment.fa')
    fasta.each do | rec |
      aln.sequences << rec
    end
    aln.sequences.first.id.should == "ZK909.2e"
    aln.sequences.first.seq[0..15].should == "atgcccactcgattgg"
  end
  it "should allow CodonSequence" do
    aln = Alignment.new
    fasta = FastaReader.new('test/data/fasta/codon/codon-alignment.fa')
    fasta.each do | rec |
      aln.sequences << CodonSequence.new(rec.id, rec.seq)
    end
    aln.sequences.first.id.should == "ZK909.2e"
    aln.sequences.first.to_s[0..46].should == "atg ccc act cga ttg gat att gtt gga aac ctt cag"
  end
end
