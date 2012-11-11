require "enumerator"
require "thread"
require "open3"
require "enumerable/lazy"

module FreeLing
  class Analyzer
    class ProcessWrapper
      attr_accessor :command, :output_fd

      def initialize(command, output_fd)
        @command = command
        @output_fd = output_fd
      end

      def run
        @output_fd.read.split("\n").to_enum
      end
    end # ProcessWrapper
  end # Analyzer
end # FreeLing
