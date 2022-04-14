DELIMITER ;
DROP TABLE IF EXISTS `TMPREGOPEINUTRAN`;
DELIMITER $$

CREATE TABLE `TMPREGOPEINUTRAN` (
  `Tmp_OpeInisial` bigint(12) unsigned NOT NULL AUTO_INCREMENT,
  `Tmp_Fecha` date DEFAULT NULL,
  `Tmp_ClaveRegistra` int(11) DEFAULT NULL,
  `Tmp_NombreReg` varchar(70) DEFAULT NULL,
  `Tmp_CatProcedIntID` char(10) DEFAULT NULL,
  `Tmp_CatMotivInuID` char(4) DEFAULT NULL,
  `Tmp_FechaDeteccion` date DEFAULT NULL,
  `Tmp_SucursalID` int(11) DEFAULT NULL,
  `Tmp_ClavePersonaInv` int(11) DEFAULT NULL,
  `Tmp_NomPersonaInv` varchar(250) DEFAULT NULL,
  `Tmp_EmpInvolucrado` char(1) DEFAULT NULL,
  `Tmp_Frecuencia` char(1) DEFAULT NULL,
  `Tmp_DesFrecuencia` char(1) DEFAULT NULL,
  `Tmp_DesOperacion` varchar(180) DEFAULT NULL,
  `Tmp_Estatus` int(11) DEFAULT NULL,
  `Tmp_ComentarioOC` char(1) DEFAULT NULL,
  `Tmp_FechaCierre` date DEFAULT NULL,
  `Tmp_CreditoID` bigint(12) DEFAULT NULL,
  `Tmp_CuentaID` bigint(12) DEFAULT NULL,
  `Tmp_TransaccionOpe` int(11) DEFAULT NULL,
  `Tmp_NaturalezaOpe` char(1) DEFAULT NULL,
  `Tmp_MontoOperacion` decimal(18,2) DEFAULT NULL,
  `Tmp_MonedaID` int(11) DEFAULT NULL,
  `Tmp_TipoOpeCNBV` char(2) DEFAULT NULL,
  `Tmp_FormaPago` char(1) DEFAULT NULL,
  `Tmp_TipoPersonaSAFI` varchar(3) DEFAULT NULL,
  `Tmp_NombresPersonaInv` varchar(150) DEFAULT NULL,
  `Tmp_ApPaternoPersonaInv` varchar(50) DEFAULT NULL,
  `Tmp_ApMaternoPersonaInv` varchar(50) DEFAULT NULL,
  `Tmp_OpeInusualID` bigint(20) DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`Tmp_OpeInisial`),
  KEY `IDX_TMPREGOPEINUTRAN_1` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP:Tabla para operaciones detectas, todas las que superen lo declarado en el perfil transaccional + holgura-PLDOPEINUSALERTTRANSPRO'$$
