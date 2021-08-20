require './controllers/post_controller'
require './models/post'
require 'securerandom'

describe PostController do
    describe "#add_post" do
        context "when initialized with valid input" do   
            it 'should be added' do
                params = {
                    'id' => 1,
                    'content' => 'Writing unit test here for #final Project #generasigigih',
                    'file' => {'filename' => 'yfP-Sl3oRisnHVZ-hYhGcQexcited.gif','tempfile' => File.new('./spec/storage/asset.gif')},
                    'user_id' => 1
                }

                allow(SecureRandom).to receive(:urlsafe_base64).and_return("asset")
                post = double
                expect(Post).to receive(:new).with(params).and_return(post)
                expect(post).to receive(:save)
                PostController.add_post(params)
                expect(File.new('./public/assets/assetyfP-Sl3oRisnHVZ-hYhGcQexcited.gif')).not_to be_nil
            end
        end
    end
    describe '#get_by_hashtag_name' do
        context "when initialized with valid input" do   
            it 'should be get_by_hashtag_name' do
                params = {'hashtag_name' => '#Hashtag'}
                expect(Hashtag).to receive(:find_by_name).with('#hashtag')
                allow(Hashtag).to receive(:find_by_name).and_return(Hashtag.new({'id' => 1}))
                expect(Post).to receive(:find_by_hashtag_id).with(1)
                PostController.get_by_hashtag_name(params)
            end
        end
    end
end