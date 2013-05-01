module FreeLing
  class Analyzer
    class FreelingDefault

      class NoFreelingError < StandardError;end

      LOCAL_ANALYZE_PATH         = "/usr/local/bin/analyzer"
      USR_ANALYZE_PATH           = "/usr/bin/analyzer"
      LOCAL_FREELING_SHARE_PATH  = "/usr/local/share/freeling"
      USR_FREELING_SHARE_PATH    = "/usr/share/freeling"

      class << self
        def analyzer_path
          self.new.analyzer_path
        end

        def freeling_path
          self.new.freeling_path
        end
      end

      def analyzer_path
        if Dir.exists? LOCAL_ANALYZE_PATH
          LOCAL_ANALYZE_PATH
        elsif Dir.exists? USR_ANALYZE_PATH
          USR_ANALYZE_PATH
        else
          raise_error(:analyze)
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
        NoFreelingError.new
      end
    end
  end
end
