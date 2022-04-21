# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(username: "root", password: "1234")
User.create(username: "dummy", password: "2345")
User.create(username: "debug", password: "3456")

StaffFavourite.create(user_id: 1, staff_id: 41208, notes: "seeded entry #1", keywords: "seed #2")
StaffFavourite.create(user_id: 1, staff_id: 40595, notes: "seeded entry #2", keywords: "seed #2")
StaffFavourite.create(user_id: 1, staff_id: 41610, notes: "seeded entry #3", keywords: "seed #3")

StaffFavourite.create(user_id: 2, staff_id: 40954, notes: "seeded entry", keywords: "seed")
StaffFavourite.create(user_id: 3, staff_id: 166114, notes: "seeded entry", keywords: "seed")

CourseFavourite.create(user_id: 1, course_number: 188081, dsw_id: 7728, dsr_id: 814, semester: "2021W", notes: "seed entry", keywords: "seed")
CourseFavourite.create(user_id: 2, course_number: 194104, dsw_id: 7728, dsr_id: 513, semester: "2022S", notes: "seed entry", keywords: "seed")
CourseFavourite.create(user_id: 3, course_number: 188981, dsw_id: 7728, dsr_id: 881, semester: "2022S", notes: "seed entry", keywords: "seed")

ProjectFavourite.create(user_id: 1, project_id: 5874, notes: "seed entry", keywords: "seed")
ProjectFavourite.create(user_id: 2, project_id: 1708928, notes: "seed entry", keywords: "seed")
ProjectFavourite.create(user_id: 3, project_id: 1641749, notes: "seed entry", keywords: "seed")

ThesisFavourite.create(user_id: 1, thesis_id: 63221, dsw_id: 2791, dsr_id: 7, notes: "seed entry", keywords: "seed")
ThesisFavourite.create(user_id: 2, thesis_id: 63220, dsw_id: 2791, dsr_id: 30, notes: "seed entry", keywords: "seed")
ThesisFavourite.create(user_id: 3, thesis_id: 63222, dsw_id: 2791, dsr_id: 411, notes: "seed entry", keywords: "seed")
