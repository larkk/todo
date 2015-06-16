shared_examples_for 'votable' do
  describe 'PATCH #vote_up' do
    context 'when signed in user' do
      before { sign_in(user) }

      it 'votes up for answer' do
        expect{ patch :vote_up, another_params }.to change(another_resource.votes, :count).by(1)
      end

      it 'saves vote to the db' do
        patch :vote_up, another_params
        resource.reload
        expect(another_resource.votes.first.value).to eq 1
      end

      it 'denies voting second time' do
        patch :vote_up, another_params
        patch :vote_down, another_params
        expect(another_resource.votes.first.value).to eq 1
      end

      it 'renders vote json template ' do
        patch :vote_up, another_params
        expect(response).to render_template :vote
      end
    end

    context 'when signed in as author' do
      before { sign_in(user) }

      it { expect{ patch :vote_up, params }.not_to change(resource.votes, :count) }

      it 'renders status forbidden' do
        patch :vote_up, params
        expect(response).to redirect_to root_path
      end
    end

    context 'when guest' do
      it 'votes for answer' do
        expect{ patch :vote_up, another_params }.not_to change(another_resource.votes, :count)
      end

      it 'renders vote json template ' do
        patch :vote_up, another_params
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'PATCH #vote_down' do
    context 'when signed in user' do
      before { sign_in(user) }

      it 'votes up for answer' do
        expect{ patch :vote_down, another_params }.to change(another_resource.votes, :count).by(1)
      end

      it 'saves vote to the db' do
        patch :vote_down, another_params
        resource.reload
        expect(another_resource.votes.first.value).to eq -1
      end

      it 'denies voting second time' do
        patch :vote_down, another_params
        patch :vote_up, another_params
        expect(another_resource.votes.first.value).to eq -1
      end

      it 'renders vote json template ' do
        patch :vote_down, another_params
        expect(response).to render_template :vote
      end
    end

    context 'when signed in as author' do
      before { sign_in(user) }

      it { expect{ patch :vote_down, params }.not_to change(resource.votes, :count) }

      it 'renders status forbidden' do
        patch :vote_up, params
        expect(response).to redirect_to root_path
      end
    end

    context 'when guest' do
      it 'votes for answer' do
        expect{ patch :vote_down, another_params }.not_to change(another_resource.votes, :count)
      end

      it 'renders vote json template ' do
        patch :vote_down, another_params
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'PATCH #unvote' do
    context 'User' do
      before do
        sign_in(user)
        patch :vote_up, another_params
      end

      it { expect{ patch :unvote, another_params }
               .to change(another_resource.votes, :count).by(-1) }

      it 'renders vote json template' do
        patch :unvote, another_params
        expect(response).to render_template :vote
      end
    end

    context 'Author' do
      before { sign_in(user) }

      it 'can not unvote' do
        expect{ patch :unvote, params }.not_to change(resource.votes, :count)
      end
    end

    context 'Guest' do
      it 'can not unvote' do
        expect{ patch :unvote, another_params }.not_to change(another_resource.votes, :count)
      end

      it 'renders status unauthorized' do
        patch :unvote, params
        expect(response).to be_unauthorized
      end
    end
  end
end
