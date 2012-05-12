module PDF
  class Reader
    class Bookmark
      attr_reader :title, :children, :page_number

      def initialize(object)
        @children = []
        @title = object[:Title]
      end

      def parent=(bookmark)
        if bookmark
          @parent = bookmark
          @parent.children << self
        end
      end

      def level
        parent ? parent.level + 1 : 1
      end

      def find_page(object, objects)
        destination_object = objects.deref(object)
        if destination_object[:S] == :GoTo
          page_object = destination_object[:D].first
          @page_number = objects.page_references.index(page_object) + 1
        end
      end

      def inspect
        "<PDF::Reader::Bookmark title: #{@title}>"
      end
    end
  end
end