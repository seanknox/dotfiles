#Reformat Prompt
Pry.config.theme = "solarized"
Pry.config.prompt = proc do |obj, level, _|
  prompt = ""
  prompt << "#{Rails.version}@" if defined?(Rails)
  prompt << "#{RUBY_VERSION}"
  "#{prompt}> "
end

# vim FTW
Pry.config.editor = "gvim --nofork"

# My pry is polite
Pry.config.hooks.add_hook(:after_session, :say_bye) { puts "bye-bye" }

#Reformat Result
begin
  require 'awesome_print' 
  Pry.config.print = proc { |output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai(indent: 2)}", output) }
rescue LoadError => err
  puts "no awesome_print :("
end

Pry.config.commands.alias_command "lM", "ls -M"
Pry.config.commands.alias_command "c", "continue"
Pry.config.commands.alias_command "n", "next"
Pry.config.commands.alias_command "e", "exit"

