-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPERFILTRANSREAL
DELIMITER ;
DROP TABLE IF EXISTS `PLDPERFILTRANSREAL`;
DELIMITER $$

CREATE TABLE `PLDPERFILTRANSREAL` (
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `Fecha` date NOT NULL COMMENT 'Fecha de Actualización',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente ID',
  `DepositosMax` decimal(16,2) DEFAULT NULL COMMENT 'Monto Máximo de Abonos y Retiros por Operación.',
  `RetirosMax` decimal(16,2) DEFAULT NULL COMMENT 'Número Máximo de Transacciones',
  `NumDepositos` int(11) DEFAULT NULL COMMENT 'Número de Depositos Maximos realizados en un periodo de un Mes',
  `NumRetiros` int(11) DEFAULT NULL COMMENT 'Número de Retiros Maximos realizados en un periodo de un Mes',
  `Hora` time DEFAULT NULL COMMENT 'Hora del Registro',
  `AntDepositosMax` decimal(16,2) DEFAULT NULL COMMENT 'Monto Maximo de Depositos Anterior',
  `AntRetirosMax` decimal(16,2) DEFAULT NULL COMMENT 'Monto Maximo de Retiros Anterior',
  `AntNumDepositos` int(11) DEFAULT NULL COMMENT 'Numero de depositos anterior',
  `AntNumRetiros` int(11) DEFAULT NULL COMMENT 'Numero de Retiros anterior declarado en el perfil y que esta autorizado',
  `TipoEval` char(1) DEFAULT 'P' COMMENT 'Tipo de Evaluación\nP:Periodica que se ejecuta cada vez que cumple cierto periodo a partir del alta del cliente, excepto todos los clientes anteriores del 2019-01-02, para ellos las evaluaciones son cada día 02.\nM: Evaluación Masiva aplica para todos los clientes independientemente si les toca evaluación o no.',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha De Inicio (Este va servir para saber el rango de la evaluacion)',
  `FechaFin` date DEFAULT NULL COMMENT 'Fecha Fin (Este va servir para saber el rango de la evaluacion)',
  `NivelRiesgo` char(1) DEFAULT NULL COMMENT 'Nivel de riesgo que tiene el cliente a la fecha que se hace la evaluacion del perfil.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ClienteID`,`TransaccionID`,`Fecha`),
  KEY `IDX_PLDPERFILTRANSREAL_001` (`TransaccionID`,`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena el perfil real del cliente.'$$