# encoding: utf-8
require "test/unit"
require File.expand_path("../../lib/freeling/analyzer", __FILE__)

class TestAnalyzer < Test::Unit::TestCase
  def setup
    @a = "El gato come pescado y bebe agua."
    @b = "Yo bajo con el hombre bajo a tocar el bajo bajo la escalera."
    @c = "Mi amigo Juan Mesa se mesa la barba al lado de la mesa."
  end

  def test_tokens
    assert true
  end
end
