input = File.open(ARGV[0])
output = File.open("./example_output.txt").each.reduce(:+).to_i


def count(conditions, data)
  return 1 if conditions.count <= 0 && (!data || !data.any?{|d| d[:required]})
  return 0 if conditions.count <= 0
  return 0 unless data && data.count > 0

  curr = conditions.first
  rest = conditions[1..]

  required = false

  data.map.with_index do |d, i|
    #puts "#{i} = #{d[:c]} >= #{curr} ?? #{d[:c] >= curr}- #{i + curr} #{data[i + curr] && data[i + curr][:required]}"

    if required
      0
    elsif d[:c] >= curr
      if data[i + curr] && data[i + curr][:required]
        required = d[:required]
        0
      else
        required = d[:required]
        count(rest, data[(i + curr + 1)..])
      end
    else
      0
    end
  end.sum
end

r = input.map do |line|
  line.strip
end.map do |line|
  row, conditions = line.split(/\s+/)
  conditions = conditions.split(",").map(&:to_i)
  {row: row, conditions: conditions}
end.map do |record|
  row = record[:row]
  data = row.split("").map.with_index do |ch, i|
    c = if ch == "." || (i > 0 && row[i - 1] == "#")
      0
    else
      row[i..row.length].match(/([#?]+)/)[0].length
    end
    {c: c, required: ch == "#"}
  end
  record[:data] = data
  #puts record
  record
end.map do |record|

  conditions = record[:conditions]
  data = record[:data]

  p = count(conditions, data)
  record[:arrangements] = p
  record
end
# r.each do |r|
#   puts "#{r[:row]} - #{r[:conditions]} - #{r[:arrangements]}"
#   #puts r[:data].join("")#.gsub("0"," ")
# end
puts r.map{|r| r[:arrangements]}.sum
#puts "#{r} (#{output})"
puts r == output

# puts "1".match(/\d.\d/)