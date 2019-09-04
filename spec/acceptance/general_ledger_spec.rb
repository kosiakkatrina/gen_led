require 'view_journal_entries'
require 'journal_entry'
require 'entry'
require 'bigdecimal'

describe 'a general ledger' do
  class InMemoryJournalEntriesGateway
    def initialize
      @journal_entry = nil
    end

    def save(journal_entry)
      @journal_entry = journal_entry
    end

    def all
      return [] if @journal_entry.nil?
      [@journal_entry]
    end
  end

  let(:journal_entries_gateway) { InMemoryJournalEntriesGateway.new }
  let(:view_journal_entries) do
    ViewJournalEntries.new(
      journal_entries_gateway: journal_entries_gateway
    )
  end

  it 'can view an empty general ledger' do
    response = view_journal_entries.execute({})
    expect(response[:entries]).to eq([])
  end

  it 'can view a general ledger with a single journal entry' do
    journal_entry = JournalEntry.new
    journal_entry.date = '2009/01/01'
    journal_entry.comment = ''
    journal_entry.entries = []

    journal_entries_gateway.save(journal_entry)
    response = view_journal_entries.execute({})
    expect(response[:entries][0]).to(
      eq(
        date: '2009/01/01',
        comment: '',
        entries: []
      )
    )
  end

  it 'can view a general ledger with a single journal entry with entries' do
    journal_entry = JournalEntry.new
    journal_entry.date = '2009/01/01'
    journal_entry.comment = ''
    journal_entry.entries = [
      Entry.new(amount: BigDecimal('100.00'), account_code: '5001', type: :debit),
      Entry.new(amount: BigDecimal('100.00'), account_code: '5002', type: :credit)
    ]

    journal_entries_gateway.save(journal_entry)
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
