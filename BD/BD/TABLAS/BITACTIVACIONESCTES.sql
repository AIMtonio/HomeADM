
DELIMITER ;
DROP TABLE IF EXISTS `BITACTIVACIONESCTES`;

DELIMITER $$
CREATE TABLE `BITACTIVACIONESCTES` (
	`AutRegistroID` bigint(12) UNSIGNED NOT NULL AUTO_INCREMENT,
	`ClienteID` int(11) NOT NULL COMMENT 'Número de Cliente.',
	`Estatus` char(1) DEFAULT '' COMMENT 'Estatus del cliente.\nA.- Activo.\nI.- Inactivo.',
	`TipoInactiva` int(11) DEFAULT 0 COMMENT 'Tipo de Movimiento.\n1.-Activación.\n2.-Inactivacion.',
	`MotivoInactiva` varchar(150) DEFAULT '' COMMENT 'Motivo de la Activación o Inactivación.',
	`FechaBaja` date DEFAULT '1900-01-01' COMMENT 'Fecha en la que se da de Baja al Cliente.',
	`FechaReactivacion` date DEFAULT '1900-01-01' COMMENT 'Fecha de Reactivación del Cliente.',
	`EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
	`Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
	`FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria.',
	`DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria.',
	`ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria.',
	`Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
	`NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria.',
	PRIMARY KEY(`AutRegistroID`),
	KEY `IDX_BITACTIVACIONESCTES_001` (`ClienteID`),
	KEY `IDX_BITACTIVACIONESCTES_002` (`Estatus`),
	KEY `IDX_BITACTIVACIONESCTES_003` (`TipoInactiva`),
	KEY `IDX_BITACTIVACIONESCTES_004` (`ProgramaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'BIT: Bitácora que Almacena el Histórico de Actualizaciones por Activación o Inactivación de Clientes antes de su Actualización.'$$

