---
layout: post
title: Parsing IATA slotfiles
location: Amsterdam
tags:
  - Python
author: Rok Mihevc
---

TL;DR - Working at Amsterdam Airport I participated in couple of projects that required parsing of slotfiles. This resulted in me wrting a parser for a very old file format. I've published the parser on pypi \o/.

# About slotfiles

Slotfiles are a good old flight industry standard for passing slot information. A slot is the right to realize a flight (or series of) with a specified plane from an airport to another. Typical slotfile might look like this:
```
SIR
/
S17
31MAR
AMS
HHV241 01APR07JUL 0200000 18973H RMFRMF0000 C2
```

The first five rows give metadata about the file.
In this case it is a Slot / Schedule Information request (SIR), it describes flights of summer season of 2017 (S17), it was generated on March 31st (31MAR) and it describes flights coming or going from Amsterdam airport (AMS). The last row describes a single slot.

```
HHV241 01APR07JUL 0200000 18973H RMFRMF0000 C2
```
Reading it would go like this:
```
H - Clearance code (H = Holding)
HV241 - Flight number
01APR07JUL - Period of operation (from 1st April to 7th July 2017)
0200000 - Days of operation (0 flight does not operate, 
          1-7 flight operates on given weekday, e.g. 2 stands for Tuesday)
189 - Number of sears on the aircraft
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

As predicting future passenger flows is of great interest for Schiphol Airport and since future schedules are passed around as slotfiles I was at some point parsing them. Original approach was using Pandas and Python's regex. It was fun, sometimes painful and always a bit uncertain. Things worked for summer season, but will they for the winter? The original design had room for improvement and there were no tests! Using it was never really pleasant and more features were required. I kind of solved only my problem, but my colleagues and the rest of the industry still had it. As we continued working on other projects I gave up on the original effort.

Discussing with colleagues from another department gave motivation to take all the examples of slotfiles I could find online and write a well tested, reliable, open source parser. The process proved realatively straightforward and now it is released under [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html) on [pypi.python.org/pypi/ssim/](https://pypi.python.org/pypi/ssim/) and [github](https://github.com/rok/ssim).

After it was published I recieved great help from colleagues (thanks Ramon and Kevin) to find and remove quite some bugs. Some features they requested were added, Ramon proposed an approach that gave a considerable performance increase. At the moment three colleagues at Schiphol are using it in their daily work and there is a plan in the works to re-release it under Schiphol's banner to better promote it in the industry. 

# About tests

Parsing and expanding of slots needs to return reliable results and lots of attention was given to good test coverage.
The parser comes with sample slotfiles from various slot authorities and flights we expect to get from them after parsing and expanding.
More tests can be added as bugs become known or new variants of slotfiles are added to ensure reliability and thurstworthiness of the parser.

# Try it out!

If you are working with slotfiles yourself you can try using the parser by pip installing it (of course you first need a working Python environment):

```
pip install ssim
```

To then use it in code you can run:
```
slots, header, footer = ssim.read('slotfile.SIR')
flights = ssim.expand(slots, header)
```

To continue analysis I would recommend Pandas:
```
df = pd.DataFrame(flights)
```

Typical performance for a large slotfile would be - reading takes about one second and expanding slots into flights takes about 4 seconds. 

If you are missing features or found bugs please get in touch via [github](https://github.com/rok/ssim/issues) or submit a pull request. Any help / feedback is welcome!