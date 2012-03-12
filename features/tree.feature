@tree
Feature: Tree support for alignments
  Alignments are often accompanied by phylogenetic trees.

  Scenario: Get ordered elements from a tree
    Given I have a multiple sequence alignment (MSA)
      """
      ----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV
      SSIISNSFSRPTIIFSGCSTACSGK--SEQVCGFR---LSDV
      SSIISNSFSRPTIIFSGCSTACSGKLTSEQVCGFR---LSDV
      ----PKLFSRPTIIFSGCSTACSGK--SEPVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGKGLSELVCGFRSFMLSDV
      ----------PTIIFSGCSKACSGK-----FRSFRSFMLSAV
      ----------PTIIFSGCSKACSGK-----VCGIFHAVRSFM
      ----------PTIIFSGCSKACSGK--SELVCGFRSFMLSAV
      """
    And I have a phylogenetic tree in Newick format
      """
      ((seq6:5.3571434,(seq4:4.04762,((seq8:1.1904755,seq5:1.1904755):1.7857151,((seq3:0.0,seq2:0.0):1.1904755,seq1:1.1904755):1.7857151):1.0714293):1.3095236):4.336735,seq7:9.693878);
      """
    Then I should be able to traverse the tree
    And fetch elements from the MSA from each end node in the tree
    And calculate the phylogenetic distance between each element