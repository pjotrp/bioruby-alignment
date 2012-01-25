# Bio-alignment design

## Introduction

Biological multi-sequence alignments (MSA) are normally matrices of
nucleotide or amino acid sequences, with gaps. Despite this rather
simple premise, most software fails make it simple to access these
structures. Also most implementations fail to support a 'pay load' of
items in the matrix (mostly because underlying sequences are String
based). This means a developer has to track information in multiple
places, for example a base pair quality score. This makes code complex
and therefore error prone. With bio-alignment elements of the matrix
can carry information. This means that when the alignment gets edited,
the element moves, and the information migrates along. For example,
say we have a nucleotide sequence with pay load

    A   G   T    A
    |   |   |    |
    5   9   *    1

most library implementations will have two strings "AGTA" and "59*1".
Removing the third nucleodide would mean removing it twice, first
"AGA", next "591". With bio-alignment this is one action because we
have one object for each element, that contains both values, e.g. the
payload of T is *. Removing T from the list also removes *.

In addition bio-alignment deals with codons and codon translation.
Rather than track mulitiple matrices, the codon is viewed as an element,
and the translated codon as the pay load. When an alignment gets
reordered the code only has to do it in one place.

Likewise, an alignment column can have a pay load (e.g. quality score
in a pile up), and an alignment row can have a pay load (e.g. the
sequence name). The concept of pay load is handled through generic
matrix element, column, or row 'attributes'.

Many of these ideas came from my work on the [BioScala
project](https://github.com/pjotrp/bioscala/blob/master/doc/design.txt),
The BioScala library has the advantage of type safety throughout.

Copyright (C) 2012 Pjotr Prins <pjotr.prins@thebird.nl>
