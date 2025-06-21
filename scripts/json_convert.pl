use strict;
use warnings;
use JSON;
use utf8;
use Tie::IxHash;

my %rename = (
    "Property Name"   => "name",
    "Bytes"           => "bytes",
    "Type"            => "type",
    "Value range Min" => "value_min",
    "Value range Max" => "value_max",
    "Multiplier"      => "multiplier",
    "Units"           => "unit",
    "Description"     => "description",
    "Values"          => "values",
    "HW Support"      => "hw_support",
    "Parameter Group" => "group",
);

sub is_number {
    my $v = shift;
    return defined($v) && $v =~ /^-?\d+(\.\d+)?$/;
}

sub extract_values_from_description {
    my $desc = shift;
    my %values;
    # Match patterns like: 0 - Off, 1 - On (handles newlines and spaces)
    while ($desc =~ /(\d+)\s*[–-]\s*([^\d\n–-]+)/g) {
        my ($num, $label) = ($1, $2);
        $label =~ s/\s+$//; # Trim trailing spaces
        $values{$num} = $label;
    }
    return %values ? \%values : undef;
}

sub hw_support_to_array {
    my $hw = shift // '';
    my @arr = $hw =~ /(FM\w{3,})/g;
    return @arr ? \@arr : [];
}

my $json = do { local $/; <> };
my $data = decode_json($json);

my %out;
foreach my $item (@$data) {
    my %new;
    my $id = $item->{"Property ID in AVL packet"};
    foreach my $k (keys %$item) {
        next if $k eq "Property ID in AVL packet";
        my $nk = $rename{$k} // $k;
        my $v = $item->{$k};
        $v = $v+0 if is_number($v);
        $new{$nk} = $v;
    }
    # --- Multiplier handling ---
    if (exists $new{multiplier}) {
        my $m = $new{multiplier};
        if (defined $m) {
            # Trim whitespace and extract the first numeric value (integer or decimal)
            if ($m =~ /^\s*(?:-|–)\s*$/) {
                $new{multiplier} = undef;
            } elsif ($m =~ /(-?\d+(?:\.\d+)?)/) {
                $new{multiplier} = $1 + 0;
            } else {
                $new{multiplier} = undef;
            }
        }
    }
    $new{unit}       = undef if exists $new{unit}       && defined $new{unit}       && $new{unit} eq "-";
    if (!exists $new{values} && exists $new{description}) {
        my $vals = extract_values_from_description($new{description});
        $new{values} = $vals if $vals;
    }
    if (exists $new{values}) {
        my $vals = delete $new{values};
        my @keys = keys %new;
        my $i = 0;
        $i++ until $i > $#keys || $keys[$i] eq 'value_max';
        my @before = @keys[0..$i];
        my @after  = @keys[$i+1..$#keys];
        my %tmp;
        $tmp{$_} = $new{$_} for @before;
        $tmp{values} = $vals;
        $tmp{$_} = $new{$_} for @after;
        %new = %tmp;
    }
    $new{hw_support} = hw_support_to_array($new{hw_support}) if exists $new{hw_support};

    # --- Translation wrapping ---
    $new{name} = { en => $new{name} } if exists $new{name};
    $new{description} = { en => $new{description} } if exists $new{description};
    if (exists $new{values} && ref $new{values} eq 'HASH') {
        my %translated_values = map { $_ => { en => $new{values}->{$_} } } keys %{ $new{values} };
        $new{values} = \%translated_values;
    }
    # --- Sort values object numerically by key ---
    if (exists $new{values} && ref $new{values} eq 'HASH') {
        tie my %sorted_values, 'Tie::IxHash';
        for my $vk (sort { $a <=> $b } keys %{ $new{values} }) {
            $sorted_values{$vk} = $new{values}{$vk};
        }
        $new{values} = \%sorted_values;
    }
    # ---------------------------

    $out{$id} = \%new;
}

# Use Tie::IxHash to preserve insertion order
tie my %sorted_out, 'Tie::IxHash';

my @key_order = qw(
    name
    description
    type
    bytes
    value_min
    value_max
    values
    multiplier
    unit
    hw_support
    group
);

for my $id (sort { $a <=> $b } keys %out) {
    my $obj = $out{$id};
    my %sorted_obj;
    tie %sorted_obj, 'Tie::IxHash';
    for my $k (@key_order) {
        $sorted_obj{$k} = $obj->{$k} if exists $obj->{$k};
    }
    # Add any remaining keys not in @key_order
    for my $k (keys %$obj) {
        $sorted_obj{$k} = $obj->{$k} unless exists $sorted_obj{$k};
    }
    $sorted_out{$id} = \%sorted_obj;
}

my $json_obj = JSON->new->utf8->pretty;
print $json_obj->encode(\%sorted_out);
