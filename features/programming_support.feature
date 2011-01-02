# File: programming_support.feature

Feature: Programming support
  In order to write good code
  As a programmer
  I want to have asserts, messages and colorization support

  Scenario: Assertions by are possible by using assert( message ) { boolean argument }
    Given I create a Brain object for scenario 1
    When I check the methods
    Then I should see a assert function

  Scenario: This example assertion should fail
    Given I create a Brain object for scenario 2
    Given I supply the debug switch
    And I execute the assert function
    And I provide the follwoing text "This should fail" as message
    And I provide the following block "{ true == false }"
    Then I should get a raised error exception

  Scenario: This example assertion should succeed
    Given I create a Brain object for scenario 3
    Given I supply the debug switch for scenario 3
    And I execute the assert function for scenario 3
    And I provide the follwoing message "This should succeed" as output text
    And I provide the following true block "{ true == true }"
    Then I should get no response

