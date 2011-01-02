#!/usr/bin/ruby


####
#
# E-Mail Brain
# ============
#
# The idea of EMailBrain is to be a substitute for display filters used by mutt.
# Display filters are for instances programs like t-prot or mutt-display-filter [1].
#
# [1] http://aperiodic.net/phil/configs/bin/mutt-display-filter
#
#
# (c) 2010-2011, Bjoern Rennhak
#
###########


# = Standard Libraries
require 'optparse'
require 'ostruct'

class Brain # {{{

  def initialize options = nil # {{{
    @options = options

    unless( options.nil? )
      assert( "Options instance variable cannot be nil" ) { @options.nil? == false }

    end
  end # of def initialize }}}


  # = The function assert is just a simple implementation of assert in the Brain ObjectSpace
  #   It is mostly used for input and output validation of functions arguments and returns.
  #   Overhead of this function is exactly one function call, one if statement and one ostruct call
  #   If this is too sensitive please override the assert function.
  #
  # Code: assert( "message" ) { boolean statement }
  # 
  # Credit: I saw the idea here http://snippets.dzone.com/posts/show/925
  def assert *message # {{{
    raise "Assertion failed --> #{message}" unless yield if @options.debug
  end # of def assert }}}

  # = The function 'parse_cmd_arguments' takes a number of arbitrary commandline arguments and parses them into a proper data structure via optparse
  # @param args Ruby's STDIN.ARGS from commandline
  # @returns Ruby optparse package options hash object
  def parse_cmd_arguments( args ) # {{{

    options               = OpenStruct.new
    options.debug         = false

    # Define default options

    pristine_options      = options.dup

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__.to_s} [options]"

      opts.separator ""
      opts.separator "General options:"

      opts.on("-d", "--debug", "Run assertions and show debug output") do |d|
        options.debug = d
      end

      opts.on_tail( "-h", "--help", "Show this message") do
        puts opts
        exit
      end

      # Another typical switch to print the version.
      opts.on_tail("--version", "Show version") do
        puts OptionParser::Version.join('.')
        exit
      end
    end

    opts.parse!(args)

    ## Show opts if we have no cmd arguments
    #if( options == pristine_options )
    #  puts opts
    #  exit
    #end

    options
  end # of parse_cmd_arguments }}}



#  def store! content = @input, file = "/tmp/email.tmp" # {{{
#    File.open( file, "w" ) { |f| f.write( content.to_s ) }
#  end # }}}
#
#  def output content = @output # {{{
#    STDOUT.puts content
#  end # of def output }}}

end # of class Brain }}}



# = Direct invocation
if __FILE__ == $0 # {{{

  options   = Brain.new.parse_cmd_arguments( ARGV )
  brain     = Brain.new( options )


#  # Is input currently from tty or from pipe?
#  if( STDIN.tty? )
#    # tty mode
#    raise ArgumentError, "Script executed as TTY not as pipe."
#  else
#    # pipe mode
#    input   = STDIN.read
#    brain   = Brain.new( input )
#
#    # push the modifed output to STDOUT
#    brain.output
#
#  end # of if( STDIN.tty? )

end # of if __FILE__ == $0 }}}

