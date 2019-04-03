using BilevelBenchmark
using Bilevel
using CSVanalyzer
import DelimitedFiles.writedlm
import Printf.@printf
using JLD

include("tools.jl")
# include("plots.jl")

function getBilevel(fnum; D_ul = 5, D_ll = 5)

    bounds_ul, bounds_ll = SMD_ranges(D_ul, D_ll, fnum)

    # leader
    F(x::Array{Float64}, y::Array{Float64}) =  SMD_leader(x, y, fnum)

    # follower
    f(x::Array{Float64}, y::Array{Float64}) = SMD_follower(x, y, fnum)

    return F, f, bounds_ul, bounds_ll

end

function getQBCA(fnum, D_ul, D_ll)
    F, f, bounds_ul, bounds_ll = getBilevel(fnum; D_ul=D_ul, D_ll=D_ll)
    method = QBCA(size(bounds_ul, 2); options = Bilevel.Options(F_tol=1e-4, f_tol=1e-4, store_convergence=true))
    optimize(F, f, bounds_ul, bounds_ll, method, Bilevel.Information(F_optimum=0.0, f_optimum=0.0))
end

function main(D_ul, D_ll)
    configure()

    NRUNS = 31

    for fnum = 1:8
        result_list = []
        for r = 1:NRUNS

            result = getQBCA(fnum, D_ul, D_ll)

            # store data
            save("output/SMD_$(D_ul)_$(D_ll)/SMD$(fnum)_r$(r).jld", "result", result)
            push!(result_list, result)

            # show log
            b      = result.best_sol
            iters  = result.iteration
            nevals_ul = result.F_calls
            nevals_ll = result.f_calls

            @printf("SMD%d \t run = %d \t F = %e \t f = %e \t ev_ul = %d \t ev_ll = %d\n", fnum, r, b.F, b.f, nevals_ul, nevals_ll)
        end
        
        save("output/SMD_$(D_ul)_$(D_ll)/SMD$(fnum).jld", "result_list", result_list)
    end

end

# main(2, 3)
main(5, 5)
# test(5, 5)

# plotConvergence(getQBCA(5, 2, 3))
