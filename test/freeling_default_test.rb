require 'test_helper'

class FreelingDefaultTest < MiniTest::Unit::TestCase
  def setup
    @usr_bin_analyzer         = "/usr/bin/analyzer"
    @local_bin_analyzer       = "/usr/local/bin/analyzer"
    @usr_bin_analyze_client   = "/usr/bin/analyzer_client"
    @local_bin_analyze_client = "/usr/local/bin/analyzer_client"
    @usr_share_freeling       = "/usr/share/freeling"
    @local_share_freeling     = "/usr/local/share/freeling"
  end

  def test_freeling_installed_on_usr
    File.stubs("exists?").with(@usr_bin_analyzer).returns(true)
    File.stubs("exists?").with(@local_bin_analyzer).returns(false)

    assert_equal FreeLing::Analyzer::FreelingDefault.analyzer_path, @usr_bin_analyzer
  end

  def test_freeling_installed_on_local
    File.stubs("exists?").with(@usr_bin_analyzer).returns(false)
    File.stubs("exists?").with(@local_bin_analyzer).returns(true)

    assert_equal FreeLing::Analyzer::FreelingDefault.analyzer_path, @local_bin_analyzer
  end

  def test_freeling_not_installed
    File.stubs("exists?").with(@usr_bin_analyzer).returns(false)
    File.stubs("exists?").with(@local_bin_analyzer).returns(false)

    assert_raises(RuntimeError) do
      assert_equal FreeLing::Analyzer::FreelingDefault.analyzer_path, @local_bin_analyzer
    end
  end

  def test_instantiate_analyzer
    File.stubs("exists?").with(@local_bin_analyzer).returns(true)
    File.stubs("exists?").with(@local_bin_analyze_client).returns(true)
    Dir.stubs("exists?").with(@local_share_freeling).returns(true)
    document = mock("document")
    document.expects('encode').returns(document)

    assert FreeLing::Analyzer.new(document)
  end
end
