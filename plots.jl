using Plots
pyplot(legend=false)

function plotConvergence(data)
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

    l = @layout [a b; c]
    p1 = plot(color=:black, title="UL convergence", xlabel="F calls")
    p2 = plot(color=:black, title="LL convergence", xlabel="f calls")
    p3 = plot(fs .+ 0.05Fs, color=:black, title="\$\\varphi_f\$ convergence")
    plot(p1, p2, p3, layout=l)

end