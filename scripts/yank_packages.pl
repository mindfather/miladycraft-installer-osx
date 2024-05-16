#!/usr/bin/perl

use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use IO::File;

sub create_user_agent {
    my $user_agent = LWP::UserAgent->new(
        ssl_opts => {
            verify_hostname => 0,
            SSL_verify_mode => 0x00, 
        },
    );
    $user_agent->agent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3');
    
    return $user_agent;
}

sub get_token {
    my $user_agent = shift;
    my $url = "https://arch.b4k.co/vg/thread/388569358";
    my $response = $user_agent->get($url);

    if ($response->is_success) {
        my $content = $response->decoded_content;

        if ($content =~ /and put .*? /) {
            my $match1 = $&;

            if ($match1 =~ /\$.*$/) {
                my $token = $&;
                $token =~ s/^\s+|\s+$//g; 

                return $token;
            }
        }
    } else {
        die $response->status_line;
    }

    return undef;
}

sub modrinth {

    ##############################################
    print "Now Installing™️ Modrinth Packages.\n";#
    ##############################################
    
    my $user_agent = shift;

    my $json_file = 'modrinth.index.json';
    open(my $fh, '<', $json_file) or die "Failed to open $json_file: $!";

    my $json_data = do { local $/; <$fh> };
    close($fh);

    my $data = decode_json($json_data);

    my @download_links;
    foreach my $files (@{$data->{files}}) {
        foreach my $file (@{$files->{downloads}}) {
            push @download_links, $file;
        }
    }

    foreach my $link (@download_links) {
        my $uri = URI->new($link);
        my $path = $uri->path;
        my ($filename) = $path =~ m/([^\/]+)$/;

        my $response = $user_agent->get($link);

        if ($response->is_success) {
            print "Size of " 
                . $filename . ": "
                . length($response->decoded_content) . " bytes\n";
        } else {
            print "Failed to download " 
            . $link . ": " 
            . $response->status_line . "\n";
        }
        undef $response;
    }
}

sub curseforge {
    ################################################
    print "Now Installing™️ Curseforge Packages.\n";#
    ################################################
    
    my $user_agent = shift;
    my $token = get_token($user_agent);

    my $json_file = 'manifest.json';

    open(my $fh, '<', $json_file) or return {
        is_success => 0,
        message => "Failed to open $json_file: $!"
    };
        
    my $json_data = do { local $/; <$fh> };
    close($fh);
    my $data = decode_json($json_data);

    my @file_ids;
    foreach my $file (@{$data->{files}}) {
        push @file_ids, $file->{fileID};
    }

    my $base_url = "https://api.curseforge.com";
    my $request_body = encode_json({ fileIds => \@file_ids });
    
    my $request = HTTP::Request->new('POST', $base_url . '/v1/mods/files');
    $request->header('Content-Type' => 'application/json');
    $request->header('x-api-key' => $token);
    $request->content($request_body);

    my $response = $user_agent->request($request);
    undef $request;

    if (!$response->is_success) {
        my $status = $response->status_line;
        return {
            is_success => 0,
            message => "Failed to send post request: $status"
        };
    }

    my $files = decode_json($response->decoded_content);
    undef $response;

    my $downloaded_files = [];
    foreach my $file (@{$files->{data}}) {

        my $download_url = $file->{downloadUrl};
        my $response = $user_agent->get($download_url);

        if (!$response->is_success) {
            print "Failed to download " 
            . $download_url . ": " 
            . $response->status_line . "\n";
            next;
        } 
        undef $response;


        my $file_name = $file->{fileName};
        my $file_hash;
        foreach my $hash (@{$file->{hashes}}) {
            if ($hash->{algo} == 1) {
                $file_hash = $hash->{value};
                last;
            }
        }

        push @{$downloaded_files}, {
            name => $file_name,
            hash => $file_hash
        };
    }
    print $downloaded_files;

    return { 
        is_success => 1,
        data => $downloaded_files
    };
}


my $user_agent = create_user_agent();

my $curseforge_result = curseforge($user_agent);
if(!$curseforge_result->{is_success}) {
    my $message = $curseforge_result->{message};
    die "Failed to install curseforge packages: $message\n";
}

my $downloaded_files = $curseforge_result->{data};

my $modrinth_result = modrinth($user_agent);
if(!$modrinth_result->{is_success}) {
    my $message = $modrinth_result->{message};
    die "Failed to install modrinth packages: $message\n";
}