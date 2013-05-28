module FreeLing
  class Analyzer
    class FreelingDefault

      LOCAL_ANALYZE_PATH        = "/usr/local/bin/analyzer"
      USR_ANALYZE_PATH          = "/usr/bin/analyzer"
      LOCAL_ANALYZE_CLIENT_PATH = "/usr/local/bin/analyzer_client"
      USR_ANALYZE_CLIENT_PATH   = "/usr/bin/analyzer_client"
      LOCAL_FREELING_SHARE_PATH = "/usr/local/share/freeling"
      USR_FREELING_SHARE_PATH   = "/usr/share/freeling"

      class << self
        def analyzer_path
          self.new.analyzer_path
        end

        def analyzer_client_path
          self.new.analyzer_client_path
        end


        def freeling_path
          self.new.freeling_path
        end

        def language_config
          self.new.language_config
        end
      end

      def language_config
        if freeling_path.instance_of? String
          File.join(freeling_path, "config")
        else
          raise_error(:analyze)
        end
      end

      def analyzer_path
        if File.exists? LOCAL_ANALYZE_PATH
          LOCAL_ANALYZE_PATH
        elsif File.exists? USR_ANALYZE_PATH
          USR_ANALYZE_PATH
        else
          raise_error(:analyze)
        end
      end

      def analyzer_client_path
        if File.exists? LOCAL_ANALYZE_CLIENT_PATH
          LOCAL_ANALYZE_CLIENT_PATH
        elsif File.exists? USR_ANALYZE_CLIENT_PATH
          USR_ANALYZE_CLIENT_PATH
        else
          raise_error(:analyze_client)
        end
      end


      def freeling_path
        if Dir.exists? LOCAL_FREELING_SHARE_PATH
          LOCAL_FREELING_SHARE_PATH
        elsif Dir.exists? USR_FREELING_SHARE_PATH
          USR_FREELING_SHARE_PATH
        else
          raise_error(:freeling)
        end
      end

      def raise_error(type)
        raise "#{type} is not installed."
      end
    end
  end
end
