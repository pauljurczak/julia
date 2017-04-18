#!/usr/bin/env julia
# This file is a part of Julia. License is MIT: http://julialang.org/license

const options =
[
    "--cflags",
    "--ldflags",
    "--ldlibs"
];

threadingOn() = ccall(:jl_threading_enabled, Cint, ()) != 0

function imagePath()
    opts = Base.JLOptions()
    return unsafe_string(opts.image_file)
end

function libDir()
    return if ccall(:jl_is_debugbuild, Cint, ()) != 0
        dirname(abspath(Libdl.dlpath("libjulia-debug")))
    else
        dirname(abspath(Libdl.dlpath("libjulia")))
    end
end

private_libDir() = joinpath(JULIA_HOME, Base.PRIVATE_LIBDIR)

function includeDir()
    dir, bin = splitdir(JULIA_HOME)
    return joinpath(dir, "include", "julia")
end

function ldflags()
    fl = replace("""-L$(libDir())""","\\","\\\\")
    if is_windows()
        fl = fl * " -Wl,--stack,8388608"
    elseif is_linux()
        fl = fl * " -Wl,--export-dynamic"
    end
    return fl
end

function ldlibs()
    libname = if ccall(:jl_is_debugbuild, Cint, ()) != 0
        "julia-debug"
    else
        "julia"
    end
    if is_unix()
        return replace("""-Wl,-rpath,$(libDir()) -Wl,-rpath,$(private_libDir()) -l$libname""","\\","\\\\")
    else
        return "-l$libname -lopenlibm"
    end
end

function cflags()
    flags = IOBuffer()
    print(flags, "-std=gnu99")
    include = replace(includeDir(),"\\","\\\\")
    print(flags, " -I", include)
    if threadingOn()
        print(flags, " -DJULIA_ENABLE_THREADING=1")
    end
    if is_unix()
        print(flags, " -fPIC")
    end
    return String(take!(flags))
end

function check_args(args)
    checked = intersect(args, options)
    if length(checked) == 0 || length(checked) != length(args)
        println(STDERR,"Usage: julia-config [",reduce((x,y)->"$x|$y",options),"]")
        exit(1)
    end
end

function main()
    check_args(ARGS)
    for args in ARGS
        if args == "--ldflags"
            println(ldflags())
        elseif args == "--cflags"
            println(cflags())
        elseif args == "--ldlibs"
            println(ldlibs())
        end
    end
end

main()
