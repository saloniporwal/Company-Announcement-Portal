require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) { FactoryBot.attributes_for(:user) }
  let(:invalid_attributes) do
    {
      email: '',
      password: '',
      first_name: ''
    }
  end

  let!(:user) { User.create(valid_attributes) }
  let(:auth_token) { JsonWebToken.encode(user_id: user.id) }

  describe 'POST #register' do
    context 'with valid parameters' do
      it 'creates a new user and returns success message' do
        post :register, params: valid_attributes
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context 'with invalid parameters' do
      it 'returns error messages' do
        post :register, params: invalid_attributes
        expect(JSON.parse(response.body)['error']).to include("Email can't be blank")
      end
    end
  end

  describe 'POST #login' do
    context 'with valid credentials' do
      it 'returns a token and success message' do
        post :login, params: { email: user.email, password: 'password123' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['token']).not_to be_nil
        expect(JSON.parse(response.body)['message']).to eq('Login successful')
      end
    end

    context 'with invalid credentials' do
      it 'returns an error message' do
        post :login, params: { email: user.email, password: 'wrongpassword' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid credentials')
      end
    end
  end

  describe 'GET #show' do
    context 'when authenticated' do
      it 'returns the user profile' do
        request.headers['Authorization'] = "Authoration #{auth_token}"
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(user.id)
      end
    end

    context 'when user not found' do
      it 'returns not found message' do
        request.headers['Authorization'] = "Authoration #{auth_token}"
        get :show, params: { id: 9999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq('User not found')
      end
    end
  end
end
