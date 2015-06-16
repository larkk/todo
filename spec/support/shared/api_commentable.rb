shared_examples_for 'api commentable' do
  context 'comment' do
    it 'belongs to question' do
      expect(response.body).to have_json_size(size).at_path("#{path}/comments")
    end

    %w(id body commentable_id commentable_type user_id created_at updated_at).each do |attr|
      it "contain #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
                                     .at_path("#{path}/comments/0/#{attr}")
      end
    end
  end
end
