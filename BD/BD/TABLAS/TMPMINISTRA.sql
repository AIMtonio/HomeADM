-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPMINISTRA
DELIMITER ;
DROP TABLE IF EXISTS `TMPMINISTRA`;
DELIMITER $$


CREATE TABLE `TMPMINISTRA` (
  `GrupoID` int(10) DEFAULT NULL COMMENT 'Numero identificador del Grupo',
  `NombreGrupo` varchar(200) DEFAULT NULL COMMENT 'Nombre del Grupo',
  `TipoFondeo` varchar(200) DEFAULT NULL COMMENT 'Tipo de Fondeo del Grupo',
  `SucursalID` int(10) DEFAULT NULL COMMENT 'Numero identificador de la Sucursal',
  `NombreSucurs` varchar(200) DEFAULT NULL COMMENT 'Nombre de la Sucursal',
  `NombrePromotor` varchar(200) DEFAULT NULL COMMENT 'Nombre del Promotor',
  `PromotorID` int(11) DEFAULT NULL COMMENT 'Numero Identificador del Promotor',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero Identificador del Cliente',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo del Cliente',
  `SolicitudCreditoID` bigint(20) DEFAULT NULL COMMENT 'Numero Identificador de la Solicitud de Credito',
  `FechaRegistro` char(10) DEFAULT NULL COMMENT 'Fecha de Registro',
  `MontoSolici` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la Solicitud',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Numero Identificador del Credito',
  `FechaAutoriza` date DEFAULT NULL COMMENT 'Fecha de Autorizacion',
  `MontoCredito` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Credito',
  `MontoDesembolso` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Desembolso',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `TipoDispersion` varchar(50) DEFAULT NULL COMMENT 'Tipo de Dispersion',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'Numero Identificador del Producto de Credito',
  `ProductoDesc` varchar(200) DEFAULT NULL COMMENT 'Descripcion del Prodcuto',
  `InstitNominaID`    INT(11) DEFAULT NULL  COMMENT 'Numero de la institucion de nomina, en caso credito nomina',
  `ConvenioNominaID`    BIGINT UNSIGNED DEFAULT NULL  COMMENT 'Numero de convenio de nomina, en caso credito nomina',
  `FechaEmision` date DEFAULT NULL COMMENT 'Fecha de Emision',
  `HoraEmision` time DEFAULT NULL COMMENT 'Hora de Emision',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria Fecha',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria DireccionIP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria NumTrasaccion',
  KEY `idx_GrupoID` (`GrupoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal para guardar toda la información de los créditos ministrados y créditos agro.'$$