Feature: GBlocks implementation in Ruby

  The GBlocks routine is often used, but the source code is not open source. This 
  is a feature request for a reimplementation of GBlocks. Some links:

  Open sourcing request by Debian: http://lists.debian.org/debian-med/2011/02/msg00008.html

  Binary download of GBlocks: http://molevol.cmima.csic.es/castresana/Gblocks.html

  Documentation: http://molevol.cmima.csic.es/castresana/Gblocks/Gblocks_documentation.html

  It is quite a simple routine, and would be easy to validate against existing outcomes.

  Scenario: Apply GBlocks to an alignment
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
    When I apply GBlocks
    Then it should return the GBlocks cleaned alignment
    And return a list of removed columns


