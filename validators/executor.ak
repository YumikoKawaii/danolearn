use cardano/assets
use cardano/transaction.{
  InlineDatum, Input, Output, OutputReference, Transaction,
}
use types.{VotingDatum}

validator execute {
  spend(
    _datum: Option<Data>,
    _rdmr: Data,
    out_ref: OutputReference,
    Transaction { inputs, .. }: Transaction,
  ) {
    expect Some(Input {
      output: Output { value: in_value, datum: InlineDatum(in_dt), .. },
      ..
    }) = inputs |> transaction.find_input(out_ref)
    expect VotingDatum { pid, asset_name, qty } = in_dt
    assets.quantity_of(in_value, pid, asset_name) > qty
  }

  else(_) {
    fail
  }
}
