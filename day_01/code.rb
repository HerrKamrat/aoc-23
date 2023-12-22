input = File.open(ARGV[0])

NUMBERS = %w[_ one two three four five six seven eight nine]

r = input.map do |line|
  line.strip
end.map do |line|
  (0..(line.length)).map do |i|
    ch = line[i]
    NUMBERS.find_index do |z|
      z == line[i..(i+z.length-1)]
    end || ch
  end.compact.join
end.map do |line|
  line.scan(/[[:digit:]]/)
end.map do |digits|
  digits.first + digits.last
end.map do |digit|
  digit.to_i
end.reduce(:+)

puts "#{r}"
