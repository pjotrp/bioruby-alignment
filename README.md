# bio-alignment

Matrix style alignment handler for multiple sequence alignments (MSA).

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-alignment.png)](http://travis-ci.org/pjotrp/bioruby-alignment)

This alignment handler makes no assumptions about the underlying
sequence object. It supports any nucleotide, amino acid and codon
sequences that are lists. Any list with payload or state, can be used
(e.g.  nucleotide quality score, codon annotation). The only
requirement is that the list is Enumerable and can be indexed, i.e.
inherit Ruby Enumerable and have the [] method.

Features are:

* Matrix notation for alignment object
* Functional style alignment access and editing
* Support for BioRuby Sequences
* Support for BioRuby trees and node distance calculation
* bio-alignment interacts well with BioRuby structures,
  including sequence objects and alignment/tree parsers
* Support for textual and HTML output of MSA (planned)
* Support for Clayton's MAF parser is (planned)

When possible, BioRuby functionality is merged in. For example, by
supporting Bio::Sequence objects, standard BioRuby alignment
functions, sequence readers and writers can be used. By supporting the
BioRuby Tree object, standard BioRuby tree parsers and writers can be
used. bio-alignment takes alignment handling with phylogenetic tree
support to a new level.

bio-alignment is based on Pjotr's experience designing the BioScala
Alignment handler and BioRuby's PAML support. Read the
Bio::BioAlignment
[design
document](https://github.com/pjotrp/bioruby-alignment/blob/master/doc/bio-alignment-design.md)
for Ruby.

## Command line

bio-alignment comes with a command line interface (CLI), which can apply a number
of editing functions on an alignment, and generate textual and HTML
output. Note that the CLI does not cover the full library. The CLI can be useful
for non-Rubyists, pipeline setups, and simply as examples

Remove bridges (columns with mostly gaps) from an alignment

    bio-alignment aa-alignment.fa --type aminoacid --edit bridges

Mask islands (short misaligned 'floating' parts in a sequence) 

    coming soon...

Mask serial mutations

    coming soon...

Remove all sequences consisting of mostly gaps (30% informative) and output to FASTA
 
    bio-alignment codon-alignment.fa --type codon --edit info --out fasta

or output codon style

    bio-alignment codon-alignment.fa --type codon --edit info --style codon

Remove all sequences containing gaps from an alignment (why would you
want to do that?)

    bio-alignment codon-alignment.fa --type codon --edit info --perc 100 --out fasta

## Section for developers

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
    aln << CodonSequence.new(rec.id, rec.seq)
  end
  # write a matching amino acid alignment
  fasta = FastaWriter.new('aa-aln.fa')
  aln.rows.each do | row |
    fasta.write(row.id, row.to_aa.to_s)
  end
  # get first codon element of the fourth sequence
  p aln[3][0]
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
  aln << Bio::Sequence::NA.new("atgcatgcaaaa")
  aln << Bio::Sequence::NA.new("atg---tcaaaa")
```

or use BioRuby's flat file reader

```ruby
  aln = Alignment.new
  Bio::FlatFile.auto(filename).each_entry do |entry|
    aln << entry
  end
```

and, the other way, we can transform BioAlignment into BioRuby's
Bio::Alignment and use BioRuby functions

```ruby
  bioruby_aln = aln.to_bioruby_alignment
  bioruby_aln.consensus_iupac
```

Note that native BioRuby objects may not always work. In the first
case, using Bio::Sequence::NA, no ID is passed in, so each sequence is
labeled 'id?'. In the second case BioRuby's FlatFile returns a
FastaFormat object, this time with ID, but FastaFormat does not
support indexing. In general, it is recommended to stay with the
bio-alignment Sequence classes (or roll your own, as long as they are
Enumerable). 

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
    aln2 << Sequence.new(rec.id, rec.seq)
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

### Phylogeny

BioAlignment has support for attaching a phylogenetic tree to an
alignment, and traversing the tree using an intuitive interface

```ruby
  newick_tree = Bio::Newick.new(string).tree  # use BioRuby's tree parser
  tree = aln.attach_tree(newick_tree)         # attach the tree
  # now do stuff with the tree, which has improved bio-alignment support
  root = tree.root 
  children = root.children
  children.map { |n| n.name }.sort.should == ["","seq7"]
  seq7 = children.last
  seq4 = tree.find("seq4")
  seq4.distance(seq7).should == 19.387756600000003 
  # find the sequence in the alignment belonging to the node
  print seq4.sequence
  print tree.output_newick                  # BioRuby Newick output
```

There are methods for finding sibling nodes, splitting the alignment
based on the tree, and locating sequences on the same branch. More
examples can be found in the tests and features.  The underlying
implementation of Bio::Tree is that of BioRuby. We have added an OOP
layer for traversing the tree by injecting methods into the BioRuby
object itself. 

### Alignment marking/masking/editing

One of the primary reasons for creating BioAlignment is to provide
easy ways of editing alignments using a functional style of
programming. Primitives are provided which take out much of the
plumbing, such as maintaining row/column/element state, and allow
copy-on-edit (so no conflicts arise in concurrent code). For example,
to walk an alignment by row, and update the row state, you can mark
all rows (sequences) which contain many gaps for deletion

```ruby
  include MarkRows
  mark_rows { |rowstate,row|  # for every row/sequence
    num = row.count { |e| e.gap? }
    if (num.to_f/row.length) > 0.5
      # this row in the alignment consists mostly of gaps
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
state has to change. In this example we only access one row at a time,
but you can also access the other rows. You won't be surprised that
marking columns looks much the same

```ruby
  include MarkColumns
  mark_columns { |colstate,col|  # for every column
    num = col.count { |e| e.gap? }
    if (num.to_f/col.length) > 0.5
      colstate.delete! 
    end
    colstate
  }
```

''count'' is one of the universal functions that counts elements in a
row, column, or alignment.

Next to modifying the state of rows and columns, you can also access
the state of alignment elements (i.e. codons, amino acids, nucleotide
acids). For example, here we mask every element that has a masked
state

```ruby
  aln = masked_aln.update_each_element { |e| (e.state.masked? ?  Element.new("X"):e)}
```

and, here we remove every marked element by turning it into a gap

```ruby
  aln = marked_aln.update_each_element { |e| (e.state.marked? ? Element.new("-"):e)}
```

''update_each_element'' visits every element in the MSA, and replaces
the old with the new. 

It is important to note that, instead of directly editing alignments
in place, bio-alignment always makes it a two step process. First items
are masked/marked through the state of the rows/columns/elements, next
the alignment is rewritten using this state. The advantage of using an
intermediate state is that the state can be queried for creating (for
example) nice output/graphics, using both the original and changed
alignments. For example, it is really easy to create a nice output
showing which columns were deleted in the original alignment, or which
amino acids were masked. Still, methods are available, which hide the
two step process, as seen in the next example.

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

More examples can be found in the features/edit directory of the
source.

### See also

For more on the design of bio-alignment, read the
Bio::BioAlignment
[design
document](https://github.com/pjotrp/bioruby-alignment/blob/master/doc/bio-alignment-design.md).

The API documentation can be found
[online](http://rubygems.org/gems/bio-alignment). For examples see the files in
[./spec/*.rb](https://github.com/pjotrp/bioruby-alignment/tree/master/spec) and
[./features/*](https://github.com/pjotrp/bioruby-alignment/tree/master/features).

## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at [#bio-alignment](http://biogems.info/index.html)

## Copyright

Copyright (c) 2012 Pjotr Prins. See LICENSE.txt for further details.

