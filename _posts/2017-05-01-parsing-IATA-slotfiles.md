---
layout: post
title: Parsing IATA slotfiles
location: Amsterdam
tags:
  - Python
author: Rok Mihevc
---

TL;DR - Working at Amsterdam Airport I participated in couple of projects that required parsing of slotfiles. This resulted in me wrting a parser for a very old file format. I've published the parser on pypi \o/. [Check it out on pypi](https://pypi.python.org/pypi/ssim/).

# About slotfiles

Slotfiles are the good old flight industry standard for passing slot information. A slot gives an airline the right to realize a flight (or series of) with a specified plane from one airport to another. Typical slotfile might look like this:
```
SIR
/
S17
31MAR
AMS
HHV241 01APR07JUL 0200000 18973H RMFRMF0000 C2
```

The first five rows give metadata about the file.
In this case it is a Schedule Information Request (SIR), meaning it was issued by slot authorithy to another party. This slotfile describes flights of summer season of 2017 (S17), it was generated on March 31st (31MAR) and it describes flights coming or going from Amsterdam airport (AMS). The last row of this slotfile contains a single slot.

```
HHV241 01APR07JUL 0200000 18973H RMFRMF0000 C2
```
Reading the slot would go like this:
```
H - Clearance code (H = Holding)
HV241 - Flight number
01APR07JUL - Period of operation (from 1st April to 7th July 2017)
0200000 - Days of operation (0 flight does not operate, 
          1-7 flight operates on given weekday, e.g. 2 stands for Tuesday)
189 - Number of seats on the aircraft
73H - Aircraft code
RMF - Next station
RMF - Final destination
0000 - Time of flight (UTC)
C - Service type (C is chartered passenger flight)
2 - Frequency rate (2 means every two weeks)
```

The reason the format is so condensed probably has to do with the fact [it was invented in the 20s](https://en.wikipedia.org/wiki/Airline_teletype_system) and was designed to send slots via [teletypewriters](https://en.wikipedia.org/wiki/Teletype_Corporation).
Even though it is a de-facto standard of the industry there is no open source implementation of it.

# Experience with slotfiles

Since predicting future passenger flows is of great interest for Schiphol Airport and future schedules are passed around as slotfiles I needed to parse various slotfiles a couple of times. Original approach was using Pandas and Python's regex. It was fun, sometimes painful and always a bit uncertain. Things worked for the summer season, but will they for the winter season? The original design had room for improvement and there were no tests! Using it was never really pleasant and more features were required. I kind of solved my problem, but my colleagues and the rest of the industry still had it. As we continued working on other projects I had no time and gave up on the original effort.

Discussing with colleagues from another department gave motivation to take all the examples of slotfiles I could find online and write a well tested, reliable, open source parser. The process proved realatively straightforward and I released a new parser under [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html) on [pypi.python.org/pypi/ssim/](https://pypi.python.org/pypi/ssim/) and [github](https://github.com/rok/ssim).

After initially publishing the parser I recieved great help from colleagues (thanks Ramon and Kevin) to find and remove quite some bugs. Some features they requested were added, Ramon proposed an approach that gave a considerable performance increase. At the moment three colleagues at Schiphol are using it in their daily work. There is a plan in the works to re-release the parser under Schiphol's banner to better promote it in the industry. 

# About tests

Parsing and expanding of slots needs to return reliable results and lots of attention was given to good test coverage.
The parser comes with sample slotfiles from various slot authorities and flights we expect to get from slotfiles after parsing and expanding.
More tests can be added to ensure reliability and thurstworthiness of the parser.
New variants of slotfiles can also be added if requested.

# Try it out!

If you are working with slotfiles yourself you can try using the parser by pip installing it (of course you first need a working Python environment):

```
pip install ssim
```

To use it in code you can run:
```
slots, header, footer = ssim.read('slotfile.SIR')
flights = ssim.expand(slots, header)
```

To continue analysis I would recommend Pandas:
```
df = pd.DataFrame(flights)
```

Or if you prefer command line:
```
ssim -i slotfile_example.SCR -o flights.csv
```

Typical performance for a large slotfile would be: reading the slotfile takes about one second and expanding slots into flights takes about four seconds. 

If you are missing features or found bugs please get in touch via [github](https://github.com/rok/ssim/issues) or submit a pull request. Any help / feedback is welcome!