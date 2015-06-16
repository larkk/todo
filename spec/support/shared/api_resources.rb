shared_examples_for 'api resource with attributes' do
  it 'contains attributes' do
    attributes.each do |attr|
      expect(response.body)
          .to be_json_eql(resource.send(attr.to_sym).to_json)
                  .at_path("#{path}/#{attr}")
    end
  end
end
