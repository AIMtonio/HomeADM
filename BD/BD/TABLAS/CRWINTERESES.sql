-- CRWINTERESES
DELIMITER ;
DROP TABLE IF EXISTS `CRWINTERESES`;
DELIMITER $$

CREATE TABLE `CRWINTERESES` (
  `ClienteID`			INT(11) 		NOT NULL COMMENT 'ID  del cliente',
  `CuentaAhoID`			BIGINT(12) 		NOT NULL COMMENT 'ID de la cuenta de Ahorro del Cliente',
  `Fecha`				DATE			NOT NULL COMMENT 'Fecha del abono',
  `InteresGlobal`		DECIMAL(14,2)	NOT NULL COMMENT 'Interes Global',
  `InteresImpulso`		DECIMAL(14,2)	NOT NULL COMMENT 'Interes Impulso',
  `InteresPlazoF`		DECIMAL(14,2)	NOT NULL COMMENT 'Interes plazo',
  `InteresImpulsoMora`	DECIMAL(14,2)	NOT NULL COMMENT 'Interes Impulso Mora',
  `InteresComFaltaPago`	DECIMAL(14,2)	NOT NULL COMMENT 'Interes con falta de pago',
  `RetenISRCtaAho`		DECIMAL(14,2)	NOT NULL COMMENT 'Retención ISR para cuenta de ahorro',
  `RetenISRPF`			DECIMAL(14,2)	NOT NULL COMMENT 'Retención ISR para persona fisica',
  `RetenISRImpulso`		DECIMAL(14,2)	NOT NULL COMMENT 'Retención ISR Impulso',
  `RetenISRImpMor`		DECIMAL(14,2)	NOT NULL COMMENT 'Retención ISR',
  `RetenISRComFal`		DECIMAL(14,2)	NOT NULL COMMENT 'Retención ISR',
  `ExentoISRCtaAho`		DECIMAL(12,2)	NOT NULL COMMENT 'Exento ISR',
  `ExentoISRPF`			DECIMAL(12,2)	NOT NULL COMMENT 'Exento ISR',
  `ExentoISRImpulso`	DECIMAL(12,2)	NOT NULL COMMENT 'Exento ISR',
  `ExentoISRImpMor`		DECIMAL(12,2)	NOT NULL COMMENT 'Exento ISR',
  `ExentoISRComFal`		DECIMAL(12,2)	NOT NULL COMMENT 'Exento ISR',
  PRIMARY KEY (`ClienteID`,`CuentaAhoID`,`Fecha`),
  KEY `IDX_Cta` (`CuentaAhoID`) USING BTREE,
  KEY `IDX_CtaFecha` (`CuentaAhoID`,`Fecha`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA DE INTERESES'$$
