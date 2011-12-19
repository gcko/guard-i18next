require 'guard'
require 'guard/guard'
require 'json'
require 'yaml'

module Guard
  class I18n < Guard

    # Initialize a Guard.
    # @param [Array<Guard::Watcher>] watchers the Guard file watchers
    # @param [Hash] options the custom Guard options
    def initialize(watchers = [], options = {})
      super
    end

    # Call once when Guard starts. Please override initialize method to init stuff.
    # @raise [:task_has_failed] when start has failed
    def start
    end

    # Called when `stop|quit|exit|s|q|e + enter` is pressed (when Guard quits).
    # @raise [:task_has_failed] when stop has failed
    def stop
    end

    # Called when `reload|r|z + enter` is pressed.
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    # @raise [:task_has_failed] when reload has failed
    def reload
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    # @raise [:task_has_failed] when run_all has failed
    def run_all
    end

    # Called on file(s) modifications that the Guard watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_change(paths)
      target = Pathname.pwd.join('app', 'assets', 'javascripts', 'i18n')
      Dir::mkdir(target) unless File.directory?(target)

      paths.each do |locale_path|
        filename = File.basename(locale_path, ".yml")
        input = File.new(locale_path, 'r')
        locale = YAML.load(input.read)
        input.close

        name = locale.keys[0]
        content = locale[name]
        next unless content.key?("javascript")
        File.open(target + "#{filename}.js", "w") do |f|
          f.puts "var locale = {}; locale.t = #{content["javascript"].to_json};"
        end
      end
    end

    # Called on file(s) deletions that the Guard watches.
    # @param [Array<String>] paths the deleted files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_deletion(paths)
    end

  end
end
