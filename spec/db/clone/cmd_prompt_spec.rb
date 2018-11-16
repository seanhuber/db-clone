require 'spec_helper'

RSpec.describe Db::Clone::CmdPrompt do
  before(:all) do
    class Prompter
      include Db::Clone::CmdPrompt
    end
    @prompter = Prompter.new
  end

  it 'can prompt a yes/no question (and receive an answer of "y")' do
    allow(STDIN).to receive(:getc) { 'y' }

    answered_yes = @prompter.ask_yes_no 'Do you wish to proceed?'
    expect(answered_yes).to eq(true)
  end

  it 'can prompt a yes/no question (and receive an answer of "n")' do
    allow(STDIN).to receive(:getc) { 'n' }

    answered_yes = @prompter.ask_yes_no 'Do you wish to proceed?'
    expect(answered_yes).to eq(false)
  end

  it 'can prompt a multiple choice question' do
    allow(STDIN).to receive(:getc) { '3' }

    response = @prompter.prompt 'Which option?', :second, {first: 'Thing One', second: 'Thing Two', third: 'Thing Three'}
    expect(response).to eq(:third)
  end

  it 'can reprompt a multiple choice question with invalid selection' do
    # allow(STDIN).to receive(:getc).once { "4" }
    allow(STDIN).to receive(:getc).and_return('4', '2')

    response = @prompter.prompt 'Which option?', :first, {first: 'Thing One', second: 'Thing Two', third: 'Thing Three'}
    expect(response).to eq(:second)
  end
end
