# ElixirBench

### Results

```bash
##### SMALL XML
$ mix run bench/xml_parsers_small.exs
Operating System: macOS
CPU Information: Apple M1
Number of Available Cores: 8
Available memory: 16 GB
Elixir 1.12.2
Erlang 24.0.4

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 35 s

Benchmarking Parser1 - SweetXml...
Benchmarking Parser2 - SAXMap...
Benchmarking Parser3 - Saxy.SimpleForm...
Benchmarking ParserSAX...
Benchmarking ParserSweet...

Name                                ips        average  deviation         median         99th %
Parser3 - Saxy.SimpleForm        743.04        1.35 ms     ±9.96%        1.31 ms        1.58 ms
Parser2 - SAXMap                 513.09        1.95 ms    ±10.97%        1.92 ms        2.74 ms
ParserSAX                        507.30        1.97 ms    ±10.88%        1.93 ms        2.82 ms
Parser1 - SweetXml               155.21        6.44 ms     ±9.56%        6.50 ms        7.51 ms
ParserSweet                      120.04        8.33 ms     ±2.81%        8.45 ms        8.95 ms

Comparison:
Parser3 - Saxy.SimpleForm        743.04
Parser2 - SAXMap                 513.09 - 1.45x slower +0.60 ms
ParserSAX                        507.30 - 1.46x slower +0.63 ms
Parser1 - SweetXml               155.21 - 4.79x slower +5.10 ms
ParserSweet                      120.04 - 6.19x slower +6.98 ms
```

```bash
##### BIG XML
$ mix run bench/xml_parsers_big.exs
Compiling 1 file (.ex)
Operating System: macOS
CPU Information: Apple M1
Number of Available Cores: 8
Available memory: 16 GB
Elixir 1.12.2
Erlang 24.0.4

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 35 s

Benchmarking Parser1 - SweetXml...
Benchmarking Parser2 - SAXMap...
Benchmarking Parser3 - Saxy.SimpleForm...
Benchmarking ParserSAX...
Benchmarking ParserSweet...

Name                                ips        average  deviation         median         99th %
Parser3 - Saxy.SimpleForm         54.35       18.40 ms     ±7.69%       18.52 ms       22.93 ms
Parser2 - SAXMap                  40.38       24.76 ms     ±6.67%       24.65 ms       28.60 ms
ParserSAX                         40.21       24.87 ms     ±3.97%       24.82 ms       27.28 ms
Parser1 - SweetXml                 5.11      195.70 ms     ±5.51%      196.54 ms      212.76 ms
ParserSweet                        3.62      276.30 ms     ±0.72%      275.74 ms      283.27 ms

Comparison:
Parser3 - Saxy.SimpleForm         54.35
Parser2 - SAXMap                  40.38 - 1.35x slower +6.36 ms
ParserSAX                         40.21 - 1.35x slower +6.47 ms
Parser1 - SweetXml                 5.11 - 10.64x slower +177.30 ms
ParserSweet                        3.62 - 15.02x slower +257.90 ms
```
