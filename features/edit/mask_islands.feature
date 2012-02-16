Feature: Alignment editing rule 3 (Island rule)
  The idea is to drop hypervariable floating sequences, as they are probably
  misaligned.

  Drop all 'islands' in a sequence with low island consensus, that show a gap
  larger than 'max_gap_size' (default 6) on both sides, and are shorter than
  'min_island_size' (default 30). The latter may be a large size, as an island
  needs to loop in and out several times to be (arguably) functional. We also
  add a parameter 'max_gap_size_inside' (default 2) which allows for small gaps
  inside the island - though the total island size is calculated including
  those small gaps. 
  
  The island consensus is calculated by column.
  'max_island_elements_unique_percentage' (default 10%) of elements in the
  island should have a 'min_island_column_matched' (default 1) somewhere in the
  element's column.

  Scenario: Apply rule 3 to an amino acid alignment
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
    Then it should have removed 2 islands
      """
      ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGK-----VCGFRSFMLSAV
      ----------PTIIFSGCSKACSGK-----------------
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      ------------------------------------------
      """

