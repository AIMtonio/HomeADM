-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIAPORTACIONES
DELIMITER ;
DROP TABLE IF EXISTS `SPEIAPORTACIONES`;
DELIMITER $$


CREATE TABLE `SPEIAPORTACIONES` (
  `FolioSpeiID` BIGINT(20) NOT NULL COMMENT 'Folio de SPEI',
  `ClaveRastreo` varchar(30) DEFAULT NULL COMMENT 'Clave de rastreo del movimiento',
  `Estatus` varchar(45) DEFAULT NULL COMMENT 'Estatus P = PENDIENTE, D= DISPERSADO, C= Cancelado',
  `AportBeneficiarioID`BIGINT UNSIGNED NOT NULL COMMENT 'ID del beneficiario, tabla HISAPORTBENEFICIARIOS',
  `CuentaAhoID` bigint(12) DEFAULT '0' COMMENT 'Cuenta del Aportante',
  `MontoAportacion` decimal(18,2) DEFAULT '0.00' COMMENT 'Monto de la Aportacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'AUDITORIA',
  `Usuario` int(11) DEFAULT NULL COMMENT 'AUDITORIA',
  `FechaActual` datetime DEFAULT NULL COMMENT 'AUDITORIA',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'AUDITORIA',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'AUDITORIA',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'AUDITORIA',
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FolioSpeiID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: TABLA AUXILIAR APRA LAS DISPERSIONES DE APORTACIONES HECHAS POR SPEI '$$
