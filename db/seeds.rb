# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Transaction.create!([
  { company_id: 0001, point_amount: 300, timestamp: "2020-10-31T10:00:00Z" },
  { company_id: 0002, point_amount: 200, timestamp: "2020-10-31T11:00:00Z" },
  { company_id: 0001, point_amount: -200, timestamp: "2020-10-31T15:00:00Z" },
  { company_id: 0003, point_amount: 10000, timestamp: "2020-11-01T14:00:00Z" },
  { company_id: 0001, point_amount: 1000, timestamp: "2020-11-02T14:00:00Z" },
])

Payer.create!([
  { name: "DANNON", company_id: 0001, point_total: 1100 },
  { name: "UNILEVER", company_id: 0002, point_total: 200 },
  { name: "MILLER COORS", company_id: 0003, point_total: 10,000 },
])
