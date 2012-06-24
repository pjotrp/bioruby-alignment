@split
Feature: Splitting alignments into equal sized branches using phylogenetic tree info

  Sometimes we want to split a large alignment into sub-sets.  When an
  alignment is accompanied by a phylogenetic tree, we can greedily split the
  tree. With a rooted tree, we start from the root, and walk the tree, taking
  the shortest edge at every node (a tie may favour splitting). If the tree can
  be split, so that both sides are similar sized, the job is done (if you want
  more splits, just repeat the exercise). Essentially one subset shows
  relatively high homology, the other relatively low homology. This is a crude
  method, but has the advantage of being quick to calculate and reproducible.
  If there is no root, we start from the point next to the longest edge. 

  We add one 'target_size' parameter to allow for leaving more sequences in the
  high homology subset. 'target_size' sets the allowed size of the
  high-homology alignment.  For example, setting it to 10 in a 15 sequence
  alignment, will stop the splitting at 5 sequences, leaving (approx.) 10
  sequences in the high homology group. Likewise, setting it to 5 will continue
  splitting until that number is reached.

  In below example the tree will be split in a branch with similar sequences,
  and a branch with sequences that are somewhat removed.

  Scenario: Split a tree
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
    When I split the tree
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
    Then I should have found sub-trees "seq4,seq6,seq7" and "seq1,seq2,seq3,seq5,seq8"
    When I split the tree with a target of 2
    Then I should have found high-homology sub-tree "seq5,seq8"
    When I split the tree with a target of 3
    Then I should have found high-homology sub-tree "seq1,seq2,seq3"
    When I split the tree with a target of 4 
    Then I should have found high-homology sub-tree "seq1,seq2,seq3,seq5,seq8"
    When I split the tree with a target of 5 
    Then I should have found high-homology sub-tree "seq1,seq2,seq3,seq5,seq8"
    When I split the tree with a target of 7
    Then I should have found low-homology sub-tree "seq7"
    When I split the tree with a target of 6
    Then I should have found low-homology sub-tree "seq7,seq6"

