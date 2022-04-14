-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGBENEFICDISPERSIONCRE
DELIMITER ;
DROP TABLE IF EXISTS `REGBENEFICDISPERSIONCRE`;
DELIMITER $$

CREATE TABLE `REGBENEFICDISPERSIONCRE` (
  `RegistroID`	BIGINT(20)	NOT NULL COMMENT 'Número de Solicitud de Crédito',
  `SolicitudCreditoID`	BIGINT(20)	NOT NULL COMMENT 'Número de Solicitud de Crédito',
  `TipoDispersion`  CHAR(1) DEFAULT '' COMMENT 'Tipo o Medio de Dispersión para la Casa Comercial.\nC: Cheque\nS: SPEI\nO: Orden de Pago',
  `Beneficiario` VARCHAR(200) DEFAULT '' COMMENT 'Nombre completo del Beneficiario.',
  `CuentaCLABE` VARCHAR(20) DEFAULT '' COMMENT 'Cuenta CLABE de la Casa Comercial\ncuando el Tipo de Dispersión es por SPEI.',
  `MontoDispersion` DECIMAL(12,2) NOT NULL	COMMENT	'Monto Para Liquidar a fecha Proyectada',
  `PermiteModificar` INT(11) NOT NULL	DEFAULT 1	COMMENT 'Indica el nivel de datos que se pueden modicar 1.- Permiter todo en Nuevos, 2.- Permite Monto en externas, 3.- No permite modificar nada para internas',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`RegistroID`),
  KEY `IDX_REGBENEFICDISPERSIONCRE_1` (`SolicitudCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que Almacena Registros de Benificiarions de Instricciones de Dispersion de Cartas Int y Ext'$$
