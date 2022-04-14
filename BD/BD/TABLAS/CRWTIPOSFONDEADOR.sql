-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWTIPOSFONDEADOR
DELIMITER ;
DROP TABLE IF EXISTS `CRWTIPOSFONDEADOR`;
DELIMITER $$

CREATE TABLE `CRWTIPOSFONDEADOR` (
  `TipoFondeadorID` int(11) NOT NULL COMMENT 'Id del Tipo de Fondeador',
  `Descripcion` varchar(100) DEFAULT '' COMMENT 'Descripción del Fondeador.' ,
  `EsObligadoSol` char(1) DEFAULT 'N' COMMENT 'Especifica si el Tipo de Inversionista, es obligado solidario\nDel credito relacionado o fondeado\nS .- Si es Obligado Solidario,\nN .- No es Obligado Solidario',
  `PagoEnIncumple` char(1) DEFAULT 'N' COMMENT 'Especifica si se paga al Inversionista en el incumplimiento\nDe de pago de la parte Activa relacionada\n\nS .- Si se Paga,\nN .- No se Paga',
  `PorcentajeMora` decimal(12,4) DEFAULT '0.0000' COMMENT 'Porcentaje de Participacion en la Mora',
  `PorcentajeComisi` decimal(12,4) DEFAULT '0.0000' COMMENT 'Porcentaje de Participacion en Comisiones',
  `Estatus` char(1) DEFAULT 'V' COMMENT 'Estatus del Tipo de Fondeador.\nV: Vigente.\nI:Inactivo.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  PRIMARY KEY (`TipoFondeadorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Tipos de Fondeadores'$$