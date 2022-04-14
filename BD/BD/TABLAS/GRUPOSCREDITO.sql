-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `GRUPOSCREDITO`;DELIMITER $$

CREATE TABLE `GRUPOSCREDITO` (
  `GrupoID` int(10) NOT NULL COMMENT 'ID de Grupo',
  `NombreGrupo` varchar(200) DEFAULT NULL COMMENT 'Nombre del Grupo',
  `FechaRegistro` datetime DEFAULT NULL COMMENT 'Fecha de Registro',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Id de la Sucursal',
  `CicloActual` int(11) DEFAULT NULL COMMENT 'Numero del Ciclo Actual Comienza en Cero',
  `EstatusCiclo` char(1) DEFAULT NULL COMMENT 'Estatus del Ciclo Actual\nA.- Abierto\nC .- Cerrado\nN .- No Iniciado',
  `FechaUltCiclo` datetime DEFAULT NULL COMMENT 'Fecha del Ultimo Ciclo',
  `CicloPonderado` int(11) DEFAULT NULL COMMENT 'Ciclo Ponderado del Grupo, en case de que el producto pondere ciclos de los integrantes',
  `EsAgropecuario` char(1) DEFAULT NULL COMMENT 'Indica si el grupo pertenece al modulo Agro S = SI N= NO',
  `TipoOperaAgro` char(2) DEFAULT NULL COMMENT 'Indica el tipo de operacion que se utilizara para los grupos de creditos AGRO: G: GLOBAL NF: NO FORMAL',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`GrupoID`),
  KEY `fk_GRUPOSCREDITO_1` (`SucursalID`),
  CONSTRAINT `fk_GRUPOSCREDITO_1` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Grupos de Creditos'$$