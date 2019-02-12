require "csv"
require 'action_view'
include ActionView::Helpers::DateHelper

class Prospect < ApplicationRecord

    has_many :communications

    def account_manager_name()
        if (account_manager_user_id)
            return User.find(account_manager_user_id).name
        else
            return "unallocated"
        end
    end

    def reminder_status()
        if (! reminder_date)
            return "set"
        else
            return reminder_date
        end
    end

    def last_contact()
        # todo - search comms for last communication and format '3 days ago' style
        if (communications.length == 0)
            return "never"
        end
        last_contact_date = communications.last.communication_date
        from_time = Time.now
        return distance_of_time_in_words(from_time, last_contact_date) + " ago"         
    end

    def last_contact_date()
        if (communications.length == 0)
            return Date.new(2013,1,1)
        end
        last_contact_date = communications.last.communication_date
        return last_contact_date        
    end

    def Prospect.import_csv(filename)
        simon = User.find_by_name('Simon')
        linda = User.find_by_name('Linda')
        CSV.foreach(filename) do |row|  
            country = row[0]
            if (country)
                prospect = Prospect.new
                prospect.organisation_name = row[1]
                prospect.contact_email = row[2]
                prospect.country = country
                prospect.lead_source = 'micro:bit suppliers list.'
                ac_manager = row[4]
                account_manager = 0
                if (ac_manager && ac_manager.start_with?('S'))
                    account_manager = simon
                else
                    account_manager = linda
                end
                prospect.account_manager_user_id = account_manager.id
                prospect.save
                email_sent_date = row[3]
                if (email_sent_date)
                    comm = Communication.new
                    comm.communication_date = email_sent_date
                    comm.incoming = false
                    comm.user_id = account_manager.id
                    comm.prospect_id = prospect.id
                    comm.notes = "Catalog Q4 2018 sent with introduction"
                    comm.save
                end
            end
        end
    end

end
