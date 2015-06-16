shared_examples_for 'publishable' do
  it 'publishes to channel' do
    expect(PrivatePub).to receive(:publish_to).with(channel, anything)
    do_request
  end
end

shared_examples_for 'not publishable' do
  it 'does not publish to channel' do
    expect(PrivatePub).not_to receive(:publish_to).with(channel, anything)
    do_request
  end
end
