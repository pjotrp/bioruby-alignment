Feature: pal2nal
  pal2nal takes a protein (amino acid) alignment and a set of nucleotide 
  sequences and generates a codon alignment based on those

  Scenario: Convert pal2nal
    Given I have an amino acid alignment
    And I have matching nucleotide sequences
    Then I should be able to generate a codon alignment
    Then I should be able to generate a codon alignment directly with pal2nal

