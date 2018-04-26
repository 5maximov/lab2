library('lattice')             # графическая система 'lattice'
library('data.table')          # работаем с объектами "таблица данных"

# загружаем файл с данными по импорту масла в РФ (из прошлой практики)

fileURL <- 'https://raw.githubusercontent.com/aksyuk/R-data/master/COMTRADE/040510-Imp-RF-comtrade.csv'

# создаём директорию для данных, если она ещё не существует:

if (!file.exists('./data')) {
  
  dir.create('./data')
  
}

# создаём файл с логом загрузок, если он ещё не существует:

if (!file.exists('./data/download.log')) {
  
  file.create('./data/download.log')
  
}

# загружаем файл, если он ещё не существует,

#  и делаем запись о загрузке в лог:

if (!file.exists('./data/040510-Imp-RF-comtrade.csv')) {
  
  download.file(fileURL, './data/040510-Imp-RF-comtrade.csv')
  
  # сделать запись в лог
  
  write(paste('Файл "040510-Imp-RF-comtrade.csv" загружен', Sys.time()), 
        
        file = './data/download.log', append = T)
  
}

# читаем данные из загруженного .csv во фрейм, если он ещё не существует

if (!exists('DT')){
  
  DT <- data.table(read.csv('./data/040510-Imp-RF-comtrade.csv', as.is = T))
  
}
t <- c('Russian Federation', 'Belarus','Kazakhstan')
s <- c('Azerbaijan','Armenia', 'Kyrgyzstan','Moldova','Tajikistan','Turkmenistan','Uzbekistan') 
q <- c('Ukraine','United States of America','Latvia','Lithuania','Mongolia','New Zealand','Finland','Georgia','Germany','Estonia','EU-27')
DT[, tam := factor(Reporter, levels = c('t','s','q'), 
                       labels = c('Таможенный союз','СНГ','Другие'))]


#Строим график
png('RPlot.png', width = 1280, height = 1024)
histogram(~ Trade.Value.USD |Reporter, 
          data = DT,
          col=c('cyan','pink','green'),
          main='Разброс стоимости поставки',
          xlab='Страны',ylab='Стоимость поставки',
          auto.key=T,groups=tam)


dev.off()

