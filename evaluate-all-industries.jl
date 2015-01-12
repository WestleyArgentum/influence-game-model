
require("./src/influence-game.jl")
using InfluenceGame

ateam = create_team(InfluenceGame.game, "A Team")

all_industries = [ id for (id, data) in InfluenceGame.game.industries ]
add_industries(ateam, all_industries)


