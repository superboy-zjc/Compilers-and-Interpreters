for i in {01..31}; do
  # 当前输出保存在一个临时文件中
  ./nearly_cc -h ~/fall2023-tests/assign04/input/example$i.c > /tmp/example$i.out

  # 比较新旧输出
  if ! diff -q ~/fall2023-tests/assign04/my_output/example$i.out /tmp/example$i.out > /dev/null; then
    echo "Warning: Output for example$i.c has changed!"
  else
    echo "example$i.c good."
  fi
done

