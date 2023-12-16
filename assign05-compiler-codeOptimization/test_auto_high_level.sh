#!/bin/bash

# 检查是否有 -d 参数
show_diffs=false
if [ "$1" == "-d" ]; then
  show_diffs=true
fi


for i in {01..31}; do
  # 当前输出保存在一个临时文件中
  ./nearly_cc -h $1 ~/fall2023-tests/assign04/input/example$i.c > /tmp/example$i.out

  # 比较新旧输出
  if ! diff -q ~/fall2023-tests/assign04/my_output/example$i.out /tmp/example$i.out > /dev/null; then
    echo "Warning: Output for example$i.c has changed!"
        if [ "$show_diffs" = true ]; then
      echo "Showing differences for example$i.c:"
      diff ~/fall2023-tests/assign04/my_output/example$i.out /tmp/example$i.out
    fi
  else
    echo "example$i.c good."
  fi
done

