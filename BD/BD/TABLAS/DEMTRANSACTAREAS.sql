-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMTRANSACTAREAS
DELIMITER ;
DROP TABLE IF EXISTS `DEMTRANSACTAREAS`;DELIMITER $$

CREATE TABLE `DEMTRANSACTAREAS` (
  `Transacciones` char(20) NOT NULL COMMENT 'Numero de transaccion'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que almacenara un consecutivo (numero de transaccion) para las transacciones de las tareas ejecutadas por el demonio'$$