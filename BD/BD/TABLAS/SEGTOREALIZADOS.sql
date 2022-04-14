-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOREALIZADOS
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOREALIZADOS`;DELIMITER $$

CREATE TABLE `SEGTOREALIZADOS` (
  `SegtoPrograID` int(11) NOT NULL COMMENT 'Consecutivo por cada credito, corresponde con la tabla SEGTOPROGRAMADO',
  `SegtoRealizaID` int(11) NOT NULL COMMENT 'Consecutivo por cada SegtoPrograID',
  `UsuarioSegto` int(11) DEFAULT NULL COMMENT 'Persona que realizo el seguimiento, corrresponde con tabla USUARIOS',
  `FechaSegto` date DEFAULT NULL COMMENT 'Fecha en la cual se llevo a  cabo el seguimiento',
  `HoraCaptura` char(5) DEFAULT NULL COMMENT 'Hora de Captura de Seguimiento',
  `TipoContacto` char(1) DEFAULT NULL COMMENT 'Indica quien atendio el segto: C=Cliente, V=Aval, O=Cónyuge, H=Hijo, P=Padre, A=Administrador, N=Contador, T=Otro',
  `NombreContacto` varchar(200) DEFAULT NULL COMMENT 'Nombre de la persona que atendió el segto, en caso de cliente , copiará el nombre desde la tabla de CLIENTES',
  `ClienteEnterado` char(1) DEFAULT NULL COMMENT 'El Cliente estaba enterado del segto a realizar? S=SI , N=No',
  `FechaCaptura` date DEFAULT NULL COMMENT 'fecha del sistema en la que se realizó la captura del segto realizado',
  `Comentario` varchar(1000) DEFAULT NULL COMMENT 'Comentario que se obtuvo del seguimiento realizado. Texto libre',
  `TelefonFijo` varchar(20) DEFAULT NULL COMMENT 'Telefono fijo del Cliente',
  `TelefonCel` varchar(20) DEFAULT NULL COMMENT 'Telefono celular del cliente',
  `ResultadoSegtoID` int(11) DEFAULT NULL COMMENT 'Resultados del segto programado tabla SEGTORESULTADOS',
  `FechaSegtoFor` date DEFAULT NULL COMMENT 'Fecha si como parte del segto se requiere siguiente segto programado forzado',
  `HoraSegtoFor` char(5) DEFAULT NULL COMMENT 'Hora de proximo segto programado forzado',
  `RecomendacionSegtoID` int(11) DEFAULT NULL COMMENT 'Primera Recomendación del segto programado, FK SEGTORECOMENDAS',
  `SegdaRecomendaSegtoID` int(11) DEFAULT NULL COMMENT 'Segunda Recomendación del segto programado, FK SEGTORECOMENDAS',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estado del Segto programado I=Iniciado, T=Terminado, C=Cancelado, R=Reprogramado, A=Autorizado ',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SegtoPrograID`,`SegtoRealizaID`),
  KEY `fk_SEGTOREALIZADOS_1_idx` (`UsuarioSegto`),
  KEY `fk_SEGTOREALIZADOS_2_idx` (`ResultadoSegtoID`),
  KEY `fk_SEGTOREALIZADOS_3_idx` (`RecomendacionSegtoID`),
  KEY `fk_SEGTOREALIZADOS_4_idx` (`SegdaRecomendaSegtoID`),
  CONSTRAINT `fk_SEGTOREALIZADOS_1` FOREIGN KEY (`UsuarioSegto`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SEGTOREALIZADOS_2` FOREIGN KEY (`ResultadoSegtoID`) REFERENCES `SEGTORESULTADOS` (`ResultadoSegtoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SEGTOREALIZADOS_3` FOREIGN KEY (`RecomendacionSegtoID`) REFERENCES `SEGTORECOMENDAS` (`RecomendacionSegtoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SEGTOREALIZADOS_4` FOREIGN KEY (`SegdaRecomendaSegtoID`) REFERENCES `SEGTORECOMENDAS` (`RecomendacionSegtoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Seguimiento Realizado'$$