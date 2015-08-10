# ssdb-ios

这个项目主要是演示怎么在 iOS 项目里集成 libssdb 作为存储引擎.

libssdb.a 是一个 C++ 静态库, 可以直接在 Objective-C 代码里使用, 但是需要把 OC 的 `.m` 文件改名为 `.mm` 文件.

C++ 的接口比较多, 具体的文档是 http://ssdb.io/docs/cpp/index.html

我封装了 `MySSDB.h` 和 `MySSDB.mm`, 但只包含了了 `get, set, del` 3 个原生的 OC 方法, 但你可以参考着完善缺少的方法. 后面我会继续补充.
