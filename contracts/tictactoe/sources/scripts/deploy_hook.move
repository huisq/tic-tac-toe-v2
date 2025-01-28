#[allow(lint(share_owned), unused_let_mut)]module tictactoe::deploy_hook {

  use std::ascii::string;

  use sui::clock::Clock;

  use tictactoe::dapp_system;

  public entry fun run(clock: &Clock, ctx: &mut TxContext) {
    // Create a dapp.
    let mut dapp = dapp_system::create(string(b"tictactoe"),string(b"sui_dubhe_version"), clock , ctx);
    // Create schemas
    let mut schema = tictactoe::schema::create(ctx);
    // Logic that needs to be automated once the contract is deployed
    {
			};
    // Authorize schemas and public share objects
    dapp.add_schema(schema);
    sui::transfer::public_share_object(dapp);
  }
}
