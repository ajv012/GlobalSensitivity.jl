using GlobalSensitivity, Test, StableRNGs

function ishi_batch(X)
    A = 7
    B = 0.1
    @. sin(X[1, :]) + A * sin(X[2, :])^2 + B * X[3, :]^4 * sin(X[1, :])
end
function ishi(X)
    A = 7
    B = 0.1
    sin(X[1]) + A * sin(X[2])^2 + B * X[3]^4 * sin(X[1])
end

function linear_batch(X)
    A = 7
    B = 0.1
    @. A * X[1, :] + B * X[2, :]
end
function linear(X)
    A = 7
    B = 0.1
    A * X[1] + B * X[2]
end

lb = -ones(4) * π
ub = ones(4) * π

rng = StableRNG(123)
# res1 = gsa(ishi,GlobalSensitivity.RBDFAST(), num_params = 4, samples=5000, rng=rng)
# res2 = gsa(ishi_batch,RBDFAST(),samples=1000, batch=true, rng=rng)

# res1efast = gsa(ishi,eFAST(),[[lb[i],ub[i]] for i in 1:4],n=15000)
# res2efast = gsa(ishi_batch,eFAST(),[[lb[i],ub[i]] for i in 1:4],n=15000,batch=true)

# @test res1 ≈ res1efast.S1[1,:] atol = 3e-2
# @test res2.S1 ≈ res2efast.S1[1,:] atol = 3e-2

res1 = gsa(linear, GlobalSensitivity.RBDFAST(), num_params = 4, samples = 15000)
res2 = gsa(linear_batch, GlobalSensitivity.RBDFAST(), num_params = 4, batch = true,
           samples = 15000)

res1efast = gsa(linear, eFAST(), [[lb[i], ub[i]] for i in 1:4], samples = 15000)
res2efast = gsa(linear_batch, eFAST(), [[lb[i], ub[i]] for i in 1:4], batch = true,
                samples = 15000)

@test res1≈res1efast.S1[1, :] atol=3e-2
@test res2≈res2efast.S1[1, :] atol=3e-2
