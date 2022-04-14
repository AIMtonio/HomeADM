-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REMESACATALOGO
DELIMITER ;
DROP TABLE IF EXISTS `REMESACATALOGO`;
DELIMITER $$


CREATE TABLE `REMESACATALOGO` (
  `RemesaCatalogoID` int(11) NOT NULL COMMENT 'llave primaria para el catalogo de remesas',
  `Nombre` varchar(200) DEFAULT NULL COMMENT 'Nombre completo de "Numero" del catalogo de remesas',
  `NombreCorto` varchar(50) DEFAULT NULL COMMENT 'Nombre corto de "Numero" del catalogo de remesas',
  `CuentaCompleta` varchar(25) DEFAULT NULL COMMENT 'Cuenta Completa con llave foranea de a cuentas contables\n',
  `CCostosRemesa` varchar(30) DEFAULT NULL COMMENT 'Nomenclatura para indicar el Centro de Costos para la Remesa\n&SC = Sucursal Cliente \n&SO = sucursal Origen de la Operacion',
  `Estatus` CHAR(2) NOT NULL DEFAULT 'A' COMMENT 'Estatus del Tipo de Remesa \nA.-Activo\n I.-Inactivo.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`RemesaCatalogoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de la pantalla "Ventanilla/TallerProductos/Catalogo'$$