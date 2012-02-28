Feature: Alignment row support
  In order to access an alignment by row
  I want to access the row state

  @rows
  Scenario: Access row information in an alignment
    Given I read an MSA nucleotide FASTA file in the test/data folder
    When I fetch a row
    When I inject row state
    Then I should be able to get the row state
    When I iterate a row
    Then I should get the row elements


