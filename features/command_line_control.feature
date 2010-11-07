# File: command_line_control.feature

Feature: Command line control
  In order to control the program
  As a command line user
  I want to be able to have a CLI control interface

  Scenario: Show CLI help screen by calling with -h or --help
    Given I am executing the program on the command line
    And I provide the '-h' or '--help' switch as a command line argument
    When I execute the program
    Then I should see in the first line "Usage: Brain.rb [options]"


