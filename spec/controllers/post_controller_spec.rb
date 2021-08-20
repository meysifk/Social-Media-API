require './controllers/post_controller'
require 'securerandom'

describe PostController do
    describe "add_post" do
        context "when initialized with valid input" do   
            it 'should be added' do
                params = {
                    'id' => 1,
                    'user_id' => 1,
                    'content' => 'content #content',
                    'file' => {'filename' => 'yfP-Sl3oRisnHVZ-hYhGcQexcited.gif','tempfile' => File.new('./spec/storage/asset.gif')}
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
end