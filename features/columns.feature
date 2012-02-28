Feature: Alignment column support
  In order to access an alignment by column
  I want to access column state
  I want to get all elements in a column

  @dev
  @columns
  Scenario: Access column information in an alignment
    Given I read an MSA nucleotide FASTA file in the test/data folder
    When I fetch a column
    When I inject column state
    Then I should be able to get the column state
    When I iterate a column
    Then I should get the column elements

