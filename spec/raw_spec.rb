require 'spec_helper'

describe LZO::Raw do
  subject { described_class }

  describe '#crc32' do
    it 'calculates expected values' do
      actual = subject.crc32 'abcdef'
      expect(actual).to eq(1_267_612_143)
    end
  end

  describe '#decompress' do
    it 'raises an error on invalid data' do
      original = 'hello world' * 40
      compressed = LZO.compress original
      compressed[0] = "\x0"
      io = StringIO.new compressed

      expect { subject.decompress io }.to raise_error(RuntimeError, 'Error: LZO_E_INPUT_OVERRUN')
    end
  end
end
