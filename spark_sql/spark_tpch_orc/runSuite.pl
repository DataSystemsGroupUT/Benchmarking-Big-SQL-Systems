#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

# PROTOTYPES
sub dieWithUsage(;$);

# GLOBALS
my $SCRIPT_NAME = basename( __FILE__ );
my $SCRIPT_PATH = dirname( __FILE__ );

# MAIN
dieWithUsage("one or more parameters not defined") unless @ARGV >= 1;
my $suite = shift;
my $scale = shift || 2;
dieWithUsage("suite name required") unless $suite eq "tpcds" or $suite eq "tpch";

chdir $SCRIPT_PATH;
if( $suite eq 'tpcds' ) {
	chdir "tpcds-queries";
} else {
#	chdir 'tpch-queries';
#	chdir 'tpch_rerun';
	chdir 'final_tpch_queries';
} # end if
my @queries = glob '*.sql';

my $db = { 
	'tpcds' => "tpcds_300gb_orc",
	'tpch' => "tpch_300gb_orc"
};

print "filename,status,time,rows\n";
for my $query ( @queries ) {
	my $logname = "$query.log";
# First trial of TPCH
#	my $cmd="hive -i /opt/hadoop/benchmarks/hive-testbench-hive14/testbench.settings -e 'use $db->{${suite}}; source /opt/hadoop/benchmarks/hive-testbench-hive14/tpch-queries/$query;' 2>&1  | tee /opt/experiment_results/hive_tpch/$query.log";
# Second trial of TPCH
#	my $cmd="hive -i /opt/hadoop/benchmarks/hive-testbench-hive14/testbench.settings -e 'use $db->{${suite}}; source /opt/hadoop/benchmarks/hive-testbench-hive14/tpch_rerun/$query;' 2>&1  | tee /opt/experiment_results/hive_tpch2/$query.log";
# First trial of TPCDS
#	my $cmd="hive -i /opt/hadoop/benchmarks/hive-testbench-hive14/testbench.settings -e 'use $db->{${suite}}; source /opt/hadoop/benchmarks/hive-testbench-hive14/tpcds-queries/$query;' 2>&1  | tee /opt/experiment_results/hive_tpcds/$query.log";

# Spark TPCH
	my $cmd="spark-sql --master yarn --conf spark.driver.memory=2G --conf spark.executor.memory=5G --conf spark.executor.cores=1 --conf spark.executor.instances=60 --database tpch_300gb_orc -f ./$query -i /opt/hadoop/benchmarks/hive-testbench-hive14/testbench.settings 2>&1  | tee /opt/experiment_results/spark_sql_tpch/$query.log";

#	my $cmd="hive -i testbench.settings -e 'use $db->{${suite}}; source /opt/hadoop/benchmarks/hive-testbench-hive14/sample-queries-tpcds/$query;' 2>&1  | tee /opt/hadoop/experiment_results/tpcds/run5/$query.log";
#	my $cmd="echo 'use $db->{${suite}}; source /opt/hadoop/benchmarks/hive-testbench-hive14/sample-queries-tpcds/$query;' | hive -i testbench.settings 2>&1  | tee /opt/hadoop/experiment_results/tpcds/run1/$query.log";
#	my $cmd="cat $query.log";
#	print $cmd ; exit;
	
	my $hiveStart = time();

	my @hiveoutput=`$cmd`;
	die "${SCRIPT_NAME}:: ERROR:  Spark command unexpectedly exited \$? = '$?', \$! = '$!'" if $?;

	my $hiveEnd = time();
	my $hiveTime = $hiveEnd - $hiveStart;
	foreach my $line ( @hiveoutput ) {
		if( $line =~ /Time taken:\s+([\d\.]+)\s+seconds,\s+Fetched:\s+(\d+)\s+row/ ) {
			print "$query,success,$hiveTime,$2\n"; 
		} elsif( 
			$line =~ /^FAILED: /
			# || /Task failed!/ 
			) {
			print "$query,failed,$hiveTime\n"; 
		} # end if
	} # end while
} # end for


sub dieWithUsage(;$) {
	my $err = shift || '';
	if( $err ne '' ) {
		chomp $err;
		$err = "ERROR: $err\n\n";
	} # end if

	print STDERR <<USAGE;
${err}Usage:
	perl ${SCRIPT_NAME} [tpcds|tpch] [scale]

Description:
	This script runs the sample queries and outputs a CSV file of the time it took each query to run.  Also, all hive output is kept as a log file named 'queryXX.sql.log' for each query file of the form 'queryXX.sql'. Defaults to scale of 2.
USAGE
	exit 1;
}

