
DELIMITER ;
DROP TABLE IF EXISTS `BITPLDDETCOINCINUS`;

DELIMITER $$
CREATE TABLE `BITPLDDETCOINCINUS` (
	`Aut_TmpID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID de la deteccion PLD.',
	`ListaPLDID` bigint(12) NOT NULL COMMENT 'Id que corresponde a las tablas de PLDLISTANEGRAS, PLDLISTAPERSBLOQ dependiendo del tipo de Lista.',
	`TipoLista` char(1) NOT NULL COMMENT 'Tipo de Lista PLD \nN: Listas Negras \nB: Listas Pers. Bloqueadas',
	`TipoListaID` varchar(45) DEFAULT '' COMMENT 'Subtipo de lista: PEP, SAT, OFAC, ETC. Corresponde al catálogo CATTIPOLISTAPLD.',
	`ClavePersonaInv` int(11) NOT NULL COMMENT 'ID o Clave de la Persona Involucrada',
	`TipoPersonaSAFI` varchar(3) NOT NULL COMMENT 'Tipo de la persona involucrada\nCTE.- Cliente\nUSU.- Usuario de Servicios\nAVA.- Avales\nPRO.- Prospectos\nREL.-  Relacionados de la cuenta (Que no son socios/clientes)\nNA.- No Aplica (cuando no se trata de Clientes ni de Usuarios)',
	`NumErr` int(11) NOT NULL COMMENT 'Número de error tras la ejecución del SP-PLDGENALERTASINUSPRO.',
	`ErrMen` varchar(400) NOT NULL COMMENT 'Mensaje de error tras la ejecución del SP-PLDGENALERTASINUSPRO.',
	`EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
	`Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
	`FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
	`DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
	`ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
	`Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
	`NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
	PRIMARY KEY (`Aut_TmpID`),
	KEY `IDX_BITPLDDETCOINCINUS_001` (`NumTransaccion`),
	KEY `IDX_BITPLDDETCOINCINUS_002` (`TipoPersonaSAFI`, `ClavePersonaInv`),
	KEY `IDX_BITPLDDETCOINCINUS_003` (`ListaPLDID`, `TipoLista`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bit: Bitácora de errores en la generación de Alertas Inusuales PLD.'$$

