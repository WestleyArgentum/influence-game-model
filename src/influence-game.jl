
module InfluenceGame

export create_team, step, add_industry, add_industries, score

using Base.Collections
using JSON

include("team.jl")
include("game.jl")

game_path = dirname(@__FILE__)
bill_data_path = joinpath(game_path, "../data/112th-bills.json")
industries_path = joinpath(game_path, "../data/crp-categories.json")

game = Game(bill_data_path, industries_path)

end
