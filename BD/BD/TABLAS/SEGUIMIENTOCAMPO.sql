-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUIMIENTOCAMPO
DELIMITER ;
DROP TABLE IF EXISTS `SEGUIMIENTOCAMPO`;DELIMITER $$

CREATE TABLE `SEGUIMIENTOCAMPO` (
  `SeguimientoID` int(11) NOT NULL COMMENT 'Identificador del Seguimiento',
  `DescripcionSegto` varchar(150) DEFAULT NULL COMMENT 'Descripcion del Seguimiento',
  `CategoriaSegtoID` int(11) DEFAULT NULL COMMENT 'Identificador de la Categoria de Seguimiento',
  `CicloInicioCte` int(11) DEFAULT NULL COMMENT 'Ciclo Inicial del Cliente',
  `CicloFinCte` int(11) DEFAULT NULL COMMENT 'Ciclo Final del Cliente',
  `EjecutorID` int(11) DEFAULT NULL COMMENT 'Identificador del Ejecutor del Seguimiento',
  `NivelAplicaVentas` char(2) DEFAULT NULL COMMENT 'Nivel de Aplicacion de Seguimiento G=Global,R=Regional,S=Sucursal, A=Agencia,O=Oficial',
  `AplicaCarteraVigente` char(1) DEFAULT NULL COMMENT 'Si el seguimiento aplica para cartera vigente S=SI , N=No',
  `AplicaCarteraAtrasada` char(1) DEFAULT NULL COMMENT 'Si el seguimiento aplica para cartera Atrasada S=SI , N=No',
  `AplicaCarteraVencida` char(1) DEFAULT NULL COMMENT 'Si el seguimiento aplica para cartera vencida S=SI , N=No',
  `CarteraNoAplica` char(1) DEFAULT NULL COMMENT 'Campo que indica que NO se aplica estado de Cartera N.- NO',
  `PermiteManual` char(1) DEFAULT NULL COMMENT 'Si permite generacion manual S.- SI   N.- NO',
  `BaseGeneracion` char(1) DEFAULT NULL COMMENT 'Metodo de calculo de los seguimientos a generar P=Porciento,N=Numero',
  `ValorBase` varchar(45) DEFAULT NULL COMMENT 'Valor que aplicara a la base o metodo de calculo de los seguimientos a generar',
  `Alcance` char(1) DEFAULT NULL COMMENT 'Alcance que se aplicara al seguimiento  G.-Global, S.-Sucursal, E.-Ejcutivo, P.-Plazas',
  `RecPropios` char(1) DEFAULT NULL COMMENT 'Se aplica recursos propios para fondeo \nS.- Si\nN.- No',
  `FechaGeneracion` date DEFAULT NULL COMMENT 'Fecha en que se genero el Seguimiento',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Seguimiento V.- Vigente C.- Cancelado',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SeguimientoID`),
  KEY `fk_SEGUIMIENTOCAMPO_1` (`EjecutorID`),
  CONSTRAINT `fk_SEGUIMIENTOCAMPO_1` FOREIGN KEY (`EjecutorID`) REFERENCES `TIPOGESTION` (`TipoGestionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Definicion de parametros para la generacion del seguimiento '$$