require 'guard'
require 'guard/guard'
require 'json'
require 'yaml'

module Guard
  class I18next < Guard
    
    DEFAULT_OPTIONS = {
        :output         => Pathname.pwd.join('app', 'assets', 'javascripts', 'i18n')
        :namespace      => '(global || window).Locales'
    }

    
    # Initialize Guard::i18next
    #
    # @param [Array<Guard::Watcher>] watchers the watchers in the Guard block
    # @param [Hash] options the options for the Guard
    # @option options [String] :output the output directory
    #
    def initialize(watchers = [], options = {})
      watchers = [] if !watchers
      defaults = DEFAULT_OPTIONS.clone

      super(watchers, defaults.merge(options))
    end
    
    # Gets called when watched paths and files have changes.
    #
    # @param [Array<String>] paths the changed paths and files
    # @raise [:task_has_failed] when stop has failed
    #
    def run_on_change(paths)
      Dir::mkdir(options(:output)) unless File.directory?(options(:output))

      paths.each do |locale_path|
        filename = File.basename(locale_path, ".yml")
        input = File.new(locale_path, 'r')
        locale = YAML.load(input.read)
        input.close

        locale_key = locale.keys[0]
        content = locale[locale_key]
        File.open(options(:output) + "#{filename}.js", "w") do |f|
            # Initialize namespace (if it hasn't been already)
            f.puts "#{options(:namespace)} = #{options(:namespace)} != null ? #{options(:namespace)} : {}"
            f.puts options(:namespace) + "[#{locale_key}] = " + content.to_json
        end
      end
    end
  end
end
