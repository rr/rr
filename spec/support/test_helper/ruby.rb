module TestHelper
  module Ruby
    def call
      super
      File.open(path, 'w') do |f|
        content = <<-EOT
          require 'rubygems'
          require 'bundler'
          Bundler.setup
          Bundler.require(:default)
        EOT

        requires = project.requires_with_rr(@requires)
        require_lines = project.require_lines(requires).
          map { |str| "#{str}\n" }.
          join
        content << "\n" + require_lines + "\n"

        content << @prelude

        if RR.debug?
          puts "~ Content of #{File.basename(path)} ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
          puts content
          puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        end

        f.write(content)
      end
    end
  end
end
