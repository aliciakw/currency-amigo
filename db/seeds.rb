# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Rule.create(base_currency: "usd", quote_currency: "eur", multiplier: 0.921, comparison_operator: "<", user_id: User.first.id)
Rule.create(base_currency: "usd", quote_currency: "eur", multiplier: 0.921, comparison_operator: ">", user_id: User.last.id)