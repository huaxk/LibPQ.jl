using LibPQ
using GeoInterface: AbstractGeometry
using Test

@testset "Register new type" begin
    conn = LibPQ.Connection("dbname=gis user=gis password=gispass"; throw_error=false)
    oid = LibPQ.getTypeOid(conn, :geometry)
    @test oid != nothing
    # @test LibPQ.registerType(:geometry, oid, AbstractGeometry)
end
