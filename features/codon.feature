Feature: Read codon file
  In order to read codon files into a codon alignment
  I want to read a multi sequences aligned (MSA) nucleodtide FASTA file and store it internally as codons

  Scenario: Support basic FASTA codon MSA
    Given I read an MSA nucleotide FASTA file in the test/data folder
    And I iterate the sequence records
    When I check the alignment 
    Then it should contain codons
    And it should translate to an amino acid MSA
    And it should write a nucleotide alignment 
    And it should write an amino acid alignment 


