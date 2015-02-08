module Flyer
  class PathNotGivenError < StandardError
  end

  class MessageMissingError < StandardError
  end

  class IdMissingError < StandardError
  end

  class FoundNonUniqueIds < StandardError
  end
end