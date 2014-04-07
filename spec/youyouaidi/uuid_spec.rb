require 'spec_helper'

describe Youyouaidi::UUID do
  describe '.new' do
    let(:param) { '' }
    let(:action) { Youyouaidi::UUID.new param }
    subject { -> { action } }

    context 'with valid uuid string' do
      let(:param) { '550e8400-e29b-41d4-a716-446655440000' }
      subject { action }

      it { should be_a Youyouaidi::UUID }
      its(:to_s) { should eq param }
    end

    context 'with uuid in short format' do
      let(:param) { '_oGOAbD9fsFFEHWSMal1v' }
      it { should raise_error Youyouaidi::InvalidUUIDError }
    end

    context 'with invalid uuid string' do
      let(:param) { 'Kekse' }
      it { should raise_error Youyouaidi::InvalidUUIDError }
    end

    context 'with non-uuid-string input' do
      let(:param) { 1234 }
      it { should raise_error Youyouaidi::InvalidUUIDError }
    end
  end

  describe '.parse' do
    let(:param) { '' }
    let(:action) { Youyouaidi::UUID.parse param }
    subject { action }

    context 'with valid uuid string' do
      let(:param) { '550e8400-e29b-41d4-a716-446655440000' }

      it { should be_a Youyouaidi::UUID }
    end

    context 'with uuid in short format' do
        let(:param) { '_oGOAbD9fsFFEHWSMal1v' }
        let(:decoded_uuid) { '550e8400-e29b-41d4-a716-446655440000' }

        it { should be_a Youyouaidi::UUID }
        its(:to_s) { should eq decoded_uuid }
    end

    context 'with invalid uuid string' do
      let(:param) { 'Kekse' }

      it 'raises error' do
        expect { Youyouaidi::UUID.parse param }.to raise_error Youyouaidi::InvalidUUIDError
      end
    end

    context 'with non-string input' do
      let(:param) { 1234 }

      it 'raises error' do
        expect { Youyouaidi::UUID.parse param }.to raise_error Youyouaidi::InvalidUUIDError
      end
    end
  end

  shared_examples_for 'equality check for two UUID objects' do
    let(:first_uuid_string)  { 'aaaaaaaa-eeee-4444-aaaa-444444444444' }
    let(:second_uuid_string) { '00000000-bbbb-2222-6666-000000000000' }
    let(:first_uuid)  { Youyouaidi::UUID.new first_uuid_string }
    let(:second_uuid) { Youyouaidi::UUID.new second_uuid_string }

    subject { action }

    context 'passing a UUID object' do
      context 'when comparing same instance' do
        let(:action) { first_uuid.send described_method, first_uuid }
        it { should be_true }
      end

      context 'when comparing different instances' do
        let(:action) { first_uuid.send described_method, second_uuid }
        context 'with same UUID strings' do
          let(:second_uuid_string) { first_uuid_string }
          it { should be_true }
        end

        context 'with different UUID strings' do
            it { should be_false }
        end
      end
    end
  end

  describe '#== (equal operator)' do
    let(:uuid_string)  { 'aaaaaaaa-eeee-4444-aaaa-444444444444' }
    let(:uuid)  { Youyouaidi::UUID.new uuid_string }

    let(:described_method) { :== }
    it_behaves_like 'equality check for two UUID objects'

    subject { action }

    context 'passing a non-UUID object' do
      let(:action) { uuid == test_object }

      context 'when this is the UUID as string' do
        let(:test_object) { uuid_string }
        it { should be_false }
      end

      context 'when this is a random other object' do
        let(:test_object) { '123' }
        it { should be_false }
      end
    end
  end

  describe '#=== (equal operator)' do
    let(:uuid_string)  { 'aaaaaaaa-eeee-4444-aaaa-444444444444' }
    let(:uuid)  { Youyouaidi::UUID.new uuid_string }

    let(:described_method) { :=== }
    it_behaves_like 'equality check for two UUID objects'

    subject { action }

    context 'passing a non-UUID object' do
      let(:action) { uuid === test_object }

      context 'when this is the same UUID as string' do
        context 'when string is upcase' do
          let(:test_object) { uuid_string.upcase }
          it { should be_true }
        end
        context 'when string is downcase' do
          let(:test_object) { uuid_string.downcase }
          it { should be_true }
        end
      end

      context 'when this is a random other object' do
        let(:test_object) { '123' }
        it { should be_false }
      end
    end
  end

  describe '#to_s' do
    let(:uuid_string) { '550e8400-e29b-41d4-a716-446655440000' }
    let(:uuid) { Youyouaidi::UUID.new uuid_string }
    subject { uuid.to_s }

    it { should be_a String }
    it { should eq uuid_string }
  end

  describe '#to_i' do
    let(:uuid_string) { '550e8400-e29b-41d4-a716-446655440000' }
    let(:uuid) { Youyouaidi::UUID.new uuid_string }
    subject { uuid.to_i }

    it { should be_a Bignum }
    it { should eq 113059749145936325402354257176981405696 }
  end

  shared_examples_for 'method for short format' do
    let(:uuid_string) { '550e8400-e29b-41d4-a716-446655440000' }
    let(:encoded_uuid) { '_oGOAbD9fsFFEHWSMal1v' }
    let(:uuid) { Youyouaidi::UUID.new uuid_string }

    let(:action) { uuid.send method }
    subject { action }

    it { should be_a String }
    it { should eq encoded_uuid }
  end
  describe '#to_short_string' do
    let(:method) { :to_short_string }
    it_behaves_like 'method for short format'
  end
  describe '#to_param' do
    let(:method) { :to_param }
    it_behaves_like 'method for short format'
  end

  describe '.valid?' do
    let(:param) { '' }
    subject { Youyouaidi::UUID.valid? param }

    context 'with valid uuid' do
      let(:param) { '550e8400-e29b-41d4-a716-446655440000' }

      it { should be_true }
    end

    context 'with invalid uuid' do
      uuid_string   = '550e8400-e29b-41d4-a716-446655440000'
      encoded_uuid  = '_oGOAbD9fsFFEHWSMal1v'
      invalid_uuids = ['Kekse', "aa#{uuid_string}", "#{uuid_string}bb",
        "#{encoded_uuid}" ]

      invalid_uuids.each do |invalid_uuid|
        it "should return false for `#{invalid_uuid}`" do
          expect(Youyouaidi::UUID.valid? invalid_uuid).to eq false
        end
      end
    end
  end
end