  // Copyright (c) Obelisk Labs, Inc.
  // SPDX-License-Identifier: Apache-2.0
  #[allow(unused_use)]
  
  /* Autogenerated file. Do not edit manually. */
  
  module tictactoe::errors {

  #[error]

  const InvalidLocation: vector<u8> = b"Move was for a position that doesnt exist on the board";

  public fun invalid_location_error(condition: bool) {
    assert!(condition, InvalidLocation)
  }

  #[error]

  const WrongPlayer: vector<u8> = b"Game expected a move from another player";

  public fun wrong_player_error(condition: bool) {
    assert!(condition, WrongPlayer)
  }

  #[error]

  const AlreadyFilled: vector<u8> = b"Attempted to place a mark on a filled slot";

  public fun already_filled_error(condition: bool) {
    assert!(condition, AlreadyFilled)
  }

  #[error]

  const GameNotFinished: vector<u8> = b"Game has not reached an end condition";

  public fun game_not_finished_error(condition: bool) {
    assert!(condition, GameNotFinished)
  }

  #[error]

  const GameAlreadyFinished: vector<u8> = b"Cant place a mark on a finished game";

  public fun game_already_finished_error(condition: bool) {
    assert!(condition, GameAlreadyFinished)
  }
}
