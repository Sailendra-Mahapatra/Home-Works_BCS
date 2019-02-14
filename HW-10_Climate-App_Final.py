
# Step 2 - Climate App

    # Now that you have completed your initial analysis, design a Flask API based on the queries that you have just developed.

    # Use FLASK to create your routes.

import sqlalchemy
import datetime as dt
import numpy as np
import pandas as pd
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func
from flask import Flask, jsonify

    # database details

engine = create_engine("sqlite:///Resources/hawaii.sqlite")

    # reflect an existing database into a new model
Base = automap_base()

    # reflect the tables
Base.prepare(engine, reflect=True)

    # Save references to each table

Measurement = Base.classes.measurement
Station = Base.classes.station

    # Link to database

session = Session(engine)

    # Flask set up

app = Flask(__name__)


    # Routes

        #Home page


@app.route('/')
def avail_routes():
   return (
       f"Welcome"
        f"List of available routes<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/station<br/>"
        f"/api/v1.0/temperature observed (tobs)<br/>"
        f"/api/v1.0/Place start date in format (YYYY-MM-DD)<br/>"
        f"/api/v1.0/Place start date/end date in format (YYYY-MM-DD/YYYY-MM-DD)<br/>"

    )
    # Convert the query results to a Dictionary using `date` as the key and `prcp` as the value.
    # Return the JSON representation of your dictionary.

@app.route("/api/v1.0/precipitation") 
def precipitation():

    last_date = session.query(Measurement.date).order_by(Measurement.date.desc()).first()
        # print(last_date)

    last_year = dt.date(2017, 8, 23) - dt.timedelta(days=365)
        # print(last_year.strftime('%Y-%m-%d'))

    rain_fall = session.query(Measurement.date, Measurement.prcp).\
    filter(Measurement.date >= last_year).\
    order_by(Measurement.date).all()
    
    total_rain = []
    for result in rain_fall:
        row = {}
        row["date"] = result[0]
        row["prcp"] = result[1]
        total_rain.append(row)
    
    return jsonify(total_rain)


    
@app.route("/api/v1.0/station")
def station():
    
    stations = session.query(Station.station, Station.name).all()
    
    return jsonify(stations)

    # query for the dates and temperature observations from a year from the last data point.
    # Return a JSON list of Temperature Observations (tobs) for the previous year.

@app.route("/api/v1.0/temperature observed (tobs)")
def tobs():

    last_date = session.query(Measurement.date).order_by(Measurement.date.desc()).first()
    last_year = dt.date(2017, 8, 23) - dt.timedelta(days=365)
    temperature = session.query(Measurement.date, Measurement.tobs).filter(Measurement.date > last_year).\
        order_by(Measurement.date).all()

    temp_obs = []
    for result in temperature:
        row = {}
        row["date"] = result.date
        row["tobs"] = result.tobs
        temp_obs.append(row)

    return jsonify(temp_obs)




# `/api/v1.0/<start>` and `/api/v1.0/<start>/<end>`

# Return a JSON list of the minimum temperature, the average temperature, and the max temperature 
# for a given start or start-end range.

@app.route("/api/v1.0/<start>")
def trip_first(start):

    start_date= dt.datetime.strptime(start, '%Y-%m-%d')
    last_year = dt.timedelta(days=365)
    start = start_date-last_year
    end =  dt.date(2017, 8, 23)
    
    trip_data = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
        filter(Measurement.date >= start).filter(Measurement.date <= end).all()
    
    trip_start = list(np.ravel(trip_data))
    
    return jsonify(trip_start)


@app.route("/api/v1.0/<start>/<end>")
def trip_range(start,end):

    
    trip_data = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
        filter(Measurement.date >= start).filter(Measurement.date <= end).all()
    
    trip_start = list(np.ravel(trip_data))
    
    return jsonify(trip_start)
# 

# When given the start only, calculate `TMIN`, `TAVG`, and `TMAX` for all dates greater than and equal to the start date.

# When given the start and the end date, calculate the `TMIN`, `TAVG`, and `TMAX` for dates between the start and end date inclusive.
    
    
if __name__ == "__main__":
     app.run()

## Hints

# You will need to join the station and measurement tables for some of the analysis queries.

# Use Flask `jsonify` to convert your API data into a valid JSON response object.

