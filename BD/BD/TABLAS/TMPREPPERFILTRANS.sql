-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREPPERFILTRANS
DELIMITER ;
DROP TABLE IF EXISTS `TMPREPPERFILTRANS`;DELIMITER $$

CREATE TABLE `TMPREPPERFILTRANS` (
  `IdPerfil` int(11) DEFAULT NULL COMMENT 'Numero ID con esto podre relacionar con el perfil anterior',
  `IdAnterior` int(11) DEFAULT NULL COMMENT 'Numero ID del perfil anterior',
  `TransaccionID` bigint(20) NOT NULL COMMENT 'NUMERO DE TRANSACCION',
  `Fecha` date NOT NULL COMMENT 'FECHA DE ACTUALIZACIÓN',
  `Hora` time DEFAULT NULL COMMENT 'HORA DEL REGISTRO',
  `ClienteID` int(11) NOT NULL COMMENT 'NUMERO DE CLIENTE ID',
  `DepositosMax` decimal(16,2) DEFAULT NULL COMMENT 'MONTO MÁXIMO DE ABONOS Y RETIROS POR OPERACIÓN.',
  `RetirosMax` decimal(16,2) DEFAULT NULL COMMENT 'NÚMERO MÁXIMO DE TRANSACCIONES',
  `NumDepositos` int(11) DEFAULT NULL COMMENT 'NÚMERO DE DEPOSITOS MAXIMOS REALIZADOS EN UN PERIODO DE UN MES',
  `NumRetiros` int(11) DEFAULT NULL COMMENT 'NÚMERO DE RETIROS MAXIMOS REALIZADOS EN UN PERIODO DE UN MES',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus',
  `TipoProceso` char(1) DEFAULT NULL COMMENT 'Tipo de Proceso',
  `SucursalOri` int(11) DEFAULT NULL COMMENT 'Sucursal de Origen',
  `AntDepositosMax` decimal(16,2) DEFAULT NULL COMMENT 'Monto Maximo de Depositos Anterior',
  `AntRetirosMax` decimal(16,2) DEFAULT NULL COMMENT 'Monto Maximo de Retiros Anterior',
  `AntNumDepositos` int(11) DEFAULT NULL COMMENT 'Numero de depositos anterior',
  `AntNumRetiros` int(11) DEFAULT NULL COMMENT 'Numero de Retiros anterior declarado en el perfil y que esta autorizado'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla temporal para el reporte historico del perfil'$$