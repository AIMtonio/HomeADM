-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOPROGRAMADO
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOPROGRAMADO`;DELIMITER $$

CREATE TABLE `SEGTOPROGRAMADO` (
  `SegtoPrograID` int(11) NOT NULL,
  `CreditoID` bigint(12) DEFAULT NULL,
  `GrupoID` int(11) DEFAULT NULL,
  `FechaProgramada` date DEFAULT NULL COMMENT 'Fecha programada para llevar a  cabo el seguimiento',
  `HoraProgramada` char(5) DEFAULT NULL,
  `CategoriaID` int(11) DEFAULT NULL,
  `PuestoResponsableID` int(11) DEFAULT NULL COMMENT 'ID de la persona que debera efectuar el segto',
  `PuestoSupervisorID` int(11) DEFAULT NULL COMMENT 'ID de la persona que  supervisara y autorizara  el segto',
  `TipoGeneracion` char(1) DEFAULT NULL COMMENT 'A=Automatico, M=Manual\nIndica si se genero por sistema, segun la definicion del segto, o manualmente\n\n',
  `SecSegtoForzado` int(11) DEFAULT NULL COMMENT 'Numero de secuencia del segto que requirio y genero este segto forzado',
  `FechaRegistro` datetime DEFAULT NULL COMMENT 'fecha de la sesion en la que se requirio y genero este segto forzado',
  `FechaInicioSegto` datetime DEFAULT NULL COMMENT 'fecha de inicio del segto realizado',
  `FechaFinalSegto` datetime DEFAULT NULL COMMENT 'fecha de finalizacion del segto realizado',
  `ResultadoSegtoID` int(11) DEFAULT NULL COMMENT 'Resultados del segto programado',
  `RecomendacionSegtoID` int(11) DEFAULT NULL COMMENT 'Recomendación final del segto programado',
  `Estatus` char(1) DEFAULT NULL COMMENT 'P=Programado, I=Iniciado, T=Terminado, C=Cancelado, R=Reprogramado, A=Autorizado',
  `EsForzado` char(1) DEFAULT NULL COMMENT 'S=''Si'' N=''No''',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SegtoPrograID`),
  KEY `fk_SEGTOPROGRAMADO_1` (`CategoriaID`),
  KEY `fk_SEGTOPROGRAMADO_2` (`ResultadoSegtoID`),
  KEY `fk_SEGTOPROGRAMADO_3` (`RecomendacionSegtoID`),
  KEY `fk_SEGTOPROGRAMADO_4` (`PuestoResponsableID`),
  CONSTRAINT `fk_SEGTOPROGRAMADO_1` FOREIGN KEY (`CategoriaID`) REFERENCES `SEGTOCATEGORIAS` (`CategoriaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Generacion del Seguimiento Programado en base a la definicion'$$