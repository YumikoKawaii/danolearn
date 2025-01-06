use aiken/collection/dict
use aiken/interval
use cardano/address
use cardano/assets
use cardano/transaction.{
  InlineDatum, Input, Output, OutputReference, Spend, Transaction,
}
use executor
use types.{VotingDatum}

const out_ref =
  OutputReference {
    transaction_id: #"d95a8085d388b8b2e19efa90ebabd3b7c10a1f9b23050a40207fff6c6217bdd6",
    output_index: 0,
  }

const pid = #"f4c9f9c4252d86702c2f4c2e49e6648c7cffe3c8f2b6b7d779788f50"

const asset_name = #"4e677579656e2e4242"

test success_valid_voting_datum() {
  let input =
    Input {
      output_reference: out_ref,
      output: Output {
        address: address.from_verification_key("vkey"),
        value: assets.from_lovelace(2_000_000)
          |> assets.add(pid, asset_name, 10),
        datum: InlineDatum(VotingDatum { pid, asset_name, qty: 5 }),
        reference_script: None,
      },
    }

  let rdmr: Data = 1

  let tx =
    Transaction {
      inputs: [input],
      reference_inputs: [],
      outputs: [],
      fee: 0,
      mint: assets.zero,
      certificates: [],
      withdrawals: [],
      validity_range: interval.between(100, 125),
      extra_signatories: [],
      redeemers: [Pair(Spend(out_ref), rdmr)],
      datums: dict.empty,
      id: #"0000000000000000000000000000000000000000000000000000000000000000",
      votes: [],
      proposal_procedures: [],
      current_treasury_amount: None,
      treasury_donation: None,
    }

  executor.execute.spend(None, None, out_ref, tx)
}
