@tree
Feature: Tree support for alignments
  Alignments are often accompanied by phylogenetic trees.

  Scenario: Get ordered elements from a tree
    Given I have a multiple sequence alignment (MSA)
      """
      seq1  ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      seq2  SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      seq3  SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      seq4  ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      seq5  ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      seq6  ----------PTIIFSGCSKACSGK-----FRSFRSFMLSAV
      seq7  ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      seq8  ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      """
    And I have a phylogenetic tree in Newick format
      """
      ((seq6:5.3571434,(seq4:4.04762,((seq8:1.1904755,seq5:1.1904755):1.7857151,((seq3:0.0,seq2:0.0):1.1904755,seq1:1.1904755):1.7857151):1.0714293):1.3095236):4.336735,seq7:9.693878);
      """
    Then I should be able to traverse the tree
    And fetch elements from the MSA from each end node in the tree
    And calculate the phylogenetic distance between each element
    And draw the MSA with the tree
      """
      +--9.69----------------------------------------- seq7  ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      |                                   ,--1.19----- seq1  ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      |                          ,--1.79--|        ,-- seq2  SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      |                 ,--1.07--+        `--1.19--+-- seq3  SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      |                 |        |--1.79--+--1.19----- seq5  ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      |        ,--1.31--|                 `--1.19----- seq8  --------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      |--4.34--|        `--4.05----------------------- seq4  ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
               `--5.36-------------------------------- seq6  ----------PTIIFSGCSKACSGK-----FRSFRSFMLSAV
      """
    Then draw MSA with the short tree
      """
      +----------------- seq7  ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      |           ,----- seq1  ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      |        ,--|  ,-- seq2  SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      |     ,--+  `--+-- seq3  SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      |     |  |--+----- seq5  ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      |  ,--|     `----- seq8  --------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      |--|  `----------- seq4  ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
         `-------------- seq6  ----------PTIIFSGCSKACSGK-----FRSFRSFMLSAV
      """
