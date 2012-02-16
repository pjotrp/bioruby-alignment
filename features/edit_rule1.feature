Feature: Alignment editing rule 1
  Edit an alignment removing or masking unique elements column-wise. 
  
  If a sequence has a unique AA in a column it is suspect. If the neighbouring
AA's are also unique rule 1 drops it. The stretch of unique AA's is defined in
'max_serial_unique' (default 5, so two bordering uniqe AA's are allowed).

  Scenario: Apply rule 1 to an amino acid alignment
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
    When I apply rule 1 masking with X and max_gap_size 5
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

