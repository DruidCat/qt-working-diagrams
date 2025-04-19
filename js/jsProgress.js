WorkerScript.onMessage = function(message) {
    if (message.start) {
        // Симуляция процесса загрузки
        for (var i = 0; i <= 100; i++) {
            WorkerScript.sendMessage({ progress: i })
            // Пауза, чтобы увидеть процесс загрузки
            var date = new Date()
            var curDate = null
            do {
                curDate = new Date()
            } while (curDate - date < 50) // Пауза 50 мс
        }
    }
}
