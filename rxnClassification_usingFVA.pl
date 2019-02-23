################################################################################################
#		CODE TO CATEGORISE FVA DATA & CHECK CHANGE IN CONTROL TO EXPT		#


#Categories: (1) PositiveFixed, (2) PositiveVariable, (3) 0 to Positive, (4) NegativeFixed, (5) NegativeVariable, 
#(6) Negative to 0, (7) # Negligible: min/max values rang -0.001 to 0.001, (8) Reversible min <-0.001 to max >0.001 , (9) Blocked: min = max = 0


# Created By :		Priyanka Sadhukhan		05 Aug 2014
# Modified By :		MadhuraMohole			21-4-15
#####################################################################################################

#use warnings;

###	INPUT	###
$file1=$ARGV[0];		# normal/control fva file
$file2=$ARGV[1];		# cancer/tumor fva file

###	READ FILE	###
open INX, $file1 or die;
open INY, $file2 or die;

#modified-MadhuraMohole 20-4 added subsystem columns.
#open INN,"< /home/charudatta/MADHURA/GBM-Models/PerlScripts/SubSystems.txt";
#@f=<INN>;
#shift(@f);

### DECLARE VARIABLE ###
my @min1;
my @max1;
my @rxn1;
my @min2;
my @max2;
my @rxn2;

### PARSE FILE LINE-WISE ###
while($line=<INX>){
	chomp $line;
	@line=split /\t/, $line;
	push @rxn1, $line[0];
	push @min1, $line[1];
	push @max1, $line[2];
	push @span1, ($line[2]-$line[1]);
}

while($line=<INY>){
	chomp $line;
	@line=split /\t/, $line;
	push @rxn2, $line[0];
	push @min2, $line[1];
	push @max2, $line[2];
	push @span2, ($line[2]-$line[1]);
}


###	CATEGORISE RXNS ACCORDING TO FVA DATA	###
my $rxn_string=join('$',@rxn1);	# Covert array to string
my $min_string=join('$',@min1);	# Covert array to string
my $max_string=join('$',@max1);	# Covert array to string
my $span_string=join('$',@span1);# Covert array to string # Modified-MadhuraMohole @span1

@cat1=&categorise(($rxn_string,$min_string,$max_string,$span_string)); # Modified-MadhuraMohole $span_string

my $rxn_string=join('$',@rxn2);	# Covert array to string
my $min_string=join('$',@min2);	# Covert array to string
my $max_string=join('$',@max2);	# Covert array to string
my $span_string=join('$',@span2);	# Covert array to string

@cat2=&categorise(($rxn_string,$min_string,$max_string,$span_string));

my @dC;
my @sC;
my @cC;
for($i=0; $i<=$#rxn1; $i++){
  if($rxn1[$i] == $rxn2[$i]){
    if($cat1[$i] == $cat2[$i]){ $cC[$i] = 0;}
    else{ $cC[$i] = 1;}
    if($span1[$i] == $span2[$i]){ $sC[$i] = 0;}
    else{ $sC[$i] = 1;}
    if($cat1[$i] < 4 && $cat2[$i] > 3){ $dC[$i] = 1;}
    elsif($cat2[$i] < 4 && $cat1[$i] > 3){ $dC[$i] = 1;}
    elsif($cat1[$i] < 7 && $cat2[$i] > 7){ $dC[$i] = 1;}
    elsif($cat2[$i] < 7 && $cat1[$i] > 7){ $dC[$i] = 1;}
    else{ $dC[$i] = 0;}
  }
}
#chomp $f[$i];

#print "Rxn\t$file1-Category\t$file2-Category\tspanChange\tdirectionChange\tcategoryChange\tReactionName##\tRxnFormula\tSubsystems\n";

print "Rxn\t$file1-Category\t$file2-Category\tspanChange\tdirectionChange\tcategoryChange\n";
for($i=0; $i<=$#rxn1; $i++){print "$rxn1[$i]\t$cat1[$i]\t$cat2[$i]\t$sC[$i]\t$dC[$i]\t$dC[$i]\n";} 
# Modified-MadhuraMohole 20-4 added subsystem columns.


#####################	SUBROUTINE TO CATEGORISE FVA DATA	##########################
sub categorise{
  my ($rxn_string,$min_string,$max_string,$span_string) = @_;
  
  my @rxn=split /\$/,$rxn_string; # Covert string to array
  my @min=split /\$/,$min_string; # Covert string to array
  my @max=split /\$/,$max_string; # Covert string to array
  my @span=split /\$/,$span_string; # Covert string to array

  for($j=0; $j<=$#rxn; $j++){
    if($min[$j] > 0 && $max[$j] > 0){
      if($span[$j] <= 0.001){
	$cat[$j] = 1;
	}
      else{ $cat[$j] = 2;}
    }
    elsif($min[$j] < 0 && $max[$j] < 0){
       if($span[$j] <= 0.001){
	$cat[$j] = 4;}
      else{$cat[$j] = 5;}
    }
    elsif(($min[$j] <= 0.001 && $min[$j] >= -0.001) && ($max[$j] <= 0.001  && $max[$j] >= -0.001)){
	if($min[$j] == 0 && $max[$j] == 0){
		$cat[$j] = 9;}
	else{  $cat[$j] = 7;}
    }
    elsif($min[$j] == 0 && $max[$j] > 0){
      $cat[$j] = 3;
    }
    elsif($min[$j] < 0 && $max[$j] == 0){
      $cat[$j] = 6;
    }
    else{ $cat[$j] = 8;}
   }
   return @cat;
}
