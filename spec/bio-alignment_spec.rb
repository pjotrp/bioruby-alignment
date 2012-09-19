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
  columns2.count { |col| col.state.deleted? }.should == 6
  aln2.columns[0].state.should == columns2[0].state
  aln2.columns[0].state.should_not == columns[0].state
  aln2.rows.first.to_s.should == "----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV"
  # now write out the alignment with deleted columns removed
  aln3 = aln2.columns_where { |col| !col.state.deleted? }
  print aln3.to_s,"\n"
  aln3.rows.first.to_s.should == "SNSFSRPTIIFSGCSTACSGKSELVCGFRSFMLSDV"
end

describe "BioAlignment::DelBridges for codons" do
  # We are going to do the same for a codon alignment
  aln = Alignment.new
  fasta = FastaReader.new('test/data/fasta/codon/codon-alignment.fa')
  fasta.each do | rec |
    aln.sequences << CodonSequence.new(rec.id, rec.seq)
  end
  aln.extend DelBridges
  aln2 = aln.mark_bridges
  # print aln2[0].to_s,"\n"
  aln2.columns.size.should == 404
  # count deleted columns
  aln2.columns.count { |col| col.state.deleted? }.should == 5
  # create new alignment
  aln3 = aln2.columns_where { |col| !col.state.deleted? }
  aln3.columns.size.should == 399
end

# require 'bio'  # BioRuby
require 'bio-alignment/bioruby' # make Bio::Sequence enumerable

describe "BioAlignment::BioRuby interface" do
  include Bio::BioAlignment

  aln = Alignment.new
  aln << Bio::Sequence::NA.new("atgcatgcaaaa")
  aln << Bio::Sequence::NA.new("atg---tcaaaa")
  aln[0].should == "atgcatgcaaaa"
  aln[1].should == "atg---tcaaaa"
  Coerce::fetch_seq_string(aln[0]).should == "atgcatgcaaaa"
  Coerce::fetch_id(aln[0]).should == "id?"
  puts aln
end
