function configure(output_dir="./")
    all_data_dir = string(output_dir, "output")
    summary_data_dir = string(output_dir, "summary")
    
    !isdir(all_data_dir)     && mkdir(all_data_dir)
    !isdir(summary_data_dir) && mkdir(summary_data_dir)

    # println("Using ", Threads.nthreads(), " threads.")
end

function saveData(output_dir="./")

    configure()

    NFUNS = 8
    NRUNS = 31

    errors_UL = zeros(NFUNS, NRUNS)
    errors_LL = zeros(NFUNS, NRUNS)

    evals_UL = zeros(NFUNS, NRUNS)
    evals_LL = zeros(NFUNS, NRUNS)


    for fnum = 1:8
        
        F, f, bounds_ul, bounds_ll = getBilevel(fnum)
        for i = 1:NRUNS

            P, best, iters, nevals_ul, nevals_ll = optimize(F, f, bounds_ul = bounds_ul, bounds_ll=bounds_ll)
        
            @printf("SMD%d \t F = %e \t f = %e \t ev_ul = %d \t ev_ll = %d\n", fnum, best.F, best.f, nevals_ul, nevals_ll)

            errors_UL[fnum, i] = best.F; errors_LL[fnum, i] = best.f
            evals_UL[fnum, i] = nevals_ul
            evals_LL[fnum, i] = nevals_ll
        end

        println("-----------------------------------------------")

    end

    writedlm("output/accuracy_UL.csv", errors_UL, ',')
    writedlm("output/accuracy_LL.csv", errors_LL, ',')

    writedlm("output/evals_UL.csv", evals_UL, ',')
    writedlm("output/evals_LL.csv", evals_LL, ',')

    ##
    println("Upper level")
    statsToLatex("output/accuracy_UL.csv"; mapping= x->abs.(x))
    println("-------------------------------------------------")

    println("Lower level")
    statsToLatex("output/accuracy_LL.csv"; mapping= x->abs.(x))
    println("-------------------------------------------------")


    println("Evaluations")
    statsToLatex("output/evals_UL.csv"; mapping= x->abs.(x))
    println("-------------------------------------------------")


end