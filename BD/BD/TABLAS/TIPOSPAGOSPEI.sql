-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSPAGOSPEI
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSPAGOSPEI`;DELIMITER $$

CREATE TABLE `TIPOSPAGOSPEI` (
  `TipoPagoID` int(2) NOT NULL COMMENT 'ID tipo pago',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del Tipo de pago',
  `Aceptacion` char(1) NOT NULL COMMENT 'Obligatoria(O), Opcional (P)',
  `Estatus` char(1) NOT NULL COMMENT 'Activo (A), Inactivo (I).',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TipoPagoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo Tipos de Pago'$$