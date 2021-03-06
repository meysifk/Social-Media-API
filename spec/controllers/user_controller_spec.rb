require './controllers/user_controller'
require './models/user'

describe UserController do
    describe '#add_user' do
        context "when initialized with valid input" do   
            it 'should be added' do
                params = {
                    'username' => 'meysi',
                    'email' => 'meysi@mail.com',
                    'bio' => 'Hello World!'
                }
                user = User.new(params)
                allow(User).to receive(:new).with(params).and_return(user)
                expect(user.username).to eq(params['username'])
                expect(user.email).to eq(params['email'])
                expect(user.bio).to eq(params['bio'])
                expect(user).to receive(:save)
                UserController.add_user(params)
            end
        end
    end
end