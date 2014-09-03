my @board = (".", ".", ".", ".", ".", ".", ".", ".",
			".", ".", ".", ".", ".", ".", ".", ".",
			".", ".", ".", ".", ".", ".", ".", ".",
			".", ".", ".", ".", ".", ".", ".", ".",
			".", ".", ".", ".", ".", ".", ".", ".",
			".", ".", ".", ".", ".", ".", ".", ".",
			".", ".", ".", ".", ".", ".", ".", ".",
			".", ".", ".", ".", ".", ".", ".", ".");


sub addPieceSpace { # Adds a space after every piece on the board to look better when printed
	@boardCopy = @board;
	for (my $i = 0; $i < 64; $i++) {
		$boardCopy[$i] = $boardCopy[$i] . " ";
	}
	return @boardCopy;
}

sub printBoard { # Print the board
	my @boardCopy = addPieceSpace();
	
	print("\n     A B C D E F G H    \n\n"); # Add File labels 
	
	my $n = 8;
	for (my $i = 0; $i < 8 * 9; $i += 10) { # Add Rank labels to both sides of board
		splice(@boardCopy, $i, 0, "  $n  ");
		splice(@boardCopy, $i + 9, 0, " $n\n");
		$n--;
	}
	
	print(@boardCopy);
	
	print("\n     A B C D E F G H    \n\n"); # Add Bottom file labels 

}

sub fillNewBoard { # Adds the defualt pieces to the board
	
	# White pieces
	addPiece("A", 1, "R");
	addPiece("B", 1, "N");
	addPiece("C", 1, "B");
	addPiece("D", 1, "Q");
	addPiece("E", 1, "K");
	addPiece("F", 1, "B");
	addPiece("G", 1, "N");
	addPiece("H", 1, "R");
	
	addPiece("A", 2, "P");
	addPiece("B", 5, "P");
	addPiece("C", 2, "P");
	addPiece("D", 2, "P");
	addPiece("E", 2, "P");
	addPiece("F", 2, "P");
	addPiece("G", 2, "P");
	addPiece("H", 2, "P");
	
	# Black pieces
	addPiece("A", 8, "r");
	addPiece("B", 8, "n");
	addPiece("C", 8, "b");
	addPiece("D", 8, "q");
	addPiece("E", 8, "k");
	addPiece("F", 8, "b");
	addPiece("G", 8, "n");
	addPiece("H", 8, "r");
	
	addPiece("A", 7, "p");
	addPiece("B", 7, "p");
	addPiece("C", 7, "p");
	addPiece("D", 7, "p");
	addPiece("E", 7, "p");
	addPiece("F", 7, "p");
	addPiece("G", 7, "p");
	addPiece("H", 7, "p");
}

sub alToIn { # algebraic to index
	my ($file, $rank) = @_;
	my %fileLookup = ('A' => 0, 'B' => 1, 'C' => 2, 'D' => 3, 'E' => 4, 'F' => 5, 'G' => 6, 'H' => 7);
	return ((8 - $rank) * 8 + $fileLookup{$file});
}

sub addPiece { # Add a piece to a particular file and rank returns piece in that location
	my ($file, $rank, $piece) = @_;
	my $currentPieceInSquare = boardLookup($file, $rank);
	@board[alToIn($file, $rank)] = $piece;
	return $currentPieceInSquare;
}

sub delPiece { # Remove a piece from the board
	my ($file, $rank) = @_;
	@board[alToIn($file, $rank)] = ".";
}

sub splitFileRank { # Takes a string e.g "e5" and returns them seperatly
	my $fileRankString = $_[0];
	return (substr($fileRankString, 0, 1), substr($fileRankString, 1, 2));
}

sub splitMove { # Split a move e.g. E5E6 into from (E5) and to (E6)
	my $move = $_[0];
	my $from = substr($move, 0, 2);
	my $to = substr($move, 2, 2);
	return ($from, $to);
}

sub boardLookup { # Returns the piece which lies at a particular file and rank
	my ($file, $rank) = @_;
	return @board[alToIn($file, $rank)];
}

sub movePiece { # Move a piece
	my $move = $_[0];
	my ($moveFrom, $moveTo) = splitMove($move);
	
	my ($toFile, $toRank) = splitFileRank($moveTo);
	my ($fromFile, $fromRank) = splitFileRank($moveFrom);

	my $piece = boardLookup($fromFile, $fromRank);

	# TODO: Check if move is valid
	if (validMove($moveFrom, $moveTo, $piece)) {
		addPiece($toFile, $toRank, $piece);
		delPiece($fromFile, $fromRank);

	} else {
		return 0;
	}
}

sub validMove { # Determin if a move is valid or not
	my ($moveFrom, $moveTo, $piece) = @_;
		
	# TODO: add valid move detection for all pieces
	if ($piece ne ".") {
		if (lc($piece) == 'p') { # If the piece is a pawn
			return pawnValidMove($moveFrom, $moveTo, $piece);
		}
	} 
}

sub canTake {
	my ($from, $to) = @_;
	my ($fromFile, $fromRank) = splitFileRank($from);
	my ($toFile, $toRank) = splitFileRank($to);
	
	my $attacker = boardLookup($fromFile, $fromRank);
	my $piece = boardLookup($toFile, $toRank);
		
	# Check if the pieces have opposite cases
	if ($piece eq ".") {
		return 0;
	} elsif (($attacker eq uc $attacker) && ($piece eq lc $piece)) {
		return 1;
	} elsif (($attacker eq lc $attacker) && ($piece eq uc $piece)) {
		return 1;
	} else {
		return 0;
	}
}

sub getColour {
	$piece = $_[0];
	if ($piece eq uc($piece)) {
		return "white";
	} else {
		return "black";
	}
}

sub getFile { # Returns all sqaures which lie in a file
	my $file = $_;
	my @squares = ();
	for (my $rank = 1; $rank < 8; $rank++) {
		push(@squares, $file . $rank);
	}
	return @squares;	
}

sub getRank { # Returns all squares which lie in a rank
	my $rank = $_;
	my @squares = ();
	foreach(my $file ("A".."H")) {
		push(@squares, $file . $rank);
	} 
}

sub getDiaginals { #TODO:
	my ($file, $rank) = @_;
} 

sub pawnValidMove {
	my ($from, $to, $piece) = @_;
	my ($fromFile, $fromRank) = splitFileRank($from);
	my ($toFile, $toRank) = splitFileRank($to);
	my $colour = getColour($piece);
			
	# Check direction	
	if (($colour eq "white") && ($fromRank >= $toRank)) {
		return 0;
	} 
	if (($colour eq "black") && ($fromRank <= $toRank)) {
		return 0;
	}
	
	# Check if diaginal
	# TODO: Check if the file is on either side!
	if ($fromFile ne $toFile) { # If moving to another file
		if (abs($fromRank - $toRank) == 1) { # if moving one space
			if (canTake($from, $to)) {
				# Do nothing
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	}

	# Check number of spaces moved
	if (abs($fromRank - $toRank) == 2) {
		if ($fromRank == 2 || $fromRank == 7) {
			# Do nothing
		} else {
			return 0;
		}
	} elsif (abs($fromRank - $toRank) == 1) {
		# Do nothing
	} else {
		return 0;
	}
	# Check if path is clear
	return 1;	
}

fillNewBoard();
printBoard();
movePiece("B5B4");
movePiece("C7C6");
movePiece("B5A6");
printBoard();
