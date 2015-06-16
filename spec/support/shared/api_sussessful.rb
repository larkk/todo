shared_examples_for 'successful request' do
  it 'returns 200 status' do
    expect(response).to be_success
  end
end
