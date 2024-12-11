## Лабораторная работа № 1
```
#!/bin/bash

name="$*"
echo "Welcome, $name"
```
`name="$*"` содержит все параметры, введенные в командной строке

Например, при запуске файла 
`bash script.bash Benedict Timothy Carlton Cumberbatch`

будет выведено 
`Welcome, Benedict Timothy Carlton Cumberbatch`

## Лабораторная работа № 2
`ip_address="$1"` считываем IPv4-адрес
```
IFS='.'
read -a -r mas <<< "$ip_address"
```
считываем в массив mas числа из ip_address, разделенные "."

```
for el in "${mas[@]}"; do
        new_el=$(echo "obase=2;$el" | bc)
        new_el=$(printf "%08d" $new_el)
        new_ip_address="$new_ip_address.$new_el"
```
проходим по всем элементам массива mas, сначала переводим каждое число в двоичную форму, затем фиксируем длину 8 символов и собираем новую строку, ставя перед каждым числом "."

`echo "${new_ip_address:1}"` убираем ненужную точку в начале и выводим IP-адрес в двоичном формате

Итак, решение задачи:
```
#!/bin/bash

ip_address="$1"

IFS='.'
read -r -a mas <<< "$ip_address"

new_ip_address=""
for el in "${mas[@]}"; do
        new_el=$(echo "obase=2;$el" | bc)
        new_el=$(printf "%08d" $new_el)
        new_ip_address="$new_ip_address.$new_el"
done

echo "${new_ip_address:1}"
```
