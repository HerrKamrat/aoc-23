input = File.open(ARGV[0])

INF = 1.0/0.0
SPACING = 1000000

# Find coords for galaxies
galaxies = input.map do |line|
  line.strip
end.flat_map.with_index do |line, y|
  line.split("").map.with_index do |ch, x|
    {x: x, y: y, d: INF} if ch != "."
  end
end.compact

# Find spaces between galaxies
empty_cols = (0..galaxies.map{|g|g[:x]}.max).select{|x| !galaxies.any?{|g| g[:x] == x}}
empty_rows = (0..galaxies.map{|g|g[:y]}.max).select{|y| !galaxies.any?{|g| g[:y] == y}}

# Adjust coords with space
galaxies.each do |g|
  g[:x] += (empty_cols.select{|r| r < g[:x]}.count * (SPACING - 1))
  g[:y] += (empty_rows.select{|r| r < g[:y]}.count * (SPACING - 1))
end

# Sum distances
r = galaxies.flat_map.with_index do |g0, i0|
  galaxies[(i0+1)..].map.with_index do |g1, i1|
    (g1[:x] - g0[:x]).abs + (g1[:y] - g0[:y]).abs
  end
end.sum

puts "#{r}"
