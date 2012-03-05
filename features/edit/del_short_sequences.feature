Feature: Alignment editing; remove short sequences
  Remove rows that are too short (short sequences)

  The dropped columns are tracked by the table rows.

  @dev
  Scenario: Apply short sequence rule to an amino acid alignment
    Given I have a bridged alignment
      """
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      -------------IFHAVR-TC-HP-----------------
      """
    When I apply the short sequence rule
    Then it should have removed one row
      """
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      """
    Then I should be able to track removed rows


