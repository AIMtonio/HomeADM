-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDETECPERS
DELIMITER ;
DROP TABLE IF EXISTS `PLDDETECPERS`;
DELIMITER $$

CREATE TABLE `PLDDETECPERS` (
  `IDPLDDetectPers` bigint(20) NOT NULL COMMENT 'Id de la deteccion PLD',
  `TipoPersonaSAFI` varchar(3) NOT NULL COMMENT 'Tipo de la persona involucrada\nCTE.- Cliente\nUSU.- Usuario de Servicios\nAVA.- Avales\nPRO.- Prospectos\nREL.-  Relacionados de la cuenta (Que no son socios/clientes)\nNA.- No Aplica (cuando no se trata de Clientes ni de Usuarios)',
  `ClavePersonaInv` int(11) NOT NULL COMMENT 'ID o Clave de la Persona Involucrada',
  `NombreCompleto` varchar(250) NOT NULL COMMENT 'Nombre completo de la persona',
  `TipoLista` char(1) NOT NULL COMMENT 'Tipo de Lista PLD \nN: Listas Negras \nB: Listas Pers. Bloqueadas',
  `FechaDeteccion` date NOT NULL COMMENT 'Fecha de la Detección',
  `ListaPLDID` bigint(12) NOT NULL COMMENT 'Id que corresponde a las tablas de PLDLISTANEGRAS, PLDLISTAPERSBLOQ dependiendo del tipo de Lista.',
  `IDQEQ` varchar(20) DEFAULT '' COMMENT 'ID del catalogo de Quien es Quien',
  `NumeroOficio` varchar(50) DEFAULT '0' COMMENT 'Numero de Oficio. Este campo no es obligatorio y por default es 0.',
  `OrigenDeteccion` char(1) DEFAULT 'P' COMMENT 'Origen de la Deteccion.\nP.- Pantallas\nC.- Carga Masiva',
  `FechaAlta` date DEFAULT '1900-01-01' COMMENT 'Fecha de Registro en la listas Negras / Personas Bloq.',
  `TipoListaID` varchar(45) DEFAULT '' COMMENT 'Subtipo de lista: PEP, SAT, OFAC, ETC. Corresponde al cataĺogo CATTIPOLISTAPLD.',
  `CuentaAhoID` bigint(12) DEFAULT '0' COMMENT 'Número de la Cuenta de Ahorro para cuando con Relacionados a la Cuenta.',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`IDPLDDetectPers`),
  UNIQUE KEY `IDPLDDetectPers_UNIQUE` (`IDPLDDetectPers`),
  KEY `PLDDETECPERS_IDX_1` (`ClavePersonaInv`),
  KEY `PLDDETECPERS_IDX_2` (`ListaPLDID`),
  KEY `PLDDETECPERS_IDX_3` (`TipoListaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que guarda los Clientes encontrados en Listas Negras y Personas Bloqueadas.'$$