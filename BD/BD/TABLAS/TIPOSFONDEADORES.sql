-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSFONDEADORES
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSFONDEADORES`;DELIMITER $$

CREATE TABLE `TIPOSFONDEADORES` (
  `TipoFondeadorID` int(11) NOT NULL COMMENT 'Id del Tipo de Fondeador',
  `Descripcion` varchar(100) DEFAULT NULL,
  `EsObligadoSol` char(1) DEFAULT NULL COMMENT 'Especifica si el Tipo de Inversionista, es obligado solidario\nDel credito relacionado o fondeado\nS .- Si es Obligado Solidario,\nN .- No es Obligado Solidario',
  `PagoEnIncumple` char(1) DEFAULT NULL COMMENT 'Especifica si se paga al Inversionista en el incumplimiento\nDe de pago de la parte Activa relacionada\n\nS .- Si se Paga,\nN .- No se Paga',
  `PorcentajeMora` decimal(8,4) DEFAULT NULL COMMENT 'Porcentaje de Participacion en la Mora',
  `PorcentajeComisi` decimal(8,4) DEFAULT NULL COMMENT 'Porcentaje de Participacion en Comisiones',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoFondeadorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Tipos de Fondeadores'$$