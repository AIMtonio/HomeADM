-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEUSUARIOS
DELIMITER ;
DROP TABLE IF EXISTS `BEUSUARIOS`;DELIMITER $$

CREATE TABLE `BEUSUARIOS` (
  `Clave` varchar(20) NOT NULL COMMENT 'Llave Primaria, es la Clave del Usuario',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Usuario\nA .- Activo\nB .- Bloqueado\nC .- Cancelado',
  `PerfilID` int(11) DEFAULT NULL,
  `EsUsuarioNomina` char(1) DEFAULT NULL COMMENT 'Indica si el usuario es un Cliente de Nomina\nS .- Si N .- No',
  `ClienteNominaID` int(11) DEFAULT NULL COMMENT 'ID del cliente de la empresa de Nomina',
  `NegocioAfiliadoID` int(11) DEFAULT NULL COMMENT 'ID Si es negocio Afiliado',
  `ClienteID` int(11) DEFAULT NULL,
  `CostoMensual` decimal(14,2) DEFAULT NULL COMMENT 'Costo por el Servicio de Banca en Linea, que sera cobrado a \nFin de Mes',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Clave`),
  KEY `fk_BEUSUARIOS_1_idx` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Usuario de la Banca en Linea'$$