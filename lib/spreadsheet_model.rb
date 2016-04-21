require "spreadsheet_model/version"
require 'google_drive'
require 'active_support'
require 'active_support/core_ext'
require 'active_model'
require 'google/api_client'

module SpreadsheetModel
  extend ActiveSupport::Concern
  include ActiveModel::Model

  included do
    def self.on_import(&block)
      @import_callback = block
    end

    def self.attr_accessor(*args)
      super
      @@column_names = args
    end

    def [](name)
      @__row[name]
    end

    def []=(name, value)
      @__row[name] = value
    end

    def self.import
      sheet_key = ENV["GOOGLE_DRIVE_#{name.demodulize.underscore.upcase}_SHEET_KEY"]
      sheet_key = self::SHEET_KEY if defined? self::SHEET_KEY
      title_regexp = /.*/
      title_regexp = self::SHEET_TITLE_REGEXP if defined? self::SHEET_TITLE_REGEXP

      sheets = worksheets(sheet_key).select do |sheet|
        sheet.title =~ title_regexp
      end

      sheets.each do |sheet|
        rows = sheet.rows.dup
        header = rows.shift

        store_hash = rows.each_with_object({}) do |row, store_hash|
          row_hash = Hash[*header.zip(row).flatten]
          row_hash = @import_callback.call(row_hash) if @import_callback
          write_rows = [store_hash[row[0]], row_hash].compact.flatten
          store_hash[row[0]] = write_rows
          store_hash
        end

        store_hash.each do |k, v|
          write_cache(k, v)
        end
      end
      write_cache('__cached', true)
    end

    # inspired by:
    # https://github.com/rails/rails/blob/4-2-stable/activerecord/lib/active_record/relation/finder_methods.rb#L66
    def self.find(*args)
      import unless cached?
      find_with_ids(*args)
    end

    def self.cached?
      !!read_cache('__cached')
    end

    private

    # inspired by:
    # https://github.com/rails/rails/blob/4-2-stable/activerecord/lib/active_record/relation/finder_methods.rb#L411
    def self.find_with_ids(*ids)
      expects_array = ids.first.kind_of?(Array)
      ids = ids.flatten.compact.uniq

      case ids.size
      when 0
        return nil
      when 1
        if expects_array
          result = find_some([ids.first])
        else
          result = find_one(ids.first)
        end
      else
        find_some(ids)
      end
    end

    # inspired by:
    # https://github.com/rails/rails/blob/4-2-stable/activerecord/lib/active_record/relation/finder_methods.rb#L432
    def self.find_one(id)
      rows = read_cache(id)
      return nil unless rows

      row_to_instance(rows[0])
    end

    # inspired by:
    # https://github.com/rails/rails/blob/4-2-stable/activerecord/lib/active_record/relation/finder_methods.rb#L449
    def self.find_some(ids)
      records = ids.map do |id|
        read_cache(id).map do |row|
          row_to_instance(row)
        end
      end.flatten
    end

    def self.cache
      @@cache = Rails.cache if defined? Rails
      @@cache ||= ActiveSupport::Cache::MemoryStore.new
    end

    def self.read_cache(key)
      cache.read "#{name}::#{key}"
    end

    def self.write_cache(key, value)
      cache.write "#{name}::#{key}", value
    end

    def self.worksheets(sheet_key)
      client = ::OAuth2::Client.new(
        ENV['GOOGLE_DRIVE_CLIENT_ID'],
        ENV['GOOGLE_DRIVE_CLIENT_SECRET'],
        site: 'https://accounts.google.com',
        token_url: '/o/oauth2/token',
        authorize_url: '/o/oauth2/auth'
      )
      auth_options = {
        refresh_token: ENV['GOOGLE_DRIVE_REFRESH_TOKEN'],
        expires_at: 3600
      }
      auth_token = ::OAuth2::AccessToken.from_hash(client, auth_options)
      auth_token = auth_token.refresh!
      session = ::GoogleDrive.login_with_oauth(auth_token.token)
      session.spreadsheet_by_key(sheet_key).worksheets
    end

    def self.row_to_instance(row)
      return nil unless row
      attributes = row.select { |key, _| @@column_names.include?(key.to_sym) }

      if attributes['type'].to_s.present?
        instance = attributes['type'].constantize.new(attributes)
      else
        instance = self.new(attributes)
      end

      instance.instance_variable_set(:@__row, row)
      instance
    end

  end
end
