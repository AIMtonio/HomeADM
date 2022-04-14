-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPINSERTMUNICI
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPINSERTMUNICI`;DELIMITER $$

CREATE PROCEDURE `TMPINSERTMUNICI`(	)
TerminaStore: BEGIN

INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(12,77,1,'MARQUELIA','01313379',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(12,78,1,'COCHOAPA EL GRANDE','01378001',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(12,79,1,'JOSE JOAQUIN HERRERA','01379005',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(12,80,1,'JUCHITAN','01380003',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(12,81,1,'ILIATENCO','01399007',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(14,125,1,'SAN IGNACIO CERRO GORDO','01508692',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(15,123,1,'LUVIANOS','01824006',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(15,124,1,'SAN JOSE DEL RINCON','01825001',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(15,125,1,'TONANITLA','01826008',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(23,9,1,'TULUM','03499003',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(23,10,1,'BACALAR','03499003',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(30,211,1,'SAN RAFAEL','04203156',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(30,212,1,'SANTIAGO SOCHIAPAN','04308006',1,NULL,'127.0.0.1','pentaho',1,1);
INSERT INTO `MUNICIPIOSREPUB`(`EstadoID`,`MunicipioID`,`EmpresaID`,`Nombre`,`Localidad`,`Usuario`, `FechaActual`,`DireccionIP`,`ProgramaID`,`Sucursal`,`NumTransaccion`) VALUES(32,58,1,'SANTA MARIA DE LA PAZ','04658008',1,NULL,'127.0.0.1','pentaho',1,1);


END TerminaStore$$