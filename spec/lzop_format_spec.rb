require 'spec_helper'

describe LZO::LZOP::LzoMethod do
  subject { described_class }

  describe '#get' do
    it 'returns a symbol for binary data' do
      data = "\x01"
      method = subject.read data
      expect(method.get).to eq(:M_LZO1X_1)
    end
  end

  describe '#set' do
    it 'takes a symbol and writes binary data' do
      method = subject.new
      method.set :M_LZO1X_1
      expect(method.to_binary_s).to eq("\x01")
    end
  end
end

describe LZO::LZOP::HeaderFlags do
  subject { described_class }

  describe '#get' do
    it 'returns an array of symbols for binary data' do
      data = "\x00\x00\x00\x55"
      flags = subject.read data
      expect(flags.get).to eq([85, :F_ADLER32_D, :F_STDIN, :F_NAME_DEFAULT, :F_H_EXTRA_FIELD])
    end
  end

  describe '#set' do
    it 'takes an array of symbols and writes binary data' do
      flags = subject.new
      flags.set %i(F_ADLER32_D F_STDIN F_NAME_DEFAULT F_H_EXTRA_FIELD)
      expect(flags.to_binary_s).to eq("\x00\x00\x00\x55")
    end
  end
end
