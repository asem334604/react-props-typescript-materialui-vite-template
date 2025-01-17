# Используем официальный образ Node.js в качестве базового
FROM node:hydrogen-slim

# Устанавливаем рабочую директорию в контейнере
WORKDIR /app

# Копируем package.json и package-lock.json в рабочую директорию
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем весь проект в рабочую директорию контейнера
COPY . .

# Собираем приложение для продакшн
RUN npm run build

# Устанавливаем сервер для обслуживания статических файлов
RUN npm install -g serve

# Определяем команду для запуска контейнера
CMD ["serve", "-s", "build", "-l", "5000"]

# Экспонируем порт, на котором будет работать приложение
EXPOSE 5000
