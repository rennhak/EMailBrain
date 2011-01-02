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
    raise ArgumentError, "Assertion failed --> #{message}" unless yield if @options.debug
  end # of def assert }}}


  # = The function 'parse_cmd_arguments' takes a number of arbitrary commandline arguments and parses them into a proper data structure via optparse
  # @param args Ruby's STDIN.ARGS from commandline
  # @returns Ruby optparse package options hash object
  def parse_cmd_arguments( args ) # {{{

    options               = OpenStruct.new
    options.debug         = false
    options.quiet         = false

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


  # = The function colorize takes a message and wraps it into standard color commands such as for bash.
  # @param color String, of the colorname in plain english. e.g. "LightGray", "Gray", "Red", "BrightRed"
  # @param message String, of the message which should be wrapped
  # @returns String, colorized message string
  # WARNING: Might not work for your terminal
  # FIXME: Implement bold behavior
  # FIXME: This method is currently b0rked
  def colorize color, message # {{{

    # Black       0;30     Dark Gray     1;30
    # Blue        0;34     Light Blue    1;34
    # Green       0;32     Light Green   1;32
    # Cyan        0;36     Light Cyan    1;36
    # Red         0;31     Light Red     1;31
    # Purple      0;35     Light Purple  1;35
    # Brown       0;33     Yellow        1;33
    # Light Gray  0;37     White         1;37

    colors  = { 
      "Gray"        => "\e[1;30m",
      "LightGray"   => "\e[0;37m",
      "Cyan"        => "\e[0;36m",
      "LightCyan"   => "\e[1;36m",
      "Blue"        => "\e[0;34m",
      "LightBlue"   => "\e[1;34m",
      "Green"       => "\e[0;32m",
      "LightGreen"  => "\e[1;32m",
      "Red"         => "\e[0;31m",
      "LightRed"    => "\e[1;31m",
      "Purple"      => "\e[0;35m",
      "LightPurple" => "\e[1;35m",
      "Brown"       => "\e[0;33m",
      "Yellow"      => "\e[1;33m",
      "White"       => "\e[1;37m"
    }
    nocolor    = "\e[0m"

    colors[ color ] + message + nocolor
  end # of def colorize }}}


  # = The function message will take a message as argument as well as a level (e.g. "info", "ok", "error", "question", "debug") which then would print 
  #   ( "(--) msg..", "(II) msg..", "(EE) msg..", "(??) msg..")
  # @param level Ruby symbol, can either be :info, :success, :error or :question
  # @param msg String, which represents the message you want to send to stdout (info, ok, question) stderr (error)
  # Helpers: colorize
  def message level, msg # {{{

    symbols = {
      :info      => "(--)",
      :success   => "(II)",
      :error     => "(EE)",
      :question  => "(??)",
			:debug		 => "(++)"
    }

    raise ArugmentError, "Can't find the corresponding symbol for this message level (#{level.to_s}) - is the spelling wrong?" unless( symbols.key?( level )  )

    unless( @options.quiet )

      if( @options.colorize )
        if( level == :error )
          STDERR.puts colorize( "LightRed", "#{symbols[ level ].to_s} #{msg.to_s}" )
        else
          STDOUT.puts colorize( "LightGreen", "#{symbols[ level ].to_s} #{msg.to_s}" ) if( level == :success )
          STDOUT.puts colorize( "LightCyan", "#{symbols[ level ].to_s} #{msg.to_s}" ) if( level == :question )
          STDOUT.puts colorize( "Brown", "#{symbols[ level ].to_s} #{msg.to_s}" ) if( level == :info )
          STDOUT.puts colorize( "LightBlue", "#{symbols[ level ].to_s} #{msg.to_s}" ) if( level == :debug and @options.debug )
        end
      else
        if( level == :error )
          STDERR.puts "#{symbols[ level ].to_s} #{msg.to_s}" 
        else
          STDOUT.puts "#{symbols[ level ].to_s} #{msg.to_s}" if( level == :success )
          STDOUT.puts "#{symbols[ level ].to_s} #{msg.to_s}" if( level == :question )
          STDOUT.puts "#{symbols[ level ].to_s} #{msg.to_s}" if( level == :info )
          STDOUT.puts "#{symbols[ level ].to_s} #{msg.to_s}" if( level == :debug and @options.debug )
        end
      end # of if( @config.colorize )

    end

  end # of def message }}}




#  def store! content = @input, file = "/tmp/email.tmp" # {{{
#    File.open( file, "w" ) { |f| f.write( content.to_s ) }
#  end # }}}
#
#  def output content = @output # {{{
#    STDOUT.puts content
#  end # of def output }}}

  attr :options

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

