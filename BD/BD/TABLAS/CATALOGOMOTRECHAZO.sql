-- CATALOGOMOTRECHAZO
DELIMITER ;
DROP TABLE IF EXISTS CATALOGOMOTRECHAZO;
DELIMITER $$
CREATE TABLE `CATALOGOMOTRECHAZO`(
  `MotivoRechazoID` int(11) NOT NULL COMMENT 'Id motivo de rechazo de solicitud de credito',
  `Descripcion` varchar(50)  NOT NULL COMMENT 'Descripcion del motivo rechazo',
  `TipoMotivo` varchar(1)  NOT NULL COMMENT 'Tipo del motivo \nC.- cancelacion \nD.- devolucion',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de motivo \nV vigente e \nI inactivo',
  `TipoPeticion` char(1) DEFAULT NULL COMMENT 'Estatus de motivo \nF financiera e \nC cliente aplica unicamente para tipo motivo Cancelacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`MotivoRechazoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: tabla para almacenar motivos de rechazo de una solicitud de credito'$$