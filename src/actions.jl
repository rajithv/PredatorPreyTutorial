# Agent-step function for agents of the type "Sheep"
function sheepwolf_step!(sheep::Sheep, model)
    walk!(sheep, rand, model) # walk!(agent, direction::NTuple, model; ifempty = false)
    sheep.energy -= 1
    if sheep.energy < 0
        kill_agent!(sheep, model)
        return
    end
    eat!(sheep, model)
    if rand(model.rng) ≤ sheep.reproduction_prob
        reproduce!(sheep, model)
    end
end

# Agent-step function for agents of the type "Wolf"
function sheepwolf_step!(wolf::Wolf, model)
    walk!(wolf, rand, model)
    wolf.energy -= 1
    if wolf.energy < 0
        kill_agent!(wolf, model)
        return
    end
    # If there is any sheep on this grid cell, it's dinner time!
    dinner = first_sheep_in_position(wolf.pos, model)
    !isnothing(dinner) && eat!(wolf, dinner, model)
    if rand(model.rng) ≤ wolf.reproduction_prob
        reproduce!(wolf, model)
    end
end

# Select a sheep for dinner
function first_sheep_in_position(pos, model)
    ids = ids_in_position(pos, model)
    j = findfirst(id -> model[id] isa Sheep, ids)
    isnothing(j) ? nothing : model[ids[j]]::Sheep
end

# Eat function for Agents of the type "Sheep"
function eat!(sheep::Sheep, model)
    if model.fully_grown[sheep.pos...]
        sheep.energy += sheep.Δenergy
        model.fully_grown[sheep.pos...] = false
    end
    return
end

# Eat function for Agents of the type "Wolf"
function eat!(wolf::Wolf, sheep::Sheep, model)
    kill_agent!(sheep, model)
    wolf.energy += wolf.Δenergy
    return
end
# Reproducing function for agents (for both agent types)
function reproduce!(agent::A, model) where {A}
    agent.energy /= 2
    id = nextid(model)
    offspring = A(id, agent.pos, agent.energy, agent.reproduction_prob, agent.Δenergy)
    add_agent_pos!(offspring, model)
    return
end

# The model step function that maintains grass growth
function grass_step!(model)
    @inbounds for p in positions(model) # we don't have to enable bound checking
        if !(model.fully_grown[p...])
            if model.countdown[p...] ≤ 0
                model.fully_grown[p...] = true
                model.countdown[p...] = model.regrowth_time
            else
                model.countdown[p...] -= 1
            end
        end
    end
end