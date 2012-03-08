@dev
Feature: Alignment editing masking serial mutations
  Edit an alignment removing or masking unique elements column-wise. 
  
  If a sequence has a unique AA in a column it is a single mutation event. If
  multiple neighbouring AA's are also unique we suspect the (partial) sequence
  may be an outlier. This rule masks, or deletes, stretches of totally unique
  AAs. The stretch of unique AA's is defined in 'max_serial_unique' (default 5,
  so two bordering unique AA's are allowed). Gaps within a series are allowed.

  Scenario: Apply rule to an amino acid alignment
    Given I have an alignment
      """
      ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSQQKKTSEQVCFR---LSDV
      ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGK-----FRSFRSFMLSAV
      ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      -------------TTTTTT-TT-HP-----------------
      """
    When I apply rule masking with X
    Then mask serial mutations should result in
      """
      ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSXXXXXXXXXXFR---LSDV
      ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGK-----FRSFRSFMLSAV
      ----------PTIIFSGCSKACSGK-----VCGXXXXXXSXX
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      -------------XXXXXX-XX-XX-----------------
      """

