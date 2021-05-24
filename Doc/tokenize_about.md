# token,tokenizer,tokenization的区别

:D

**token**: 表示符号，包括单词和标点。名词

**tokenization**: 分词，我是中国人->['我', '是', '中国人'], 动词

**tokenizer**: 分词器, 用于将文本转换成序列(即单词在字典中的下标构成的列表，从1算起)

tokenizer是一个类方法，其中可以集成分词等方法，主要功能有统计词频，然后将文本转化成
序列。序列可以不等长，后面需要我们自己补充为等长的序列

参考：

- https://zhuanlan.zhihu.com/p/55412623

- https://blog.floydhub.com/tokenization-nlp/

TODO:

- [ ] 为什么要使用tokenizer，转换成词频向量？

- [ ] 在自然语言处理中，为什么要分词呢？

