-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TCR_TCISSVALF_ADM
DELIMITER ;
DROP TABLE IF EXISTS `TCR_TCISSVALF_ADM`;DELIMITER $$

CREATE TABLE `TCR_TCISSVALF_ADM` (
  `Iss_Seccion` int(11) NOT NULL COMMENT 'Seccion del archivo ISS',
  `Iss_CampoID` int(11) NOT NULL COMMENT 'CampoID del archivo ISS',
  `Iss_Alias` varchar(25) DEFAULT NULL COMMENT 'Alias del archivo ISS',
  `Iss_Descri` varchar(1008) DEFAULT NULL COMMENT 'Descripcion del archivo ISS',
  `Iss_AltaNom` varchar(30) DEFAULT NULL COMMENT 'Nombre del archivo ISS',
  `Iss_AltaLot` varchar(30) DEFAULT NULL COMMENT 'Lote del archivo ISS',
  `Iss_Modifi` varchar(30) DEFAULT NULL COMMENT 'Modificacion del archivo ISS',
  `Iss_AsignaL` varchar(30) DEFAULT NULL COMMENT 'Asiganacion del archivo ISS',
  `Iss_AltaNomDeb` varchar(30) DEFAULT NULL COMMENT 'Nombre Debito del archivo ISS',
  `Iss_AltaLotDeb` varchar(30) DEFAULT NULL COMMENT 'Nombre Lote Debito del archivo ISS',
  `Iss_ModifiDeb` varchar(30) DEFAULT NULL COMMENT 'Modificacion Debito del archivo ISS',
  `Iss_AsignaLDeb` varchar(30) DEFAULT NULL COMMENT 'Asiganacion Lote Debito del archivo ISS',
  PRIMARY KEY (`Iss_Seccion`,`Iss_CampoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene la parametrizacion de las secciones del archivo ISS'$$