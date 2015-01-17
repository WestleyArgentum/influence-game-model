
require("./src/influence-game.jl")
using InfluenceGame


game_path = dirname(@__FILE__)
bill_data_112 = joinpath(game_path, "./data/112th-bills.json")
bill_data_113 = joinpath(game_path, "./data/113th-bills.json")
industries_path = joinpath(game_path, "./data/crp-categories.json")

# 112th data
game_112 = Game(bill_data_112, industries_path)

ateam_112 = create_team(game_112, "A Team")

all_industry_codes = [ id for (id, data) in game_112.industries ]
add_industries(ateam_112, all_industry_codes)

while step(game_112) end

industries_112 = [ industry for (id, industry) in game_112.industries ]
sort!(industries_112; lt = (lhs, rhs) -> lhs["score"] > rhs["score"])


# 113th data
game_113 = Game(bill_data_113, industries_path)

ateam_113 = create_team(game_113, "A Team")

all_industry_codes = [ id for (id, data) in game_113.industries ]
add_industries(ateam_113, all_industry_codes)

while step(game_113) end

industries_113 = [ industry for (id, industry) in game_113.industries ]
sort!(industries_113; lt = (lhs, rhs) -> lhs["score"] > rhs["score"])
