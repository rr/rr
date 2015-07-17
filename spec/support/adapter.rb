require 'appraisal/file'

class Adapter
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def appraisal_name
    parts = []
    parts << 'ruby_19'
    parts << name
    parts.join('_')
  end

  def appraisal
    @appraisal ||= Appraisal::File.new.appraisals.find do |appraisal|
      appraisal.name == appraisal_name
    end
  end
end
