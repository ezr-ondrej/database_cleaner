require 'database_cleaner/data_mapper/base'

module DatabaseCleaner::DataMapper
  class Transaction
    include ::DatabaseCleaner::DataMapper::Base
    #TODO Figure out repositories, may have to refactor connection_klass to something more sensible
    def start(repo = :default)
      DataMapper.repository(repo) do |r|
        transaction = DataMapper::Transaction.new(r)
        transaction.begin
        r.adapter.push_transaction(transaction)
      end
    end

    def clean(repo = :default)
      DataMapper.repository(repo) do |r|
        adapter = r.adapter
        while adapter.current_transaction
          adapter.current_transaction.rollback
          adapter.pop_transaction
        end
      end
    end

  end
end
