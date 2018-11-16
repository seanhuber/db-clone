require 'cli/ui'

CLI::UI::StdoutRouter.enable

module Db
  module Clone
    module CmdPrompt
      def frame(title)
        CLI::UI::Frame.open(title) do
          yield
        end
      end

      def ask_yes_no question, default_to_yes: true
        if default_to_yes
          CLI::UI.confirm question
        else
          CLI::UI.ask(question, options: %w(no yes)) == 'yes'
        end
      end

      def prompt question, default, options={}
        opts = options.except(default)
        default_option = options[default]

        CLI::UI::Prompt.ask(question) do |handler|
          handler.option(default_option) { default }

          opts.each do |(value, text)|
            handler.option(text.to_s) { value }
          end
        end
      end

      def fmt text
        CLI::UI.fmt text
      end
    end
  end
end
