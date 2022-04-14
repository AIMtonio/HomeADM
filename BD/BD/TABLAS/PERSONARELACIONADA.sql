-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERSONARELACIONADA
DELIMITER ;
DROP TABLE IF EXISTS `PERSONARELACIONADA`;DELIMITER $$

CREATE TABLE `PERSONARELACIONADA` (
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente ',
  `EmpleadoID` bigint(20) NOT NULL COMMENT 'Numero de empleado',
  `ClaveCNBV` int(11) NOT NULL COMMENT 'Clave del Tipo de Relacion Segun la CNBV y el SITI. 2 .- Consejo de Admon, 3 .- Consejo de Vigilancia, 4.- Comite de Credito, 8.- Funcionario con Firma o Poder, 7 .- Gerente General ',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria: Identificador de la empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria:Identificador del usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria: Fecha actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria: Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria: Identificador del programa',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria: Identificador de la sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria:Numero de transaccion',
  PRIMARY KEY (`ClienteID`,`EmpleadoID`),
  KEY `FK_PERSONARELACIONADA1_idx` (`ClaveCNBV`),
  CONSTRAINT `FK_PERSONARELACIONADA1` FOREIGN KEY (`ClaveCNBV`) REFERENCES `CLAVERELACIONCNVB` (`ClaveRelacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Relaciones entre clientes y funcionarios Segun Catalogo de CNBV'$$