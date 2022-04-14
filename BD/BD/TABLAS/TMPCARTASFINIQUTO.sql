-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCARTASFINIQUTO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCARTASFINIQUTO`;DELIMITER $$

CREATE TABLE `TMPCARTASFINIQUTO` (
  `Transaccion` bigint(20) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT NULL,
  `CreditoIDMig` bigint(12) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(200) DEFAULT NULL,
  `FechaTerminacion` date DEFAULT NULL,
  `SucursalID` int(11) DEFAULT NULL,
  `NombreSucurs` varchar(200) DEFAULT NULL,
  `EstadoSucID` int(11) DEFAULT NULL,
  `EstadoSucNom` varchar(50) DEFAULT NULL,
  `MunicipioSucID` int(11) DEFAULT NULL,
  `MunicipioSucNom` varchar(50) DEFAULT NULL,
  `ProductoCreditoID` int(11) DEFAULT NULL,
  `Descripcion` varchar(200) DEFAULT NULL,
  `ProductoNomina` char(1) DEFAULT NULL,
  `PromotorActual` int(11) DEFAULT NULL,
  `NombrePromotor` varchar(200) DEFAULT NULL,
  `FechaEmision` date DEFAULT NULL,
  `SolicitudCreditoID` bigint(12) DEFAULT NULL,
  `InstitucionNomID` int(11) DEFAULT NULL,
  `NombreInstNomina` varchar(200) DEFAULT NULL,
  `DirecInstNomina` varchar(200) DEFAULT NULL,
  `EstatusCredito` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$