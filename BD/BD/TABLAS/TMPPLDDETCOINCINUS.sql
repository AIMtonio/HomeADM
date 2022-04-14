
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDDETCOINCINUS`;

DELIMITER $$
CREATE TABLE `TMPPLDDETCOINCINUS` (
	`Aut_TmpID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID de la deteccion PLD.',
	`ListaPLDID` bigint(12) NOT NULL COMMENT 'Id que corresponde a las tablas de PLDLISTANEGRAS, PLDLISTAPERSBLOQ dependiendo del tipo de Lista.',
	`TipoLista` char(1) NOT NULL COMMENT 'Tipo de Lista PLD \nN: Listas Negras \nB: Listas Pers. Bloqueadas',
	`TipoListaID` varchar(45) DEFAULT '' COMMENT 'Subtipo de lista: PEP, SAT, OFAC, ETC. Corresponde al catálogo CATTIPOLISTAPLD.',
	`ClavePersonaInv` int(11) NOT NULL COMMENT 'ID o Clave de la Persona Involucrada',
	`PrimerNombre` varchar(50) DEFAULT NULL COMMENT 'Primer Nombre del Cliente',
	`SegundoNombre` varchar(50) DEFAULT NULL COMMENT 'Segundo Nombre del Cliente.',
	`TercerNombre` varchar(50) DEFAULT NULL COMMENT 'Tercer Nombre Del Cliente.',
	`ApellidoPaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno del Cliente.',
	`ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno del Cliente.',
	`RFCOficial` char(13) DEFAULT NULL COMMENT 'RFC del cliente ya sea RFC que es asignado como persona fisica o el RFC como persona moral',
	`FechaNacimiento` date DEFAULT NULL COMMENT 'Fecha Nacimiento del Cliente o Rep Legal.',
	`NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos.',
	`CuentaAhoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'Número de la cuenta de ahorro en caso de aplicar.',
	`LugarNacimiento` int(11) DEFAULT NULL COMMENT 'Pais de Nacimiento, llave foranea a PAISES.',
	`EstadoID` int(11) DEFAULT NULL COMMENT 'Identificador de Estado que Se Encuentra en la tabla ESTADOSREPUB',
	`TipoPersonaSAFI` varchar(3) NOT NULL COMMENT 'Tipo de la persona involucrada\nCTE.- Cliente\nUSU.- Usuario de Servicios\nAVA.- Avales\nPRO.- Prospectos\nREL.-  Relacionados de la cuenta (Que no son socios/clientes)\nNA.- No Aplica (cuando no se trata de Clientes ni de Usuarios)',
	`TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial.',
	`NumTransaccion` bigint(12) DEFAULT '0' COMMENT 'Número de la Transacción.',
	PRIMARY KEY (`Aut_TmpID`),
	KEY `IDX_TMPPLDDETCOINCINUS_001` (`NumTransaccion`),
	KEY `IDX_TMPPLDDETCOINCINUS_002` (`NumTransaccion`, `TipoLista`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Registros de coincidencias para la generación de Alertas Inusuales PLD.'$$

