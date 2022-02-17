(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using MarinoApi
push!(Base.modules_warned_for, Base.PkgId(MarinoApi))
MarinoApi.main()
