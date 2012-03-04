# Bio-alignment design

''A well designed library should be simple and elegant to use...''

## Introduction

Biological multi-sequence alignments (MSA) are normally matrices of
nucleotide or amino acid sequences, with gaps. Despite this rather
simple premise, most software fails make it simple to access these
structures. Also most implementations fail to support a 'pay load' of
items in the matrix (mostly because underlying sequences are String
based). This means a developer has to track information in multiple
places, for example a base pair quality score. This makes code complex
and therefore error prone. With bio-alignment elements of the matrix
can carry information. So, when the alignment gets edited,
the element gets moved or deleted, and the information moves or
deletes along. For example,
say we have a nucleotide sequence with pay load

    A   G   T    A
    |   |   |    |
    5   9   *    1

most library implementations will have two strings "AGTA" and "59*1".
Removing the third nucleotide would mean removing it twice, into first
"AGA", and second "591". With bio-alignment this is one action because we
have one object for each element that contains both values, e.g. the
payload of 'T' is '*'. Moving 'T' automatically moves '*'.

In addition the bio-alignment library deals with codons and codon translation.
Rather than track multiple matrices, the codon is viewed as an element,
and the translated codon as the pay load. Again, when an alignment gets
reordered the code only has to do it in one place.

Likewise, an alignment column can have a pay load (e.g. quality score
in a pile up), and an alignment row can have a pay load (e.g. the
sequence name). The concept of pay load is handled through generic
matrix element, column, or row 'attributes'.

Many of these ideas came from my work on the [BioScala
project](https://github.com/pjotrp/bioscala/blob/master/doc/design.txt),
The BioScala library has the additional advantage of having type
safety throughout.

## Row or Sequence

Any sequence for an alignment is simply a list of objects. The
requirement is that the list should be enumerable and can be indexed. This means
it has to include Enumerable and provide 'each' and '[]' methods. CodonSequence 
is a good example.

In addition, elements in the list should respond to certain properties (see
below). 

```ruby
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

in fact, because Sequence is indexable we can write directly

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

## Element

Elements in the list should respond to a gap? method, for an alignment
gap, and the undefined? method for a position that is either an
element or a gap. Also it should respond to the to_s method.

An element can contain any pay load.  If a list of attributes exists
in the sequence object, it can be used.

## Column

The column list tracks the columns of the alignment. The requirement
is that it should be iterable and can be indexed. The Column contains
no elements, but may point to a list when the alignment is transposed.

One of the 'features' of this library is that the Column access logic is 
split out into a separate module, which accesses the data in a lazy fashion. 
Also column state is stored as an 'any object'. I.e. a column can contain
any state.

## Matrix or MSA

The Matrix consists of a Column list, multiple Sequences, in turn
consisting of Elements. Accessing the matrix is by Sequence, followed
by Element.

```ruby
  require 'bio-alignment'
  require 'bigbio' # for the Fasta reader
  include Bio::BioAlignment # Namespace
  aln = Alignment.new
  fasta = FastaReader.new('test/data/fasta/codon/codon-alignment.fa')
  fasta.each do | rec |
    aln.sequences << rec
  end
```

note that MSA understands rec, as long as rec.id and rec.seq exist, and strings
(req.seq is a String). Alternatively we can convert to a Codon sequence by

```ruby
  fasta.each do | rec |
    aln.sequences << CodonSequence.new(rec.id,rec.seq)
  end
```

The Matrix can be accessed in transposed fashion, but accessing the normal
matrix and transposed matrix at the same time is not supported.  Matrix is not
designed to be transaction safe - though you can copy the Matrix any time.

## Adding functionality

To ascertain that the basic BioAlignment implementation does not get
polluted, extra functionality is added by using extra Modules. These
modules can be added at run time(!) One advantage is that there is
less name space pollution, the other is that different implementations
can be plugged in - using the same interface. For example, here we are
going to use an alignment editor named DelBridges, which has a method
named del_bridges:

```ruby
  require 'bio-alignment/edit/del_bridges'

  aln = Alignment.new(string.split(/\n/))
  aln.extend DelBridges   # bring the module into scope
  aln2 = aln.del_bridges
```

in other words, the functionality in DelBridges gets attached to the
aln instance at run time, without affecting any other instatiated
object(!) Also, when not requiring 'bio-alignment/edit/del_bridges',
the functionality is never visible, and never added to the
environment. This type of runtime plugin is something you can only do
in a dynamic language.

Note: if we wanted only to allow one plugin per instance at a time, we can
create a generic interface with a method of the same name for every
plugged in module. 

Copyright (C) 2012 Pjotr Prins <pjotr.prins@thebird.nl>
