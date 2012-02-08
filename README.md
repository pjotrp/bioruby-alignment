# bio-alignment

Alignment handler for multiple sequence alignments (MSA).

This alignment handler makes no assumptions about the underlying
sequence object.  Support for any nucleotide, amino acid and codon
sequences that are lists. Any list with payload can be used (e.g.
nucleotide quality score, codon annotation). The only requirement is
that the list is iterable and can be indexed. 

This work is based on Pjotr's experience designing the BioScala
Alignment handler and BioRuby's PAML support. Read the
Bio::BioAlignment
[design
document](https://github.com/pjotrp/bioruby-alignment/blob/master/doc/bio-alignment-design.md)
for Ruby.

Note: this software is under active development.

## Developers

### Codon alignment example

To use the library, load aligned sequences into the Alignment
matrix. Here we write an amino acid alignment from a codon
aligmment (note codon gaps are represented by '---')

```ruby
  require 'bio-alignment'
  require 'bigbio' # Fasta reader and writer

  aln = Alignment.new
  fasta = FastaReader.new('codon-alignment.fa')
  fasta.each do | rec |
    aln.sequences << CodonSequence.new(rec.id, rec.seq)
  end
  # write a matching amino acid alignment
  fasta = FastaWriter.new('aa-aln.fa')
  aln.rows.each do | row |
    fasta.write(row.id, row.to_aa.to_s)
  end
```

### BioRuby Sequence objects

The BioAlignment supports adding BioRuby's Bio::Sequence objects:

```ruby
  require 'bio'  # BioRuby
  require 'bio-alignment/bioruby' # make Bio::Sequence enumerable
  
  aln = Alignment.new
  aln << Bio::Sequence::NA.new("atgcatgcaaaa")
  aln << Bio::Sequence::NA.new("atg---tcaaaa")
```

and we can transform BioAlignment into BioRuby's Bio::Alignment and
use BioRuby functions

```ruby
  bioruby_aln = aln.to_bioruby_alignment
  bioruby_aln.consensus_iupac
```

### Pal2nal

A protein (amino acid) to nucleotide alignment would first load
the sequences

```ruby
  aln1 = Alignment.new
  fasta1 = FastaWriter.new('aa-aln.fa')
  aln1.rows.each do | row |
    fasta1.write(row.id, row.to_aa.to_s)
  end
  aln2 = Alignment.new
  fasta2 = FastaReader.new('nt.fa')
  fasta2.each do | rec |
    aln2.sequences << Sequence.new(rec.id, rec.seq)
  end
```

Writing a (simple) version of pal2nal would be something like

```ruby
  fasta3 = FastaWriter.new('nt-aln.fa')
  aln.each_with_index do | aaseq, i |
    ntseq = aln2.sequences[i]
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
    fasta3.write(aaseq.id, result.join(''))
  end
```

With amino acid aa_aln and nucleotide nt_aln loaded, the library
version of pal2nal includes validation

```ruby
  aln = aa_aln.pal2nal(nt_aln, :codon_table => 3, :do_validate => true)
```

resulting in the codon alignment.

The API documentation is online. For more code examples see
[./spec/*.rb](https://github.com/pjotrp/bioruby-alignment/tree/master/spec) and
[./features/*](https://github.com/pjotrp/bioruby-alignment/tree/master/features).

## Cite

If you use this software, please cite http://dx.doi.org/10.1093/bioinformatics/btq475

## Copyright

Copyright (c) 2012 Pjotr Prins. See LICENSE.txt for further details.

## Biogems.info

This exciting Ruby Biogem is published on http://biogems.info/
