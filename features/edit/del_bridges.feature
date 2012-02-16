Feature: Alignment editing, the bridge rule
  Remove columns that contain too many gaps

  Drop all bridges in less than 'min_bridges_fraction' (default 1/3 or 33%).

  The dropped columns are tracked by the table columns.

  Scenario: Apply bridge rule to an amino acid alignment
    Given I have an alignment
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
    When I apply the bridge rule
    Then it should have removed 4 bridges
      """
      SNSFSRPTIIFSGCSTACSGKSELVCGFRSFMLSDV
      SNSFSRPTIIFSGCSTACSGKSEQVCGFR---LSDV
      SNSFSRPTIIFSGCSTACSGKSEQVCGFR---LSDV
      PKLFSRPTIIFSGCSTACSGKSEPVCGFRSFMLSDV
      ------PTIIFSGCSKACSGKSELVCGFRSFMLSDV
      ------PTIIFSGCSKACSGK---FRSFRSFMLSAV
      ------PTIIFSGCSKACSGK---VCGIFHAVRSFM
      ------PTIIFSGCSKACSGKSELVCGFRSFMLSAV
      ---------IFHAVR-TC-HP---------------
      """
    Then I should be able to track removed columns

