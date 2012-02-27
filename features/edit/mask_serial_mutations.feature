Feature: Alignment editing masking serial mutations
  Edit an alignment removing or masking unique elements column-wise. 
  
  If a sequence has a unique AA in a column it is a single mutation event. If
  multiple neighbouring AA's are also unique we suspect the sequence is an
  outlier. This rule masks, or deletes, stretches of unique AAs. The stretch of
  unique AA's is defined in 'max_serial_unique' (default 5, so two bordering
  unique AA's are allowed).

  Scenario: Apply rule to an amino acid alignment
    Given I have an alignment
      """
      ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSQQKLTSEQVCFR---LSDV
      ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGK-----FRSFRSFMLSAV
      ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      -------------IFHAVR-TC-HP-----------------
      """
    When I apply rule masking with X and max_gap_size 5
    Then it should result in
      """
      ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACXXXXXXXXXXXFR---LSDV
      ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGK-----VCGFRSFMLSAV
      ----------PTIIFSGCSKACSGK-----------------
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      -------------XXXXXX-XX-XX-----------------
      """
