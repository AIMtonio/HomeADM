-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMSKUBO
DELIMITER ;
DROP TABLE IF EXISTS `PARAMSKUBO`;DELIMITER $$

CREATE TABLE `PARAMSKUBO` (
  `PorcSalCapFondeo` decimal(10,2) DEFAULT NULL COMMENT 'Porcentaje De Saldo de Capital No Pagado para Poder ser Fondeado el Credito',
  `PorcPropFondeo` decimal(10,2) DEFAULT NULL COMMENT 'Porcentaje que se Debe mantener del Fondeo Propio (Institucion)',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Registro',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa Origen',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal Origen',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros Generales de Kubo Financiero'$$