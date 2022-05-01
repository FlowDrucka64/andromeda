# Andromeda README

<!--- This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ... --->

# Student Data

Names: Michael Winkler, Florian Drucker

Student Numbers: 11809940, 11808253

Program Numbers: UE 033 534, UE 033 534

Project Name: andromeda

# Project Details

Ruby Version: 3.0.3

Rails Version: 7.0.1


# Setup

## Setup Database

```sh
rake db:migrate
```

## Enable Caching

Toggle api result caching in dev environment:
```sh
rails dev:cache
```

# Other

## Reset DB to seeded values
```sh
rake db:reset
```


# Architecture
For the main functionallities

                                         application_controller
                                                  |
                                             base_controller
                                         /     |       |        \
                                staff_c.   thesis_c.  project_c.  course_c.

For Session and User management

                                            application_c.
                                             /         \
                                       session c.     user_c.
# TISS API doc

https://tiss.tuwien.ac.at/api/dokumentation



# Timetables

## Florian Drucker

|  Date  |                                                   Description                                                   | Amount |
|:------:|:---------------------------------------------------------------------------------------------------------------:|:------:|
| 09.04. |                                  initial model,view and db setup (with seeds)                                   |  1:45  |
| 09.04. |        user registration, session management, simple user homepage, flash display in application layout         |  1:50  |
| 10.04. | search controller (parent) and children (staff, course, project, thesis) <br/>partials for all searches/results |  3:24  |
| 11.04  |                                            alignment with colleague                                             |  1:00  |
| 20.04  |                                     Staff search (api pull + result pages)                                      |  3:10  |
| 21.04  |                                            Caching of api responses                                             |  1:10  |
| 21.04  |                                         Staff favourite fetch + render                                          |  2:27  |
| 21.04  |                                   Staff favourite cleanup / Add, edit, delete                                   |  2:42  |
| 30.04  |                                             Documentation, cleanup                                              |  1:41  |
|        |                                                       SUM                                                       | 19:05  |
## Michael Winkler

|    Date     |                                       Task                                        | Amount |
|:-----------:|:---------------------------------------------------------------------------------:|:------:|
| 31.03.2022  |   Setup Ruby on Rails on Windows 10 WSL - https://gorails.com/setup/windows/10    |   1h   |
| 02.04.2022  | Work through Rails tutorial - https://guides.rubyonrails.org/getting_started.html |   2h   |
| 04.04.2022  |                               Stylesheet - Research                               |   1h   |
| 06.04.2022  |                         Stylesheet - First basic version                          |  1.5h  |
| 11.04.2022  |                             Alignment with Colleague                              |   1h   |
| 11.04.2022  |                             Stylesheet - Improvement                              |   2h   |
| 21.04.2022  |                             Alignment with Colleague                              |   1h   |
| 21.04.2022  |                          Detail View for search results                           |  2.5h  |
| 22.04.2022  |                             Alignment with Colleague                              |  0.5h  |
| 22.04.2022  |                      Adopt Detail View to support Favorites                       |  1.5h  |
| 01.05.2022  |           Alignment, Clean up for intermediate hand in, Styling changes           |   1h   |
|             |                                        SUM                                        |  15h   |
