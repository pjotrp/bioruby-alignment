@dev
Feature: Remove non-informative sequences

  After alignment cleaning, it may be we have non-informative sequences. These
  can be removed from the alignment.

  Scenario: Apply non informative sequence rule to an amino acid alignment
    Given I have a bridged alignment containing unknown amino acids
      """
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      ----------XTIXXXXXXXXXSGK--SELXXXXXSFXXXXV
      -------------IFHAVR-TC-HP-----------------
      """
    When I apply the non-informative sequence rule
    Then it should have removed two rows
      """
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      """
    Then I should be able to track removed non-informative rows

