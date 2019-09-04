class ViewJournalEntries
  def initialize(journal_entries_gateway:)
    @journal_entries_gateway = journal_entries_gateway
  end
  
  def execute(_)
    journal_entries = @journal_entries_gateway.all
    entries = []
    if journal_entries.length > 0
      if journal_entries[0].entries.length > 0
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
