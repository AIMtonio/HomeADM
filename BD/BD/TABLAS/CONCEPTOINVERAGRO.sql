-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOINVERAGRO
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOINVERAGRO`;DELIMITER $$

CREATE TABLE `CONCEPTOINVERAGRO` (
  `ConceptoInvID` int(11) NOT NULL COMMENT 'Identificador consecutivo del concepto de inversion',
  `SolicitudCreditoID` bigint(20) DEFAULT NULL COMMENT 'Solicitud del credito',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del cliente.',
  `ConceptoFiraID` int(11) NOT NULL COMMENT 'ID del concepto fira proveniente de la tabla CATCONCEPTOSINVERAGRO',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha de registro concepto',
  `NoUnidad` decimal(16,2) NOT NULL COMMENT 'Será un campo que solo permitirá capturar valores decimales mayores o iguales a cero, en caso de ingresar un valor menor a cero se deberá notificar al usuario. ',
  `ClaveUnidad` varchar(45) NOT NULL COMMENT 'campo  para ingresar el número de la unidad (ID)',
  `Unidad` varchar(45) NOT NULL COMMENT 'campo informativo y mostrará la clave de la unidad',
  `Monto` decimal(16,2) NOT NULL COMMENT 'Monto del concepto.',
  `TipoRecurso` char(2) NOT NULL COMMENT 'Indica el tipo de Recurso P= prestamo, S= Solicitante, OF= Otras Fuentes.',
  `EmpresaID` int(11) NOT NULL COMMENT 'EmpresaID ',
  `Usuario` int(11) NOT NULL COMMENT 'UsuarioID',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Nombre del programa',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` int(11) NOT NULL COMMENT 'Numero de transaccion',
  PRIMARY KEY (`ConceptoInvID`),
  KEY `fk_CONCEPTOINVERAGRO_1_idx` (`ClienteID`),
  KEY `fk_CONCEPTOINVERAGRO_2_idx` (`ConceptoFiraID`),
  KEY `fk_CONCEPTOINVERAGRO_3_idx` (`SolicitudCreditoID`),
  CONSTRAINT `fk_CONCEPTOINVERAGRO_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CONCEPTOINVERAGRO_2` FOREIGN KEY (`ConceptoFiraID`) REFERENCES `CATCONCEPTOSINVERAGRO` (`ConceptoFiraID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CONCEPTOINVERAGRO_3` FOREIGN KEY (`SolicitudCreditoID`) REFERENCES `SOLICITUDCREDITO` (`SolicitudCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los Conceptos de inversion por cliente'$$