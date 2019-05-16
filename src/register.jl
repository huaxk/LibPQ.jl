function getTypeOid(conn::LibPQ.Connection, typname::Symbol)
    result = LibPQ.execute(conn, "select oid from pg_type where typname='$typname'")
    data = Tables.columntable(result)
    LibPQ.close(result)
    return data.oid[1]
end

function registerType(typname::Symbol, oid::LibPQ.Oid, type::Type)
    LibPQ.PQ_SYSTEM_TYPES[typname] = oid
    LibPQ.LIBPQ_TYPE_MAP[typname] = type
    nothing
end

function register(conn::LibPQ.Connection, typname::Symbol, type::Type, func_from::Function, func_to::Function)
    oid = getTypeOid(conn, typname)
    registerType(typname, oid, type)

    @eval function Base.parse(::Type{$type}, pqv::PQValue{$oid})
              $func_from(pqv)
          end

    @eval function Base.string(obj::$type)
        $func_to(obj)
    end
    nothing
end
