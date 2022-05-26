from gpiozero import Button
import time
import math
import bme680_sensor
import wind_direction_byo
import statistics
import ds18b20_therm
import database

wind_count = 0 # counts how many half-rotations
radius_cm = 9.0 # Radius of your anemoeter
wind_interval = 5 # How often (secs) to report speed
store_speeds = []
store_directions = []
rain_count = 0
gust = 0

#CM_IN_A_M = 160934.4
CM_IN_A_KM = 100000.0
SECS_IN_AN_HOUR = 3600
ADJUSTMENT = 1.18
interval = 50
BUCKET_SIZE = 0.2794
batch = bme680_sensor.readyweady()
ambient_temp, humidity, pressure = batch.split()
#ambient_temp, humidity, pressure = bme680_sensor.read_all()

def spin():
    global wind_count
    wind_count = wind_count + 1
    #print("spin" + str(wind_count))

def calculate_speed(time_sec):
        global wind_count
        global gust
        circumference_cm = (2 * math.pi) * radius_cm
        rotations = wind_count / 2.0

        dist_m = (circumference_cm * rotations) / CM_IN_A_KM

        km_per_sec = dist_m / time_sec
        km_per_hour = km_per_sec * SECS_IN_AN_HOUR

        final_speed = km_per_hour * ADJUSTMENT
        
        return final_speed
    
def reset_wind():
    global wind_count
    wind_count = 0

def reset_gust():
    global gust
    gust = 0

def bucket_tipped():
    global rain_count
    rain_count = rain_count + 1
    #print (rain_count * BUCKET_SIZE)

def reset_rainfall():
    global rain_count
    rain_count = 0

wind_speed_sensor = Button(5)
wind_speed_sensor.when_pressed = spin
temp_probe = ds18b20_therm.DS18B20()

rain_sensor = Button(6)
rain_sensor.when_pressed = bucket_tipped

db = database.weather_database()

while True:
    print("start loop1")
    start_time = time.time()
    while time.time() - start_time <= interval:
        print("start timed loop")
        wind_start_time = time.time()
        reset_wind()
        #time.sleep(wind_interval)
        while time.time() - wind_start_time <= wind_interval:
                #store_directions.append(wind_direction_byo.get_value())
            store_directions.append(0.4)
            
        final_speed = calculate_speed(wind_interval)
        store_speeds.append(final_speed)
    wind_average = wind_direction_byo.get_average(store_directions)

    wind_gust = max(store_speeds)
    wind_speed = statistics.mean(store_speeds)
    rainfall = rain_count * BUCKET_SIZE
    reset_rainfall()
    store_speeds = []
    store_directions= []
    print("read temps")
    ground_temp = temp_probe.read_temp()
    print("read bme680")
    #ambient_temp, humidity, pressure = bme680_sensor.read_all()
    batch = bme680_sensor.readyweady()
    ambient_temp, pressure, humidity = batch.split()

    db.insert(int(ambient_temp), ground_temp, 0, pressure, humidity, wind_average, wind_speed, wind_gust, rainfall)
    print()
    print('Wind direction: ' + str(wind_average) +' /', 'Wind speed: ' + str(wind_speed) + ' /',
          'Wind gust: ' + str(wind_gust) +' / ', 'Rainfall: ' + str(rainfall) +' /',
          'Humidity: ' + str(humidity) +' /', 'Pressure: ' + str(pressure) +' /',
          'Ambient temperature: ' + str(ambient_temp) +' / ', 'Ground Temperature: ' + str(ground_temp) +';') 
    print()
    


