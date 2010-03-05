module InternetRadio
  module BBCiPlayer
    class Brand
      attr_reader :name, :id

      alias_method :to_s, :name

      def initialize(name, id)
        @name = name
        @id = id
      end

      def hash
        (@name.hash.to_s + @id.hash.to_s).to_i
      end

      def <=>(brand)
        if @name > brand.name
          1
        elsif @name == brand
          0
        else
          -1
        end
      end
    end
  end
end
