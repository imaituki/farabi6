use v6;

say "Starting electron platform";

my $pc = Proc::Async.new( "electron", "my_app" );
$pc.start;

use JSON::RPC::Server;

my $json_bridge_server;

# define application class
# that will handle remote procedure calls
class My::JSON::RPC::Bridge {

   # method without params
   method stop {
     say "Stopping main Perl 6 process";
     $pc.kill;
     exit 1;
     return;
   }

   # method with named params
   method sum (  :$a!, :$b! ) { 
     say "Got a call from Javascript land";
     return $a + $b;
  }
}

# start server with your application as handler
say "Starting the JSON::RPC bridge";
$json_bridge_server = JSON::RPC::Server.new( application => My::JSON::RPC::Bridge );
$json_bridge_server.run;