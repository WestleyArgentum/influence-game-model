
require("./src/influence-game.jl")
using InfluenceGame

ateam = create_team(InfluenceGame.game, "A Team")

all_industry_codes = [ id for (id, data) in InfluenceGame.game.industries ]
add_industries(ateam, all_industry_codes)

while step(InfluenceGame.game) end

industries = [ industry for (id, industry) in InfluenceGame.game.industries ]
sort!(industries; lt = (lhs, rhs) -> lhs["score"] < rhs["score"])
