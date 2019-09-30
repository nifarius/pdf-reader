module PDF
  class Reader
    class Bookmark
      attr_reader :title, :children, :start_page
      attr_writer :end_page
      attr_accessor :next_bookmark

      def initialize(object)
        @children = []
        @title = object[:Title]
      end

      def parent=(bookmark)
        if bookmark
          @parent = bookmark
          if previous = bookmark.children.last
            previous.next_bookmark = self
          end
          @parent.children << self
        end
      end

      def level
        @parent ? @parent.level + 1 : 1
      end

      def find_page(object, objects)
        destination_object = objects.deref(object)
        if destination_object[:S] == :GoTo
          page_object = destination_object[:D].first
          @start_page = objects.page_references.index(page_object) + 1
        end
      end

      def end_page
        return @end_page if defined?(@end_page)

        if next_bookmark
          page_number = next_bookmark.start_page
          @end_page = start_page == page_number ? start_page : page_number - 1
        else
          @end_page = @parent.end_page
        end
      end

      def inspect
        "<PDF::Reader::Bookmark title: #{@title}>"
      end
    end
  end
end