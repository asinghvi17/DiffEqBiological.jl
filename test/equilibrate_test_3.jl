#Tests on the networks requiring fixed concentrations.
for rn in reaction_networks_fixed_conc
    p_vals = map(amp->amp*rand(length(rn.params)),[1.,10.,100.])
    for p in p_vals
        fps = steady_states(rn,p)
        stab = map(fp->stability(fp,p,rn), fps)
        for i=1:length(fps)
            stab[i] ? (tend = 10) : (tend = -10)
            end_point = OrdinaryDiffEq.solve(ODEProblem(rn,fps[i],(0.,tend),p),Rosenbrock23())[end]
            @test maximum(end_point-fps[i])<0.0001
        end
    end
end