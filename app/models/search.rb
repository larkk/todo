class Search
  def self.search(q, filter_option=nil)
   return [] unless q.present?
   if %w(Questions Answers Comments Users).include? filter_option
     filter_option.singularize.constantize.search q
   else
     ThinkingSphinx.search q
   end
  end
end
