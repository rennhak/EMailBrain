#!/usr/bin/ruby19


# Other display filters are e.g. t-prot or http://aperiodic.net/phil/configs/bin/mutt-display-filter

class Brain # {{{

  def initialize input # {{{
    @input    = input

    store!

    @output   = input
  end # of def initialize }}}

  def store! content = @input, file = "/tmp/email.tmp" # {{{
    File.open( file, "w" ) { |f| f.write( content.to_s ) }
  end # }}}

  def output content = @output # {{{
    STDOUT.puts content
  end # of def output }}}

end # of class Brain }}}

# Direct invocation
if __FILE__ == $0 # {{{

  # ENV["RUBYOPT"] = ""

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
