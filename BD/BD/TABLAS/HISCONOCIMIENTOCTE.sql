-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCONOCIMIENTOCTE
DELIMITER ;
DROP TABLE IF EXISTS `HISCONOCIMIENTOCTE`;
DELIMITER $$

CREATE TABLE `HISCONOCIMIENTOCTE` (
  `NumTransaccionAct` bigint(20) NOT NULL COMMENT 'Numero de Transaccion que realizo la actualización de los datos',
  `ClienteID` int(11) NOT NULL COMMENT 'Cliente ID',
  `NomGrupo` varchar(100) DEFAULT NULL COMMENT 'En caso de pertenecer a una sociedad, grupo o filial\n',
  `RFC` varchar(13) DEFAULT NULL COMMENT 'En caso de pertenecer a una sociedad, grupo o filial',
  `Participacion` decimal(14,2) DEFAULT NULL COMMENT 'En caso de pertenecer a una sociedad, grupo o filial',
  `Nacionalidad` varchar(45) DEFAULT NULL COMMENT 'En caso de pertenecer a una sociedad, grupo o filial',
  `RazonSocial` varchar(100) DEFAULT NULL COMMENT 'En caso de tener actividad empresarial\n',
  `Giro` varchar(100) DEFAULT NULL COMMENT 'En caso de tener actividad empresarial',
  `PEPs` char(1) DEFAULT NULL COMMENT 'Persona politicamente expuesta, aque individuo que desempeña o ha desempeñado funciones publicas destacadas en un pais extrajero o territorio nacional\nValor: S =Si\nN= No\n',
  `FuncionID` int(11) DEFAULT NULL COMMENT 'ID del Funcionario',
  `ParentescoPEP` char(1) DEFAULT NULL COMMENT 'Valor: S =Si\nN= No',
  `NombFamiliar` varchar(50) DEFAULT NULL COMMENT 'Nombre del familia',
  `APaternoFam` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno del familiar',
  `AMaternoFam` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno del familiar',
  `Cober_Geograf` char(10) DEFAULT NULL COMMENT 'valor : L=Local\nE=Estatal\nR=Regional\nN=Nacional\nI=Internacional\n',
  `Activos` decimal(14,2) DEFAULT NULL COMMENT 'Activos',
  `Pasivos` decimal(14,2) DEFAULT NULL COMMENT 'Pasivos',
  `Capital` decimal(14,2) DEFAULT NULL COMMENT 'Capital',
  `Importa` char(1) DEFAULT NULL COMMENT 'Valores Si=S\nNo=N',
  `DolaresImport` char(5) DEFAULT NULL COMMENT 'valores:\nmenos1000:DImp\n1,001 a 5,000:DImp2\n5,001 a 10,000:DImp3\nMayores 10,001DImp4',
  `PaisesImport` varchar(50) DEFAULT NULL COMMENT 'Pais al que importa',
  `PaisesImport2` varchar(50) DEFAULT NULL COMMENT 'Pais al que importa',
  `PaisesImport3` varchar(50) DEFAULT NULL COMMENT 'Pais al que importa',
  `Exporta` char(1) DEFAULT NULL COMMENT 'Valores Si=S\nNo=N',
  `DolaresExport` char(5) DEFAULT NULL COMMENT 'valores:\nmenos1000:DExp\n1,001 a 5,000: DExp2\n5,001 a 10,000: DExp3\nmayor10001:DExp4\n\n',
  `PaisesExport` varchar(50) DEFAULT NULL COMMENT 'Pais al que exporta',
  `PaisesExport2` varchar(50) DEFAULT NULL COMMENT 'Pais al que exporta',
  `PaisesExport3` varchar(50) DEFAULT NULL COMMENT 'Pais al que exporta',
  `PFuenteIng` varchar(100) DEFAULT NULL COMMENT 'Principal Fuente de Ingresos\n',
  `IngAproxMes` varchar(10) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `OperacionAnios` int(11) DEFAULT 0 COMMENT 'Años de operación',
  `GiroAnios` int(11) DEFAULT 0 COMMENT 'Años de Giro',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`ClienteID`,`NumTransaccionAct`),
  KEY `fk_HISCONOCIMIENTOCTE_1` (`FuncionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Historica de los Modificaciones de los Registros de la tabla de CONOCIMIENTOCTE'$$