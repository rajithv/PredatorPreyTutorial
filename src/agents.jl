# Agent declarations using the @agent macro

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
