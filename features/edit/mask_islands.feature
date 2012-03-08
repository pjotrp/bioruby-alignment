@dev
Feature: Alignment editing with the Island rule
  The idea is to drop hypervariable 'floating' sequences, or islands, as 
  they are possibly/probably misaligned.

  Drop all 'islands' in a sequence with low consensus, that show a gap larger
  than 'min_gap_size' (default 3) on both sides, and are shorter than
  'max_island_size' (default 30). An island larger than 30 elements is arguably
  no longer an island, and low consensus stretches may be loops - it is up to
  the alignment procedure to get that right. We also allow for micro deletions
  inside an alignment (1 or 2 elements).
  
  The island consensus is calculated by column. If more than 50% of the island
  shows consensus, the island is retained. Consensus for each element is
  defined here as the number of matches in the column (default 1).

  Scenario: Apply island rule to an amino acid alignment
    Given I have an alignment with islands
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
    Then it should have masked islands
      """
      ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGK-----XXXXXXXXXXXX
      ----------PTIIFSGCSKACSGK-----XXXXXXXXXXXX
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      -------------XXXXXX-XX-XX-----------------
      """
    Then it should also be able to delete islands
      """
      ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGK-----------------
      ----------PTIIFSGCSKACSGK-----------------
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      ------------------------------------------
      """

