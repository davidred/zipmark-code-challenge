require 'open-uri'
require 'fileutils'

class Bank < ActiveRecord::Base

  validates :routing_number, uniqueness: true, presence: true
  validates :name, presence: true


  def self.fetch_bank_info
    open("#{Rails.root}/app/models/concerns/test.txt", 'wb') do |file|
      file << open('http://www.fededirectory.frb.org/FedACHdir.txt').read
    end
  end

  def self.parse_bank_info
    File.readlines("#{Rails.root}/app/models/concerns/test.txt").each do |line|
      bank_data = /\d{7}(\d{9})\d{9}(.{0,36})(.{0,36})\s+(.{0,20})(\w{2})(\d{5})(\d{4})(\d{10})/.match(line)
      bank = self.find_by_routing_number(bank_data[1])
      if bank
        bank.update!({
          routing_number: bank_data[1].strip,
          name: bank_data[2].strip,
          phone_number: bank_data[8].strip,
          street: bank_data[3].strip,
          city: bank_data[4].strip,
          state: bank_data[5].strip,
          zip_code: bank_data[6].strip
          })
      else
        self.create!({
          routing_number: bank_data[1].strip,
          name: bank_data[2].strip,
          phone_number: bank_data[8].strip,
          street: bank_data[3].strip,
          city: bank_data[4].strip,
          state: bank_data[5].strip,
          zip_code: bank_data[6].strip
        })
      end

    end
  end

end
