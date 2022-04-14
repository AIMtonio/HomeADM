-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASCORREO
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASCORREO`;DELIMITER $$

CREATE TABLE `CUENTASCORREO` (
  `CuentaCorreoID` int(11) NOT NULL COMMENT 'Id o llave primara',
  `CorreoContactoCte` varchar(45) DEFAULT NULL COMMENT 'Cuenta de correo\nelectronico para\nel contacto con\nlos clientes',
  `AsuntoContactoCte` varchar(45) DEFAULT NULL COMMENT 'Asunto o subject\na mostrar en\nel envio de correos\na los clientes',
  `CorreoPromocion` varchar(45) DEFAULT NULL COMMENT 'Cuenta de correo\nelectronico para\nlas campanias\no promocion',
  `AsuntoPromocion` varchar(45) DEFAULT NULL COMMENT 'Asunto o subject\na mostrar en\nel envio de correos\na los clientes\ncomo promocion\no prospectacion',
  `CorreoRiesgos` varchar(45) DEFAULT NULL COMMENT 'Cuenta de correo\nelectronico para\nla administracion\ndel riesgos y\ncontrol de limites\nde la aplicacion',
  `AsuntoRiesgos` varchar(45) DEFAULT NULL COMMENT 'Asunto o subject\na mostrar en\nel envio de correos\ninternos por\nexceder los \nlimites de \noperacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CuentaCorreoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Definicion de las Cuentas de Correo de la Aplicacion'$$