-- ============================================================
--  Script de inicialización de la base de datos "inventario"
--  MySQL lo ejecuta automáticamente SOLO la primera vez,
--  cuando el volumen datos_mysql está vacío.
-- ============================================================

SET NAMES utf8mb4;
USE inventario;

CREATE TABLE IF NOT EXISTS equipos (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    tipo            ENUM('Perforadora','Camión minero','Cargador frontal','Equipo de monitoreo','Computadora','Servidor','Otro') NOT NULL,
    marca           VARCHAR(50)  NOT NULL,
    numero_serie    VARCHAR(50)  NOT NULL UNIQUE,
    ubicacion       VARCHAR(100) NOT NULL,
    estado          ENUM('Operativo','En mantenimiento','Fuera de servicio') NOT NULL DEFAULT 'Operativo',
    fecha_registro  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Registros de ejemplo (datos ficticios)
INSERT INTO equipos (nombre, tipo, marca, numero_serie, ubicacion, estado) VALUES
('Perforadora Zona Este',  'Perforadora',         'Epiroc',      'PER-0001', 'Zona Este',          'Operativo'),
('Camión de acarreo 1',    'Camión minero',       'Caterpillar', 'CAM-0001', 'Rampa principal',    'En mantenimiento'),
('Cargador frontal 2',     'Cargador frontal',    'Komatsu',     'CAR-0002', 'Zona Norte',         'Operativo'),
('Sensor de gases 3',      'Equipo de monitoreo', 'Dräger',      'MON-0003', 'Galería 2',          'Fuera de servicio'),
('Servidor de planta',     'Servidor',            'Dell',        'SRV-0001', 'Oficina de control', 'Operativo');
