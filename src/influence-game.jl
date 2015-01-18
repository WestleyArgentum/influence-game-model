
module InfluenceGame

export Game, ScoringSystem, create_team, step, add_industry, add_industries, score

using Base.Collections
using JSON

include("team.jl")
include("game.jl")

end
