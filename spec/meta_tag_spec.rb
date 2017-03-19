require 'spec_helper'

RSpec.describe GovukAbTesting::AcceptanceTests::MetaTag do
  let(:meta_tag) do
    described_class.new(content: 'ABTest:B', dimension: 100)
  end

  describe '#for_ab_test?' do
    context 'with a matching A/B test name' do
      it 'is truthy' do
        expect(meta_tag.for_ab_test?('ABTest')).to be_truthy
      end
    end

    context 'without a matching A/B test name' do
      it 'is falsy' do
        expect(meta_tag.for_ab_test?('UnknownTest')).to be_falsy
      end
    end
  end
end
