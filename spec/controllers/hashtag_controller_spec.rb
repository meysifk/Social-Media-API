require './controllers/hashtag_controller'
require './models/hashtag'

describe HashtagController do
    describe '#get_by_trend' do
        context "when find_by_trend" do   
            it 'Hashtag should call find_by_trend' do
                expect(Hashtag).to receive(:find_by_trend)
                HashtagController.get_by_trend
            end
        end
    end
end
