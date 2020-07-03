# frozen_string_literal: true

require 'peddler/client'

module MWS
  module FulfillmentInventory
    # The Fulfillment Inventory API can help you stay up-to-date on the
    # availability of your inventory in the Amazon Fulfillment Network. The
    # Fulfillment Inventory API reports real-time availability information for
    # your Amazon Fulfillment Network inventory regardless of whether you are
    # selling your inventory on Amazon's retail web site or through other retail
    # channels.
    class Client < ::Peddler::Client
      self.version = '2010-10-01'
      self.path = "/FulfillmentInventory/#{version}"

      # Returns information about the availability of a seller's inventory
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inventory/FBAInventory_ListInventorySupply.html
      # @param [Hash] opts
      # @option opts [Array<String>, String] :seller_skus
      # @option opts [String, #iso8601] :query_start_date_time
      # @option opts [String] :response_group
      # @option opts [String] :marketplace_id
      # @return [Peddler::XMLParser]
      def list_inventory_supply(opts = {})
        operation('ListInventorySupply')
          .add(opts)
          .structure!('SellerSkus', 'member')

        run
      end

      # Returns the next page of information about the availability of a
      # seller's inventory
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inventory/FBAInventory_ListInventorySupplyByNextToken.html
      # @param [String] next_token
      # @return [Peddler::XMLParser]
      def list_inventory_supply_by_next_token(next_token)
        operation('ListInventorySupplyByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Gets the operational status of the API
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inventory/MWS_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end
    end
  end
end
