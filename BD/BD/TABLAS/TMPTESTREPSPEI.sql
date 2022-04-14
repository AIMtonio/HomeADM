-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTESTREPSPEI
DELIMITER ;
DROP TABLE IF EXISTS `TMPTESTREPSPEI`;DELIMITER $$

CREATE TABLE `TMPTESTREPSPEI` (
  `FolioSPEI` int(11) DEFAULT NULL,
  `CreditoID` int(11) DEFAULT NULL,
  `MontoPago` decimal(14,2) DEFAULT NULL,
  `TipoPago` varchar(200) DEFAULT NULL,
  `NumErr` int(11) DEFAULT NULL,
  `ErrMen` varchar(400) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$