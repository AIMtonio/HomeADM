-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDMATRIZRIESGOXCONC
DELIMITER ;
DROP TABLE IF EXISTS `PLDMATRIZRIESGOXCONC`;DELIMITER $$

CREATE TABLE `PLDMATRIZRIESGOXCONC` (
  `MatrizCatalogoID` int(11) NOT NULL COMMENT 'ID del catalogo',
  `Folio` int(11) DEFAULT NULL COMMENT 'Numero de Folio ',
  `Tipo` int(11) DEFAULT NULL COMMENT 'Tipo \n1: Concepto\n2: Sub-Concepto',
  `MatrizConceptoID` int(11) DEFAULT NULL COMMENT 'Id del Concepto',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion',
  `Porcentaje` decimal(12,2) DEFAULT '0.00' COMMENT 'Porcentaje del Concepto',
  `LimiteInferior` decimal(14,2) DEFAULT NULL COMMENT 'Este campo aplica cuando es un rango',
  `LimiteSuperior` decimal(14,2) DEFAULT NULL COMMENT 'Este campo aplica cuando es un Rango',
  `Orden` int(11) DEFAULT NULL COMMENT 'Orden en el que se mostrara en pantalla.',
  `TipoPersona` char(1) DEFAULT 'T' COMMENT 'Tipo de Persona\nF:Fisica\nM:Moral\nT:Todas',
  `MostrarSub` char(1) DEFAULT 'N' COMMENT 'Mostrar Subconceptos o Subclasificaciones S:Si N:No',
  `EmpresaID` int(11) DEFAULT '1' COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT '1' COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT '127.0.0.1' COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT 'WORKBENCH' COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT '1' COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT '1' COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`MatrizCatalogoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para los conceptos de la matriz de riesgo por puntos'$$