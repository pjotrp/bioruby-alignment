# Bio-alignment design

''A well designed library should be *simple* and elegant to use...''

## Introduction

Biological multi-sequence alignments (MSA) are matrices of nucleotide or amino
acid sequences with gaps. Despite this rather simple premise, most software
fails make it simple to access these structures. Also most implementations fail
to support a 'pay load' of items in the matrix (this is because underlying
sequences are String based). The result is that a developer has to track
information in multiple places. For example to track a base pair quality score
will be a second matrix of information. This makes code complex and therefore
error prone. With the bio-alignment library, elements of the matrix can carry
information, so called 'state'.  When the alignment gets edited, i.e. the
element gets moved or deleted, the information gets moved or deleted along. For
example, say we have a nucleotide sequence with quality pay load

    A   G   T    A
    |   |   |    |
    5   9   *    1

most library implementations will have two strings "AGTA" and "59*1".  Removing
the third nucleotide would mean removing it twice, into first "AGA", and second
"591". With bio-alignment this is one action because we have one object for
each element that contains both values, e.g. the payload of 'T' is '*'. Moving
'T' automatically moves '*'. Simple really.

In addition to carrying state, the bio-alignment library deals with codons and
codon translation.  Rather than track multiple matrices, the codon is viewed as
an element, and the translated codon as the pay load. Again, when an alignment
gets reordered the code only has to do it in one place.

Likewise, an alignment column can have a pay load (e.g. quality score in a pile
up), and an alignment row can have a pay load (e.g. the sequence name). The
concept of pay load, normally referred to as 'state', is handled through
generic matrix element, column, or row 'attributes'.

Many of these ideas came from my earlier work on the [BioScala
project](https://github.com/pjotrp/bioscala/blob/master/doc/design.txt),
The BioScala library has the additional advantage of having type
safety throughout, but lacks many of the features I have added to the
Ruby version.

## Row or Sequence

Any sequence for an alignment is simply a list of objects. The requirement for
any such list is that it should be enumerable and can be indexed. In Ruby
terms, the list has to include Enumerable and provide 'each' and '[]' methods.
The CodonSequence list, included in this library, is a good example.

In addition, elements in the list should respond to certain properties (see
below). 

```ruby
    # create a list of codons
    codons = CodonSequence.new(rec.id,rec.seq)
    print codons.id
    # get first codon
    print codons.seq[0].to_s
```

where to_s is defined as part of the Sequence.

Normally, at the sequence level a pay load is possible. This can be a standard
attribute of the class. If a list of attributes exists in the
sequence object, it can be used. For Codons we can fetch the amino
acid with

```ruby
    print codons.seq[0].to_aa
```

in fact, because bio-alignment demands Sequence is index-able we can write
directly

```ruby
    print codons[0].to_aa        # 'M'
    print codons[0].gap?         # false
    print codons[0].undefined?   # false
```

and because CodonSequence is enumerable, and Codon has the to_aa method, we can
do a fancy

```ruby
  aaseq = codons.map { | codon | codon.to_aa }.join("")
```

this is getting interesting... Codons, which are three letter nucleotide base
pairs, actually act as basic lists, and can be converted to amino acids. 

## Element

Elements in the list should respond to a gap? method, for an alignment
gap, and the undefined? method for a position that is either an
element or a gap. Also it should respond to the to_s method.

It is important to note that an element can contain *any* pay load, or state. Ruby
objects are 'open'. You can even add state at runtime.

## Elements and CodonSequence

Where the Sequence class is the most basic String representation of a sequence, we
also have the Elements class, which allows each element in a coding sequence to 
carry state.

The third list type we normally use in an Alignment, next to Sequence and
Elements, is the CodonSequence (remember, you can easily roll your own Sequence
type, just make them Enumerable and indexed).

## Column

The column list tracks the columns of the alignment. Again, the requirement is
that the list should be Enumerable and indexed. By default, the Column contains
no elements, only when the alignment is transposed. Matrix elements are found
by indexing on the sequences (rows).

One of the features of this library is that the Column access logic is 
split out into a separate module, which accesses the data in a lazy fashion. 
Also column state is stored as an 'any object'. I.e. a column can contain
any type of state.

## Matrix (MSA)

The matrix (multi sequence alignment or MSA) consists of a Column list, and
multiple Sequences, in turn consisting of Elements. Accessing the matrix is by
Sequence, followed by Element, leading to a matrix style notation

```ruby
  require 'bio-alignment'
  require 'bigbio' # for the Fasta reader
  include Bio::BioAlignment # Namespace
  aln = Alignment.new
  fasta = FastaReader.new('test/data/fasta/codon/codon-alignment.fa')
  fasta.each do | rec |
    aln.sequences << rec
  end
  # get first codon element of the fourth sequence
  codon = aln[3][0]
```

note that MSA understands rec, as long as rec.id and rec.seq exist, and strings
(req.seq is a String). Alternatively we can first convert to a Codon sequence by

```ruby
  fasta.each do | rec |
    aln.sequences << CodonSequence.new(rec.id,rec.seq)
  end
  # get first codon element of the fourth sequence
  codon = aln[3][0]
```

The Matrix can be accessed in transposed fashion, but accessing the normal
matrix and transposed matrix at the same time is not supported. Note that
Matrix editing is not designed to be transaction safe - better to copy the
Matrix when editing.

## Adding functionality

To ascertain that the basic BioAlignment implementation does not get polluted
with heaps of methods, extra functionality is added by using modules. These
modules can be added at run time(!) One advantage is that there is less name
space pollution, the other is that different implementations can be plugged in
- using the same interface. For example, here we are going to use an alignment
editor named DelBridges, which has a method named del_bridges:

```ruby
  require 'bio-alignment/edit/del_bridges'

  aln = Alignment.new(string.split(/\n/))
  aln.extend DelBridges   # bring the module into scope
  aln2 = aln.del_bridges
```

in other words, the functionality in DelBridges gets attached to the aln
instance at run time, without affecting any other instantiated object(!) Also,
when not requiring 'bio-alignment/edit/del_bridges', the functionality is never
visible, and never added to the runtime environment. This type of runtime
plugin is something you can only do in a dynamic language, such as Ruby. Ruby, 
makes it rather convenient.

You may have created own style sequence objects in an alignment. To register a
prefab deletion state, extend the sequence with the RowState module:

```ruby
  require 'bio-alignment/state'
  # Use the standard BioRuby sequence object
  bioseq = Bio::Sequence::NA.new("AGCT")
  bioseq.extend(State)          # add state
  bioseq.state = RowState.new   # set state
  p mysequence.state.deleted?   # query state
  > false
```

That is impressive - the BioRuby Sequence has no deletion state facility by
itself. We just added that, and it can even be used in BioAlignment editors
which require such a state object. See also the scenario "Give deletion state
to a Bio::Sequence object" in the bioruby.feature.

Note: if we wanted only to allow one plugin per instance at a time, we can
create a generic interface with a method of the same name for every
plugged in module. This ascertains that the same method can not be invoked from
multiple plugins (by default).

## Adding Phylogenetic support

An MSA often comes with a phylogenetic tree. Similar to runtime adding of the
delete state module, now we extend BioAlignment with
BioAlignment::AlignmentTree. A tree is plugged in with the add_tree method. See
the README and features directory for more examples.

## Methods returning alignments and concurrency

When an alignment gets changed, e.g. by one of the editing modules, the
original is copied using the 'clone' method. The idea is never to share data in
this library. Ruby does not really have guaranteed immutable data, so the only
safe way to write concurrent code is to copy all data before changing. The
'clone' methods implemented in the Alignment class are 'deep' clones.

Not only is copying a good idea for concurrency (and lazy caching of
values), but it also allows one to write succinct and descriptive code
in functional style, such as

```ruby
    aln2 = aln.mark_bridges.columns_where { |col| !col.state.deleted? }
```

where aln2 is a copy (of aln) with columns removed that were marked for
deletion.  In other words, applied ''Functional programming in Ruby.'' If
functions can be easily 'piped', and code can be easily copy and pasted into
different algorithms, it is likely that the module is written in a functional
style.

Copyright (C) 2012 Pjotr Prins <pjotr.prins@thebird.nl>
