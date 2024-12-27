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
## Лабораторная работа № 3
1)	Создаем 3 виртуальных машины Ubuntu c одинаковыми настройками в Virtual Box, вводим название, выбираем путь хранения, и ставим галочку пропустить автоматическую настройку
2)	Во вкладке оборудование ставим размер ОЗУ 1 ГБ, Процессор по умолчанию, Во вкладке жесткий диск указываем размер диск 15 ГБ
![](/images/1.png)
![](/images/2.png)
![](/images/3.png)
3)	Переходим в вкладку Расширенные – Сеть, проверяем, чтобы стояла галочка включить сетевой адаптер 1, все остальные адаптеры отключаем и в поле тип подключения выбираем Виртуальный адаптер, все остальное оставляем как есть
![](/images/5.png)
4)	Заходим в меню Файл - Инструменты – Менеджер сетей. Нажимаем кнопку Свойства Адаптера и выбираем вкладку DHCP сервер, и снимаем галочку Включить сервер
5)	Запускаем виртуальную машину
6)	Устанавливаем Ubuntu, создаём учётную запись 
### Настройка сети
1)	Выключим виртуальную машину, и зайдем сеть Файл – Менеджер Сетей - Свойства – Сети NAT. Во вкладке основные опции введем имя сети NatNetwork, далее введем IP сети с маской подсети 24 – 172.16.1.0/24, снимем галочку включить DCHP
2)	Теперь перейдем в настройки сети самой виртуальной машины и выберем тип подключения сеть NAT остальное оставим по умолчанию
Запустим виртуальную машину , откроем терминал , введем команду IP A и убедимся что у нас есть сетевой адаптер и у него есть физический адрес(MAC) 
![](/images/8.png)
3)	Теперь нужно отредактировать файл конфига сети Ubuntu, перейдем в каталог командой Cd /Etc/Netplan/ и проверил какие файлы у нас есть командой LS, и сделаем их бекапы
4)	Откроем текстовые редактор и отредактируем файл 01-network-manager-all.yaml командой SUDO NANO /ETC/NETPLAN/01-NETWORK-MANAGER.YAML.Так как IP адрес 172.16.1.1 обычно занят маршрутизатором, гостевые устройства начинаются с адреса 172.16.1.2 , По сетевому плану Машина А будет иметь адрес 172.16.1.2, Машина Б адрес 172.16.1.3, Машина В 172.16.1.4
![](/images/9.png)
5)	После редактирования файлов перезагрузим машину и проверим выход в интернет 
![](/images/10.png)
![](/images/11.png)
6)	Проверим сетевое взаимодействие между машинами
![](/images/12.png)
![](/images/13.png)
![](/images/14.png)
7)	Чтобы ограничить сетевой доступ для машины Б в машину В, но оставить сетевой доступ в машину В машине А настроим встроенный Firewall Ubuntu на машине В. 
Проверим статус и включим  Firewall если не  запущен с помощью команд sudo ufw status и sudo ufw enable
8)	Добавим правило запрещающее отправку пакетов из машины Б: sudo ufw deny from 172.16.1.3
9)	Запретим ICMP пакеты из машины Б. Отредактируем файл /Etc/Ufw/Before.Rules перед секцией ICMP: 
```console
# drop icmp codes for INPUT
-A ufw-before-input -p icmp --icmp-type destination-unreachable -s 172.16.1.3 -j REJECT
-A ufw-before-input -p icmp --icmp-type time-exceeded -s 172.16.1.3 -j REJECT
-A ufw-before-input -p icmp --icmp-type parameter-problem -s 172.16.1.3 -j REJECT
-A ufw-before-input -p icmp --icmp-type echo-request -s 172.16.1.3 -j REJECT

# drop  icmp code for FORWARD
-A ufw-before-forward -p icmp --icmp-type destination-unreachable -s 172.16.1.3 -j REJECT
-A ufw-before-forward -p icmp --icmp-type time-exceeded -s 172.16.1.3 -j REJECT
-A ufw-before-forward -p icmp --icmp-type parameter-problem -s 172.16.1.3 -j REJECT
-A ufw-before-forward -p icmp --icmp-type echo-request -s 172.16.1.3 -j REJECT
```
10)	Перезагрузим FireWall sudo командой  SUDO UFW RELOAD  и проверим сетевое взаимодействие 
![](/images/15.png)

## Лабораторная работа № 4
1)	Создадим еще одну виртуальную машину с Ubuntu и обновим существующий список пакетов sudo apt update 
2)	Устанавливаем Докер sudo apt install docker-ce
3)	Проверим статус докер sudo systemctl status docker
4)	Создадим новый образ Docker: для  начала создадим папку для хранения образов mkdir /var/Ubuntu-aafire и новый файл Docker: sudo nano Dockerfile
5)	Отредактируем файл Dockerfile:   
```console
# Используем официальный образ Ubuntu в качестве базового
   FROM ubuntu:latest

   # Устанавливаем необходимые пакеты
   RUN apt-get update && \
       apt-get install -y libaa-bin && \
       apt-get install -y iputils-ping && \
       apt-get clean

   # Указываем команду, которая будет выполняться при запуске контейнера
   CMD ["aafire"]
```
6)	Запустим сборку образа Docker командой sudo docker build –t ubuntu-aafire и проверим все образы командой sudo docker images 
![](/images/16.png)
7)	Запустим сам контейнер на основе образа в интерактивном режиме: sudo docker –run aafire_1 –it ubuntu-aafire
![](/images/17.png)
8)	Запустим 2 контейнера на основе образа Ubuntu-aafire в фоновом режиме
```console
sudo docker –run name aafire_1 –t –d ubuntu-aafire
sudo docker –run name aafire_2 –t –d ubuntu-aafire
```
9)	Настроим сетевое взаимодействие между контейнерами: создадим сеть: 
mynetwork: docker network create my_network и подключим контейнеры к этой сети docker network create my_network 
10)	 Проверим как контейнеры получили сеть и проверим есть ли связь
![](/images/18.png)
![](/images/19.png)
![](/images/20.png)


## Лабораторная работа № 5

## Введение

1 Создаю репозитория на GitHub

2 Клонирование репозитория:
```console
(base) annashishkina@MacBook-Pro-Anna ITMO github % git clone https://github.com/anyashishkina/git-practice.git
(base) annashishkina@MacBook-Pro-Anna ITMO github % cd git-practice 
```
3 Добавление файла:
```console
(base) annashishkina@MacBook-Pro-Anna ITMO github % git clone https://github.com/anyashishkina/git-practice.git
(base) annashishkina@MacBook-Pro-Anna ITMO github % cd git-practice 
(base) annashishkina@MacBook-Pro-Anna git-practice % touch example.txt 
(base) annashishkina@MacBook-Pro-Anna git-practice % vim example.txt 
(base) annashishkina@MacBook-Pro-Anna git-practice % git add example.txt
(base) annashishkina@MacBook-Pro-Anna git-practice % git commit -m "File added example.txt"
(base) annashishkina@MacBook-Pro-Anna git-practice % git push origin main
```
4 Создание ветки:
```console
git branch feature-branch
git checkout feature-branch
```
5 Отредактируйте файл example.txt, добавив еще текст.
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % vim example.txt
(base) annashishkina@MacBook-Pro-Anna git-practice % git add example.txt
(base) annashishkina@MacBook-Pro-Anna git-practice % git commit -m "Added chapter 4 in example.txt"
(base) annashishkina@MacBook-Pro-Anna git-practice % git push origin feature-branch     
```
6 Слияние изменений:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git checkout main
(base) annashishkina@MacBook-Pro-Anna git-practice % git merge feature-branch
(base) annashishkina@MacBook-Pro-Anna git-practice % git push origin main
```
### Завершение: все сработало правильно

## Работа с ветками
1 Создайте новый текстовый файл с базовой структурой книги
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % touch book.txt
(base) annashishkina@MacBook-Pro-Anna git-practice % vim book.txt 
```
2 Создайте ветку "feature-login" для разработки новой функциональности:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git checkout -b feature-login
```
3 Внесите изменения в файл:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % vim book.txt
```
4 Завершите изменения, закоммитьте их и отправьте ветку на GitHub:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git add README.md
(base) annashishkina@MacBook-Pro-Anna git-practice % git add book.txt 
(base) annashishkina@MacBook-Pro-Anna git-practice % git commit -m "Добавлена глава 3: Вход в систему"
(base) annashishkina@MacBook-Pro-Anna git-practice % git push origin feature-login
```
## Работа с удаленным репозиторием
1 Переключитесь на основную ветку (main) и внесите изменения:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git checkout main
```
2 Внесите изменения в основной ветке (например, добавьте описание книги):
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % vim example2.txt       
```
3 Закоммитьте изменения и отправьте их на GitHub:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git add example2.txt 
(base) annashishkina@MacBook-Pro-Anna git-practice % git commit -m "Изменено название книги и введение"
(base) annashishkina@MacBook-Pro-Anna git-practice % git push origin main
```
## Моделирование конфликта
1 Вернитесь в ветку "feature-login" и внесите изменения в том же участке:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git checkout feature-login
```
2 Измените главу 2 в файле
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % vim example2.txt    
```
3 Закоммитьте изменения и отправьте их на GitHub:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git add example2.txt 
(base) annashishkina@MacBook-Pro-Anna git-practice % git commit -m "Добавлен раздел о магии конфликтов"
(base) annashishkina@MacBook-Pro-Anna git-practice % git push origin feature-login
```
## Разрешение конфликта
1 Вернитесь в основную ветку и попробуйте слить изменения:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git checkout main
(base) annashishkina@MacBook-Pro-Anna git-practice % git pull origin main
```
Возникновение конфликта:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git merge feature-login 
Автослияние example2.txt
КОНФЛИКТ (добавление/добавление): Конфликт слияния в example2.txt
Сбой автоматического слияния; исправьте конфликты, затем зафиксируйте результат.
```
2 Возникнет конфликт. Разрешите его в файле
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % vim example2.txt
```
3 Закоммитьте разрешение конфликта и отправьте изменения на GitHub:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git add example2.txt
(base) annashishkina@MacBook-Pro-Anna git-practice % git commit -m "Resolved conflict in chapter 2"
(base) annashishkina@MacBook-Pro-Anna git-practice % git push origin main
```
## Автоматизация проверки формата файлов при коммите
1 Создайте bash-скрипт (например, check_format.sh), который будет выполнять проверку формата .txt файлов. 
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % vim check_format.sh
```
bash-скрипт проверяет, чтобы сроки в txt файлах начинались с большой буквы.
![Изображение](images/code.png)
Запишу "hello world" в файл test.txt и попробую его закоммитить
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % echo "hello world" > test.txt
```
В результате проверки коммит отменён.
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git add test.txt 
(base) annashishkina@MacBook-Pro-Anna git-practice % git commit -m "проверка на формат"  
Проверка файла: test.txt
Ошибка: Файл 'test.txt' содержит строки, которые не начинаются с заглавной буквы.
Форматирование файлов не прошло проверку. Коммит отменен.
```
Теперь запишу в тот же файл Hello world.
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % echo "Hello World" > test.txt
```
Теперь прошёл.
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git add test.txt
(base) annashishkina@MacBook-Pro-Anna git-practice % git commit -m "изменённый commit" 
Проверка файла: test.txt
Все файлы прошли проверку формата.
[main 32dd970] изменённый commit
 1 file changed, 1 insertion(+)
 create mode 100644 test.txt
```
## Использование Git Flow в проекте
1 Убедитесь, что Git Flow установлен на локальной машине:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % brew install git-flow
```
2 В корне репозитория выполните инициализацию Git Flow.
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git flow init     

Which branch should be used for integration of the "next release"?
   - develop
   - feature-branch
   - feature-login
Branch name for "next release" development: [develop] develop

How to name your supporting branch prefixes?
Feature branches? [feature/] 
Release branches? [release/] 
Hotfix branches? [hotfix/] 
Support branches? [support/] 
Version tag prefix? [] (base) annashishkina@MacBook-Pro-Anna git-practice % echo "Hello World" > test.txt
```
3 Создайте ветку для новой функциональности "task-management":
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git flow feature start task-management
Переключились на новую ветку «feature/task-management»

Summary of actions:
- A new branch 'feature/task-management' was created, based on 'develop'
- You are now on branch 'feature/task-management'

Now, start committing on your feature. When done, use:

     git flow feature finish task-management

```
4 Внесите изменения в код для добавления функционала управления задачами (например, в файл task_manager.py):
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % vim task_manager.py
```
Выполните коммит изменения по мере разработки:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git add task_manager.py
(base) annashishkina@MacBook-Pro-Anna git-practice % git commit -m "Добавлен функционал управления задачами"
```
5 После завершения разработки функции завершите фичу и объедините ее с основной веткой:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git flow feature finish task-management 

Переключились на ветку «develop»
Обновление 32dd970..375d22c
Fast-forward
 task_manager.py | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 task_manager.py
Ветка feature/task-management удалена (была 375d22c).

Summary of actions:
- The feature branch 'feature/task-management' was merged into 'develop'
- Feature branch 'feature/task-management' has been removed
- You are now on branch 'develop'

```
6 Переключитесь на ветку "develop" и начните создание релиза:
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git checkout develop                   
Уже на «develop»
```
7 Внесите изменения, связанные с релизом (например, обновите версию в файле version.txt):
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % echo "V1.0.0" > version.txt                      
(base) annashishkina@MacBook-Pro-Anna git-practice % git add version.txt                               
(base) annashishkina@MacBook-Pro-Anna git-practice % git commit -m "Обновлена версия для релиза v1.0.0"

Проверка файла: version.txt
Все файлы прошли проверку формата.
[release/v1.0.0 648b86e] Обновлена версия для релиза v1.0.0
 1 file changed, 1 insertion(+)
 create mode 100644 version.txt
```
8 Завершите релиз и объедините его с ветками "develop" и "main":
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git flow release finish v1.0.0
```
Никаких критических ошибок не возникло. Завершение работы и отправка изменений на удаленный репозиторий.
```console
(base) annashishkina@MacBook-Pro-Anna git-practice % git push origin develop
Перечисление объектов: 11, готово.
Подсчет объектов: 100% (11/11), готово.
При сжатии изменений используется до 8 потоков
Сжатие объектов: 100% (8/8), готово.
Запись объектов: 100% (10/10), 1.14 КиБ | 1.14 МиБ/с, готово.
Всего 10 (изменений 3), повторно использовано 0 (изменений 0), повторно использовано пакетов 0
remote: Resolving deltas: 100% (3/3), done.
remote: 
remote: Create a pull request for 'develop' on GitHub by visiting:
remote:      https://github.com/anyashishkina/git-practice/pull/new/develop
remote: 
To https://github.com/anyashishkina/git-practice.git
 * [new branch]      develop -> develop
(base) annashishkina@MacBook-Pro-Anna git-practice % git push origin main
Перечисление объектов: 1, готово.
Подсчет объектов: 100% (1/1), готово.
Запись объектов: 100% (1/1), 231 байт | 231.00 КиБ/с, готово.
Всего 1 (изменений 0), повторно использовано 0 (изменений 0), повторно использовано пакетов 0
To https://github.com/anyashishkina/git-practice.git
   830290e..1f321fb  main -> main
```

