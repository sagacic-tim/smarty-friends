require 'dry-types'

module Types
  include Dry.Types()

  NameTitleType = Strict::String.enum('Adm.', 'Amb.', 'Baron', 'Brnss.', 'Bishop', 'Brig. Gen.', 'Br.', 'Cpt.', 'Capt.', 'Chan.', 'Chapln.', 'CPO', 'Cmdr.', 'Col.', 'Col. (Ret.)', 'Cpl.', 'Count', 'Countess', 'Dean', 'Dr.', 'Duke', 'Ens.', 'Fr.', 'Frau', 'Gen.', 'Gov.', 'Judge', 'Justice', 'Lord', 'Lt.', '2Lt.', '2dLt.', 'Lt. Cmdr.', 'Lt. Col.', 'Lt. Gen.', 'Lt. j.g.', 'Mlle.', 'Maj.', 'Master', 'Master Sgt.', 'Miss', 'Mme.', 'MIDN', 'M.', 'Msgr.', 'Mr.', 'Mrs.', 'Ms.', 'Mx.', 'Pres.', 'Princess', 'Prof.', 'Rabbi', 'R.Adm.', 'Rep.', 'Rev.', 'Rt.Rev.', 'Sgt.', 'Sen.', 'Sr.', 'Sra.', 'Srta.', 'Sheikh', 'Sir', 'Sr.', 'S. Sgt.', 'The Hon.', 'The Venerable', 'V.Adm.').freeze
end