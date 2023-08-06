require 'dry-types'

module Types
  include Dry.Types()
    NameSuffixType = Strict::String.enum('B.A.', 'B.F.A.', 'B.F.D', 'B.M.', 'B.S.', 'B.S.E.E.', 'D.A.', 'D.B.A.', 'D.D.S.', 'D.M.L.', 'D.Min.','D.P.T.', 'Ed.D.', 'Ed.M.', 'J.D.', 'M.A.', 'M.B.A.', 'M.Div.', 'M.F.A.', 'M.D.', 'M.M.', 'M.P.A.', 'M.Phil.', 'M.S.', 'M.S.A.', 'M.S.E.E.', 'M.S.L.I.S.', 'M.S.P.T.', 'M.Th.', 'Ph.D.', 'R.N.', 'S.T.M.', 'Th.D.').freeze
end