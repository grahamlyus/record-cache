module RecordCache
  module Strategy
    class FullTableCache < Base
      FULL_TABLE = 'full-table'

      # parse the options and return (an array of) instances of this strategy
      def self.parse(base, record_store, options)
        return nil unless options[:full_table]
        FullTableCache.new(base, :full_table, record_store, options)
      end

      # Can the cache retrieve the records based on this query?
      def cacheable?(query)
        true
      end

      # Clear the cache on any record change
      def record_change(record, action)
        record_store.delete(cache_key(FULL_TABLE))
      end

      protected

      # retrieve the record(s) with the given id(s) as an array
      def fetch_records(query)
        key = cache_key(FULL_TABLE)
        # get the records from the cache 
        records = from_cache(key)
        # logging (only in debug mode!) and statistics
        log_full_table_cache_hit(key, records) if RecordCache::Base.logger.debug?
        statistics.add(1, records ? 1 : 0) if statistics.active?
        # no records found? retrieve all records from the DB and return
        records ||= from_db(key)
      end

      private

      # ---------------------------- Querying ------------------------------------

      # retrieve the records from the cache with the given keys
      def from_cache(key)
        record_store.read(key)
      end

      # retrieve the records with the given ids from the database
      def from_db(key)
        RecordCache::Base.without_record_cache do
          # retrieve the records from the database
          records = @base.all.to_a
          # write all records to the cache
          record_store.write(key, records)
          records
        end
      end

      # ------------------------- Utility methods ----------------------------

      # log cache hit/miss to debug log
      def log_full_table_cache_hit(key, records)
        hit = records ? "hit" : "miss"
        msg = "FullTableCache #{hit} for model #{@base.name}"
        RecordCache::Base.logger.debug(msg)
      end

    end
  end
end
