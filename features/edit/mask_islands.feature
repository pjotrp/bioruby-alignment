Feature: Alignment editing with the Island rule
  The idea is to drop hypervariable 'floating' sequences, or islands, as 
  they are possibly/probably misaligned.

  Drop all 'islands' in a sequence with low consensus, that show a gap larger
  than 'max_gap_size' (default 3) on both sides, and are shorter than
  'min_island_size' (default 30). The latter may be a large size, as an island
  needs to loop in and out several times to be (arguably) functional. We also
  add a parameter 'max_gap_size_inside' (default 2) which allows for small gaps
  inside the island - the total island size is calculated including
  those small gaps. 
  
  The island consensus is calculated by column. If more than 50% of the island
  shows consensus, the island is retained. Consensus for each element is
  defined as the number of matches in the column (default 1).

  Scenario: Apply island rule to an amino acid alignment
    Given I have an alignment
      """
      ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGK-----FRSFRSFRSFRS
      ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      -------------IFHAVR-TC-HP-----------------
      """
    When I apply island rule with max_gap_size 4
    Then it should have removed 2 islands
      """
      ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGK-----------------
      ----------PTIIFSGCSKACSGK-----VCGFRSFMLSAV
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      ------------------------------------------
      """

