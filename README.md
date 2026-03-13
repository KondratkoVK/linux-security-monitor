# Linux Security Monitor

**Linux Security Monitor** — это система мониторинга безопасности Linux-сервера.
Она анализирует системные логи, обнаруживает подозрительную активность и отправляет уведомления через Telegram.

Проект построен на базе следующих инструментов:

* Prometheus
* Alertmanager
* Grafana
* Node Exporter
* Bash-скрипты для обнаружения атак

---

# Архитектура

Система работает по следующему принципу:

```
auth.log → detection scripts → metrics → Node Exporter → Prometheus → Alertmanager → Telegram
```

1. Скрипты анализируют системные логи Linux.
2. Скрипты создают метрики в формате Prometheus.
3. Node Exporter считывает метрики из папки `metrics`.
4. Prometheus собирает метрики.
5. Alertmanager анализирует алерты.
6. При обнаружении атаки отправляется уведомление в Telegram.

---

# Возможности

* Обнаружение **SSH brute force атак**
* Мониторинг подозрительной активности
* Отправка уведомлений в **Telegram**
* Интеграция с **Prometheus**
* Визуализация через **Grafana**
* Простое развёртывание через **Docker**

---

# Структура проекта

```
linux-security-monitor
│
├── detection
│   ├── network_scan.sh
│   ├── resource_abuse.sh
│   └── ssh_bruteforce.sh
│
├── docker
│
├── docker-compose.yml
│
├── grafana
│
├── metrics
│   └── ssh_bruteforce.prom
│
├── prometheus
│   ├── alertmanager.yml
│   ├── alerts.yml
│   └── prometheus.yml
│
└── README.md
```

---

# Требования

Перед запуском проекта необходимо установить:

* Docker
* Docker Compose
* Cron
* Git

---

# Установка

Клонировать репозиторий:

```
git clone https://github.com/KondratkoVK/linux-security-monitor.git
cd linux-security-monitor
```

Запустить систему мониторинга:

```
docker compose up -d
```

После запуска будут доступны сервисы:

Prometheus
http://localhost:9090

Grafana
http://localhost:3000

Alertmanager
http://localhost:9093

---

# Настройка Telegram уведомлений

Создайте Telegram-бота через **BotFather**.

Получите:

* `BOT_TOKEN`
* `CHAT_ID`

Отредактируйте файл:

```
prometheus/alertmanager.yml
```

Пример конфигурации:

```
receivers:
- name: telegram
  telegram_configs:
  - bot_token: "YOUR_BOT_TOKEN"
    chat_id: YOUR_CHAT_ID
```

---

# Настройка Cron

Скрипты обнаружения атак необходимо запускать периодически.
Для этого используется **cron**.

Открыть редактор cron:

```
crontab -e
```

Добавить запуск скрипта обнаружения SSH атак каждую минуту:

```
* * * * * /path/to/linux-security-monitor/detection/ssh_bruteforce.sh
```

При необходимости можно добавить и другие скрипты:

```
* * * * * /path/to/linux-security-monitor/detection/network_scan.sh
* * * * * /path/to/linux-security-monitor/detection/resource_abuse.sh
```

---

# Обнаружение SSH Brute Force

Скрипт анализирует системный лог:

```
/var/log/auth.log
```

Если за короткий промежуток времени обнаружено несколько неудачных попыток входа с одного IP, создаётся метрика Prometheus.

Пример метрики:

```
ssh_failed_logins{ip="192.168.56.1"} 3
```

Prometheus проверяет эту метрику и создаёт **alert**, если значение превышает установленный порог.

Alertmanager отправляет уведомление в Telegram.

---

# Запуск системы

Запуск контейнеров:

```
docker compose up -d
```

Проверить контейнеры:

```
docker ps
```

---

# Остановка системы

```
docker compose down
```

---

# Примечание

Проект предназначен для демонстрации принципов мониторинга безопасности Linux-систем и не является полноценной IDS/IPS системой.

---

