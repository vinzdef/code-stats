Collection of bash scripts to keep track of how many lines I write and 
their language

Computes how many lines of code are in my Workspace directory for each language, formatting the result in json under ./results/languages.json

Also shows the following statistcs: (under ./results/stats.json)
+ Difference (in lines of code) from the previous run, 
+ Overall total 
+ Past total
+ Number of files involved.

It uses __cloc__ utility. You can find it preinstalled in many distros or on their official repos.

`run.sh` auto commits with the overall total of lines as commit message

The code is not so portable, but it should work in most cases, see Todo and Notes

####Todo:

+   Evaluate the correct argument number dinamically in `parseLine`,
    the problem is that if a language has a name which is composed of more than one word parseLine will wrongly assume taht `$5` is the number of lines of code. Can be solved by taking the last argument instead of the fifth and set the language name as a concatenation of the first trough last-4 arguments. For now I just hardcoded 'Bash' because was the only one with that issue in my case.

+   Create a `source.sh` with variables and remove hardcoded values, then have `run.sh` `source` it

#####Note:
`cloc` puts both C and C++ header files under `C/C++ Headers`.

I add it's value to C's total and force `.hpp` files to be put under `C++`.

So in the end C contains every header file which is not .hpp (.h, .inl, .hh) and C++ every .hpp
