require "enumerator"
require "thread"
require "open3"

module FreeLing
  class Analyzer
    class ProcessWrapper
      attr_accessor :command, :output_fd, :env, :error_log

      def initialize(command, output_fd, env={})
        @command = command
        @output_fd = output_fd
        @env = env
        @error_log = nil
      end

      def run
        @error_log = nil

        Enumerator.new do |yielder|
          open_process

          if @stdout.nil?
            run_process
          end

          while line = @stdout.gets
            line.chomp!
            yielder << line
          end

          @stdout.close_read
          @error_log = @stderr.read
          @write_thr.join
          close_process
        end
      end

      def close
        close_process
      end

    private
      def open_process
        @stdin, @stdout, @stderr, @wait_thr = Open3.popen3(@env, command)

        @write_thr = Thread.new do
          begin
            IO.copy_stream(@output_fd, @stdin)
            @stdin.close_write
          rescue Errno::EPIPE
            @error_log = @stderr.read
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
