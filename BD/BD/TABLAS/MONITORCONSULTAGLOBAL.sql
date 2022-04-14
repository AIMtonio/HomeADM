-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONITORCONSULTAGLOBAL
DELIMITER ;
DROP TABLE IF EXISTS `MONITORCONSULTAGLOBAL`;
DELIMITER $$


CREATE TABLE `MONITORCONSULTAGLOBAL` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de la Transaccion',
  `SolicitudCreditoID` bigint(11) NOT NULL COMMENT 'ID de la Solicitud de Credito',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'ID del Credito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del Cliente',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Nombre del Cliente',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'ID del Prospecto',
  `NombreProspecto` varchar(200) DEFAULT NULL COMMENT 'Nombre del Prospecto',
  `PromotorID` int(11) DEFAULT NULL COMMENT 'ID del Promotor',
  `NombrePromotor` varchar(100) DEFAULT NULL COMMENT 'Nombre del Promotor',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'ID del Usuario',
  `NombreUsuario` varchar(160) DEFAULT NULL COMMENT 'Nombre del Usuario',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'ID de la Sucursal',
  `Comentario` varchar(6000) DEFAULT NULL COMMENT 'Comentario de la Solicitud',
  `Fecha` datetime DEFAULT NULL COMMENT 'Fecha del Comentario',
  `Estatus` char(2) DEFAULT NULL COMMENT 'Estatus de la Solicitud',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha de Registro de la Solicitud',
  `CanalIngreso` char(1) DEFAULT NULL COMMENT 'Canal de Ingreso de la Solicitud',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'ID del Producto de Credito',
  `Orden` int(11) DEFAULT NULL COMMENT 'Orden de los registros',
  `UsuarioConsulta` int(11) NOT NULL COMMENT 'Usuario que realiza la consulta',
  `Condicionada` char(1) DEFAULT NULL,
  `UsuarioIDAnalista` int(11) DEFAULT '0' COMMENT 'Id del usuario analista asignado para revisar la solicitd de credito',,
  `ClaveUsuario` varchar(45) DEFAULT '' COMMENT 'Clave del usuario analista',
  `MotivoRechazoID` varchar(50) DEFAULT NULL COMMENT 'Id motivo de rechazo de solicitud de credito',
  `DescripcionRegreso` varchar(1000) DEFAULT '' COMMENT 'Descripcion del motivo de regreso de la solicitud',
  `EstatusSolicitud` char(1) DEFAULT '' COMMENT 'Nombre de la Sucursal',
  `NombreSucursal` varchar(50) DEFAULT NULL COMMENT 'Nombre de la Sucursal',
  `DescProductoCre` varchar(100) DEFAULT NULL COMMENT 'Descripcion del\nTipo de Producto',
  `MontoCredito` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Credito otorgado al cliente',
  `TipoAsignacionID` int(11) DEFAULT '0' COMMENT 'Id Tipo de asignacion de la tabla cat: CATASIGNASOLICITUD; ',
  KEY `INDNUMTRANSAC` (`Transaccion`),
  KEY `MONITORCONSULTAGLOBAL_idx1` (`SolicitudCreditoID`) USING BTREE,
  KEY `MONITORCONSULTAGLOBAL_idx2` (`CreditoID`),
  KEY `MONITORCONSULTAGLOBAL_idx3` (`ClienteID`),
  KEY `MONITORCONSULTAGLOBAL_idx5` (`PromotorID`),
  KEY `MONITORCONSULTAGLOBAL_idx6` (`UsuarioID`),
  KEY `MONITORCONSULTAGLOBAL_idx7` (`SucursalID`),
  KEY `MONITORCONSULTAGLOBAL_idx8` (`Estatus`),
  KEY `MONITORCONSULTAGLOBAL_idx9` (`ProductoCreditoID`),
  KEY `MONITORCONSULTAGLOBAL_idx10` (`UsuarioConsulta`),
  KEY `MONITORCONSULTAGLOBAL_idx4` (`ProspectoID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Datos generales para el Monitor de Solicitud de Credito'$$