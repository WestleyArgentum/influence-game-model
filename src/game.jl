
type Game
    teams
    scoring_system
    industries
    bills
    timeline

    function Game(bill_data_file, industry_data_file)
        bills = JSON.parse(readall(bill_data_file))
        industries = build_industry_list(industry_data_file)
        timeline = build_timeline(bills)

        new(Team[], ScoringSystem(), industries, bills, timeline)
    end
end

type ScoringSystem
    support_passed
    opposed_passed
    support_failed
    oppose_failed
    support_introduced
    oppose_introduced

    ScoringSystem(s_p = 12, o_p = -6, s_f = -6, o_f = 12, s_i = 1, o_i = 3) = new(s_p, o_p, s_f, o_f, s_i, o_i)
end

function create_team(g::Game, name)
    last(push!(g.teams, Team(g, length(g.teams) + 1, name)))
end

add_industry_to_team(g::Game, teamid, industry) = add_industries(g.teams[teamid], industry)
add_industries_to_team(g::Game, teamid, industries) = add_industries(g.teams[teamid], industries)

function filter_overlapping_votes(bills)
    overlap = Any[]
    for (k,v) in bills
        for (k2,v2) in bills
            if k != k2 && v["num"] == v2["num"] && v["prefix"] == v2["prefix"]
                if !([k, k2] in overlap) && !([k2, k] in overlap)
                    push!(overlap, [k, k2])
                end
            end
        end
    end

    for (id1, id2) in overlap
        (haskey(bills, id1) && haskey(bills, id2)) || continue

        passed1 = get(bills[id1], "dateVote", -1)
        passed2 = get(bills[id2], "dateVote", -2)
        if passed1 == passed2
            delete!(bills, id1)
        end
    end

    bills
end

function filter_has_votes(bills)
    bills_with_votes = filter((k,b)->get(b, "action", "") == "passage", bills)
end

function build_timeline(bills)
    bills_with_votes = filter_has_votes(bills)
    bill_unique = filter_overlapping_votes(bills_with_votes)

    timeline = PriorityQueue()
    for (aid, bill) in bill_unique
        enqueue!(timeline, ["introduced", aid], bill["dateIntroduced"])
        enqueue!(timeline, ["vote", aid], bill["dateVote"])
    end

    timeline
end

function build_industry_list(industry_data_file)
    data = JSON.parse(readall(industry_data_file))
    { id => { "details" => details, "score" => 0, "events" => Any[] } for (id, details) in data }
end

function score_change(system::ScoringSystem, action_type, action, position)
    if action_type == "vote"
        if action["passed"]
            position == "support" ? system.support_passed : system.opposed_passed
        else
            position == "support" ? system.support_failed : system.oppose_failed
        end
    elseif action_type == "introduced"
        position == "support" ? system.support_introduced : system.oppose_introduced
    end
end

function score_industries(system::ScoringSystem, event, action, industries, position)
    for id in action["positions"][position]
        industry = industries[id]
        industry["score"] += score_change(system, first(event), action, position)
        push!(industry["events"], event)
    end
end

function step(g::Game)
    isempty(g.timeline) && return false

    event = dequeue!(g.timeline)
    action = g.bills[last(event)]

    score_industries(g.scoring_system, event, action, g.industries, "support")
    score_industries(g.scoring_system, event, action, g.industries, "oppose")

    true
end
