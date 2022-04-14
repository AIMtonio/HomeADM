-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSDOCUMENTOS
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSDOCUMENTOS`;

DELIMITER $$
CREATE TABLE `TIPOSDOCUMENTOS` (
  `TipoDocumentoID` int(11) NOT NULL COMMENT 'Numero de Tipo de Documento',
  `Descripcion` varchar(60) NOT NULL COMMENT 'Descripcion del Tipo de Documento',
  `RequeridoEn` varchar(50) NOT NULL COMMENT 'En que modulo se ocupa el tipo de documento\r\n"C"- clientes\r\n"Q"- Cuentas\r\n"P"- PLD\r\n"G"- Garantias\r\n"S"- Solicitud Cred\r\n"O"- Poliza Contable\n"A" - Programa de Proteccion al Ahorro y Credito\n"B" - Gastos Funerarios (Servifun)\n"F" - Profun.\n"K" - Creditos.\n"Y" - Documentos de Apoyo Escolar\n"M" - Seguimiento',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Indica el Estatus en el que se encuentra el Tipo de Documento A=Activo, I=Inactivo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoDocumentoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Documentos que se pueden Digitalizar'$$