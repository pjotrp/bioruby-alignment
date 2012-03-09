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

  include Bio::BioAlignment
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

Now add some state - you can define your own row state

```ruby
  # tell the row to handle state
  aln[0].extend(State)
  # mark the first row for deletion
  aln[0].state = MyStateDeleteObject.new
  if aln.rows[0].state.deleted?
    # do something
  end
```

### Accessing columns

BioAlignment has a module for handling columns in an alignment. As
long as the contained sequence objects have the [] and length methods,
they can lazily be iterated by column. To get a column and iterate it

```ruby
  column = aln.columns[3]
  column.each do |element|
    p element
  end
```

Now add some state - you can define your own column state

```ruby
  aln.columns[3].state = MyStateDeleteObject.new
  if aln.columns[3].state.deleted?
    # do something
  end
```

### BioRuby Sequence objects

BioAlignment supports adding BioRuby's Bio::Sequence objects:

```ruby
  require 'bio'  # BioRuby
  require 'bio-alignment'
  require 'bio-alignment/bioruby' # make Bio::Sequence enumerable
  include Bio::BioAlignment

  aln = Alignment.new
  aln.sequences << Bio::Sequence::NA.new("atgcatgcaaaa")
  aln.sequences << Bio::Sequence::NA.new("atg---tcaaaa")
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

### Alignment editing

One of the primary reasons for creating BioAlignment is to provide
easy ways of editing alignments using a functional style of
programming. Primitives are provided which take out much of the
plumbing, such as maintaining row/column/element state, and allow
copy-on-edit (so no conflicts arise in concurrent code). For example,
to walk an alignment by row, and update the row state, you can mark
all rows for deletion which contain many gaps

```ruby
  include MarkRows
  mark_rows { |rowstate,row|  # for every row/sequence
    num = row.count { |e| e.gap? }
    if (num.to_f/row.length) > 0.5
      rowstate.delete!  # mark row for deletion
    end
    rowstate   # returns the updated row state
  }
```

next, return a (deep) copy of the original alignment with the rows
that are not marked for deletion

```ruby
  aln2 = aln.rows_where { |row| !row.state.deleted? }
```

The general idea is that there are many potential ways of selecting
rows, and changing some state. The 'mark_rows' function/iterator takes
care of the plumbing. All the programmer needs to do is to set the
criterion, in this case a gap percentage, and tell the library what
state has to change. In this example we only access one row, but you
can also access the other rows. You won't be surprised that marking
columns looks much the same

```ruby
  include MarkColumns
  mark_columns { |colstate,col|  # for every row/sequence
    num = col.count { |e| e.gap? }
    if (num.to_f/col.length) > 0.5
      colstate.delete! 
    end
    colstate
  }
```

Next to modifying the state of rows and columns, you can also access
the state of alignment elements (i.e. codons, amino acids, nucleotide
acids). For example

```ruby
  # coming
```

Note that, instead of directly editing alignments, this module always
makes it a two step process. First items are marked through the state,
next the alignment is rewritten using this state. The advantage of
using an intermediate state is that the state can be queried for
creating (for example) nice output/graphics, using both the original
and changed alignments. For example, it is really easy to create a
nice output showing which columns were deleted in the original
alignment, or which amino acids were masked. Still, methods are
available, which hide the two step process, as seen in the next
example.

BioAlignment supports many alignment editing features, which are
listed
[here](https://github.com/pjotrp/bioruby-alignment/tree/master/features/edit).
An edit feature is added at runtime(!) Example:

```ruby
  require 'bio-alignment/edit/del_bridges'

  aln.extend DelBridges         # mix the module into the object 
  aln2 = aln.del_bridges        # execute the alignment editor
```

where aln2 is a copy of aln with bridging columns deleted.

### See also

The API documentation is online. For more code examples see
[./spec/*.rb](https://github.com/pjotrp/bioruby-alignment/tree/master/spec) and
[./features/*](https://github.com/pjotrp/bioruby-alignment/tree/master/features).

## Cite

If you use this software, please cite http://dx.doi.org/10.1093/bioinformatics/btq475

## Copyright

Copyright (c) 2012 Pjotr Prins. See LICENSE.txt for further details.

## Biogems.info

This exciting Ruby Biogem is published on http://biogems.info/
