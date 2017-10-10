# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "bio-alignment"
  s.version = File.read("VERSION")

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pjotr Prins"]
  # s.date = "2016-10-10"
  # s.description = "Alignment handler for multiple sequence alignments (MSA)"
  s.email = "pjotr.public01@thebird.nl"
  s.executables = ["bio-alignment", "pal2nal"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md",
    "TODO"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".travis.yml",
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "TODO",
    "VERSION",
    "bin/bio-alignment",
    "bin/pal2nal",
    "doc/bio-alignment-design.md",
    "features/bioruby-feature.rb",
    "features/bioruby.feature",
    "features/codon-feature.rb",
    "features/codon.feature",
    "features/columns-feature.rb",
    "features/columns.feature",
    "features/edit/del_bridges-feature.rb",
    "features/edit/del_bridges.feature",
    "features/edit/del_non_informative_sequences-feature.rb",
    "features/edit/del_non_informative_sequences.feature",
    "features/edit/del_short_sequences-feature.rb",
    "features/edit/del_short_sequences.feature",
    "features/edit/gblocks-feature.rb",
    "features/edit/gblocks.feature",
    "features/edit/mask_islands-feature.rb",
    "features/edit/mask_islands.feature",
    "features/edit/mask_serial_mutations-feature.rb",
    "features/edit/mask_serial_mutations.feature",
    "features/pal2nal-feature.rb",
    "features/pal2nal.feature",
    "features/phylogeny/split-tree-feature.rb",
    "features/phylogeny/split-tree.feature",
    "features/phylogeny/tree-feature.rb",
    "features/phylogeny/tree.feature",
    "features/rows-feature.rb",
    "features/rows.feature",
    "features/support/env.rb",
    "lib/bio-alignment.rb",
    "lib/bio-alignment/alignment.rb",
    "lib/bio-alignment/bioruby.rb",
    "lib/bio-alignment/codonsequence.rb",
    "lib/bio-alignment/coerce.rb",
    "lib/bio-alignment/columns.rb",
    "lib/bio-alignment/edit/del_bridges.rb",
    "lib/bio-alignment/edit/del_non_informative_sequences.rb",
    "lib/bio-alignment/edit/del_short_sequences.rb",
    "lib/bio-alignment/edit/edit_columns.rb",
    "lib/bio-alignment/edit/edit_rows.rb",
    "lib/bio-alignment/edit/mask_islands.rb",
    "lib/bio-alignment/edit/mask_serial_mutations.rb",
    "lib/bio-alignment/edit/tree_splitter.rb",
    "lib/bio-alignment/elements.rb",
    "lib/bio-alignment/format/fasta.rb",
    "lib/bio-alignment/format/phylip.rb",
    "lib/bio-alignment/format/text.rb",
    "lib/bio-alignment/pal2nal.rb",
    "lib/bio-alignment/rows.rb",
    "lib/bio-alignment/sequence.rb",
    "lib/bio-alignment/state.rb",
    "lib/bio-alignment/tree.rb",
    "spec/bio-alignment_spec.rb",
    "spec/spec_helper.rb",
    "test/data/fasta/codon/aa-alignment.fa",
    "test/data/fasta/codon/codon-alignment.fa",
    "test/data/fasta/codon/nt.fa",
    "test/data/regression/aa-aln.fa",
    "test/data/regression/nt-aln.fa",
    "test/data/regression/pal2nal.fa"
  ]
  s.homepage = "http://github.com/pjotrp/bioruby-alignment"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  # s.rubygems_version = "1.8.23"
  s.summary = "Support for multiple sequence alignments (MSA)"

end
