from tkinter import *

import datetime
import platform
import time
import mysql.connector
from getpass import getpass

degree_sign= u'\N{DEGREE SIGN}'



root=Tk()
#root.overrideredirect(True) # turns off title bar, geometry
root.geometry('400x100+200+200') # set new geometry

w = 420 # width for the Tk root
h = 210 # height for the Tk root

# get screen width and height
ws = root.winfo_screenwidth() # width of the screen
hs = root.winfo_screenheight() # height of the screen

# calculate x and y coordinates for the Tk root window
x = (ws) - (w)
y = (hs) - (h)

root.geometry('%dx%d+%d+%d' % (w, h, x, y))

# make a frame for the title bar
title_bar = Frame(root, bg='black', relief='raised', bd=0,highlightthickness=4, highlightbackground="black")

# put a close button on the title bar
close_button = Button(title_bar, text='X', command=root.destroy,bg="black",padx=2,pady=2,activebackground='red',bd=0,font="bold",fg='black',highlightthickness=0)

# a canvas for the main area of the window
window = Canvas(root, bg='black', bd=2, highlightthickness=0)

#  #2e2e2e

# pack the widgets
title_bar.pack(expand=1, fill=X)
close_button.pack(side=RIGHT)
window.pack(expand=1, fill=BOTH)

xwin=None
ywin=None

# bind title bar motion to the move window function

def move_window(event):
    root.geometry('+{0}+{1}'.format(event.x_root, event.y_root))
def change_on_hovering(event):
    global close_button
    close_button['bg']='red'
def return_to_normalstate(event):
    global close_button
    close_button['bg']='black'

time_label = Label(font = ('VCR OSD Mono', 32), foreground = 'white', background = 'black')
#time_label.pack(anchor='se')
date_label = Label(font = ('VCR OSD Mono', 32), foreground = 'white', background = 'black')
#date_label.pack(anchor='se')
weather_label = Label(font = ('VCR OSD Mono', 22), foreground = 'white', background = 'black')
#weather_label.pack(anchor='se')

time_label_window = window.create_window(200,0, anchor=NW, window=time_label)
date_label_window = window.create_window(75, 60, anchor=NW, window=date_label)
weather_label_window = window.create_window(0, 120, anchor=NW, window=weather_label)



def getusernamepword():
    uname=getpass("Enter username: ")
    pword=getpass("Enter password: ")
    pwpair = [uname, pword]
    return pwpair

unpwpair = getusernamepword()
uname = unpwpair[0]
pword = unpwpair[1]

def clock():
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

    print("update clock!")
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

    mycursor.close ()


    date_time = datetime.datetime.now().strftime("%b-%d-%Y %H:%M:%S/%p")
    date,time1 = date_time.split()
    month,day,year = date.split('-')
    time2,time3 = time1.split('/')
    hour,minutes,seconds =  time2.split(':')
    if int(hour) > 12 and int(hour) < 24:
            time = time3 + ' ' + str(int(hour) - 12) + ':' + minutes
    else:
            time = time3 + ' ' + hour + ':' + minutes
    time_label.config(text = time)
    date_label.config(text= month + '. ' + day + ' ' + year)

    temp_f = (temp_ambient * 9/5) + 32
    weather = '{0:}°F, {1:}hPa, {2:}%RH'.format(
           int(temp_f),
           int(pressure),
           int(humi_dity))

    ambient_temp, humidity, pressure = weather.split()

    weather_label.config(text = weather)
    time_label.after(10000, clock)

clock()

title_bar.bind('<B1-Motion>', move_window)
close_button.bind('<Enter>',change_on_hovering)
close_button.bind('<Leave>',return_to_normalstate)
clock()
root.mainloop()
