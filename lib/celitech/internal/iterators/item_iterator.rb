# frozen_string_literal: true

module Celitech
  module Internal
    class ItemIterator
      include Enumerable

      # The raw HTTP response from the most recent page response.
      # @return [Net::HTTPResponse, nil]
      def http_response
        @page_iterator&.http_response
      end

      # Iterates over each item returned by the API.
      #
      # @yield [item] Each retrieved item.
      # @return [NilClass]
      def each
        while (item = next_element)
          yield(item)
        end
      end

      # Whether another item will be available from the API.
      #
      # @return [Boolean]
      def next?
        load_next_page if @page.nil?
        return false if @page.nil?

        return true if any_items_in_cached_page?

        load_next_page
        any_items_in_cached_page?
      end

      # Retrieves the next item from the API.
      def next_element
        item = next_item_from_cached_page
        return item if item

        load_next_page
        next_item_from_cached_page
      end

      private

      def next_item_from_cached_page
        return unless @page

        resolve_field(@page, @item_field)&.shift
      end

      def any_items_in_cached_page?
        return false unless @page

        !resolve_field(@page, @item_field).to_a.empty?
      end

      def load_next_page
        @page = @page_iterator.next_page
      end

      # Resolves a field accessor (Symbol) or nested accessor path (Array<Symbol>) against a page.
      def resolve_field(page, field)
        return nil if page.nil? || field.nil?

        Array(field).reduce(page) { |value, accessor| value&.send(accessor) }
      end
    end
  end
end
