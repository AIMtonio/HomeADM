-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOFORMDESPROY
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOFORMDESPROY`;DELIMITER $$

CREATE TABLE `SEGTOFORMDESPROY` (
  `SegtoPrograID` int(11) NOT NULL,
  `SegtoRealizaID` int(11) NOT NULL COMMENT 'FK de la tabla de SEGTOREALIZADO ',
  `AsistenciaGpo` int(11) DEFAULT NULL COMMENT 'Porcentaje de asistencia del grupo',
  `AvanceProy` int(11) DEFAULT NULL COMMENT 'Porcentaje de avance del Proyecto',
  `MontoEstProd` decimal(12,2) DEFAULT NULL COMMENT 'Monto Estimado de Producción',
  `UnidEstProd` int(11) DEFAULT NULL COMMENT 'Unidades Estimadas de Produccion\n',
  `PrecioEstUni` decimal(12,2) DEFAULT NULL COMMENT 'Precio Esperado de venta de bienes x unidad',
  `MontoEspVtas` decimal(12,2) DEFAULT NULL COMMENT 'Monto Esperado de Ventas Brutas',
  `FechaComercializa` date DEFAULT NULL COMMENT 'Fecha de Comercialización',
  `ReconoceAdeudo` char(1) DEFAULT NULL COMMENT 'Cliente Reconoce Adeudo?\nS.- Si\nN.-No\n',
  `ConoceMtosFechas` char(1) DEFAULT NULL COMMENT 'Cliente conoce montos y fechas de pago?\nS.-Si\nN.-No\n',
  `TelefonoFijo` varchar(20) DEFAULT NULL COMMENT 'Telefono Fijo del Cliente',
  `TelefonoCel` varchar(20) DEFAULT NULL COMMENT 'Telefono Celular del Cliente',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SegtoPrograID`,`SegtoRealizaID`),
  KEY `fk_SEGTOFORMDESPROY_1_idx` (`SegtoPrograID`),
  CONSTRAINT `fk_SEGTOFORMDESPROY_1` FOREIGN KEY (`SegtoPrograID`) REFERENCES `SEGTOPROGRAMADO` (`SegtoPrograID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar campos para \nSeguimiento de Desarrollo de Proyectos'$$