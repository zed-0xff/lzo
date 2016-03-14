require 'spec_helper'

describe LZO::LzopCompressor do
  describe 'writing a file' do
    let(:output_io) { StringIO.new ''.force_encoding 'BINARY' }
    subject do
      mtime = Date.new(1989, 4, 25).to_time
      described_class.new output_io, name: 'name', mode: '100644'.to_i(8), mtime: mtime
    end
    it 'writes a compressible single-block file correctly' do
      subject.write 'aaa'*100
      subject.close

      generated = output_io.string
      expected = File.binread fixture_path 'compressor_output.txt.lzo'
      expect(generated).to eq(expected)
    end

    it 'writes multiple blocks correctly' do
      subject.write 'aaa'*100
      subject.write 'bbb'*100
      subject.close

      generated = output_io.string
      expected = File.binread fixture_path 'compressor_multiblock_output.txt.lzo'
      expect(generated).to eq(expected)
    end

    it 'writes an incompressible file correctly' do
      data = 10.times.reduce('hello world') {|m, _e| m + Digest::MD5.digest(m) }
      subject.write data
      subject.close

      generated = output_io.string
      expected = File.binread fixture_path 'compressor_incompressible_output.txt.lzo'
      expect(generated).to eq(expected)
    end
  end
end
