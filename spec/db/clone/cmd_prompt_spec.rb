require 'spec_helper'

RSpec.describe Db::Clone::CmdPrompt do
  before(:all) do
    class Prompter
      include Db::Clone::CmdPrompt
    end
    @prompter = Prompter.new
  end

  it 'can prompt a yes/no question (and receive an answer of "y")' do
    allow(STDIN).to receive(:gets) { 'y' }
    answered_yes = nil
    expect { answered_yes = @prompter.ask_yes_no 'Do you wish to proceed?' }.to output("\nDo you wish to proceed? [Yn]: ").to_stdout
    expect(answered_yes).to eq(true)
  end

  it 'can prompt a yes/no question (and receive an answer of "n")' do
    allow(STDIN).to receive(:gets) { 'n' }
    answered_yes = nil
    expect { answered_yes = @prompter.ask_yes_no 'Do you wish to proceed?' }.to output("\nDo you wish to proceed? [Yn]: ").to_stdout
    expect(answered_yes).to eq(false)
  end

  it 'can prompt a multiple choice question' do
    allow(STDIN).to receive(:gets) { '3' }

    expected_prompt = "\n  [\e[1;37m1\e[0m] Thing One\n  [\e[1;37m2\e[0m] Thing Two\n  [\e[1;37m3\e[0m] Thing Three\n\nWhich option? [1-3, default=2]: "

    response = nil
    expect { response = @prompter.prompt 'Which option?', :second, {first: 'Thing One', second: 'Thing Two', third: 'Thing Three'} }.to output(expected_prompt).to_stdout

    expect(response).to eq(:third)
  end

  it 'can reprompt a multiple choice question with invalid selection' do
    # allow(STDIN).to receive(:gets).once { "4" }
    allow(STDIN).to receive(:gets).and_return('4', '2')

    expected_prompt = "\n  [\e[1;37m1\e[0m] Thing One\n  [\e[1;37m2\e[0m] Thing Two\n  [\e[1;37m3\e[0m] Thing Three\n\nWhich option? [1-3, default=2]: #{'Invalid selection:'.red} 4\n\n  [\e[1;37m1\e[0m] Thing One\n  [\e[1;37m2\e[0m] Thing Two\n  [\e[1;37m3\e[0m] Thing Three\n\nWhich option? [1-3, default=2]: "

    response = nil
    expect { response = @prompter.prompt 'Which option?', :second, {first: 'Thing One', second: 'Thing Two', third: 'Thing Three'} }.to output(expected_prompt).to_stdout

    expect(response).to eq(:second)
  end
end
