#!/usr/bin/perl -w
#
# You must have perl installed to use this script. Perl for
# the Windows platform is available from:
# http://www.activestate.com
# Please read their directions about how to execute a perl
# script in the Windows environment before e-mailing me that
# question.
#
# Take a Mars Obriter Laser Altimeter .IMG file and convert
# section of it (defined by latitude, longitude and size) for
# use as Empire Earth .dat/.txt elevation files.
#
# The data in these .img files is a simple cylindrical projection
# so it suffers from distortion at the poles. For the best terrain
# without distortion stay within +/- 50 degrees of the equator.
#
# Melech Ric, February 7, 2002
# I can be e-mailed at the following address:
# melech_ric@earthlink.net
#
# If you build something cool with this utility let me know.
# However, if I start getting spam and other crap this mailbox
# will disappear quickly.
#
# Also, thanks to IvyMike for the beta testing and the idea
# for water level. Heaps of thanks to SSSI for making Empire 
# Earth.
#
# BUGS:
# If you find them you can fix them or e-mail me and I will fix
# them.
#
# The terrain produced by the Empire Earth 3D engine with this
# mars data is jagged. This is likely due to quantization error
# within the data in the .img file. It's possible some rendering
# limitations / assumptions in the EE renderer my also cause it. 
# I've checked and this also happens (to a lesser degree) with 
# topo data downloaded from the USGS site mentioned in the EE
# help document.
#
# COPYRIGHT:
# This code is copyrighted under GNU Public Library license.
# see: http://www.gnu.org/copyleft/gpl.html for more information.
#
# LIABILITY: By using this program the user assumes all liablity
# for any damages that may result from the program's use.
#
# Revision History:
# 20020207: Initial release
# 20020219: Check for zero size .img and abort added
# 20020220: New read in and rotation code added by IvyMike
#

# .IMG File data organized as shown (in 16bit big-endian fields)
# BOF     90N                      N
#         ^                        ^
#         |                        |
#   0E<---+--->360E           W<---+--->E
#         |                        |
#         v                        v
#        -90N     EOF              S

# http://www.msss.com/mars_images/moc/moc_atlas/
# uses the following coordinate system
#
#         90N
#         ^
#         |
#180W<---0+360W-->180W
#         |
#         v
#       -90N

use strict;
use Benchmark;
use Getopt::Long;

&GetOptions("mapsize=i"    => \$main::mapsize,
            "latitude=i"   => \$main::latitude,
            "longitude=i"  => \$main::longitude,
            "imgfile=s"    => \$main::imgfile,
            "outname=s"    => \$main::outname,
            "mintopo=i"    => \$main::mintopo,
            "maxtopo=i"    => \$main::maxtopo,
            "water=i"      => \$main::water,
            "rotate=i"     => \$main::rotate,
            "help"         => \$main::help,
            "debug"        => \$main::debug);

&usage() if $main::help;
&check_cmdline_opts() unless $main::debug;
&convert_img();

sub convert_img {

    # Verify that we can open all the input and output files we need

    open(IMGFILE,"<$main::imgfile") or
      die "Couldn't open the .IMG file: $!";
    binmode(IMGFILE);

    open(DATFILE,">$main::outname.dat") or
      die "Couldn't open the $main::outname.dat file: $!";
    binmode(DATFILE);

    open(TXTFILE,">$main::outname.txt") or
      die "Couldn't open the $main::outname.txt file: $!";

    open(INFOFILE,">".$main::outname."_info.txt") or
      die "Couldn't open the ".$main::outname."_info.txt file: $!";

    # Find the resolution of the file:
    my $filesize   = (stat($main::imgfile))[7];
    die "$main::imgfile has file size of $filesize; can't continue!"
      unless $filesize > 0;
    print "img filesize is $filesize\n" if $main::debug;
    my $resolution = sqrt(( 180 * 360 * 2) / $filesize);
    print "calculated resolution is $resolution\n" if $main::debug;
    my $scale = int( (1.0 /$resolution)+.5);
    print "calculated scale is $scale\n" if $main::debug;
    my %valid_scales = (  4 => 1,
                          8 => 1,
                         16 => 1,
                         32 => 1);
    unless(exists($valid_scales{$scale})) {
        die "File scale ($scale) is not a power of two!";
    }

    #
    # Calculate some specific things based on scale
    #
    my $BYTES_PER_TOPO =  2;  # 16bit big-endian
    my $FILE_RECORDS   =  180 * $scale;
    my $RECORD_BYTES   = (360 * $scale) * $BYTES_PER_TOPO;

    # Normalize the latitude from 90N/-90N to 0S/180S
    my $latitude_norm = ($main::latitude * -1) + 90;
    print "normalized latitude = $latitude_norm\n" if $main::debug;

    # Normalize the longitude from 0W/360W to 0E/360E.
    my $longitude_norm = 360 - $main::longitude;
    print "normalized longitude $longitude_norm\n" if $main::debug;

    # Calculate where in the IMG file (in bytes) we need to start
    # reading.

    my $lat_offset = ($latitude_norm * $scale) *
                     $RECORD_BYTES;
    print "lat_offset = $lat_offset\n" if $main::debug;
    my $long_offset = ($longitude_norm * $scale) *
                      $BYTES_PER_TOPO;
    print "long_offset = $long_offset\n" if $main::debug;

    my $time0 = new Benchmark;

    #
    # Get the data out of the IMG file
    #
    my $img_buffer;
    my $buffer;
    my($pi) = 3.14159265358979;
    print "rotation in degrees is $main::rotate\n" if $main::debug;
    #convert to radians
    my $rotate_rad = $main::rotate * $pi/180;
    print "rotation in radians is $rotate_rad\n" if $main::debug;

    # What is all this $#%#!??? This is where reading in and rotation are
    # done.
    # First the program itterates over the mapspace which is just
    # mapsize x mapsize. This coordinate system is translated to
    # center about the user's latitude and longitude. Then a 
    # rotation is applied to these translated coordinates. Finally
    # these translated and rotated coordinates are found in the 
    # .img file and read into a buffer. The rest is history.
    # If your map has a river through it like this with no rotation:  "/"
    # ...it will look like this with 45 degrees of rotation: "|"
    # P.S. Rotation code contributed by IvyMike.

    # Iterate over the output array
    for(my $outy = 0; $outy < $main::mapsize; $outy++) {
        for (my $outx = 0; $outx < $main::mapsize; $outx++) {
            my($tx) = $outx - int($main::mapsize / 2 );
            my($ty) = $outy - int($main::mapsize / 2 );

            # CW Rotation
           #my($rot_x) = $tx * cos($rotate_rad) + $ty * sin($rotate_rad);
           #my($rot_y) = -1*$tx * sin($rotate_rad)+ $ty * cos($rotate_rad);

            # CCW Rotation
            my($rot_x) = $tx * cos($rotate_rad) + -1*$ty*sin($rotate_rad);
            my($rot_y) = $tx * sin($rotate_rad)+ $ty * cos($rotate_rad);

            my($file_x) = int(($rot_x + $longitude_norm *$scale))%(360*$scale);
            my($file_y) = int($rot_y + $latitude_norm * $scale);

	   #print "$tx $rot_x $file_x $ty $rot_y $file_y\n";
            if($file_y < 0  || $file_y > 180*$scale) {
                die "Rotated co-ords are off the top or bottom of the map\n";
            }
            my $offset = $file_y * $RECORD_BYTES + $file_x * $BYTES_PER_TOPO;
            seek IMGFILE, $offset, 0 or die 
              "Couldn't get to $offset in .IMG file.";
            my $read_ok = read IMGFILE, $buffer, $BYTES_PER_TOPO;
            die "Error reading .IMG file." unless defined($read_ok);
            $img_buffer .= $buffer;
        }
    }

    my $time1 = new Benchmark;
    my $time_diff = timediff($time1,$time0);
    print ".img file read took: ",timestr($time_diff),"\n" if $main::debug;

    close(IMGFILE);
    # unpack the 16bit big-endian data into an array
    push my @IMGDATA, (unpack "n*",$img_buffer);

    my $time2 = new Benchmark;
    $time_diff = timediff($time2,$time1);
    print ".img file unpack took: ",timestr($time_diff),"\n" if $main::debug;

    # Get IMGDATA into the perl world of numbers 
    # At this point @IMGDATA has things like 4012, 46782, 39156 ...
    # which are unsigned representations of signed short values.
    # We need them to look like 4012, -18754, -26380 so we
    # determine which are > 32767 and subtract 65536.
    foreach my $element (@IMGDATA) {
        if($element > 32767 ) {
            $element -= 65536;
        }
    }

    # Set the amount of the map that appears under water
    if(defined($main::water)) {
        my %histogram;
        my $water_mark = int($main::mapsize**2 * ($main::water/100));
        my $marked_elevation;

        # Build the histogram
        for my $datum (@IMGDATA) {
            $histogram{$datum}++;
        }

        my $count = 0;
        for my $elevation (sort {$a<=>$b} keys %histogram) {
            $count += $histogram{$elevation};
            if($count >= $water_mark) {
                $marked_elevation = $elevation;
                last;
            }
        }

        @IMGDATA = map{$_ - $marked_elevation }@IMGDATA;
    }

    # Do a scale and offset with the min/max topo values if
    # they are defined. Don't do it if water percentage was
    # defined.
    my $min;
    my $max;
    my $delta;
    if(defined($main::mintopo) && 
       defined($main::maxtopo) && 
       !defined($main::water)) {
        ($min, $max) = find_min_max(\@IMGDATA);
        my $scale  = ($main::maxtopo - $main::mintopo) / ($max - $min);
        my $offset = $main::mintopo - ($min * $scale);
        scale_and_offset_img_data(\@IMGDATA,$scale,$offset);
        $min = $main::mintopo;
        $max = $main::maxtopo;
    }
    else {
        ($min,$max) = find_min_max(\@IMGDATA);
    }
    $delta = $max - $min;

    # For easier cutoff and elevation fiddling we give the
    # min and max topo
    print "mintopo = $min m\tmaxtopo = $max m\tdelta = $delta m\n";
    print INFOFILE "center latitude  = $main::latitude\n";
    print INFOFILE "center longitude = $main::longitude\n";
    print INFOFILE "rotation         = $main::rotate\n";
    if(defined($main::water)) {
        print INFOFILE "water percentage = $main::water\n";
    }
    print INFOFILE "mintopo = $min m\tmaxtopo = $max m\tdelta = $delta m\n";
    close(INFOFILE);

    # pack it into 16bit little-endian data and put it into the dat file
    print DATFILE pack "v*", @IMGDATA;
    close(DATFILE);

    print TXTFILE "$main::mapsize $main::mapsize\n";
    close(TXTFILE);
}


sub scale_and_offset_img_data {
    my $imgdata_ref  = shift;
    my $scale_factor = shift;
    my $offset       = shift;

    print "offset is $offset\n" if $main::debug;
    print "scale factor is $scale_factor\n" if $main::debug;

    #
    # Uses y = mx + b where m is the scale and y is offset
    #
    for my $data (@$imgdata_ref) {
        $data = int($data * $scale_factor + $offset);
    }
}

sub find_min_max {
    my $imgdata_ref = shift;
    my $min = $$imgdata_ref[0];
    my $max = $$imgdata_ref[0];
    for my $data (@$imgdata_ref) {
        $min = $data unless $data > $min;
        $max = $data unless $data < $max;
    }
    return($min,$max);
}


sub usage() {

print <<EOF;

$0 will convert a section of a Mars Orbiter Laser Altimeter
topographic data file in .img format to a .dat and .txt file 
which are usable as elevation data for Empire Earth. An 
_info.txt which contains info about the section converted 
is also generated.

usage: $0 [options]

Options are the following:

  --mapsize <int>

    Specifies the length of a side on the square map that
    will be generated. The minimum is 15 and the maximum
    is 400. These limits are the smallest and largest
    square maps possible in Empire Earth.

  --latitude <int>

    Specifies the center latitude in degrees. Latitude
    may be any integer from 90 N to -90 N.

  --longitude <int>

    Specifies the center latitude in degrees. Latitude
    may be any integer from 0 W to 360 W.

    For help on picking latitude and longitude you can go to the
    following website:

    http://www.msss.com/mars_images/moc/moc_atlas/

    NOTE: There are other maps of Mars on the internet, but they
    may not use the same coordinate system. In that case do a little
    math and all will be well.

  --imgfile <string>

    Specifies the name of the topographic .IMG file to read
    from. These files can be obtained from:

    http://wufs.wustl.edu/missions/mgs/mola/egdr.html

    The .LBL associated with the .IMG contains further data
    about things such as the degrees of resolution.

  --outname <string>

    The name prepended to the .dat and .txt output files
    generated by this utility.

    OPTIONAL ARGUMENTS:

  --mintopo <int>
  --maxtopo <int>

    These cause the actual IMG topo data to be scaled to fit
    between mintopo and maxtopo.

    Legal values for mintopo and maxtopo are between -32767
    and 32767.

    maxtopo must be greater than mintopo and both must be
    specified together.

    Mintopo and maxtopo will be ignored if the --water
    switch is given.

  --water <int>

    Specifies what percentage of the map should be under
    water.

    Legal values for water are between 0 and 100.

    If water is specified then --mintopo and --maxtopo are 
    ignored.

  --rotate <int>

    Specifies a counter clockwise rotation in degrees for the
    map to be rotated.

    If rotate is left unspecified zero will be used as a rotation.

EOF

  exit;

}


sub check_cmdline_opts() {

    #
    # Required Command Line Switches
    #

    unless(defined($main::mapsize)) {
        print "Please specify a map size with the --mapsize option\n";
          exit;
    }

    unless(defined($main::latitude)) {
        print "Please specify a starting latitude".
              " with the --latitude option\n";
        exit;
    }

    unless(defined($main::longitude)) {
        print "Please specify a longitude latitude".
              " with the --longitude option\n";
        exit;
    }

    unless(defined($main::imgfile)) {
        print "Please specify a source .img file with the ".
          "--imgfile option\n";
        exit;
    }

    unless(defined($main::outname)) {
        print "Please specify a name for the output files ".
          "with the --outname option.\n";
        exit;
    }

    unless($main::mapsize <= 400 && $main::mapsize > 15) {
        print "\nmapsize: $main::mapsize is out of range.\n";
        exit;
    }

    unless($main::latitude <= 90  && $main::latitude >= -90) {
        print "\nlatitude: $main::latitude is out of range\n";
        exit;
    }

    unless($main::longitude <= 360 && $main::longitude >= 0 ) {
        print "\nlongitude: $main::longitude is out of range\n";
        exit;
    }

    #
    # Optional Command Line Switches
    #

    # Make rotation be 0 degrees unless it was defined by the user
    unless(defined($main::rotate)) {
        $main::rotate = 0;
    }

    # Min/Max Topo are exclusive of Water Area so handle the 
    # three posibilities:

    # 1. None were provided so return
    unless(defined($main::maxtopo) ||
           defined($main::mintopo) ||
           defined($main::water)) {
        return;
    }

    # 2. Water area was provided .. min/max topo will be ignored
    if(defined($main::water)) {
        unless($main::water <= 100 && $main::water >= 0) {
            print"\nwater value: $main::water is out of range\n";
            exit;
        }
        return;
    }

    # 3. Only mintopo and maxtopo were provided
    if(defined($main::mintopo) || defined($main::maxtopo)) {

        #Make sure we get a min and max topo
        if(defined($main::maxtopo) && !defined($main::mintopo) ||
           !defined($main::maxtopo) && defined($main::mintopo)) {
            print "\nmintopo and maxtopo must both be specified\n";
            exit;
        }

        unless($main::maxtopo > $main::mintopo) {
            print "\nmaxtopo must be greater than mintopo\n";
            exit;
        }

        unless($main::maxtopo <= 32767 && $main::maxtopo >= -32767) {
            print "\nmaxtopo: $main::maxtopo is out of range\n";
            exit;
        }

        unless($main::mintopo <= 32767 && $main::mintopo >= -32767) {
            print "\nmintopo: $main::mintopo is out of range\n";
            exit;
        }
        return;
    }

    # Should never get here
    print "Abnormal command exit.\n";
    exit;
}

