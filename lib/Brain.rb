#!/usr/bin/ruby19


####
#
# EMailBrain desc
#
# Other display filters are e.g. t-prot or http://aperiodic.net/phil/configs/bin/mutt-display-filter
#
###########


# = Standard Libraries
require 'optparse'


# = 
class Brain # {{{

  def initialize input, options  # {{{
    # @input    = input
    # store!
    # @output   = input
  end # of def initialize }}}

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

  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: Brain.rb [options]"

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      options[:verbose]   = v
    end

  end.parse!

  if( options.empty? )
    raise ArgumentError, "Please try '-h' or '--help' to view all possible options"
  else
    # Give some kind of argument advice for first time users?
    # raise ArgumentError, "How would you like that formatted ? For instance minumum version would be, e.g. '-nv' or '-nvr' for raw" unless( options[:value] or options[:bar] or options[:percent] )
  end

  brain = Brain.new( options )


  # Is input currently from tty or from pipe?
  if( STDIN.tty? )
    # tty mode
    raise ArgumentError, "Script executed as TTY not as pipe."
  else
    # pipe mode
    input   = STDIN.read
    brain   = Brain.new( input )

    # push the modifed output to STDOUT
    brain.output

  end # of if( STDIN.tty? )

end # of if __FILE__ == $0 }}}

