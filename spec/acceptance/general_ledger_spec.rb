require 'view_journals'
require 'journal'
require 'entry'
require 'bigdecimal'

describe 'a general ledger' do
  class InMemoryJournalsGateway
    def initialize
      @journal = nil
    end

    def save(journal)
      @journal = journal
    end

    def all
      return [] if @journal.nil?
      [@journal]
    end
  end

  let(:journals_gateway) { InMemoryJournalsGateway.new }
  let(:view_journal_entries) do
    ViewJournals.new(
        journals_gateway: journals_gateway
    )
  end

  it 'can view an empty general ledger' do
    response = view_journal_entries.execute({})
    expect(response[:entries]).to eq([])
  end

  it 'can view a general ledger with a single journal' do
    journal = Journal.new
    journal.date = '2009/01/01'
    journal.comment = ''
    journal.entries = []

    journals_gateway.save(journal)
    response = view_journal_entries.execute({})
    expect(response[:entries][0]).to(
      eq(
        date: '2009/01/01',
        comment: '',
        entries: []
      )
    )
  end

  xit 'can view a general ledger with a single journal entry with entries' do
    journal_entry = JournalEntry.new
    journal_entry.date = '2009/01/01'
    journal_entry.comment = ''
    journal_entry.entries = [
      Entry.new(amount: BigDecimal('100.00'), account_code: '5001', type: :debit),
      Entry.new(amount: BigDecimal('100.00'), account_code: '5002', type: :credit)
    ]

    journals_gateway.save(journal_entry)
    response = view_journal_entries.execute({})
    expect(response[:entries][0]).to(
      eq(
        date: '2009/01/01',
        comment: '',
        entries: [
          { amount: '100.00', account_code: '5001', type: :debit },
          { amount: '100.00', account_code: '5002', type: :credit }
        ]
      )
    )
  end
end
