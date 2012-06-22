@split
Feature: Splitting phylogenetic trees on distance
  Alignments are often accompanied by phylogenetic trees. When we have an
  alignment with its tree, we want to greedily split the alignment, based on
  the number of items in a branch. 

  Scenario: Split out branches from a tree
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
    When I split out branches with a maximum of 5 sequences from
      """
      ,--9.69----------------------------------------- seq7  ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      |                                   ,--1.19----- seq1  ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      |                          ,--1.79--|        ,-- seq2  SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      |                 ,--1.07--|        `--1.19--+-- seq3  SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      |                 |        `--1.79--+--1.19----- seq5  ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      |        ,--1.31--|                 `--1.19----- seq8  ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      `--4.34--|        `--4.05----------------------- seq4  ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
               `--5.36-------------------------------- seq6  ----------PTIIFSGCSKACSGK-----FRSFRSFMLSAV
      """
    Then I should have found "seq1,seq2,seq3,seq5,seq8" and "seq4,seq6,seq7"
    When I split out branches with a minimum of 3 and maximum of 3 sequences 
    Then I should have found "seq1,seq2,seq3" and "seq5,seq8,seq4"

