require 'spec_helper'

describe LZO::LzopDecompressor do
  describe 'header metadata' do
    subject do
      io = File.open fixture_path 'long_utf8_plaintext.txt.lzo'
      described_class.new io
    end

    it 'it can read the name' do
      expect(subject.name).to eq('long_utf8_plaintext.txt')
    end

    it 'it can read the mode' do
      expect(subject.mode).to eq(0100644)
    end

    it 'it can read the mtime' do
      expect(subject.mtime).to eq(Time.utc(2016, 2, 2, 22, 45, 16))
    end

    it 'it can read the method' do
      expect(subject.method).to eq(:M_LZO1X_1)
    end

    it 'it can read the level' do
      expect(subject.level).to eq(5)
    end
  end

  describe 'reading file' do
    it 'reads a file in user-specified chunks' do
      io = File.open fixture_path 'long_utf8_plaintext.txt.lzo'
      lzo = described_class.new io

      ary = []
      until lzo.eof?
        bytes = lzo.read(20)
        ary << bytes
      end

      expect(ary.first).to eq('The Project Gutenber')
      expect(ary.last).to eq("w eBooks.\r\n")
      expect(ary.length).to eq(35_879)
    end
  end
end
