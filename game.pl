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
	addPiece("B", 2, "P");
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

sub delPiece {
	my ($file, $rank) = @_;
	@board[alToIn($file, $rank)] = ".";
}

sub splitFileRank { # Takes a string e.g "e5" and returns them seperatly
	my $fileRankString = $_;
	return ($fileRankString[0], $fileRankString[1]);
}

sub boardLookup { # Returns the piece which lies at a particular file and rank
	my ($file, $rank) = @_;
	return @board[alToIn($file, $rank)];
}

fillNewBoard();
printBoard();