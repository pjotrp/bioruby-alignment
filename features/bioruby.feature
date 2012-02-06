Feature: BioAlignment should play with BioRuby 
  In order to use BioRuby functionality
  I want to convert BioAlignment to Bio::Alignment
  And I want to support Bio::Sequence objects

  Scenario: Use Bio::Sequence to fill BioAlignment
    Given I have multiple Bio::Sequence objects
    When I assign BioAlignment
    Then it should accept the objects
    And and return a partial sequence
    And be indexable

  Scenario: Use Bio::Sequence to fill BioAlignment with AA
    Given I have multiple Bio::Sequence::AA objects
    When I assign BioAlignment for AA
    Then it should accept the Bio::Sequence::AA objects
    And and return a partial AA sequence
    And be AA indexable

  Scenario: Convert BioAlignment to Bio::Alignment
    Given I have a BioAlignment
    When I convert
    Then I should have a Bio::Alignment
