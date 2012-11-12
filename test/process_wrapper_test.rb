require "test_helper"

class ProcessWrapperTest < MiniTest::Unit::TestCase
  def setup
    @command = "cat"
    @text = ["Hello", "world!"]
    @output_fd = StringIO.new(@text.join("\n"))
    @pw = FreeLing::Analyzer::ProcessWrapper.new(@command, @output_fd)
  end

  def test_constructor_paramenters_can_be_read
    assert_equal @command, @pw.command
    assert_equal @output_fd, @pw.output_fd
    assert_equal({}, @pw.env)
  end

  def test_constructor_paramenters_can_be_written
    assert_equal @command, @pw.command
    @pw.command = "cat -n"
    assert_equal "cat -n", @pw.command

    assert_equal @output_fd, @pw.output_fd
    new_text_io = StringIO.new("New text")
    @pw.output_fd = new_text_io
    assert_equal new_text_io, @pw.output_fd

    assert_equal({}, @pw.env)
    @pw.env["FREELINGSHARE"] = "/usr/local/share/freeling"
    assert_equal({
      "FREELINGSHARE" => "/usr/local/share/freeling"
    }, @pw.env)
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

  def test_invalid_command
    @pw.command = "inexistant_command"
    assert_raises(Errno::ENOENT) { @pw.run }
  end

  def test_custom_env_variables
    @pw.env["MY_VARIABLE"] = "foobar"
    @pw.command = "echo $MY_VARIABLE"
    assert_equal "foobar", @pw.run.first
  end
end
