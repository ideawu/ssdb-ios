# ssdb-ios

这个项目主要是演示怎么在 iOS 项目里集成 libssdb 作为存储引擎.

libssdb.a 是一个 C++ 静态库, 可以直接在 Objective-C 代码里使用, 但是需要把 OC 的 `.m` 文件改名为 `.mm` 文件.

C++ 的接口比较多, 具体的文档是 http://ssdb.io/docs/cpp/index.html

我封装了 `MySSDB.h` 和 `MySSDB.mm`, 这样, 你就可以不需要把 OC 文件改名, 因为它暴露的是 Objective-C 的接口.

目前只包含了部分接口:

* get
* set
* del

你可以参考着完善缺少的方法. 后面我会继续补充.

## ssdb.framework 打包

你可以使用 https://github.com/mysteriouss/ssdb.framework.iOS 来生成 ssdb.framework, 这样引用 ssdb 库的时候更方便.

