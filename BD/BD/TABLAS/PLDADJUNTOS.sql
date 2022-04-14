-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDADJUNTOS
DELIMITER ;
DROP TABLE IF EXISTS `PLDADJUNTOS`;DELIMITER $$

CREATE TABLE `PLDADJUNTOS` (
  `AdjuntoID` int(11) NOT NULL COMMENT 'Id del Adjunto',
  `TipoProceso` int(11) NOT NULL COMMENT 'Tipo de Proceso que Adjunto el Archivo.\n1.- Segto Ope. Inusuales\n2.- Segto Ope. Interna Preocupanes',
  `OpeInusualID` bigint(20) DEFAULT NULL COMMENT 'Número de la Operación Inusual\n',
  `OpeInterPreoID` int(11) DEFAULT NULL COMMENT 'Número de Operacion Interna Preocupante que adjunto el archivo.',
  `TipoDocumento` int(11) DEFAULT NULL COMMENT 'Tipo de documento a digitalizar',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Numero consecutivo para la imagen a digitalizar',
  `Observacion` varchar(200) DEFAULT NULL COMMENT 'Descripcion breve referente al tipo de documento.',
  `Recurso` varchar(500) DEFAULT NULL COMMENT 'Recurso o Nombre de la Página.',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en la que se digitalizo el Archivo',
  `Estatus` char(1) DEFAULT 'A' COMMENT 'Estatus del Archivo A: Activo B:Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`AdjuntoID`),
  KEY `INDEX_PLDADJUNTOS_2` (`OpeInterPreoID`),
  KEY `INDEX_PLDADJUNTOS_1` (`OpeInusualID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que contiene el registro de los archivos Adjuntos de PLD para el proceso de Seguimiento de Ope. Inusuales e Internas Preocupantes.'$$