## BEP介绍

参考：https://wmathor.com/index.php/archives/1517/

**bep又称为bytes-pair-encoding**

作用：解决自然语言处理中未登陆词的一种做法，未登陆词指那些既没有出现在训练集中也没有出现在测试集中的文字或者单词。

**参考资料**：

- https://blog.csdn.net/jmh1996/article/details/89286898
- https://towardsdatascience.com/byte-pair-encoding-the-dark-horse-of-modern-nlp-eb36c7df4f10
- https://zh.wikipedia.org/wiki/%E5%AD%97%E8%8A%82%E5%AF%B9%E7%BC%96%E7%A0%81

**debug**：

假如输入的corpus为以下：

```
corpus = 'The last few years have been an exciting time to be in the field of NLP.'
```

**Step1**:

可以看到单词被切分成了下面这些样子

```
# 建立单词表
# 这是一个列表
00:'T h e </w>'
01:'l a s t </w>'
02:'f e w </w>'
03:'y e a r s </w>'
04:'h a v e </w>'
05:'b e e n </w>'
06:'a n </w>'
07:'e x c i t i n g </w>'
08:'t i m e </w>'
09:'t o </w>'
```

**建立的单词表如下**：

```
'T h e </w>':1
'l a s t </w>':1
'f e w </w>':1
'y e a r s </w>':1
'h a v e </w>':1
'b e e n </w>':1
'a n </w>':1...
```

**Step2**：

统计成对出现的单词和字符，将构建好的直接使用下面代码

```
pairs = defaultdict(int)
    for word, frequency in vocab.items(): # 首先对'T h e </w>':1进行操作
        symbols = word.split() # symbols = ['T', 'h', 'e', '</w>']

        # Counting up occurrences of pairs
        # defaultdict(<class 'int'>, {('T', 'h'): 1, ('h', 'e'): 1, ('e', '</w>'): 1})
        for i in range(len(symbols) - 1):
            pairs[symbols[i], symbols[i + 1]] += frequency
    return pairs
```

最后得到的pairs如下：

```
<defaultdict, len() = 47>
special variables
function variables
class variables
('T', 'h'):1
('h', 'e'):2
('e', '</w>'):5
('l', 'a'):1
('a', 's'):1
('s', 't'):1
('t', '</w>'):1
('f', 'e'):1
('e', 'w'):1
```

**Step3：**

找到匹配频率最大的几个点：

```
('e', '</w>')
```

然后我们看看下面这个函数在做什么

```
def merge_vocab(pair: tuple, v_in: dict) -> dict:
    """Step 3. Merge all occurrences of the most frequent pair"""
    
    v_out = {}
    bigram = re.escape(' '.join(pair))
    p = re.compile(r'(?<!\S)' + bigram + r'(?!\S)')
    
    for word in v_in:
        # replace most frequent pair in all vocabulary
        w_out = p.sub(''.join(pair), word)
        v_out[w_out] = v_in[word]

    return v_out
```

```
# 经过re.escape后, 这里为什么是\\呢
# 因为一个\要匹配空格，因为
'e </w>' --> 'e\\ </w>'

# 最后的匹配模式为
# 空格就是双\\
'(?<!\\S)e\\ </w>(?!\\S)'
```

**这个匹配的意思为：**

```
p.sub(''.join(pair), word)
# 将word中满足p模式的，都替换成''.join(pair)
```

**然后介绍下这个匹配是匹配什么**：

`(?<!…)`

```
匹配当前位置之前不是 ... 的样式。这个叫 negative lookbehind assertion （后视断定取非）。类似正向后视断定，包含的样式匹配必须是定长的。由 negative lookbehind assertion 开始的样式可以从字符串搜索开始的位置进行匹配
```

`(?!…)`

```
匹配 … 不符合的情况。这个叫 negative lookahead assertion （前视取反）。比如说， Isaac (?!Asimov) 只有后面 不 是 'Asimov' 的时候才匹配 'Isaac ' 。
```

所以这个正则匹配的是：

```
# 首先该正则有三个位置
(1)2(3)

# 位置1表示
当前位置只要不是\S，都可以匹配，因为是匹配不是，所以该位置只能为空白, 只要前面是空白，就匹配位置2

# 位置2
匹配 e\\ </w>

# 位置3
只要后面不是\S,才匹配前面的位置，即只有是空白字符才匹配位置2

\S是任何非空白字符
```

为什么是这样请看：https://docs.python.org/zh-cn/3/library/re.html

**比如匹配：**

```
p = re.compile(r'(?<!\S)' + 't\ i' + r'(?!\S)')

# 则下面都能匹配
p.match('t i')
p.match('t i ')

# 匹配到的是
<re.Match object; span=(0, 3), match='t i'>

# 下面都不能匹配
p.match(' t i')
p.match('at i')
```

可以参考：

```
# 这个例子将颜色都转换成colour

>>> p = re.compile('(blue|white|red)')
>>> p.sub('colour', 'blue socks and red shoes')
'colour socks and colour shoes'
```

就是将出现频率最高的字符对，进行替换。这里强烈看看[维基百科](https://zh.wikipedia.org/wiki/%E5%AD%97%E8%8A%82%E5%AF%B9%E7%BC%96%E7%A0%81)

解压的时候只要反向操作就好了。

这里有个超参数：因为要进行替换，所以可以设置一个循环，替换多少次，和是否要替换完。

**bep算法前的vocab**

```
Counter({'T h e </w>': 1, 'l a s t </w>': 1, 'f e w </w>': 1, 'y e a r s </w>': 1, 'h a v e </w>': 1, 'b e e n </w>': 1, 'a n </w>': 1, 'e x c i t i n g </w>': 1, 't i m e </w>': 1, 't o </w>': 1, 'b e </w>': 1, 'i n </w>': 1, 't h e </w>': 1, 'f i e l d </w>': 1, 'o f </w>': 1, 'N L P . </w>': 1})
```

**bep算法后的vocab**

```
{'The</w>': 1, 'last</w>': 1, 'few</w>': 1, 'years</w>': 1, 'have</w>': 1, 'been</w>': 1, 'an</w>': 1, 'exciting</w>': 1, 'time</w>': 1, 'to</w>': 1, 'be</w>': 1, 'in</w>': 1, 'the</w>': 1, 'field</w>': 1, 'of</w>': 1, 'NLP.</w>': 1}
```

## Sentence Piece介绍

分词主要有jieba分词和sentence piece分词，这里简称为sp

sentencpiece更倾向输出更大粒度的词，像把“机器学习领域中”放在一起，说明这个词语在语料库中出现的频率很高。

例如“机器学习领域“这个文本，按jieba会分“机器/学习/领域”，但你想要粒度更大的切分效果，如“机器学习/领域”或者不切分，这样更有利于模型捕捉更多N-gram特征。为实现这个，你可能想到把对应的大粒度词加到词表中就可以解决，但是添加这类词是很消耗人力。然而对于该问题，sentencepiece可以得到一定程度解决，甚至完美解决你的需求。

**请参考链接3**

- 通常nlp的任务都会在训练之前得到一个固定大小的词典。但是，多数无监督分词算法都假设词典大小不固定并且是无限的。虽然sp也是无监督分词，但是通过预先指定词典的大小，可以得到一个固定大小的词典。
- 其他的无监督分词器需要预先分词，这样的话就会形成语言依赖，也就是对于不同的语言需要不同的分词器，如果考虑分词器本身的效果不理想，势必会造成后续过程的结果不理想。而sp可以直接在原始句子上训练，这就大大提高了sp的可用性。
- 之前的一些分词器将whitespace看做特殊的符号，会导致tokenized后的文本不能恢复到原始文本。但是sp把序列看作是unicode字符序列，这样whitespace就和其他字符一样都是基础符号了，这就实现了可逆性。

**Sentence Piece介绍**：

- https://www.jianshu.com/p/d36c3e06fb98
- https://github.com/google/sentencepiece
- https://zhpmatrix.github.io/2019/04/26/sentencepiece/

