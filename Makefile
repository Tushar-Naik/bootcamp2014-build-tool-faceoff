
default: per_person_charges per_team_charges

person_bags.data.tmp: person_bags
	tail -n +2 person_bags | sed -e 's/ \+/ /g' > person_bags.data.tmp

bag_person.data.tmp: person_bags.data.tmp
	cat person_bags.data.tmp | awk '{print $$2" "$$1}' | sort > bag_person.data.tmp

bag_team.data.tmp: person_bags.data.tmp
	cat person_bags.data.tmp | awk '{print $$2" "$$3}' | sort > bag_team.data.tmp

baggage_charges.data.tmp: baggage_charges
	tail -n +2 baggage_charges > baggage_charges.data.tmp

per_person_charges.data.tmp: bag_person.data.tmp baggage_charges.data.tmp
	join -j 1 bag_person.data.tmp baggage_charges.data.tmp | awk '{print $$2" "$$3}' > per_person_charges.data.tmp

per_team_charges.data.tmp: bag_team.data.tmp baggage_charges.data.tmp
	join -j 1 bag_team.data.tmp baggage_charges.data.tmp | awk '{print $$2" "$$3}' | sort | awk '{ if ($$1 == last) { sum += $$2 } else { print last" "sum; sum = 0; last = $$1; }} END {print last" "sum }' | grep '[^ ]\+' > per_team_charges.data.tmp

clean:
	rm *.tmp

per_person_charges: per_person_charges.data.tmp
	echo "Per person changes are..."
	cat per_person_charges.data.tmp
	echo

per_team_charges: per_team_charges.data.tmp
	echo "Per team charges are..."
	cat per_team_charges.data.tmp

.PHONY: clean default per_person_charges per_team_charges
