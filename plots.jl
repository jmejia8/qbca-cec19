using Plots
using JLD
using Bilevel

pyplot(legend=false)

function stateToList(data::Bilevel.State)
    Fs = Real[]
    fs = Real[]
    ul_evals = Int[]
    ll_evals = Int[]
    for s = data.convergence
        push!(Fs, s.best_sol.F)
        push!(fs, s.best_sol.f)
        push!(ul_evals, s.F_calls)
        push!(ll_evals, s.f_calls)
    end
    return Fs, fs, ul_evals, ll_evals    
end

function plotConvergence(data::Bilevel.State)
    Fs, fs, ul_evals, ll_evals = stateToList(data)

    l = @layout [a b; c]
    p1 = plot(ul_evals, Fs, color=:black, title="UL convergence", xlabel="F calls")
    p2 = plot(ll_evals, fs, color=:black, title="LL convergence", xlabel="f calls")
    p3 = plot(fs .+ 0.05Fs, color=:black, title="\$\\varphi_f\$ convergence")
    plot(p1, p2, p3, layout=l)

end

function plotConvergence(data_list::Array)
   
    p1 = plot(title="UL convergence", xlabel="F calls")
    p2 = plot(title="LL convergence", xlabel="f calls")
    p3 = plot(title="\$\\varphi_f\$ convergence")
    for data = data_list
        Fs, fs, ul_evals, ll_evals = stateToList(data)
        plot!(p1, ul_evals, Fs, color=:black)
        plot!(p2, ll_evals, fs, color=:black)
        plot!(p3, fs .+ 0.05Fs, color=:black)
    end
    
    l = @layout [a b; c]
    plot(p1, p2, p3, layout=l)
end

function main()
    l = load("output/SMD_2_3/SMD6.jld")
    result_list = l["result_list"]

    plotConvergence(result_list)
end

main()