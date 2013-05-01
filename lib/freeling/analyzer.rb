require "open3"
require "hashie/mash"
require "freeling/analyzer/process_wrapper"
require "freeling/analyzer/freeling_default"

module FreeLing
  class Analyzer
    attr_reader :document, :latest_error_log

    DEFAULT_ANALYZE_PATH         = FreelingDefault.analyzer_path
    DEFAULT_FREELING_SHARE_PATH  = FreelingDefault.freeling_path
    DEFAULT_LANGUAGE_CONFIG_PATH = File.join(DEFAULT_FREELING_SHARE_PATH, "config")

    Token = Class.new(Hashie::Mash)


    def initialize(document, opts={})
      @document = document

      @options = {
        :share_path => DEFAULT_FREELING_SHARE_PATH,
        :analyze_path => DEFAULT_ANALYZE_PATH,
        :input_format => :plain,
        :output_format => :tagged,
        :memoize => true,
      }.merge(opts)

      unless Dir.exists?(@options[:share_path])
        raise "#{@options[:share_path]} not found"
      end

      unless File.exists?(@options[:analyze_path])
        raise "#{@options[:analyze_path]} not found"
      end

      if @options[:config_path] and !File.exists?(@options[:config_path])
        raise "#{@options[:config_path]} not found"
      else
        @options[:language] ||= :es
      end
    end

    def sentences(run_again=false)
      if @options[:output_format] == :token
        raise "Sentence splitter is not available with output format set to 'token'"
      end

      if not run_again and @sentences
        return @sentences.to_enum
      end

      Enumerator.new do |yielder|
        tokens = []
        read_tokens.each do |token|
          if token
            tokens << token
          else
            yielder << tokens
            if @options[:memoize]
              @sentences ||= []
              @sentences << tokens
            end
            tokens = []
          end
        end
      end
    end

    def tokens(run_again=false)
      if not run_again and @tokens
        return @tokens.to_enum
      end

      if @sentences
        @tokens ||= @sentences.flatten
        return @tokens.to_enum
      end

      Enumerator.new do |yielder|
        read_tokens.each do |token|
          if token
            yielder << token
            if @options[:memoize]
              @tokens ||= []
              @tokens << token
            end
          end
        end
      end
    end


  private
    def command
      "#{@options[:analyze_path]} " \
        "-f #{config_path} " \
        "--inpf #{@options[:input_format]} " \
        "--outf #{@options[:output_format]} " \
        "--nec " \
        "--noflush"
    end

    def config_path
      @options[:config_path] || File.join(DEFAULT_LANGUAGE_CONFIG_PATH, "#{@options[:language]}.cfg")
    end

    def read_tokens
      Enumerator.new do |yielder|
        output_fd = @document.respond_to?(:read) ? @document : StringIO.new(@document)
        @process_wrapper = ProcessWrapper.new(command, output_fd, "FREELINGSHARE" => @options[:share_path])

        @process_wrapper.run.each do |line|
          if not line.empty?
            yielder << parse_token_line(line)
          end
        end

        @latest_error_log = @process_wrapper.error_log

        @process_wrapper.close
        @process_wrapper = nil
      end
    end

    def parse_token_line(str)
      form, lemma, tag, prob = str.split(' ')[0..3]
      Token.new({
        :form => form,
        :lemma => lemma,
        :tag => tag,
        :prob => prob && prob.to_f,
      }.reject { |k, v| v.nil? })
    end
  end
end
