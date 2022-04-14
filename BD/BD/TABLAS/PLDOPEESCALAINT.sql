-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEESCALAINT
DELIMITER ;
DROP TABLE IF EXISTS `PLDOPEESCALAINT`;DELIMITER $$

CREATE TABLE `PLDOPEESCALAINT` (
  `OperProcesoID` bigint(12) NOT NULL COMMENT 'Es el ID del proceso\nque disparo escalamiento\n\n(CtaAhoID, \nLineaCreditoID,\n SolicitudCreditoID,\n InversionID, \nFondeoSolicitudID,\n CreditoID  ,\n \n nombre de \nusuario\n (en caso de no \ntener cve de \nusuarios))',
  `ProcesoEscID` varchar(16) NOT NULL COMMENT 'clave del proceso que genero el escalamiento\nsegún catalogo de procesos de escalamiento',
  `FechaDeteccion` datetime DEFAULT NULL COMMENT 'fecha de deteccion del escalamiento',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal donde se genero el escalamiento',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente',
  `MatNivelRiesgo` char(1) DEFAULT NULL COMMENT 'Si hubo coincidencia por nivel de riesgo\n\n1=match, Nulo=no match',
  `MatPeps` char(1) DEFAULT NULL COMMENT 'Si hubo coincidencia por nivel de riesgo\n\n1=match, Nulo=no match',
  `MatCta3SinDecl` char(1) DEFAULT NULL COMMENT 'Si hubo coincidencia por actuacion por cuenta de tercero sin haberlo declarado\n\n1=match, Nulo=no match',
  `MatDetDoctos` char(1) DEFAULT NULL COMMENT 'Si hubo coincidencia por existir dudas en documentacion de identificacion o documentos para determinar perfil transaccional\n1=match, Nulo=no match',
  `MatMonto` char(1) DEFAULT NULL COMMENT 'Si hubo coincidencia por montos en procesos de aplicación de pagos, adquisicion de servicios en efectivo\n\n1=match, Nulo=no match',
  `MatchOtro` char(1) DEFAULT NULL COMMENT 'Si hubo coincidencia por otras razones en alguno de los procesos que detectan escalamiento\n1=match\nNulo=no match\n',
  `MatchOtroDesc` char(40) DEFAULT NULL COMMENT 'En caso de otra coincidencia descripcion de la coincidencia\nSolo cuando el campo de dpld_escala_match_otro\n\n',
  `CveFuncionario` int(11) DEFAULT NULL COMMENT 'clave del funcionario (Usuario) que realizo el escalamiento\n(según catalogo de empleados y funcionarios)\n',
  `TipoResultEscID` char(1) DEFAULT NULL COMMENT 'cve de resultado de la revision en escalamiento (Estatus)\n\n',
  `ClaveJustEscIntID` int(11) DEFAULT NULL COMMENT 'Cve de la justificacion de la decision en el escalamiento interno\nSegún catalogo de justificaciones\n',
  `SolSeguimiento` char(1) DEFAULT NULL COMMENT 'Si se requirio seguimiento de la operación',
  `NotasRevisor` varchar(1500) DEFAULT NULL COMMENT 'Notas u observaciones del funcionario revisor',
  `FechRealizacion` datetime DEFAULT NULL COMMENT 'fecha y hora de realizacion del escalamiento (cuando se acepta o rechaza solamente)',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`OperProcesoID`,`ProcesoEscID`),
  KEY `fk_PLDOPEESCALAINT_2` (`CveFuncionario`),
  KEY `fk_PLDOPEESCALAINT_3` (`TipoResultEscID`),
  KEY `fk_PLDOPEESCALAINT_1` (`ProcesoEscID`),
  KEY `fk_PLDOPEESCALAINT_4` (`ClaveJustEscIntID`),
  CONSTRAINT `fk_PLDOPEESCALAINT_1` FOREIGN KEY (`ProcesoEscID`) REFERENCES `PROCESCALINTPLD` (`ProcesoEscID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PLDOPEESCALAINT_2` FOREIGN KEY (`CveFuncionario`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PLDOPEESCALAINT_3` FOREIGN KEY (`TipoResultEscID`) REFERENCES `TIPORESULESCPLD` (`TipoResultEscID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PLDOPEESCALAINT_4` FOREIGN KEY (`ClaveJustEscIntID`) REFERENCES `PLDCLAJUSESCINTER` (`ClaveJustEscIntID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalles de las oper que solicitaron escalamiento interno y '$$