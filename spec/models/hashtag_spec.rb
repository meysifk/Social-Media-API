require './models/hashtag'

describe Hashtag do
    describe '#initialize, #valid?, and #exist?' do
        context 'when initialized with valid input' do
            it 'should return true' do
                    params={
                        'name' => '#generasigigih'
                    }

                    hashtag = Hashtag.new(params)
                    mock_client = double
                    allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                    
                    allow(mock_client).to receive(:query).with("SELECT id FROM Hashtags WHERE name = '#{hashtag.name}'").and_return([])
                    expect(hashtag.valid?).to eq(true)
            end
        end

        context 'when initialized with invalid input' do
            it 'should return false' do
                params = {}

                hashtag = Hashtag.new(params)
                mock_client = double
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                
                allow(mock_client).to receive(:query).with("SELECT id FROM Hashtags WHERE name = '#{hashtag.name}'").and_return([])
                expect(hashtag.valid?).to eq(false)
            end
        end
    end
    describe '#save' do
        context 'when initialized with valid input' do
            it 'should be created' do
                params={
                    'name' => '#generasigigih'
                }

                convert_result=[Hashtag.new({'id' => 1,'name'=>'#generasigigih'})]
                hashtag = Hashtag.new(params)
                mock_client = double
                allow(hashtag).to receive(:valid?).and_return(true)
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with("INSERT INTO Hashtags (name) VALUES ('#{hashtag.name}')")
                expect(mock_client).to receive(:query).with("SELECT id FROM Hashtags WHERE name = '#{hashtag.name}'")
                allow(Hashtag).to receive(:convert_to_array).and_return(convert_result)
                expect(hashtag.save).to eq(1)  
            end
        end
        context 'when initialized with invalid input' do
            it 'should not be created' do
                params = {
                    'id' => 1
                }

                hashtag = Hashtag.new(params)
                allow(hashtag).to receive(:valid?).and_return(false)
                expect(hashtag.save).to equal(false)
            end
        end
    end
    describe '#find_by_id' do
        context 'when initialized with valid input' do
            it 'should be find' do
                id = 1
                hashtag = Hashtag.new({'id' => 1, 'name' => '#generasigigih'})
                convert_result = [hashtag]
                mock_client = double 
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with("SELECT * FROM Hashtags WHERE id = #{hashtag.id}")
                allow(Hashtag).to receive(:convert_to_array).and_return(convert_result)
                expect(Hashtag.find_by_id(1)).to eq(hashtag)
            end
        end
    end
    describe '#convert_to_array' do
        context 'when initialized with valid input' do
            it 'should be converted' do
                rawData = [{'id' => 1, 'name' => '#generasigigih'}]
                hashtag = Hashtag.new({'id' => 1, 'name' => '#generasigigih'})
                expected_result = [hashtag]
                rawData.each do |data|
                    allow(Hashtag).to receive(:new).with(data).and_return(hashtag)
                end
                expect(Hashtag.convert_to_array(rawData)).to eq(expected_result)
            end
        end
    end
    describe '#as_json' do
        context "when initialized with valid input" do
            it 'should return expected result' do
                hashtag = Hashtag.new({'id' => 1, 'name' => '#generasigigih'})
                expected_result = {id: hashtag.id, name: hashtag.name}
                expect(hashtag.as_json).to eq(expected_result)
            end
        end
    end
    describe '#find_by_name' do
        context 'when initialized with valid input' do
            it 'should be find' do
                name = '#generasigigih'
                hashtag = Hashtag.new({'id' => 1})
                query_result = [{'id' => 1}]
                convert_result = [hashtag]
                mock_client = double 
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                allow(mock_client).to receive(:query).with("SELECT id FROM Hashtags WHERE name = '#{name}'").and_return(query_result)
                allow(query_result).to receive(:any?).and_return(true)
                allow(Hashtag).to receive(:convert_to_array).and_return(convert_result)
                expect(Hashtag.find_by_name('#generasigigih')).to eq(hashtag)
            end
        end
    end
    describe '#find_by_trend' do
        context 'when initialized with valid input' do
            it 'should be find' do
                time = Time.now - 60 * 60 * 24
                rawData_result_id =[
                    {'hashtag_id' => 1},
                    {'hashtag_id' => 2},
                    {'hashtag_id' => 3},
                    {'hashtag_id' => 4},
                    {'hashtag_id' => 5}
                ]
                rawData_result_hashtags =[
                    {'id' => 1, 'name' => '#generasigigih1'},
                    {'id' => 2, 'name' => '#generasigigih2'},
                    {'id' => 3, 'name' => '#generasigigih3'},
                    {'id' => 4, 'name' => '#generasigigih4'},
                    {'id' => 5, 'name' => '#generasigigih5'}
                ]
                hashtags = Array.new
                for data in rawData_result_hashtags
                    hashtag = Hashtag.new(data)
                    hashtags << hashtag
                end
                result = [
                    {
                        :id => 1,
                        :name =>"#generasigigih1"
                    },
                    {
                        :id => 2,
                        :name =>"#generasigigih2"
                    },
                    {
                        :id => 3,
                        :name =>"#generasigigih3"
                    },
                    {
                        :id => 4,
                        :name =>"#generasigigih4"
                    },
                    {
                        :id => 5,
                        :name =>"#generasigigih5"
                    }
                ]
                mock_client = double
                query = "SELECT hashtag_id, SUM(number) total FROM ( SELECT hashtag_id, COUNT(hashtag_id) AS number FROM Post_Hashtags WHERE created_at > '#{time}' GROUP BY hashtag_id UNION ALL SELECT hashtag_id, COUNT(hashtag_id) AS number from Comment_Hashtags WHERE created_at > '#{time}' GROUP BY hashtag_id) h GROUP BY hashtag_id ORDER BY total DESC LIMIT 5"
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with(query)
                allow(mock_client).to receive(:query).with(query).and_return(rawData_result_id)
                rawData_result_id.each_with_index do |data, index|
                    allow(Hashtag).to receive(:find_by_id).with(data['hashtag_id']).and_return(hashtags[index])
                end
                hashtags.map { |hashtag| allow(hashtag).to receive(:as_json).and_return({id: hashtag.id, name: hashtag.name})}
                expect(Hashtag.find_by_trend).to eq(result)
            end
        end
    end
end