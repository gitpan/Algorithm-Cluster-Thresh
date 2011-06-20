#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Algorithm::Cluster;
use Algorithm::Cluster::Thresh;

# Copied partially from Algorithm::Cluster t/12-treecluster.t

#-------[treecluster on a distance matrix]------------

my $matrix   =  [
        [],
        [ 3.4],
        [ 4.3, 10.1],
        [ 3.7, 11.5,  1.0],
        [ 1.6,  4.1,  3.4,  3.4],
        [10.1, 20.5,  2.5,  2.7,  9.8],
        [ 2.5,  3.7,  3.1,  3.6,  1.1, 10.1],
        [ 3.4,  2.2,  8.8,  8.7,  3.3, 16.6,  2.7],
        [ 2.1,  7.7,  2.7,  1.9,  1.8,  5.7,  3.4,  5.2],
        [ 1.4,  1.7,  9.2,  8.7,  3.4, 16.8,  4.2,  1.3,  5.0],
        [ 2.7,  3.7,  5.5,  5.5,  1.9, 11.5,  2.0,  1.5,  2.1,  3.1],
        [10.0, 19.3,  2.2,  3.7,  9.1,  1.2,  9.3, 15.7,  6.3, 16.0, 11.5]
];

my %params = (
    method     =>       's', # Single linkage clustering
    data       =>   $matrix,
);

my $tree = Algorithm::Cluster::treecluster(%params);

# Make sure that @clusters and @centroids are the right length
is ( scalar(@$matrix) - 1, $tree->length );

my $node;

# Basic sanity checks
$node = $tree->get(0);
is ($node->left, 2);
is ($node->right, 3);
is (sprintf("%7.3f", $node->distance), "  1.000");

$node = $tree->get(2);
is ($node->left, 5);
is ($node->right, 11);
is (sprintf("%7.3f", $node->distance), "  1.200");

$node = $tree->get(4);
is ($node->left, 0);
is ($node->right, -4);
is (sprintf("%7.3f", $node->distance), "  1.400");

$node = $tree->get(6);
is ($node->left, -2);
is ($node->right, -6);
is (sprintf("%7.3f", $node->distance), "  1.600");

$node = $tree->get(8);
is ($node->left, 8);
is ($node->right, -8);
is (sprintf("%7.3f", $node->distance), "  1.800");

$node = $tree->get(10);
is ($node->left, -10);
is ($node->right, -3);
is (sprintf("%7.3f", $node->distance), "  2.200");


# Basic clustering test, inter-cluster distance <= 1.5
my $clusters = $tree->cutthresh(1.5);
# Tree cointains only internal nodes
# Num of internal nodes is one less than leaf nodes
is ( scalar(@$clusters) - 1, $tree->length);
is   ($clusters->[0], $clusters->[9] );
isnt ($clusters->[0], $clusters->[11]);


done_testing;

