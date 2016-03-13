# Coaching Scheduler Service

A RESTful coaching scheduler service that allows registration of clients and coaches and scheduling of appointments.

## Prerequisites
* Install [Git] (https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) (you're on Github!)
* Install [Node.js](https://nodejs.org/en/download/)
* Use npm to globally install gulp, bower, and coffee-script:
```
sudo npm install -g gulp bower coffee-script
```
* Install [Postgresql 9.4](http://www.postgresql.org/download/)
* Go through [Postgres First Steps](https://wiki.postgresql.org/wiki/First_steps) to create a postgres user
* Create the *scheduler* database in postgres:
```
create database scheduler;
```
* Optionally, install [Docker](https://docs.docker.com/engine/installation/)

## Installation
* Clone this repo
* Install Node modules:
```
cd scheduler_service
npm install
```
* Use your favorite editor to set your postgres settings in *database.json*
* Run postgres migrations:
```
gulp migrate
```
* Start the server:
```
node server.js
```

## Usage
The Coaching Scheduler Service is used entirely through a resource-based REST API. This service is intended to be run behind a firewall and connected to by web app backends.

### API

#### Appointment
```
GET /appointment
Codes: 200, 500
Returns: An array of appointment objects
```
```
GET /coach/:coach_id/appointment/date/:date
Codes: 200, 500
Returns: An array of appointment objects, filtered by coach and date
URL Parameters:
  - coach_id <UUID>
  - date <ms since epoch>
```
```
GET /client/:client_id/appointment
Codes: 200, 500
Returns: An appointment object
URL Parameters:
  - client_id <UUID>
```
```
GET /coach/:coach_id/appointment
Codes: 200, 500
Returns: An array of appointment objects, filtered by coach
URL Parameters:
  - coach_id <UUID>
```
```
POST /appointment
Codes: 201, 500
Returns: URL of the newly created appointment
Notes: If there is already an appointment for the given client_id, it will be overwritten
Body Parameters:
  - client_id <UUID>
  - coach_id <UUID>
  - appointment_date <ms since epoch>
```

#### Client
```
GET /client
Codes: 200, 500
Returns: An array of client objects
```
```
GET /client/:id
Codes: 200, 500
Returns: A client object
URL Parameters:
  - id <UUID>
```
```
GET /coach/:coach_id/client
Codes: 200, 500
Returns: An array of client objects, filtered by coach
URL Parameters:
  - coach_id <UUID>
```
```
POST /client
Codes: 201, 403, 500
Returns: URL of the newly created client
Notes: If a client with the given email already exists, it will not be overwritten and a 403 will be returned
Body Parameters:
  - google_id <Obtained from Google OAuth sub string>
  - name <string>
  - email <string>
  - avatar <URI>
```
```
POST /coach/:coach_id/client
Codes: 201, 500
Notes: Assigns a coach to a client (and vice versa)
URL Parameters:
  - coach_id <UUID>
Body Parameters:
  - client_id: <UUID>
```

#### Coach
```
GET /coach
Codes: 200, 500
Returns: An array of coach objects
```
```
GET /coach/:id
Codes: 200, 500
Returns: A coach object
URL Parameters:
  - id <UUID>
```
```
POST /coach
Codes: 201, 403, 500
Returns: URL of the newly created coach
Notes: If a coach with the given email already exists, it will not be overwritten and a 403 will be returned
Body Parameters:
  - google_id <Obtained from Google OAuth sub string>
  - name <string>
  - email <string>
  - phone <string>
  - avatar <URI>
```

### Docker (optional)
The Coaching Scheduler Service can optionally be launched in a Docker container. This repository includes a Dockerfile from which the Docker container can be built. Please ensure that you have installed Docker, then run the following commands (*sudo* may not be necessary, depending on your environment):
```
sudo docker build --tag=scheduler_service .
sudo docker run -p 9998:9998 --add-host="dockerhost:<Your IP Address>" -it scheduler_service
```
When finished, the container can be stopped like so:
* Find the container ID:
```
sudo docker ps
```
* Stop the container:
```
sudo docker stop -t 0 <container_id>
```
Note that postgres may require additional configuration to allow the Docker container to connect. Configuration of pg_hba.conf is beyond the scope of this guide.