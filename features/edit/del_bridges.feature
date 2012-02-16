Feature: Alignment editing rule 4 (Bridge rule)
  Remove columns that contain too many gaps

  Drop all bridges in less than 'min_bridges_fraction' (default 1/3 or 33%).

  The dropped columns are tracked by the table columns.

  Scenario: Apply rule 4 to an amino acid alignment
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
    When I apply rule 3 with max_gap_size 4
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

