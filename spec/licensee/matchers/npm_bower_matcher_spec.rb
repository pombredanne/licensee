RSpec.describe Licensee::Matchers::NpmBower do
  let(:content) { '"license": "mit"' }
  let(:file) { Licensee::Project::LicenseFile.new(content, 'LICENSE.txt') }
  let(:mit) { Licensee::License.find('mit') }
  let(:no_license) { Licensee::License.find('no-license') }
  subject { described_class.new(file) }

  it 'matches' do
    expect(subject.match).to eql(mit)
  end

  it 'has a confidence' do
    expect(subject.confidence).to eql(90)
  end

  {
    'double quotes' => '"license": "mit"',
    'single quotes' => "'license': 'mit'",
    'mixed quotes'  => "'license': \"mit\"",
    'whitespace'    => "'license' : 'mit'",
    'no whitespace' => "'license':'mit'"
  }.each do |description, license_declaration|
    context "with a #{description} declaration" do
      let(:content) { license_declaration }

      it 'matches' do
        expect(subject.match).to eql(mit)
      end
    end
  end
end
