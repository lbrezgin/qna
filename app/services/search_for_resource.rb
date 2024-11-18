class SearchForResource
  def self.search_for(query, resource)
    query.insert(query.index('@'), "\\") if query.include?('@')

    if resource == 'All'
      ThinkingSphinx.search(query)
    else
      resource.constantize.search(query)
    end
  end
end
