module TweetPrices
  class Competitor
    attr_accessor :name, :price, :price_decimal

    def initialize(name, price)
      @name, @price = name, price
      @price_decimal = decimal_price
    end

    def decimal_price
      numerator, denominator = @price.split('/')
      if denominator
        (numerator.to_f / denominator.to_f) + 1
      else
        numerator.to_f + 1
      end
    end

  end
end