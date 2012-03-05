Feature: Alignment editing; remove short sequences
  Remove rows that are too short (short sequences)

  The dropped columns are tracked by the table rows.

  @dev
  Scenario: Apply short sequence rule to an amino acid alignment
    Given I have a bridged alignment
      """
      ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGK-----FRSFRSFMLSAV
      ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      -------------IFHAVR-TC-HP-----------------
      """
    When I apply the short sequence rule
    Then it should have removed one row
      """
      SNSFSRPTIIFSGCSTACSGKSELVCGFRSFMLSDV
      SNSFSRPTIIFSGCSTACSGKSEQVCGFR---LSDV
      SNSFSRPTIIFSGCSTACSGKSEQVCGFR---LSDV
      PKLFSRPTIIFSGCSTACSGKSEPVCGFRSFMLSDV
      ------PTIIFSGCSKACSGKSELVCGFRSFMLSDV
      ------PTIIFSGCSKACSGK---FRSFRSFMLSAV
      ------PTIIFSGCSKACSGK---VCGIFHAVRSFM
      ------PTIIFSGCSKACSGKSELVCGFRSFMLSAV
      """
    Then I should be able to track removed rows


