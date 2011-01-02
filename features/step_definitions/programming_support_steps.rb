# step_definitions/programming_support_steps.rb

# Scenario 1: Assertions by are possible by using assert( message ) { boolean argument } {{{
Given /^I create a Brain object for scenario 1$/ do
  require 'Brain.rb'
  @options = OpenStruct.new
  @options.debug = false
  @options.quiet = false

  @brain = Brain.new( @options )
end

When /^I check the methods$/ do
  @brain_methods = @brain.methods
end

Then /^I should see a assert function$/ do
  @brain_methods.include?( "assert" )
end
# }}}

# Scenario 2: This example assertion should fail {{{
Given /^I create a Brain object for scenario 2$/ do
  require 'Brain.rb'
  @options = OpenStruct.new
  @options.debug = false
  @options.quiet = false

  @brain = Brain.new( @options )
end

Given /^I supply the debug switch$/ do
  @brain.options.debug = true
end

Given /^I execute the assert function$/ do
  @cmd = "@brain.assert"
end

Given /^I provide the follwoing text "([^\"]*)" as message$/ do |arg1|
  @message = arg1
end

Given /^I provide the following block "([^\"]*)"$/ do |arg1|
  @block = arg1
end

Then /^I should get a raised error exception$/ do
  command = @cmd + "( \"" + @message + "\" ) #{@block}"
  begin
    eval( command )
  rescue ArgumentError
  else
    raise Error
  end
end
# }}}


# Scenario 3: This example assertion should succeed {{{
Given /^I create a Brain object for scenario 3$/ do
  require 'Brain.rb'
  @options = OpenStruct.new
  @options.debug = false
  @options.quiet = false

  @brain = Brain.new( @options )
end

Given /^I supply the debug switch for scenario 3$/ do
  @brain.options.debug = true
end

Given /^I execute the assert function for scenario 3$/ do
  @cmd = "@brain.assert"
end

Given /^I provide the follwoing message "([^\"]*)" as output text$/ do |arg1|
  @message = arg1
end

Given /^I provide the following true block "([^\"]*)"$/ do |arg1|
  @block = arg1
end

Then /^I should get no response$/ do
  command = @cmd + "( \"" + @message + "\" ) #{@block}"
  eval( command )
end
# }}}

