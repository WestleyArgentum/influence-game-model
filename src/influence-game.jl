
module InfluenceGame

export create_team, step, add_industry, add_industries, score

using Base.Collections
using JSON

include("team.jl")
include("game.jl")

game = Game("./data/112th-bills.json", "./data/112th-industries.json")

end
