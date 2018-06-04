#!/usr/bin/perl
# (the path to perl)
# 
# Nais, A script to search through the Geographic Names DataBase      
# by name, and return a list of names.  The user then selects the
# location they are seeking, and the key to that record is sent to another
# script.
# Contact Paul "O'Blenes Geographical Names Section
#         Geomatics Canada, Natural Resources Canada  
#         Tel (613) 947-3589
#  
# Include the Common Gateway Interface Perl library
push(@INC, "/opt/perl5/lib/5.6.0"); # Change your path to suit
require 'formlib.pl';
require CGI;

$query = new CGI;
#print $query->header;

# Read input from form
#&GetFormArgs;
$input = $query->param('ora_query');

#$lang = $query->param('Language');

$lang  = "English";
$who = "name";


#Content type= plain/text
#print &PrintHead

print "Content-type: text/html\n\n";

$docbase="/CANSIS/NSDB/META";
$url_server_dir="/usr/local/etc/httpd/internet/cgi-bin/CANSIS";
$url_server="webget.pl";
$client="Agriculture and Agri-Food Canada";

#$ENV{'http_proxy'}="142.61.33.1";

if ($lang =~ /English/) { 
   print <<"EOF";
  <HTML>
  <head><title>$client</title>
  </head>
  <body bgcolor="#FFFFE8">
  <center><h1>$client</h1></center>
  <a href="$docbase/name.html"><img src="$docbase/images/back.gif" border="0" alt="Back"></a>
  <hr>
  <h3> You have selected :  <i>$input</i> 
EOF
} else {
   print <<"EOF";
   <HTML>
   <head><title>$client</title>
   </head>
   <body background="$docbase/images/bkcream.gif">
   <center><h1>$client</h1></center>
   <hr>
   <h3> Vous avez s&eacute;lectionn&eacute : <i>$input</i>
EOF
} 
# grab output from keyword query
# check that the query will not kill the server
# It might try to send the entire data base it you request '*', or ' ', or..
if ((length($input) < 3) || ($input =~ /\s\*/) || ($input =~ /^\*+/)){
  if ($lang =~ /English/) {
     print <<"EOF";
    <hr>
    <b>Sorry</b><br>
    That query is too general.  Please make sure that any wildcards you use
    are at the end of words, and that you type at least <b>three</b>, 
    alphanumeric characters.  <Br>
    Please try <A href=$docbase/name.html>again</a>.
    <hr>
    </body>
    </html>
EOF
       exit;
  } 
  if ($lang =~ /French/) {
    print <<"EOF";
    <hr>
    <b>D&eacute;sol&eacute;</b><br>
    Cette recherche est trop vaste. Veuillez vous assurer que les passe-partout sont &agrave; la fin des mots et que vous tapez un minimum the <b>trois</b> lettres.<br>
     S'il-vous-pla&icirc;t, essayez <A href=$docbase/name.html>de nouveau</a>.
    <hr>
    </body>
    </html>
EOF
       exit;
    }
	
} else {
#---
# User entered input in correct format
#---

    $input =~ s/-//g;
    $input =~ s/'//g;
    $input =~ s/,//g;
    $input =~ s/!//g;
    $input =~ s/ //g;
#---
# perform the keyword search of the NAIS database, piping the output 
# to a filehandle
#---
   
}
#
# Assume nothing will be found
#
 $found_some = "0";
#
# Go get whatever comes back
#
  if ($lang =~ /English/) {
      open(FILE, "$url_server_dir/$url_server -quiet http://GeoNames.nrcan.gc.ca/cgi-bin/direct/terse2_name?ora_query=$input?language=ENGLISH |") || die("$0 :  Could not run command.\n");
    } else {
      open(FILE, "$url_server_dir/$url_server -quiet http://GeoNames.nrcan.gc.ca/cgi-bin/direct/terse2_name?ora_query=$input?language=FRANCAIS |") || die("$0 :  Incapable d'ex&eacute;cuter la commande.\n");
    }

  $header_printed = "0";

  while(<FILE>)

  {
      chop;

#     print $_;
      if(substr($_, 0, 8) eq "[RECORD]")
      {
#      Some records came back!
       $found_some = "1";
       if($header_printed =~ /0/){
         $header_printed = "1";
         if ($lang =~ /English/) {
         print "<p>The Canadian Geographical Names Database returned the following list.  Please select the one on which you wish to have the map centered.</h3>\n";
         print "<p><hr><p>\n";
         } else {
         print "<p>La base de donn&eacute;es des Noms G&eacute;ographique du Canada a retoun&eacute; la liste suivante. Veuillez appuyer sur celui que vous d&eacute;sirez.</h3>\n";
         print "<p><hr><p>\n";
         }   

         print "<TABLE BORDER WIDTH=100%>\n";
         print "<TR>\n";
         print "<TH>NAME</th>\n";
         print "<TH>PROVINCE / TERRITORY</th>\n";
         print "<TH>FEATURE TYPE</th>\n";
       }
      }
#
# Don't look at anything until a [RECORD] has been found
#
      if ($found_some =~ /1/)
   {

      ($name, $value) = split(/=/, $_);
      if($name eq "UNIQUE_KEY")
        { $key = $value; } 
        
        elsif($name eq "FEATURE_NAME") 
        { $feature_name = $value; } 
        
        elsif($name eq "REGION") 
        { $region = $value; } 
        
        elsif($name eq "FEATURE_TYPE") 
        { $feature_type = $value; } 
        
        elsif($name eq "LAT") 
        { 
          $lat = $value; 
          ($lat_deg, $lat_min, $lat_sec) = split(/ /, $lat);
        } 
        
        elsif($name eq "LONG") 
        { 
          $long = $value; 
          ($long_deg, $long_min, $long_sec) = split(/ /, $long);
        print "<TR ALIGN=CENTER>\n";
        print "<TD><A HREF=\"http://hp260/bin/scripts/.esrimap?name=Test&Cmd=Locate";
        print "&LL=$lat_deg-$lat_min-$lat_sec";
        print "N,$long_deg-$long_min-$long_sec";
        print "W\">$feature_name</a>\n";
        print "<TD>$region\n";
        print "<TD>$feature_type\n";
        } 
   } 
 }
close(FILE);
#
# Now that we're done with the FILE, did anything get processed up there?
# If so, print end of table, otherwise inform user nothing came back
#
if($found_some =~ /1/){
  print "</table>\n";
} else {
       if ($lang =~ /English/) {

          print "<h3> The Canadian Geographical Names Database returned no records.</h3>";
          print "Click <a href=$docbase/name.html>here</a> for another search.\n";
          print "<hr>\n";

       } else {
	  print "<h3> La banque de donn&eacute;e des noms canadiens n'a trouv&eacute; aucune r&eacute;ponse &agrave; cette interrogation.</h3>\n";
	  print "Appuyer <a href=$docbase/name.html>ici</a> pour chercher un autre nom g&eacute;ographique.";
	  print "<hr>\n"; 
      }
}

print "</html>\n";
print "</body>\n";

