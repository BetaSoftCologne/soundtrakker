# The CPC Soundtrakker

This repository is (was) supposed to contain everything concerning Soundtrakker for the Amstrad CPC, where everything means all bits and pieces which constitute the actual software. 

A short story how the source finally ended up in this repository.

I managed to turn most of my old 3" disks into disk-images in the .dsk format in 2023 and every now and then I took a look into the resulting images, sometimes extracting some files and generally messing around. In May 2024 I finally managed to obtain the main assembly source files for Soundtrakker 1.0, a task which was not as easy as it may sound, since I used the GENA3 assembler of the https://www.cpcwiki.eu/index.php/Hisoft_Devpac package to build everything. GENA3 uses a proprietary file format for the source files and the only way to turn them into ASCII files to put on github was to load up GENA3, load and export to ASCII each of the source files. Turns out that some of the files got messed up when exported that way and initially I had no idea why or how to resolve it. After a break of a few months I revisited the thing, tried exporting the files in chunks of a few kilobytes each and somehow that did the trick! 

So here you go, the four source files (diskop, insedit, misc & trakker) which I wrote to create Soundtrakker. The final program is linked together using a couple of jump tables at the beginning of each of the objects files you get after assembly (take a look at the *org* directive in each file) , but I did not (yet) want to invest more time into that so that's some kind of exercise for those who are curious enough. The thing is, you will still not get a running Soundtrakker because the font file is (yet?) missing. :-O 

BTW: The files assemble without errors using rasm (v2.1.6)

st128-player.asm is the stand-alone player to use for compiled Soundtrakker 128 files.
