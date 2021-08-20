require './models/hashtag'

class HashtagController
    def self.get_by_trend  
        Hashtag.find_by_trend
    end
end