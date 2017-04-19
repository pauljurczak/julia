# tests the output of the embedding example is correct
using Base.Test
let lines = readlines(STDIN)
    @test length(lines) == 6
    @test parse(Float64, lines[1]) ≈ sqrt(2)
end
