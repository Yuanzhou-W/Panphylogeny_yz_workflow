[trimal](https://github.com/inab/trimal)

# 现状：
目前使用的是 -automated1 参数用于比对结果的修剪
```
-automated1
        Use a heuristic selection of the automatic method
            based on similarity statistics. (see User Guide).
        Optimized for Maximum Likelihood phylogenetic tree reconstruction.
```

在gappyout和similarity-strict之间选择了针对ML树优化的方法来剪切

# 问题
1. 该参数是否具有生物学意义
2. 是否需要找别的标准或更有生物学意义的标准来进行修剪