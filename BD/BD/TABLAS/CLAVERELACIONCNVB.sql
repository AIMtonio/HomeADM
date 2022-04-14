-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLAVERELACIONCNVB
DELIMITER ;
DROP TABLE IF EXISTS `CLAVERELACIONCNVB`;DELIMITER $$

CREATE TABLE `CLAVERELACIONCNVB` (
  `ClaveRelacionID` int(11) NOT NULL COMMENT 'ID de la Clave de la Relacion',
  `Descripcion` varchar(1000) NOT NULL COMMENT 'Descripcion del Tipo de Relacion segun CNBV',
  `TipoInstitID` int(11) NOT NULL DEFAULT '0' COMMENT 'Tipo de Institucion  - 3 : Sofipo, 6:  Socap, de la tabla TIPOSINSTITUCIONES',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria: Identificador de la empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria:Identificador del usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria: Fecha actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria: Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria: Identificador del programa',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria: Identificador de la sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria:Numero de transaccion',
  PRIMARY KEY (`ClaveRelacionID`,`TipoInstitID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Claves de Relaciones entre clientes y funcionarios Segun Catalogo de CNBV'$$