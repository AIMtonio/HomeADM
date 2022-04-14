-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALIFICACIONCLI
DELIMITER ;
DROP TABLE IF EXISTS `CALIFICACIONCLI`;DELIMITER $$

CREATE TABLE `CALIFICACIONCLI` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del cliente del cual se registra la calificacion',
  `ClasificaCliID` int(11) DEFAULT NULL COMMENT 'ID de la clasificacion del cliente, Debe existir en CLASIFICACIONCLI',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en que se asigno la calificacion al cliente',
  `Antiguedad` float(12,2) DEFAULT NULL COMMENT 'Calificacion por antiguedad del cliente en la institucion',
  `Creditos` float(12,2) DEFAULT NULL COMMENT 'Calificacion por numero de creditos solicitados por cliente',
  `Morosidad` float(12,2) DEFAULT NULL COMMENT 'Calificacion por morosidad promedio ',
  `FormaPago` float(12,2) DEFAULT NULL COMMENT 'Calificacion por forma de pago(liquidar) los creditos',
  `AhorroNeto` float(12,2) DEFAULT NULL COMMENT 'Calificacion por Ahorro neto del socio vs Ahorro promedio general',
  `PromedioInteres` float(12,2) DEFAULT NULL COMMENT 'Calificacion por Promedio interés normal',
  `Reestructuras` float(12,2) DEFAULT NULL COMMENT 'Calificacion  por Reestructuras en créditos',
  `Renovaciones` float(12,2) DEFAULT NULL COMMENT 'Calificacion  por Renovación en créditos',
  `AsisteAsamblea` float(12,2) DEFAULT NULL COMMENT 'Calificacion  por Asistencia a la asamblea',
  `Calificacion` float(12,2) DEFAULT NULL COMMENT 'Calificacion  total (sumatoria de los puntajes obtenidos en cada concepto)',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`),
  KEY `FK_ClasificaCliID_1` (`ClasificaCliID`),
  CONSTRAINT `FK_ClienteID_4` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena un registro por cliente con su clasifiación Y la ca'$$