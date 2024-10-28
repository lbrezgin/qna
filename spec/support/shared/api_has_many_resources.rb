shared_examples_for 'API Has many resources' do
  describe 'comments' do
    it 'returns all comments' do
      expect(api_response['comments'].size).to eq 3
    end

    it 'returns comments all public fields' do
      %w[id content commentable_type commentable_id user_id created_at updated_at].each do |attr|
        expect(api_response['comments'].first[attr]).to eq comments.first.send(attr).as_json
      end
    end
  end

  describe 'files' do
    it 'returns files url' do
      expect(api_response['files'].first['url']).to eq rails_blob_path(resource.files.first, only_path: true)
    end
  end

  describe 'links' do
    it 'return all links' do
      expect(api_response['links'].size).to eq 2
    end

    it 'returns links all public fields' do
      %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
        expect(api_response['links'].first[attr]).to eq links.first.send(attr).as_json
      end
    end
  end
end
