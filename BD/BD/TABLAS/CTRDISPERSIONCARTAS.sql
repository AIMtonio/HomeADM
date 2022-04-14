-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CTRDISPERSIONCARTAS
DELIMITER ;
DROP TABLE IF EXISTS `CTRDISPERSIONCARTAS`;
DELIMITER $$

CREATE TABLE `CTRDISPERSIONCARTAS` (
  `IDControl` int(11) NOT NULL COMMENT 'ID de Control de la Tabla',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `SolicitudCreditoID`  bigint(20) NOT NULL COMMENT 'Número de Solicitud',
  `Destino` char(1) DEFAULT 'C' COMMENT 'Tipo de Desitno \nC = Registro Cliente,\nL = Registro Carta de Liquidacion',
  `AsignacionCartaID` bigint(11) NOT NULL COMMENT 'ID de Asignación de la Carta.',
  `CasaComercialID` bigint(12) NOT NULL COMMENT 'ID Número de la Casa Comercial',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus con respecto a la Importacion de Dispersion .\nS: si Importada \n N: No Importada',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`IDControl`),
  KEY `FK_CTRDISPERSIONCARTAS_1_idx` (`SolicitudCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Control de las Cartas que se han Importado en el Proceso de Dispersion.'$$
