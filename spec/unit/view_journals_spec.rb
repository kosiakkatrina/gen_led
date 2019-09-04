describe ViewJournals do
  class StubJournalsGateway
    def initialize(journals:)
      @journal_entries = journals
    end

    def all
      @journal_entries
    end
  end

  it 'can view an empty journal' do
    view_journals = described_class.new(
        journals_gateway: StubJournalsGateway.new(journals: [])
    )
    response = view_journals.execute({})
    expect(response[:entries]).to eq([])
  end

  it 'can view a single journal' do
    journal_entry = Journal.new
    journal_entry.entries = []
    view_journals = described_class.new(
        journals_gateway: StubJournalsGateway.new(journals: [journal_entry])
    )
    response = view_journals.execute({})
    expect(response[:entries][0]).to(
      eq(
        date: '2009/01/01',
        comment: '',
        entries: []
      )
    )
  end


  it 'can view a single journal with entries' do
    journal_entry = Journal.new
    journal_entry.entries = [
        Entry.new(type: :debit, amount: BigDecimal('10.00'), account_code: 1)
    ]

    view_journals = described_class.new(
        journals_gateway: StubJournalsGateway.new(journals: [journal_entry])
    )
    response = view_journals.execute({})
    expect(response[:entries][0]).to(
      eq(
        date: '2009/01/01',
        comment: '',
        entries: [{type: :debit, amount: '10.00', account_code: 1}]
      )
    )
  end
end
