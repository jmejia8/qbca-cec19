using BilevelBenchmark
using Bilevel
using CSVanalyzer
import DelimitedFiles.writedlm
import Printf.@printf

include("tools.jl")

function getBilevel(fnum; D_ul = 5, D_ll = 5)

    bounds_ul, bounds_ll = SMD_ranges(D_ul, D_ll, fnum)

    # leader
    F(x::Array{Float64}, y::Array{Float64}) =  SMD_leader(x, y, fnum)

    # follower
    f(x::Array{Float64}, y::Array{Float64}) = SMD_follower(x, y, fnum)

    return F, f, bounds_ul, bounds_ll

end

function test(D_ul, D_ll)
    for fnum = 1:8
        F, f, bounds_ul, bounds_ll = getBilevel(fnum; D_ul=D_ul, D_ll=D_ll)
        method = QBCA(size(bounds_ul, 2); options = Bilevel.Options(F_tol=1e-4, f_tol=1e-4))
        result = optimize(F, f, bounds_ul, bounds_ll, method, Bilevel.Information(F_optimum=0.0, f_optimum=0.0))
        b   = result.best_sol
        iters  = result.iteration
        nevals_ul = result.F_calls
        nevals_ll = result.f_calls
        
        @printf("SMD%d \t F = %e \t f = %e \t ev_ul = %d \t ev_ll = %d\n", fnum, b.F, b.f, nevals_ul, nevals_ll)
    end

end

test(2, 3)
# test(5, 5)
