#!/opt/perl5/bin/perl
# ^^^the path to perl
#
#  Contact Paul O'Blenes Geographical Names Section
#                        Geomatics Canada, Natural Resources Canada
#                        Tel (613) 947-3589
#
# A script to search through the Geographical Names Database 
# by name, and return a list of names.  The user then selects the
# location they are seeking, and the key to that record is sent to another
# script.
# Include the Common Gateway Interface Perl library
push(@INC, "/opt/perl5/lib/5.6.0"); # Change your path to suit
require 'formlib.pl';
require CGI;

$query = new CGI;

$input = $query->param('key');

$docbase="/CANSIS/NSDB/META";
$url_server_dir="/usr/local/etc/httpd/internet/cgi-bin/CANSIS";
$url_server="webget.pl";
#$ENV{'http_proxy'}="142.61.33.1";

#---
# perform the keyword search of the NAIS database, piping the output 
# to a filehandle
#---
  open(FILE, "$url_server_dir/$url_server -quiet http://GeoNames.nrcan.gc.ca/cgi-bin/direct/terse2_unique\?unique_key=$input |") || die("$0 :  Could not run command.\n");

  while(<FILE>)
  {
      chop;

      ($name, $value) = split(/=/, $_);

      if ($name =~ /LAT/){
          $lat = $value;
          next;
      }
      elsif ($name =~ /LONG/) {
          $long = $value;
          last;
      }

  }
  close(FILE);

  ($lat_deg, $lat_min, $lat_sec) = split(/ /, $lat);
  ($long_deg, $long_min, $long_sec) = split(/ /, $long);

  print "Location: /cgi-bin/CANSIS/ors/ors/obj=mappage?/file=soil/center=$lat_deg-$lat_min-$lat_sec";
  print "N,";
  print "$long_deg-$long_min-$long_sec";
  print "W/scale=3000000/format=gif/click=zin/mfact=3/fea1=ON/fea5=ON/mapdraw.x=0/mapdraw.y=0";
  print "\n";
  print "\n";


