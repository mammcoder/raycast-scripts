# raycast-scripts

Открывает или активирует уже активную вкладку в Safari.
Позволяет быстро и удобно открыть нужный проект.

Короткий справочник команд Raycast.

## Команды и алиасы

| Команда            | Алиас  | Файл                  |
| ------------------ | ------ | --------------------- |
| `gitlab delivery`  | —      | `gitlab-delivery.sh`  |
| `gitlab rewards`   | —      | `gitlab-rewards.sh`   |
| `gitlab barriers`  | —      | `gitlab-barriers.sh`  |
| `gitlab bonuses`   | —      | `gitlab-bonuses.sh`   |
| `gitlab chat`      | —      | `gitlab-chat.sh`      |
| `gitlab couriers`  | —      | `gitlab-couriers.sh`  |
| -                  |        |                       |
| `jenkins delivery` | —      | `jenkins-delivery.sh` |
| `jenkins rewards`  | —      | `jenkins-rewards.sh`  |
| `jenkins barriers` | —      | `jenkins-barriers.sh` |
| `jenkins bonuses`  | —      | `jenkins-bonuses.sh`  |
| `jenkins chat`     | —      | `jenkins-chat.sh`     |
| -                  |        |                       |
| `log test`         | `lt`   | `log-test.sh`         |
| `log prod`         | `lp`   | `log-prod.sh`         |
| -                  |        |                       |
| `kafka test`       | `kt`   | `kafka-test.sh`       |
| `kafka prod`       | `kp`   | `kafka-prod.sh`       |
| -                  |        |                       |
| `jaeger test`      | `jt`   | `jaeger-test.sh`      |
| `jaeger prod`      | `jp`   | `jaeger-prod.sh`      |

## Добавить новую команду

1. Создайте новый `.sh` рядом с остальными.
2. Добавьте метаданные Raycast: `@raycast.title`, опционально `@raycast.aliases`.
3. Вызовите `lib/open-or-focus.sh` с нужным URL.
4. Сделайте файл исполняемым: `chmod +x <file>.sh`.
5. Проверьте синтаксис: `bash -n <file>.sh`.
