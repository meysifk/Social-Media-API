require './models/post'
require './models/hashtag'

describe Post do
    describe '#valid?' do
        context 'when initialized with valid input' do
            it 'should return true' do
                params = { 
                    "id" => 1, 
                    "content" => "Writing unit test here for #final Project #generasigigih", 
                    "user_id" => 1, 
                    'file' => 'Pictures/Photo.png'
                }
                post = Post.new(params)

                expect(post.valid?).to eq(true)
            end
        end

        context 'when initialized with invalid input' do
            it 'should return false' do
                post = Post.new(id: 1)

                expect(post.valid?).to eq(false)
            end
        end
    end

    describe '#as_json' do
        context "when initialized with valid input" do
            it 'should return expected result' do
                post = Post.new({ 
                    "id" => 1, 
                    "content" => "Writing unit test here for #final Project #generasigigih", 
                    "user_id" => 1, 
                    'file' => 'Pictures/Photo.png'
                })
                
                expected_result = {
                    id: post.id, 
                    content: post.content, 
                    file: post.file, 
                    user_id: post.user_id, 
                    hashtags: ["#final", "#generasigigih"]
                }

                expect(post.as_json).to eq(expected_result)
            end
        end
    end

    describe '#save' do
        context 'when initialized with valid input' do
            it 'should be created' do
                params = { 
                    "id" => 1, 
                    "content" => "Writing unit test here for #final Project #generasigigih", 
                    "file" => "Pictures/Photo.png",
                    "user_id" => 1                    
                }

                post = Post.new(params)
                hashtag = Hashtag.new({'id' => 1})
                hashtag_new = Hashtag.new({'name' => '#generasigigih'})
                post_id = [Post.new({'id' => 1})]
                mock_client = double
                mock_rawData = double

                allow(post).to receive(:valid?).and_return(true)
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with("INSERT INTO Posts (content, file, user_id) VALUES ('#{post.content}', '#{post.file}', #{post.user_id})")
                expect(mock_client).to receive(:query).with("SELECT LAST_INSERT_ID() AS id").and_return(mock_rawData)

                allow(Post).to receive(:convert_to_array).with(mock_rawData).and_return(post_id)
                expect(post.hashtags).to receive(:empty?).and_return(false)
                allow(Hashtag).to receive(:find_by_name).with('#final').and_return(hashtag)

                allow(Hashtag).to receive(:find_by_name).with('#generasigigih').and_return(nil)
                allow(Hashtag).to receive(:new).with({'name' => '#generasigigih'}).and_return(hashtag_new)
                allow(hashtag_new).to receive(:save).and_return(2)
                expect(mock_client).to receive(:query).with("INSERT INTO Post_Hashtags (hashtag_id, post_id) VALUES (#{1}, #{post_id[0].id})")
                expect(mock_client).to receive(:query).with("INSERT INTO Post_Hashtags (hashtag_id, post_id) VALUES (#{2}, #{post_id[0].id})")
                expect(post.save).to eq(post_id[0].id) 
            end
        end
    end

    describe '#convert_to_array' do
        context 'when initialized with valid input' do
            it 'should be converted' do
                params = { 
                    "id" => 1, 
                    "content" => "Writing unit test here for #final Project #generasigigih", 
                    "user_id" => 1, 
                    'file' => 'Pictures/Photo.png'
                }
                rawData = [params]
                post = Post.new(params)
                expected_result = [post]
                rawData.each do |data|
                    allow(Post).to receive(:new).with(data).and_return(post)
                end
                expect(Post.convert_to_array(rawData)).to eq(expected_result)
            end
        end
    end

    describe '#find_by_hashtag_id' do
        context 'when initialized with valid input' do
            it 'should be find' do
                params = {
                    "id" => 1, 
                    "content" => "Writing unit test here for #final Project #generasigigih", 
                    "user_id" => 1, 
                    'file' => 'Pictures/Photo.png', 
                    "create_at" => "2021-08-14 17:36:54"
                }
                id = 1
                post = Post.new(params)
                convert_result = Array.new 
                convert_result << post
                as_json_result = {
                        :id => 1,
                        :content => "Writing unit test here for #final Project #generasigigih", 
                        :user_id  => 1, 
                        :file  => 'Pictures/Photo.png',
                        :create_at  => "2021-08-14 17:36:54"
                    }
                expected_result = [{
                    :id => 1,
                    :content => "Writing unit test here for #final Project #generasigigih", 
                    :user_id  => 1, 
                    :file  => 'Pictures/Photo.png',
                    :create_at  => "2021-08-14 17:36:54"
                }]
                mock_client = double 
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with("SELECT Posts.* FROM Post_Hashtags JOIN Posts on Post_Hashtags.post_id = Posts.id WHERE hashtag_id = #{id}")
                allow(Post).to receive(:convert_to_array).and_return(convert_result)
                convert_result.map { |post| allow(post).to receive(:as_json).and_return(as_json_result)}
                expect(Post.find_by_hashtag_id(1)).to eq(expected_result)
            end
        end
    end
end