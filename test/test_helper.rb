$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'spreadsheet_model'

require 'minitest/autorun'
require 'pry'

account = YAML.load_file(File.join(File.dirname(__FILE__), "account.yml"))

ENV['GOOGLE_DRIVE_CLIENT_ID'] = account['google_drive_client_id']
ENV['GOOGLE_DRIVE_CLIENT_SECRET'] = account['google_drive_client_secret']
ENV['GOOGLE_DRIVE_REFRESH_TOKEN'] = account['google_drive_refresh_token']
ENV["GOOGLE_DRIVE_TEST_MODEL_SHEET_KEY"] = account['google_drive_test_model_sheet_key']
