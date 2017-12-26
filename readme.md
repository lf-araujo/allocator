# Allocator v0.9.1

This is an example on how to build a command line tool in R. It serves as example on how to build a program that expects user input and perform calculations with these.

<<<<<<< HEAD
The program is a totally functional passive allocation program, the user defines his risk profile and the age when s/he expects to stop moving investments around. The tool then calculates how much to allocate into each of the pools of investments.
=======
The program is a totally functional passive allocation tool in which the user defines his risk profile and the age when s/he expects to stop moving investiments around. The tool then calculates how much to allocate into each of the pools of investments.
>>>>>>> 4c6cb3d482ce88ebf023b3f89b34ddeabf17b4a3

This is an example of R programming, it is distributed "as is", without warranty. Do not use it if you don't understand the code and the principle of passive allocation. 

## Use

<<<<<<< HEAD
It's help page: 

```
Passive allocation investment tool. It departs from three assumptions:
  1. the age when one wants to stop investing (should take life expectancy
=======
```
Passive allocation investiment tool. It departs from three assumptions:
  1. the age when one whants to stop investing (should take life expectancy
>>>>>>> 4c6cb3d482ce88ebf023b3f89b34ddeabf17b4a3
    in your country into consideration);
  2. the user risk profile;
  3. that assets are grouped in three pools.
  3.1. the emergency fund, corresponds to expenses for six months (think six
    months of unemployment),
  3.2. the second pool corresponds to low risk investments
  3.3. the third pool are the high risk investments.

  Vary the types of investments within each pool, this tool will not handle
  investments within pool, only the total pool value. Decision on what is low
  and high risk, as well as decision on the risk profile is entirely on users
  discretion. Every year, the tool will help the user allocate the correct
  amount in each of the pools, based in a simple algorithm. Finally, since
  sometimes one needs to record a deposit into one of the investments
  quickly, there is a quick-add add command, in which one can add the latest
  low risk and high risk investment without going trough all the questions.

usage:
 allocator.R [(quick-add <low> <high>)]

options:
 -h --help         Shows this screen
<<<<<<< HEAD

 ```
=======
```
>>>>>>> 4c6cb3d482ce88ebf023b3f89b34ddeabf17b4a3
