require './controllers/comment_controller'
require 'securerandom'

describe CommentController do
    describe "add_comment" do
        context "when initialized with valid input" do   
            it 'should be added' do
                params = {
                    'id' => 1,
                    'content' => 'What a cool unit test using #mock and #stub',
                    'file' => {'filename' => 'yfP-Sl3oRisnHVZ-hYhGcQexcited.gif','tempfile' => File.new('./spec/storage/asset.gif')},
                    'user_id' => 1,
                    'post_id' => 1
                }

                allow(SecureRandom).to receive(:urlsafe_base64).and_return("asset")
                comment = double
                expect(Comment).to receive(:new).with(params).and_return(comment)
                expect(comment).to receive(:save)
                CommentController.add_comment(params)
                expect(File.new('./public/assets/assetyfP-Sl3oRisnHVZ-hYhGcQexcited.gif')).not_to be_nil
            end
        end
    end
end