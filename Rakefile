task :default => [:per_person_charges, :per_team_charges]

file 'person_bags.data.tmp' => 'person_bags' do
  sh "tail -n +2 person_bags | sed -e 's/ \+/ /g' > person_bags.data.tmp"
end

file 'bag_person.data.tmp' => 'person_bags.data.tmp' do
  sh "cat person_bags.data.tmp | awk '{print $2\" \"$1}' | sort > bag_person.data.tmp"
end

file 'bag_team.data.tmp' => 'person_bags.data.tmp' do
  sh "cat person_bags.data.tmp | awk '{print $2\" \"$3}' | sort > bag_team.data.tmp"
end

file 'baggage_charges.data.tmp' => 'baggage_charges' do
  sh "tail -n +2 baggage_charges > baggage_charges.data.tmp"
end

file 'per_person_charges.data.tmp' => ['bag_person.data.tmp', 'baggage_charges.data.tmp'] do
  sh "join -j 1 bag_person.data.tmp baggage_charges.data.tmp | awk '{print $2\" \"$3}' > per_person_charges.data.tmp"
end

file 'per_team_charges.data.tmp' => ['bag_team.data.tmp', 'baggage_charges.data.tmp'] do
  sh "join -j 1 bag_team.data.tmp baggage_charges.data.tmp | awk '{print $2\" \"$3}' | sort | awk '{ if ($1 == last) { sum += $2 } else { if (last) { print last\" \"sum }; sum = 0; last = $1; }} END {print last\" \"sum }' > per_team_charges.data.tmp"
end

task :clean do
  rm Dir.glob('*.tmp')
end

task :per_person_charges => 'per_person_charges.data.tmp' do
  puts "Per person changes are..."
  File.open('per_person_charges.data.tmp').each do |l|
    puts l
  end
  puts ""
end

task :per_team_charges => 'per_team_charges.data.tmp' do
  puts "Per team changes are..."
  File.open('per_team_charges.data.tmp').each do |l|
    puts l
  end
  puts ""
end
