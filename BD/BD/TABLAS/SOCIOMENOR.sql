-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIOMENOR
DELIMITER ;
DROP TABLE IF EXISTS `SOCIOMENOR`;DELIMITER $$

CREATE TABLE `SOCIOMENOR` (
  `IDSocio` int(11) NOT NULL COMMENT 'Id del Socio Menor',
  `SocioMenorID` int(11) NOT NULL COMMENT 'Id del Socio Menor, FK con la tabla Clientes ',
  `ClienteTutorID` int(11) DEFAULT NULL COMMENT 'Id del Tutor, en caso de que el tutor sea socio de la financiera, FK de la tabla Clientes',
  `TipoRelacionID` int(11) DEFAULT NULL COMMENT 'Id del parentesco del menor con su Tutor, FK de la tabla TipoRelaciones',
  `NombreTutor` varchar(150) DEFAULT NULL COMMENT 'Nombre completo del Tutor, en caso de que no sea socio de la financiera',
  `EjecutivoCap` int(11) DEFAULT NULL COMMENT 'Ejecutivo de captación\n0.-No Asignado',
  `PromotorExtInv` int(11) DEFAULT NULL COMMENT 'Promotor Externo de inversiones\n0-No Asignado',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`IDSocio`,`SocioMenorID`),
  KEY `fk_SOCIOMENOR_1` (`SocioMenorID`),
  KEY `fk_SOCIOMENOR_2_idx` (`TipoRelacionID`),
  CONSTRAINT `fk_SOCIOMENOR_1` FOREIGN KEY (`SocioMenorID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOCIOMENOR_2` FOREIGN KEY (`TipoRelacionID`) REFERENCES `TIPORELACIONES` (`TipoRelacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena los tutores de los Socios Menores'$$