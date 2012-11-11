require "enumerator"
require "thread"
require "open3"

module FreeLing
  class Analyzer
    class ProcessWrapper
      attr_accessor :command, :output_fd

      def initialize(command, output_fd)
        @command = command
        @output_fd = output_fd
        @env = {}
      end

      def run
        open_process

        Enumerator.new do |yielder|
          if @stdout.nil?
            run_process
          end

          while line = @stdout.gets
            line.chomp!
            if line.empty?
              yielder << nil
            else
              yielder << line
            end
          end

          @stdout.close_read
          @write_thr.join
          close_process
        end
      end

    private
      def open_process
        @stdin, @stdout, @stderr, @wait_thr = Open3.popen3(@env, command)

        @write_thr = Thread.new do
          begin
            IO.copy_stream(@output_fd, @stdin)
            @stdin.close_write
          rescue Errno::EPIPE
            raise
            #@last_error_mutex.synchronize do
            #  @last_error = @stderr.read.chomp
            #end
          end
        end
      end

      def close_process
        close_fds
        kill_threads
        @stdin = @stdout = @stderr = nil
        @wait_thr = @write_thr = nil
      end

      def close_fds
        [@stdin, @stdout, @stderr].each do |fd|
          if fd and not fd.closed?
            fd.close
          end
        end
      end

      def kill_threads
        [@wait_thr, @write_thr].each do |thr|
          if thr and thr.alive?
            thr.kill
          end
        end
      end

    end # ProcessWrapper
  end # Analyzer
end # FreeLing
