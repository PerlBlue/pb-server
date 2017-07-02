package PB::App::MQWorker::Daemon;

use Moose;
use MooseX::App::Command;
use Data::Dumper;
use namespace::autoclean;
#use App::Daemon qw(daemonize);
use Log::Log4perl qw(:levels);
use Try::Tiny;

use PB::MessageQueue;

extends 'PB::App::MQWorker';

option 'nodaemonize' => (
    is              => 'rw',
    isa             => 'Bool',
    required        => 0,
    default         => 0,
    documentation   => 'Run in the foreground.',
);

option 'verbose' => (
    is              => 'rw',
    isa             => 'Bool',
    required        => 0,
    default         => 0,
    documentation   => 'Verbose messages.',
);

option 'watch' => (
    is              => 'rw',
    isa             => 'ArrayRef',
    required        => 1,
    documentation   => 'Queues to watch',
);

sub run {
    my ($self) = @_;

    my $log = Log::Log4perl->get_logger('PB::MessageQueue');

    print "Run the Message Queue daemon [".$self->nodaemonize."]\n";

#    $App::Daemon::loglevel = $self->verbose ? $DEBUG : $WARN;

    my $pid_file = '/home/perlblue/pb-server/log/MQWorkerDaemon.pid';
    my $start = time;

    # Kill any existing process
    if (-f $pid_file) {
        open(my $pid_fh, $pid_file);
        my $pid = <$pid_fh>;
        chomp $pid;
        close($pid_fh);

        if (grep /$pid/,`ps -p $pid`) {
            $self->out("Killing previous job, PID=$pid");
            kill 9, $pid;
            sleep 5;
        }
    }

    #--- Daemonize
    #
    if ($self->nodaemonize) {
        $self->out('Running in the foreground');
    }
    else {
        daemonize();
        $self->out('Running as a daemon');
    }

    my $config          = PB::Config->instance;
    my $queue           = PB::Queue->instance;
    my $message_queue   = PB::MessageQueue->new({
        name    => 'bg_worker',
    });

    #--- Hard code the queues to watch, they should come
    # TODO from the command line
    #
    $self->out('Started');
    foreach my $to_watch ( @{$self->watch} ) {
        $queue->watch($to_watch);
    }

    while (1) {
        my $job = $queue->consume;
        my $payload = $job->payload;

        try {
            $self->out("Process job ".Dumper($payload));
            $log->error("PROCESS JOB ".Dumper($payload));

            $message_queue->queue($job);

            $job->delete;
        }
        catch {
            # Bury the job, it failed
            $log->error("Job failed: $_");
            $job->bury;
        };
    }
}

sub out {
    my ($self, $message) = @_;

    print STDERR "$message\n";
}

__PACKAGE__->meta->make_immutable;

