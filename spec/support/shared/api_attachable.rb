shared_examples_for 'api attachable' do
  context 'attachment' do
    it 'belongs to attachable' do
      expect(response.body).to have_json_size(size).at_path("#{path}/attachments")
      expect(response.body).to be_json_eql(attachment.file.url.to_json)
                                   .at_path("#{path}/attachments/0/url")
    end
  end
end

