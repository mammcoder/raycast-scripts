# raycast-scripts

Открывает или активирует уже активную вкладку в Safari.
Позволяет быстро и удобно открыть нужный проект.

Короткий справочник команд Raycast.

# Поддержка браузеров

- Safari через open-or-focus.sh (текущая версия)
- Google Chromе через open-or-focus-chrome.sh (нужно подменить скрипт open-or-focus.sh)

## Команды и алиасы

| Команда                               | Алиас     | Файл                           |
| ------------------------------------- | --------- | ------------------------------ |
| `gitlab delivery`                     | -         | `gitlab-delivery.sh`           |
| `gitlab rewards`                      | -         | `gitlab-rewards.sh`            |
| `gitlab barriers`                     | -         | `gitlab-barriers.sh`           |
| `gitlab bonuses`                      | -         | `gitlab-bonuses.sh`            |
| `gitlab chat`                         | -         | `gitlab-chat.sh`               |
| `gitlab couriers`                     | -         | `gitlab-couriers.sh`           |
| `gitlab schedules`                    | -         | `gitlab-schedules.sh`          |
| -                                     |           |                                |
| `jenkins delivery`                    | -         | `jenkins-delivery.sh`          |
| `jenkins rewards`                     | -         | `jenkins-rewards.sh`           |
| `jenkins barriers`                    | -         | `jenkins-barriers.sh`          |
| `jenkins bonuses`                     | -         | `jenkins-bonuses.sh`           |
| `jenkins chat`                        | -         | `jenkins-chat.sh`              |
| `jenkins schedules`                   | -         | `jenkins-schedules.sh`         |
| -                                     |           |                                |
| `log test`                            | `lt`      | `log-test.sh`                  |
| `log prod`                            | `lp`      | `log-prod.sh`                  |
| -                                     |           |                                |
| `kafka test`                          | `kt`      | `kafka-test.sh`                |
| `kafka prod`                          | `kp`      | `kafka-prod.sh`                |
| -                                     |           |                                |
| `jaeger test`                         | `jt`      | `jaeger-test.sh`               |
| `jaeger prod`                         | `jp`      | `jaeger-prod.sh`               |
| -                                     |           |                                |
| `yandex tracker DOSTAVKAPIKO`         | `yd`      | `yandex-dp-task.sh`            |
| `yandex tracker POOLING`              | `yp`      | `yandex-pooling-task.sh`       |
| `yandex tracker внутренние работы`    | `yi`      | `yandex-tracker-int-work.sh`   |
| `yandex tracker мои задачи`           | `ym`      | `yandex-tracker-my-tasks.sh`   |

## Добавить новую команду

1. Создайте новый `.sh` рядом с остальными.
2. Добавьте метаданные Raycast: `@raycast.title`, опционально `@raycast.aliases`.
3. Вызовите `lib/open-or-focus.sh` с нужным URL.
4. Сделайте файл исполняемым: `chmod +x <file>.sh`.
5. Проверьте синтаксис: `bash -n <file>.sh`.
