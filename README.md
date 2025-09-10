# Customers API

Este microservicio se encarga de la gestión de clientes y la actualización de datos en respuesta a eventos de órdenes recibidos desde RabbitMQ.

## Documentación principal

La descripción completa de la arquitectura, la relación entre servicios, instrucciones de ejecución y el diagrama del sistema se encuentran en el README de **Orders API**.

👉 **Consulta el README principal en Orders API para información detallada y pasos de instalación.**

---

## Ejecución rápida

1. Instala dependencias, migra y carga seeds:

```bash
bundle install
rails db:create
rails db:migrate
rails db:seed
```

2. Levanta la API:

```bash
rails s -p 3001
```

3. Inicia el listener de eventos (ajusta el comando según tu implementación):

```bash
rails runner 'OrderEventsListener.run'
```

---

Para más detalles sobre la configuración, pruebas e integración entre servicios, visita el README de Orders API.