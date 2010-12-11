require File.dirname(__FILE__) + '/../spec_helper'

describe 'the base filter class' do
  before  { @base = Rack::PageSpeed::Filters::Base.new(:foo => 'bar') }
  
  it 'when instancing, it optionally takes an options hash as argument' do
    @base.options[:foo].should == 'bar'
  end

  context 'the #method declaration, which can be used to declare a method name which the filter can be called upon' do
    it 'can be called from inside the class' do
      class Boo < Rack::PageSpeed::Filters::Base
        method 'mooers'
      end
      Boo.method.should == 'mooers'
    end

    it 'defaults to the class name if not called' do
      class BananaSmoothie < Rack::PageSpeed::Filters::Base; end
      BananaSmoothie.method.should == 'banana_smoothie'
    end
  end

  context '#file_for returns a File object' do
    before { @base.options.stub(:[]).with(:public).and_return(FIXTURES_PATH) }

    it 'for a script' do
      script = FIXTURES.complex.at_css('#mylib')
      @base.send(:file_for, script).stat.size.should == File.size(File.join(FIXTURES_PATH, 'mylib.js'))
    end

    it "for a stylesheet" do
      style = FIXTURES.complex.at_css('link')
      @base.send(:file_for, style).stat.size.should == File.size(File.join(FIXTURES_PATH, 'reset.css'))
    end
  end
end
