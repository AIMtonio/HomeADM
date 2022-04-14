-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTEEXPEDIENTE
DELIMITER ;
DROP TABLE IF EXISTS `CLIENTEEXPEDIENTE`;DELIMITER $$

CREATE TABLE `CLIENTEEXPEDIENTE` (
  `ClienteID` int(11) NOT NULL COMMENT 'ID del Cliente, corresponde a la tabla de CLIENTES.',
  `FechaExpediente` date NOT NULL COMMENT 'Fecha de Actualización del Expediente del Cliente. Si no se ha actualizado tendrá Fecha Vacia.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria. Id del Usuario.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria. Fecha actual del Sistema.',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria. Direccion IP del Usuario.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria. Nombre del programa.',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria. Id de la Sucursal.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria. Número de Transacción.',
  KEY `fk_CLIENTEEXPEDIENTE_1` (`ClienteID`),
  CONSTRAINT `fk_CLIENTEEXPEDIENTE_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacenara los datos de la actualizacion del expediente del Cliente a modo de bitacora.'$$