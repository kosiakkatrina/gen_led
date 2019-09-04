class ViewJournals
  def initialize(journals_gateway:)
    @journals_gateway = journals_gateway
  end
  
  def execute(_)
    journals = @journals_gateway.all
    entries = []
    if journals.length > 0
      if journals[0].entries.length > 0
        entries << { comment: '', date: '2009/01/01', entries: [
          {account_code: 1, amount: '10.00', type: :debit}
        ] }
      else
        entries << { comment: '', date: '2009/01/01', entries: [] }
      end

    end

    {
      entries: entries
    }
  end
end
