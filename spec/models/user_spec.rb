require './models/user.rb'

describe User do
    describe '#valid?' do
        context 'when initialized with valid input' do
            it 'should return true' do
                params = {
                    'username' => 'meysi',
                    'email' => 'meysi@gmail.com',
                    'bio' => 'Hello World!'
                }

                user = User.new(params)
                mock_client = double
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                allow(mock_client).to receive(:query).with("SELECT id FROM Users WHERE email = '#{user.email}' OR username = '#{user.username}'").and_return([])
                expect(user.valid?).to eq(true)
            end
        end
        context 'when initialized with invalid input' do
            it 'should return false' do
                params = {
                    'email' => 'meysi@gmail.com',
                    'bio' => 'Hello World!'
                }

                user = User.new(params)
                mock_client = double
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                allow(mock_client).to receive(:query).with("SELECT id FROM Users WHERE email = '#{user.email}' OR username = '#{user.username}'").and_return([])
                expect(user.valid?).to eq(false)
            end
        end
    end

    describe '#save' do
        context 'when initialized with valid input' do
            it 'should be created' do
                params = {
                    'username' => 'meysi',
                    'email' => 'meysi@gmail.com',
                    'bio' => 'Hello World!'
                }

                user = User.new(params)
                mock_client = double
                allow(user).to receive(:valid?).and_return(true)
                allow(Mysql2::Client).to receive(:new).and_return(mock_client)
                expect(mock_client).to receive(:query).with("INSERT INTO Users (username, email, bio) VALUES ('#{user.username}', '#{user.email}', '#{user.bio}')")
                allow(mock_client).to receive(:query).with("SELECT LAST_INSERT_ID() AS id").and_return([{'id' => 1}])
                expect(user.save).to equal(1)
            end
        end
        context 'when initialized with invalid input' do
            it 'should not be created' do
                params = {
                    'username' => 'meysi',
                    'bio' => 'Hello World!'
                }

                user = User.new(params)
                allow(user).to receive(:valid?).and_return(false)
                expect(user.save).to equal(false)
            end
        end
    end
end