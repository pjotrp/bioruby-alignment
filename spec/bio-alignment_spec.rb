require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'bio-alignment'
require 'bigbio'  # for the FastaReader
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


describe "BioAlignment::DelBridges" do
  require 'bio-alignment/edit/del_bridges'
    string = 
      """
      ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGK-----FRSFRSFMLSAV
      ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      -------------IFHAVR-TC-HP-----------------
      """
  aln = Alignment.new(string.split(/\n/))
  print aln.to_s,"\n"
  columns = aln.columns
  columns.should_not == nil
  columns.should_not == []
  columns.size.should == 42
  # make sure we are using the same columns
  aln.columns.should == columns
  aln.extend DelBridges
  aln2 = aln.mark_bridges
  print aln2.to_s,"\n"
  columns2 = aln2.columns
  columns2.should_not == nil
  columns2.should_not == [] 
  columns2.count { |e| e.state.deleted? }.should == 6
  aln2.columns[0].state.should == columns2[0].state
  aln2.columns[0].state.should_not == columns[0].state

  # now write out the alignment without deleted columns
  aln3 = aln2.columns_where { |col| !col.state.deleted? }
  print aln3.to_s,"\n"
end
