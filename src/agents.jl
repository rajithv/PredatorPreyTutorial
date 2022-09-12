# Agent declarations using the @agent macro
## https://juliadynamics.github.io/Agents.jl/dev/tutorial/#Agents.@agent
## GridAgent{D} <: AbstractAgent, where D is the Dimensions

@agent Sheep GridAgent{2} begin
    energy::Float64
    reproduction_prob::Float64
    Δenergy::Float64
end

@agent Wolf GridAgent{2} begin
    energy::Float64
    reproduction_prob::Float64
    Δenergy::Float64
end
