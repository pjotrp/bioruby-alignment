Feature: Tree support for alignments
  Alignments are often accompanied by phylogenetic trees.

  Scenario: Get ordered elements from a tree
    Given I have an amino acid MSA
    And I have a phylogenetic tree
    Then I should be able to traverse the tree
    And fetch elements from each end node in the tree
    And calculate the phylogenetic distance between each element
