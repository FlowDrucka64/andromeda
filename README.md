# README

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

# TODOS

Staff
--------------

1. Show more Details for favourites
2. ~~Add favourite~~
3. ~~Remove favourite~~
4. ~~Edit favourite~~
5. ~~Caching of single staff~~
6. "Input validation" i.e. empty search results
7. Edit favourite form could be done in "base_controller" (abstraction)
8. Strong typing

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

## Reset DB
```sh
rake db:reset
```


# Architecture

TODO


# TISS API doc

https://tiss.tuwien.ac.at/api/dokumentation



# Timetables

## Florian Drucker

|  Date  |                                                   Description                                                   | From  |  To   |
|:------:|:---------------------------------------------------------------------------------------------------------------:|:-----:|:-----:|
| 09.04. |                                  initial model,view and db setup (with seeds)                                   | 12:15 | 14:00 |
| 09.04. |        user registration, session management, simple user homepage, flash display in application layout         | 14:35 | 16:25 |
| 10.04. | search controller (parent) and children (staff, course, project, thesis) <br/>partials for all searches/results | 14:06 | 17:30 |
| 11.04  |                                            alignment with colleague                                             | 16:15 | 17:15 |
| 20.04  |                                     Staff search (api pull + result pages)                                      | 17:21 | 20:32 |
| 21.04  |                                            Caching of api responses                                             | 11:03 | 12:15 |
| 21.04  |                                         Staff favourite fetch + render                                          | 15:10 | 17:37 |
| 21.04  |                                   Staff favourite cleanup / Add, edit, delete                                   | 13:26 | 16:06 |

## Michael Winkler

|    Date    |                                       Task                                        | Amount |
|:----------:|:---------------------------------------------------------------------------------:|:------:|
| 31.03.2022 |   Setup Ruby on Rails on Windows 10 WSL - https://gorails.com/setup/windows/10    |   1h   |
| 02.04.2022 | Work through Rails tutorial - https://guides.rubyonrails.org/getting_started.html |   2h   |
| 04.04.2022 |                               Stylesheet - Research                               |   1h   |
| 06.04.2022 |                         Stylesheet - First basic version                          |  1.5h  |
| 11.04.2022 |                             Alignment with Colleague                              |   1h   |
| 11.04.2022 |                             Stylesheet - Improvement                              |   2h   |
| 21.04.2022 |                             Alignment with Colleague                              |   1h   |
| 21.04.2022 |                          Detail View for search results                           |  2.5h  |
| 22.04.2022 |                             Alignment with Colleague                              |  0.5h  |
| 22.04.2022 |                                         x                                         |  1.5h  |
|            |                                        SUM                                        |  14h   |
