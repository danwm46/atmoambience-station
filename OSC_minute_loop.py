from pythonosc import osc_message_builder
from pythonosc import udp_client
import time
import random
import sched
import datetime
from suntime import Sun, SunTimeException
import mysql.connector
from getpass import getpass

latitude = 39.95
longitude = -75.165

sun = Sun(latitude, longitude) # sets lat and long to location

sender = udp_client.SimpleUDPClient('127.0.0.1', 4560) # sets up sender for OSC signal
s = sched.scheduler(time.time, time.sleep)

def getusernamepword():
    uname=getpass("Enter username: ")
    pword=getpass("Enter password: ")
    pwpair = [uname, pword]
    return pwpair

unpwpair = getusernamepword()
uname = unpwpair[0]
pword = unpwpair[1]

random.seed()       # generates random seed for formulas

class RangeDict(dict):              #creates dict ranges for temps etc.
    def __getitem__(self, item):
        if not isinstance(item, range):
            for keys in self:
                if item in keys:
                    return self[keys]
            raise KeyError(item)
        else:
            return super().__getitem__(item)

key_check = RangeDict({range(1,-5) : 61, range(3) : 61, range(2,6) : 68,
                range(5,9) : 63, range(8,12) : 70, range(11,15) : 65,
                range(14,18) : 60, range(17,21) : 67, range(20,24) : 62,
                range(23,27) : 69, range(26,30) : 64, range(29,33) : 71,
                range(32,36) : 66, range(35,61) : 61, range(1,-5) : 61})

tempo_check = RangeDict({range(1,-5) : 20, range(3) : 20, range(2,6) : 28,
                range(5,9) : 36, range(8,12) : 44, range(11,15) : 52,
                range(14,18) : 60, range(17,21) : 68, range(20,24) : 76,
                range(23,27) : 84, range(26,30) : 92, range(29,33) : 100,
                range(32,36) : 108, range(35,61) : 116, range(1,-5) : 20})

reverb_check = RangeDict({range(1,-5) : 1, range(3) : 1, range(2,6) : 0.8,
                range(5,9) : 0.65, range(8,12) : 0.5, range(11,61) : 0.25})

flanger_check = RangeDict({range(-1,1) : 0, range(2) : 0.17, range(1,4) : 0.34,
                range(3,6) : 0.51, range(5,8) : 0.68, range(7,11) : 0.85,
                range(10,41) : 1})

tonality_check = RangeDict({range(994,1014) : '/minor', range(1013,1022) : '/major',
                  range(1021,1031) : '/pent'})

density_check = RangeDict({range(994,1005) : '/dense3', range(1004,1014) : '/dense2',
                 range(1013,1021) : '/dense1', range(1020,1041) : '/dense0'})

resonance_check = RangeDict({range(0,35) : 0, range(34,50) : 0.15, range(49,60) : 0.3,
                range(59,68) : 0.45, range(67,80) : 0.6, range(79,100) : 0.75})

synth_check = RangeDict({range(-5, 9) : '/synth_low', range(9, 24) : '/synth_mid',
                range(23, 51) : '/synth_hi'})

#main_pads = ['/copland', '/mincopland']
ornaments = ['/piano', '/brit', '/chirp', '/riff', '/melody', 'null'] #'/riff',
min_ornaments = ['/piano', '/brit', '/min_chirp', '/min_riff', '/melody', 'null']
#drums = ['/drum', '/drum2']
bass = ['/bass']
fx = ['/flanger', '/reverb']

def timed_loop(sc):
    print("set and check!")
    abd = datetime.date.today() #checks time
    abd_sr = sun.get_local_sunrise_time(abd) # sets sunrise time
    abd_ss = sun.get_local_sunset_time(abd) # sets sunset time
    now = datetime.datetime.now()
    if now.strftime('%H:%M') > abd_sr.strftime('%H:%M') and now.strftime('%H:%M') < abd_ss.strftime('%H:%M'):
        day = True
    else:
        day = False

    while True:
        try:
            mydb = mysql.connector.connect(
              host="192.168.0.130",
              user=uname,
              password=pword,
              database="weather"
            )
            break
        except mysql.connector.Error as e:
            continue

    print(mydb)

    print("start loop")
    print("checking!")
    mycursor = mydb.cursor ()
    mycursor.execute ('select AMBIENT_TEMPERATURE,GROUND_TEMPERATURE,AIR_QUALITY, AIR_PRESSURE, HUMIDITY, WIND_DIRECTION, WIND_SPEED, WIND_GUST_SPEED, RAINFALL, id from WEATHER_MEASUREMENT order by id desc limit 1')

    row = mycursor.fetchone ()
    print(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9])
    temp_ambient = row[0]
    temp_ground  = row[1]
    air_quality  = row[2]
    pressure     = row[3]
    humi_dity    = row[4]
    wind_dir     = row[5]
    wind_speed   = row[6]
    wind_gust    = row[7]
    rainfall     = row[8]
    ident        = row[9]
    print("BMP180 temperature (air board): %d", temp_ambient)
    print("soil probe DS18B20 external sensor: %d", temp_ground)
    print("air quality (volatile harmful gases): %d", air_quality)
    print("air pressure: %d", pressure)
    print("humidity: %d", humi_dity)
    print("wind directiona angle: %d", wind_dir)
    print("wind speed: %d", wind_speed)
    print("wind gust: %d", wind_gust)
    print("rainfall: %d", rainfall)
    print("id number: %d", ident)
    mycursor.close ()

    key = int(temp_ground)
    key2 = int(temp_ambient)
    key3 = int(temp_ground)
    seed = int(random.randint(0,2000))
    air_pr = int(pressure)
    rain = rainfall
    wind = int(wind_speed)
    humidity = int(humi_dity)
    if day == True:
        print("day!")
        print(now)
        print("key check!", key_check[key])
        print("Key2 check!", (key_check[key2]-12))
        print("tempo check!", tempo_check[key])
        cutoff = 131
        print("no cutoff!", cutoff)
    else:
        print("night!")
        print(now)
        print("key check!", (key_check[key]-12))
        print("Key2 check!", (key_check[key2]-24))
        print("tempo check!", int((tempo_check[key]*(0.66))))
        cutoff = 70
        print("cutoff!", cutoff)
    print("seed check!", seed)
    print("tempo check!", tempo_check[key])
    print("pressure check!", air_pr, tonality_check[air_pr])
    print("density check!", density_check[air_pr])
    print("rain check!", rain)
    print("wind check!", wind)
    print("humidity check!", humidity)
    print("synth check!", synth_check[key])
    print("pad check!")
    if air_pr > 1013:
        if air_pr > 1022:
            bass = random.choice([0,1])
            padB = 1
        else:
            bass = random.choice([0,1])
            padB = 1
    else:
        if air_pr < 1004:
            bass = random.choice([0,1])
            padB = 0
        else:
            bass = random.choice([0,1])
            padB = 1

    print (bass, padB)
    print("reverb?")
    print(reverb_check[key])
    print("flanger?")
    print(flanger_check[wind])
    print("resonance?")
    print(resonance_check[humidity])

    if day == True:
        sender.send_message('/key', [key_check[key]])
        sender.send_message('/key2', [(key_check[key2])-12])
        sender.send_message('/key3', [(key_check[key3])+12])
        sender.send_message('/tempo', tempo_check[key])
    else:
        sender.send_message('/key', [(key_check[key]-12)])
        sender.send_message('/key2', [(key_check[key2])-24])
        sender.send_message('/key3', [(key_check[key3])])
        sender.send_message('/tempo', int((tempo_check[key]*(0.66))))
    sender.send_message('/seed', [seed])
    sender.send_message('/tempo', tempo_check[key])
    sender.send_message(tonality_check[air_pr], 1)
    sender.send_message(density_check[air_pr], 1)
    sender.send_message(synth_check[key], 1)
    sender.send_message('/reverb', reverb_check[key])
    sender.send_message('/flanger', flanger_check[wind])
    sender.send_message('/resonance', resonance_check[humidity])
    sender.send_message('/cutoff', cutoff)
    time.sleep(2)

    print("pad A on!")
    sender.send_message('/padA', 1)
    if rain > 0:
        sender.send_message('/rain', 1)
    else:
        sender.send_message('/rain', 0)
    dubble = random.choice([0,1])
    print(dubble)
    if dubble == 1:
        sender.send_message('/bass', bass)
    time.sleep(20)

    print("extra start!")
    if air_pr > 1013:
        extra = random.choices(ornaments, weights=(16,16,16,16,21,15))
    else:
        extra = random.choices(min_ornaments, weights=(16,16,16,16,21,15))
    print(extra[0])
    sender.send_message(extra[0], 1)
    time.sleep(20)

    print("pad B on!")
    sender.send_message('/padB', padB)
    sender.send_message('/bass', bass)
    #time.sleep(15)
    if air_pr > 1013:
        time.sleep(5)
    else:
        time.sleep(10)


    print("finish 1!")
    sender.send_message('/padA', 0)
    if air_pr > 1013:
        if air_pr > 1022:
            time.sleep(35)
        else:
            time.sleep(30)
    else:
        if air_pr < 1004:
            time.sleep(20)
        else:
            time.sleep(25)

    print("finish 2!")
    sender.send_message('/padB', 0)
    sender.send_message('/bass', 0)
    if rain > 0:
        sender.send_message('/rain', 1)
    else:
        sender.send_message('/rain', 0)
    print("clear extra!")
    sender.send_message(extra[0], 0)
    if air_pr > 1013:
        if air_pr > 1022:
            s.enter(10, 1, timed_loop, (sc,))
        else:
            s.enter(6, 1, timed_loop, (sc,))
    else:
        if air_pr < 1004:
            s.enter(2, 1, timed_loop, (sc,))
        else:
            s.enter(4, 1, timed_loop, (sc,))

s.enterabs(90, 1, timed_loop, (s,))
s.run()
