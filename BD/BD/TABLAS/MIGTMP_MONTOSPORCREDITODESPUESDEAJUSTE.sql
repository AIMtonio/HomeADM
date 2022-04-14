-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MIGTMP_MONTOSPORCREDITODESPUESDEAJUSTE
DELIMITER ;
DROP TABLE IF EXISTS `MIGTMP_MONTOSPORCREDITODESPUESDEAJUSTE`;DELIMITER $$

CREATE TABLE `MIGTMP_MONTOSPORCREDITODESPUESDEAJUSTE` (
  `CreditoID` int(11) NOT NULL COMMENT 'Credito',
  `IntVen` decimal(36,4) DEFAULT NULL,
  `IntProv` decimal(36,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$