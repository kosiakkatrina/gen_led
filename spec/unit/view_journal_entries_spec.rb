describe ViewJournalEntries do
  class StubJournalEntriesGateway
    def initialize(journal_entries:)
      @journal_entries = journal_entries
    end

    def all
      @journal_entries
    end
  end

  class EmptyJournalEntriesGateway < StubJournalEntriesGateway
    def initialize
      super(journal_entries: [])
    end
  end

  class AlwaysSingleEntryJournalEntriesGateway < StubJournalEntriesGateway
    def initialize
      journal_entry = JournalEntry.new
      journal_entry.entries = []
      super(journal_entries: [journal_entry])
    end
  end

  class AlwaysHasEntriesSingleEntryJournalEntriesGateway < StubJournalEntriesGateway
    def initialize
      journal_entry = JournalEntry.new
      journal_entry.entries = [
        Entry.new(type: :debit, amount: BigDecimal('10.00'), account_code: 1)
      ]
      super(journal_entries: [journal_entry])
    end
  end
  it 'can view an empty journal' do
    view_journal_entries = described_class.new(
      journal_entries_gateway: EmptyJournalEntriesGateway.new
    )
    response = view_journal_entries.execute({})
    expect(response[:entries]).to eq([])
  end

  it 'can view a single journal entry' do
    view_journal_entries = described_class.new(
      journal_entries_gateway: AlwaysSingleEntryJournalEntriesGateway.new
    )
    response = view_journal_entries.execute({})
    expect(response[:entries][0]).to(
      eq(
        date: '2009/01/01',
        comment: '',
        entries: []
      )
    )
  end


  it 'can view a single journal entry with entries' do
    view_journal_entries = described_class.new(
      journal_entries_gateway: AlwaysHasEntriesSingleEntryJournalEntriesGateway.new
    )
    response = view_journal_entries.execute({})
    expect(response[:entries][0]).to(
      eq(
        date: '2009/01/01',
        comment: '',
        entries: [{type: :debit, amount: '10.00', account_code: 1}]
      )
    )
  end
end
