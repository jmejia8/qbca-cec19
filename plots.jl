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
    p1 = plot(ul_evals, Fs, title="UL convergence")
    p2 = plot(ll_evals, fs, title="LL convergence")
    p3 = plot(fs .+ 0.05Fs, title="\$\\varphi\$ convergence")
    plot(p1, p2, p3, layout=l)

end