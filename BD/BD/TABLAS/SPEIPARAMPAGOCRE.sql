-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIPARAMPAGOCRE
DELIMITER ;
DROP TABLE IF EXISTS `SPEIPARAMPAGOCRE`;
DELIMITER $$


CREATE TABLE `SPEIPARAMPAGOCRE` (
  `NumEmpresaID` 			INT(11) NOT NULL COMMENT 'ID de la empresa',
  `AplicaPagAutCre` 		CHAR(1) NOT NULL COMMENT 'Pago Automatico S.-SI\n N.-NO',
  `EnCasoNoTieneExiCre`		CHAR(1) DEFAULT NULL COMMENT 'No Tiene Exigible el credito A.-Abono a Cta.\n P.-Prepago',
  `EnCasoSobrantePagCre` 	CHAR(1) DEFAULT NULL COMMENT 'Tiene Sobrante del Pago A.-Abono a Cta.\n P.-Prepago',
    
  `EmpresaID` 				INT(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` 				INT(11) DEFAULT NULL,
  `FechaActual` 			DATETIME DEFAULT NULL,
  `DireccionIP` 			VARCHAR(15) DEFAULT NULL,
  `ProgramaID` 				VARCHAR(50) DEFAULT NULL,
  `Sucursal` 				INT(11) DEFAULT NULL,
  `NumTransaccion` 			BIGINT(20) DEFAULT NULL,
  PRIMARY KEY (`NumEmpresaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TAB: Tabla que contiene la parametrizacion de pago de credito'$$
