module TestHelper
  module Rails
    def call
      super

      content = File.read(path)

      regexp = Regexp.new(
        '(' + start_of_requires.source + '.+?\n\n)',
        Regexp::MULTILINE
      )
      requires = project.requires_with_rr(@requires)
      require_lines = project.require_lines(requires).
        map { |str| "#{str}\n" }.
        join
      unless content.gsub!(regexp, '\1' + require_lines + "\n")
        raise "Regexp didn't match!\nRegex: #{regexp}\nContent:\n#{content}"
      end

      content << "\n\n" + @prelude

      File.open(path, 'w') { |f| f.write(content) }

      if RR.debug?
        puts "~ Content of #{File.basename(path)} ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts File.read(path)
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      end
    end
  end
end
