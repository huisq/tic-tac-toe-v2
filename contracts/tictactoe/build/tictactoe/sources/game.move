module tictactoe::game{
    use tictactoe::schema::{Self, Schema};
    use tictactoe::errors;
    use tictactoe::events;

/// The state of an active game of tic-tac-toe.
public struct Game has key {
    id: UID,
    /// Marks on the board.
    board: vector<u8>,
    /// The next turn to be played.
    turn: u8,
    /// The address expected to send moves on behalf of X.
    x: address,
    /// The address expected to send moves on behalf of O.
    o: address,
}

// === Constants ===

// Marks
const MARK__: u8 = 0;
const MARK_X: u8 = 1;
const MARK_O: u8 = 2;

// Game status
const ONGOING: u8 = 0;
const DRAW: u8 = 1;
const WON: u8 = 2;


// === Public Functions ===

/// Create a new game, played by `x` and `o`. This function should be called
/// by the address responsible for administrating the game.
public fun new(x: address, o: address, ctx: &mut TxContext) {
    transfer::share_object(Game {
        id: object::new(ctx),
        board: vector[MARK__, MARK__, MARK__, MARK__, MARK__, MARK__, MARK__, MARK__, MARK__],
        turn: 0,
        x,
        o,
    });
}

/// Called by the next player to add a new mark.
public fun place_mark(leaderboard: &mut Schema, game: &mut Game, row: u8, col: u8, ctx: &mut TxContext) {
    errors::game_already_finished_error(game.ended() == ONGOING);
    errors::invalid_location_error(row < 3 && col < 3);

    // Confirm that the mark is from the player we expect.
    let (me, sentinel) = game.next_player();
    errors::wrong_player_error(me == ctx.sender());

    errors::already_filled_error(game[row, col] == MARK__);

    *(&mut game[row, col]) = sentinel;
    game.turn = game.turn + 1;

    // Check win condition -- if there is a winner, send them the trophy.
    let end = game.ended();
    if (end == WON) {
        let winner_new_total = update_leaderboard(leaderboard, me);
        events::game_won_event(me, winner_new_total);
    } else if (end == DRAW) {
        events::game_won_event(@0x0, 0);
    } 
}

// === Private Helpers ===

/// Address of the player the move is expected from, and the mark to use for the upcoming move.
fun next_player(game: &Game): (address, u8) {
    if (game.turn % 2 == 0) {
        (game.x, MARK_X)
    } else {
        (game.o, MARK_O)
    }
}

/// Test whether the values at the triple of positions all match each other
/// (and are not all EMPTY).
fun test_triple(game: &Game, x: u8, y: u8, z: u8): bool {
    let x = game.board[x as u64];
    let y = game.board[y as u64];
    let z = game.board[z as u64];

    MARK__ != x && x == y && y == z
}

/// Update leaderboard
fun update_leaderboard(scores: &mut Schema, winner: address): u256{
    if(schema::borrow_scores(scores).contains(winner)){
        let score = *schema::borrow_scores(scores).get(winner) + 1;
        schema::scores(scores).set(winner, score);
        score
    }else{
         schema::scores(scores).set(winner, 1);
        1
    }
}

public fun burn(game: Game) {
    errors::game_not_finished_error(game.ended() != ONGOING);
    let Game { id, .. } = game;
    id.delete();
}

/// Test whether the game has reached an end condition or not.
public fun ended(game: &Game): u8 {
    if (// Test rows
        test_triple(game, 0, 1, 2) ||
            test_triple(game, 3, 4, 5) ||
            test_triple(game, 6, 7, 8) ||
            // Test columns
            test_triple(game, 0, 3, 6) ||
            test_triple(game, 1, 4, 7) ||
            test_triple(game, 2, 5, 8) ||
            // Test diagonals
            test_triple(game, 0, 4, 8) ||
            test_triple(game, 2, 4, 6)) {
        WON
    } else if (game.turn == 9) {
        DRAW
    } else {
        ONGOING
    }
}


#[syntax(index)]
public fun mark(game: &Game, row: u8, col: u8): &u8 {
    &game.board[(row * 3 + col) as u64]
}

#[syntax(index)]
fun mark_mut(game: &mut Game, row: u8, col: u8): &mut u8 {
    &mut game.board[(row * 3 + col) as u64]
}


}

