import { DubheConfig } from '@0xobelisk/sui-common';

export const dubheConfig = {
  name: 'tictactoe',
  description: 'sui_dubhe_version',
  errors: {
    InvalidLocation: 'Move was for a position that doesnt exist on the board',
		WrongPlayer: 'Game expected a move from another player',
		AlreadyFilled: 'Attempted to place a mark on a filled slot',
		GameNotFinished: 'Game has not reached an end condition',
		GameAlreadyFinished: 'Cant place a mark on a finished game',
  },
  events: {
    GameWon: {
			player: 'address',
			player_new_total_score: 'u256',
		},
  },
  schemas: {
    leaderboard: 'StorageMap<address, u256>',
    }
} as DubheConfig;