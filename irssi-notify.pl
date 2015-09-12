# irssi-notify.pl, slightly modified by ravekutsuu@gmail.com
use Irssi;
use Net::DBus;
 
$::VERSION='0.0.1';
%::IRSSI = (
    authors => 'Ashish Shukla',
    contact => 'gmail.com!wahjava',
    name => 'irssi-notify',
    description => 'Displays a pop-up message for message received',
    url => 'https://wahjava.wordpress.com/',
    license => 'GNU General Public License',
    changed => '$Date$'
    );
 
my $APPNAME = 'irssi';
 
my $bus = Net::DBus->session;
my $notifications = $bus->get_service('org.freedesktop.Notifications');
my $object = $notifications->get_object('/org/freedesktop/Notifications',
					'org.freedesktop.Notifications');
 
my $notify_nick = 'rave';
 
# $object->Notify('appname', 0, 'info', 'Title', 'Message', [], { }, 3000);
 
sub pub_msg {
    my ($server,$msg,$nick,$address,$target) = @_;
 
    if ($msg =~ $notify_nick)
    {
	$object->Notify("${APPNAME}:${server}",
			0,
			'info',
			"Public Message in $target",
			"$nick: $msg",
			[], { }, 3000);
    }
}
 
sub priv_msg {
    my ($server,$msg,$nick,$address) = @_;
    $object->Notify("${APPNAME}:${server}",
		    0,
		    'info',
		    'Private Message',
		    "$nick: $msg",
		    [], { }, 3000);
}
 
Irssi::signal_add_last('message public', \&pub_msg);
Irssi::signal_add_last('message private', \&priv_msg);
Irssi::command_bind('notify-on', \&cmd_notifyon);
