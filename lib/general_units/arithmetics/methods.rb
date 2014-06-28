module GeneralUnits
  
  module Arithmetics
    def self.two_factors_of(number)
      if (number = number.to_i) && (number > 1)
        primes, powers = number.prime_division.transpose
        exponents = powers.map {|i| (0..i).to_a}
        divisors = exponents.shift.product(*exponents).map do |powers|
          primes.zip(powers).map {|prime, power| prime ** power}.inject(:*)
        end
        divisors.sort.map {|div| [div, number/div]}
      else
        []
      end
    end

    def self.three_factors_of(number)
      export = []
      two_factors_of(number).each do |factors|
        two_factors_of(factors[1]).each do |next_factors|
          export << [factors[0]] + next_factors
        end
      end
      export
    end
  end
  
end