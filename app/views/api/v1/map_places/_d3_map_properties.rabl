attributes :city, :state

node(:name) { |mp| mp.title }
node(:description) { |mp| mp.link_summary }
node(:price) { |mp| "$#{mp.price}" }
node(:year) { |mp| mp.ww_year }
node(:park_type) { |mp| mp.category_name }
node(:date) { |mp| mp.arrived.strftime('%b %-d %Y') }
node(:date_i) { |mp| mp.arrived.strftime('%m-%-d') }

# "name": "82 Smugglers View Rd",
# "description": "<a href=\"http://www.watsonswander.com/2012/day-1-goodbye-house-goodbye-jeffersonville/\" title=\"Permalink to Day 1- Goodbye House, Goodbye Jeffersonville\" rel=\"bookmark\" target=\"_blank\">Day 1- Goodbye House, Goodbye Jeffersonville</a>&nbsp;<div></div><div></div>",
# "city": "Cambridge",
# "state": "Vermont",
# "date": "-",
# "date_i": "-",
# "park_type": "Private Residence",
# "price": "$0",
# "year": 0
