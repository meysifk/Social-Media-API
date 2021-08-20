require './models/comment'
require './models/hashtag'

describe Comment do
    describe '#valid?' do
        context 'when initialized with valid input' do
            it 'should return true' do
                params = {
                    'id' => 1,
                    'content' => 'What a cool unit test using #mock and #stub',
                    'user_id' => 1,
                    'post_id' => 1,
                    'file' => 'Pictures/Photo.png'
                }
                
                comment = Comment.new(params)
                expect(comment.valid?).to eq(true)
            end
        end
        context 'when initialized with invalid input' do
            it 'should return false' do
                params = {
                    'id' => 1
                }
                comment = Comment.new(params)
                expect(comment.valid?).to eq(false)
            end
        end
    end
    describe '#save' do
        context "when initialized with valid input" do
            it 'should be created' do
                params = {
                    'id' => 1,
                    'content' => 'What a cool unit test using #mock and #stub',
                    'user_id' => 1,
                    'post_id' => 1,
                    'file' => 'Pictures/Photo.png'
                }
                comment = Comment.new(params)
                hashtag = Hashtag.new({'id' => 1})
                hashtag_new = Hashtag.new({'name' => '#stub'})
                comment_id = [Comment.new({'id' => 1})]
                mock_client = double
                mock_rawData = double

                allow(comment).to receive(:valid?).and_return(true)
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with("INSERT INTO Comments (content, file, user_id, post_id) VALUES ('#{comment.content}', '#{comment.file}', #{comment.user_id}, #{comment.post_id})")
                expect(mock_client).to receive(:query).with("SELECT LAST_INSERT_ID() AS id").and_return(mock_rawData)

                allow(Comment).to receive(:convert_to_array).with(mock_rawData).and_return(comment_id)
                expect(comment.hashtags).to receive(:empty?).and_return(false)
                allow(Hashtag).to receive(:find_by_name).with('#mock').and_return(hashtag)

                allow(Hashtag).to receive(:find_by_name).with('#stub').and_return(nil)
                allow(Hashtag).to receive(:new).with({'name' => '#stub'}).and_return(hashtag_new)
                allow(hashtag_new).to receive(:save).and_return(2)
                expect(mock_client).to receive(:query).with("INSERT INTO Comment_Hashtags (hashtag_id, comment_id) VALUES (#{1}, #{comment_id[0].id})")
                expect(mock_client).to receive(:query).with("INSERT INTO Comment_Hashtags (hashtag_id, comment_id) VALUES (#{2}, #{comment_id[0].id})")
                expect(comment.save).to eq(comment_id[0].id) 
            end
        end
    end

    describe '#convert_to_array' do
        context 'when initialized with valid input' do
            it 'should be converted' do
               params = {
                    'id' => 1,
                    'content' => 'What a cool unit test using #mock and #stub',
                    'user_id' => 1,
                    'post_id' => 1,
                    'file' => 'Pictures/Photo.png'
                }

                rawData = [params]
                comment = Comment.new(params)
                expected_result = [comment]
                rawData.each do |data|
                    allow(Comment).to receive(:new).with(data).and_return(comment)
                end
                expect(Comment.convert_to_array(rawData)).to eq(expected_result)
            end
        end
    end
end