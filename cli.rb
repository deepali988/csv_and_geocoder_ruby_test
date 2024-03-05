require 'csv'

if ARGV.empty?
  input_file = 'clients.csv'
else
  input_file = ARGV[0]
end

unless File.exist?(input_file)
  puts "Error: File #{input_file} not found."
  exit(1)
end

rows = CSV.read(input_file, headers: true)

valid_rows = rows.select do |row|
  valid_email = !row['Email'].to_s.empty?
  valid_name = !row['First Name'].to_s.empty? && !row['Last Name'].to_s.empty?
  valid_residential_address = !row['Residential Address Street'].to_s.empty? &&
                               !row['Residential Address Locality'].to_s.empty? &&
                               !row['Residential Address State'].to_s.empty? &&
                               !row['Residential Address Postcode'].to_s.empty?

  valid_postal_address = !row['Postal Address Street'].to_s.empty? &&
                         !row['Postal Address Locality'].to_s.empty? &&
                         !row['Postal Address State'].to_s.empty? &&
                         !row['Postal Address Postcode'].to_s.empty?

  valid_location_postcode = valid_residential_address || valid_postal_address

  valid_email && valid_name && valid_location_postcode &&
    row.fields.all? { |value| !value.to_s.empty? }
end

output_file = 'output.csv'

CSV.open(output_file, 'w', write_headers: true, headers: rows.headers + ['Latitude', 'Longitude']) do |csv|
  valid_rows.each do |row|
    address = "#{row['Residential Address Street']}, #{row['Residential Address Locality']}, #{row['Residential Address State']} #{row['Residential Address Postcode']}"
    latitude = 0.0
    longitude = 0.0

    csv << row.fields + [latitude, longitude]
  end
end

puts "Output written to #{output_file}"
