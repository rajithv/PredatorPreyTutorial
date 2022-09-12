## This code has been adapted from:
## https://juliadynamics.github.io/Agents.jl/v5.4/examples/predator_prey/

module PredatorPreyTutorial

# External Packages that we make use of
using Agents
using Random
using CairoMakie

# Other source files from our project
include("agents.jl")
include("actions.jl")
include("model.jl")


# Setting up data collection

## Monitoring functions for data collection
sheep(a) = a isa Sheep
wolf(a) = a isa Wolf
count_grass(model) = count(model.fully_grown)

## Agent-data and Model-data collected separately
adata = [(sheep, count), (wolf, count)]
mdata = [count_grass]

# Run the model

## Set-up the model with default parameters
sheepwolfgrass = initialize_model()

## Step count for the model run
steps = 1000

## Run the model! And Collect the data into the two specified dataframes
adf, mdf = run!(sheepwolfgrass, sheepwolf_step!, grass_step!, steps; adata, mdata)

# Plots

## Setting up the plots as a function
function plot_population_timeseries(adf, mdf)
    figure = Figure(resolution = (600, 400))
    ax = figure[1, 1] = Axis(figure; xlabel = "Step", ylabel = "Population")
    sheepl = lines!(ax, adf.step, adf.count_sheep, color = :cornsilk4)
    wolfl = lines!(ax, adf.step, adf.count_wolf, color = RGBAf(0.2, 0.2, 0.3))
    grassl = lines!(ax, mdf.step, mdf.count_grass, color = :green)
    figure[1, 2] = Legend(figure, [sheepl, wolfl, grassl], ["Sheep", "Wolves", "Grass"])
    figure
end

## Now call the function with the collected data
plot_population_timeseries(adf, mdf)


# Stable Scenario

## define the parameters
stable_params = (;
    n_sheep = 140,
    n_wolves = 20,
    dims = (30, 30),
    Δenergy_sheep = 5,
    sheep_reproduce = 0.31,
    wolf_reproduce = 0.06,
    Δenergy_wolf = 30,
    seed = 71758,
)

## Initialise the model as before, but with our parameters
## then run the model
sheepwolfgrass = initialize_model(;stable_params...)
adf, mdf = run!(sheepwolfgrass, sheepwolf_step!, grass_step!, 2000; adata, mdata)

## Plot the newly collected data
plot_population_timeseries(adf, mdf)


end
