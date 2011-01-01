# step_definitions/command_line_control_steps.rb


# Scenario 1
Given /^I am executing the program on the command line$/ do
  @command     = "ruby lib/Brain.rb"
end

Given /^I provide the '\-h' or '\-\-help' switch as a command line argument$/ do
  @arguments     = [ "-h", "--help" ]
  @values      ||= []
end

When /^I execute the program$/ do
  @short       = `#{@command} #{@arguments.first} #{@values.join(" ")}`
  @long        = `#{@command} #{@arguments.last} #{@values.join(" ")}`
end

Then /^I should see in the first line "([^\"]*)"$/ do |arg1|
  first_line = @short.split( "\n" ).first.gsub( "lib", "." ) # needs to be executed from project base dir NOT lib dir; rake cucumber
  raise Exception, "The -h and --help switch need to return a specific first line containing usage" unless( first_line == arg1.strip )
end


