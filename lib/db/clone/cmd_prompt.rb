module Db::Clone
  module CmdPrompt
    def ask_for_text instruction, default_text=nil
      if default_text
        print "\n#{instruction} [default = \"#{default_text}\"]: "
      else
        print "\n#{instruction}: "
      end
      text = STDIN.gets.chomp.strip
      text = default_text if text.blank? && default_text
      text
    end

    def ask_yes_no question, default_to_yes=true
      print "\n#{question} [#{default_to_yes ? 'Yn' : 'yN'}]: "
      answer = STDIN.gets.chomp.strip.downcase
      default_to_yes ? !(answer == 'n') : answer == 'y'
    end

    def prompt question, default, options={}
      default_num = nil
      numbered_opts = options.map.with_index do |opt, idx|
        default_num = idx+1 if opt[0] == default
        [idx+1, {ret_key: opt[0], label: opt[1]}]
      end.to_h

      puts "\n"
      numbered_opts.each{|choice_num, opt| puts "  [#{choice_num.to_s.white}] #{opt[:label]}" }

      print "\n#{question} [1-#{options.length}, default=#{default_num}]: "

      selection = STDIN.gets.chomp.strip.to_i
      selection = default_num if selection.zero?

      if numbered_opts.has_key? selection
        numbered_opts[selection][:ret_key]
      else
        puts "#{'Invalid selection:'.red} #{selection}"
        prompt question, default, options
      end
    end
  end
end
