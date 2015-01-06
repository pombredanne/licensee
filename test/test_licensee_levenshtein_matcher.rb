require 'helper'

class TestLicenseeLevenshteinMatcher < Minitest::Test

  def setup
    text = license_from_path( Licensee::Licenses.find("mit").path )
    blob = FakeBlob.new(text)
    @mit = Licensee::LicenseFile.new(blob)
  end

  should "match the license" do
    assert_equal "mit", Licensee::LevenshteinMatcher.match(@mit).key
  end

  should "know the match confidence" do
    matcher = Licensee::LevenshteinMatcher.new(@mit)
    assert matcher.confidence > 98, "#{matcher.confidence} < 98"
  end

  should "calculate max delta" do
    assert_equal 964.8000000000001, Licensee::LevenshteinMatcher.new(@mit).max_delta
  end

  should "calculate length delta" do
    isc = Licensee::Licenses.find("isc")
    assert_equal 2, Licensee::LevenshteinMatcher.new(@mit).length_delta(Licensee::Licenses.find("mit"))
    assert_equal 334, Licensee::LevenshteinMatcher.new(@mit).length_delta(isc)
  end

  should "round up potential licenses" do
    assert_equal 5, Licensee::LevenshteinMatcher.new(@mit).potential_licenses.size
  end

end
