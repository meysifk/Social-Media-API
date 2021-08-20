require './controllers/hashtag_controller'
require './models/hashtag'

describe HashtagController do
    describe '#get_by_trend' do
        context "when initialized with valid input" do   
            it 'should be find_by_trend' do
                expect(Hashtag).to receive(:find_by_trend)
                HashtagController.get_by_trend
            end
        end
    end
end
