require "test_helper"

class ProcessWrapperTest < Test::Unit::TestCase
  def setup
    @command = "cat"
    @text = ["Hello", "world!"]
    @output_fd = StringIO.new(@text.join("\n"))
    @pw = FreeLing::Analyzer::ProcessWrapper.new(@command, @output_fd)
  end

  def test_command_and_output_fd_can_be_read_from_instance
    assert_equal @command, @pw.command
    assert_equal @output_fd, @pw.output_fd
  end

  def test_command_can_be_changed_once_wrapper_was_created
    assert_equal @command, @pw.command
    @pw.command = "cat -n"
    assert_equal "cat -n", @pw.command
  end

  def test_run_returns_an_enumerator
    enum = @pw.run
    assert_instance_of Enumerator, enum
  end

  def test_run_returns_process_output_per_line
    assert_equal @text, @pw.run.to_a
  end

  def test_run_twice_without_rewinding_output_fd
    assert_equal @text, @pw.run.to_a
    assert @pw.output_fd.eof?
    assert_equal [], @pw.run.to_a
  end

  def test_run_twice_but_rewind_output_fd_after_first_run
    assert_equal @text, @pw.run.to_a
    assert @pw.output_fd.eof?
    @pw.output_fd.rewind
    assert_equal @text, @pw.run.to_a
  end

  def test_another_command
    @pw.command = "cat -n"
    assert_equal ["     1\tHello", "     2\tworld!"], @pw.run.to_a
  end
end
