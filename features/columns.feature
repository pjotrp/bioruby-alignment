Feature: Alignment column support
  In order to access an alignment by column
  I want to access column state
  I want to get all elements in a column

  Scenario: Access column information in an alignment
    Given I read an MSA nucleotide FASTA file in the test/data folder
    And I iterate the columns
    When I fetch a column
    Then I should be able to get the column state
    And I should get the column elements

