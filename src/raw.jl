module _Raw
    using CxxWrap
    using gdstk_jll
    @wrapmodule(() -> gdstk_jll.libgdstk_wrapper)
    function __init__()
        @initcxx
    end
end
