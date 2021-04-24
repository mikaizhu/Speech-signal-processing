`run.sh` has multiple stages including data prepration, traning, and etc., so you may likely want to start from the specified stage if some stages are failed by some reason for example.

You can start from specified stage as following and stop the process at the specifed stage:

```
# Start from 3rd stage and stop at 5th stage
$ ./run.sh --stage 3 --stop-stage 5
```

