require 'test_helper'

class FreelingDefaultTest < MiniTest::Unit::TestCase
  def setup
    @usr_bin_analyzer     = "/usr/bin/analyzer"
    @local_bin_analyzer   = "/usr/local/bin/analyzer"
    @usr_share_freeling   = "/usr/share/freeling"
    @local_share_freeling = "/usr/local/share/freeling"
  end

  def test_freeling_installed_on_usr
    File.stubs("exists?").with(@usr_bin_analyzer).returns(true)
    File.stubs("exists?").with(@local_bin_analyzer).returns(false)

    FreeLing::Analyzer::FreelingDefault.analyzer_path.must_equal @usr_bin_analyzer
  end

  def test_freeling_installed_on_local
    File.stubs("exists?").with(@usr_bin_analyzer).returns(false)
    File.stubs("exists?").with(@local_bin_analyzer).returns(true)

    FreeLing::Analyzer::FreelingDefault.analyzer_path.must_equal @local_bin_analyzer
  end

  def test_freeling_not_installed
    File.stubs("exists?").with(@usr_bin_analyzer).returns(false)
    File.stubs("exists?").with(@local_bin_analyzer).returns(false)

    lambda {
      FreeLing::Analyzer::FreelingDefault.analyzer_path.must_equal @local_bin_analyzer
    }.must_raise RuntimeError
  end
end