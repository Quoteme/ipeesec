import Lake
open Lake DSL

package «ipeesec» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩, -- pretty-prints `fun a ↦ b`
    ⟨`pp.proofs.withType, false⟩
  ]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.36.0"

lean_lib «Ipeesec» where

@[default_target]
lean_exe «ipeesec» where
  root := `Main
