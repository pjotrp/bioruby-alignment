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
end
