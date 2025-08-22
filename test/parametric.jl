using MathematicalSystems, Test

# dummy set types for testing
struct MyMatrixSet
    n::Int
end
Base.size(s::MyMatrixSet, i::Int) = s.n

struct MyOtherMatrixSet
    n::Int
    m::Int
end
Base.size(s::MyOtherMatrixSet, i::Int) = i == 1 ? s.n : s.m

@testset "Parametric linear systems" begin
    # continuous
    As = MyMatrixSet(2)
    s = @system(x' = A*x, A ∈ As)
    @test s isa LinearParametricContinuousSystem
    @test s.A == As
    @test statedim(s) == 2

    # discrete
    As = MyMatrixSet(3)
    s = @system(x⁺ = A*x, A ∈ As)
    @test s isa LinearParametricDiscreteSystem
    @test s.A == As
    @test statedim(s) == 3
end

@testset "Parametric linear control systems" begin
    # continuous
    As = MyMatrixSet(2)
    Bs = MyOtherMatrixSet(2, 1)
    s = @system(x' = A*x + B*u, A ∈ As, B ∈ Bs)
    @test s isa LinearControlParametricContinuousSystem
    @test s.A == As
    @test s.B == Bs
    @test statedim(s) == 2
    @test inputdim(s) == 1

    # discrete
    As = MyMatrixSet(3)
    Bs = MyOtherMatrixSet(3, 2)
    s = @system(x⁺ = A*x + B*u, A ∈ As, B ∈ Bs)
    @test s isa LinearControlParametricDiscreteSystem
    @test s.A == As
    @test s.B == Bs
    @test statedim(s) == 3
    @test inputdim(s) == 2
end
