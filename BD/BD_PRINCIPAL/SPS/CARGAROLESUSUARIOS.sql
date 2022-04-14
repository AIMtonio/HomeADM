-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGAROLESUSUARIOS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGAROLESUSUARIOS`;DELIMITER $$

CREATE PROCEDURE `CARGAROLESUSUARIOS`(

)
TerminaStore: BEGIN

truncate table GRUPOSMENU;

insert into `GRUPOSMENU`
SELECT
`GRUPOSMENU`.`GrupoMenuID`,	`GRUPOSMENU`.`MenuID`,	`GRUPOSMENU`.`EmpresaID`,	`GRUPOSMENU`.`Descripcion`,
`GRUPOSMENU`.`Desplegado`,	`GRUPOSMENU`.`Orden`,	`GRUPOSMENU`.`Usuario`,		`GRUPOSMENU`.`FechaActual`,
`GRUPOSMENU`.`DireccionIP`,	`GRUPOSMENU`.`ProgramaID`,	`GRUPOSMENU`.`Sucursal`,	`GRUPOSMENU`.`NumTransaccion`
FROM `microfin`.`GRUPOSMENU`;

truncate table MENUSAPLICACION;

INSERT INTO `MENUSAPLICACION`
SELECT
`MENUSAPLICACION`.`MenuID`,	`MENUSAPLICACION`.`EmpresaID`,	`MENUSAPLICACION`.`Descripcion`,	`MENUSAPLICACION`.`Desplegado`,
`MENUSAPLICACION`.`Orden`,	`MENUSAPLICACION`.`Usuario`,	`MENUSAPLICACION`.`FechaActual`,	`MENUSAPLICACION`.`DireccionIP`,
`MENUSAPLICACION`.`ProgramaID`,`MENUSAPLICACION`.`Sucursal`,`MENUSAPLICACION`.`NumTransaccion`
FROM `microfin`.`MENUSAPLICACION`;

truncate table OPCIONESMENU;

insert into `OPCIONESMENU`
SELECT
`OPCIONESMENU`.`OpcionMenuID`,	`OPCIONESMENU`.`GrupoMenuID`,	`OPCIONESMENU`.`EmpresaID`,	`OPCIONESMENU`.`Descripcion`,
`OPCIONESMENU`.`Desplegado`,	`OPCIONESMENU`.`Recurso`,	`OPCIONESMENU`.`Orden`,	`OPCIONESMENU`.`RequiereCajero`,
`OPCIONESMENU`.`Usuario`,	`OPCIONESMENU`.`FechaActual`,	`OPCIONESMENU`.`DireccionIP`,	`OPCIONESMENU`.`ProgramaID`,
`OPCIONESMENU`.`Sucursal`,	`OPCIONESMENU`.`NumTransaccion`
FROM `microfin`.`OPCIONESMENU`;

truncate table OPCIONESROL;

INSERT `OPCIONESROL`
SELECT
`OPCIONESROL`.`RolID`,	`OPCIONESROL`.`OpcionMenuID`,	`OPCIONESROL`.`EmpresaID`,	`OPCIONESROL`.`Usuario`,
`OPCIONESROL`.`FechaActual`,	`OPCIONESROL`.`DireccionIP`,	`OPCIONESROL`.`ProgramaID`,	`OPCIONESROL`.`Sucursal`,
`OPCIONESROL`.`NumTransaccion`
FROM `microfin`.`OPCIONESROL`;

truncate table ROLES;

insert into `ROLES`
select `ROLES`.`RolID`,`ROLES`.`EmpresaID`,`ROLES`.`NombreRol`,`ROLES`.`Descripcion`,
		`ROLES`.`Usuario`,`ROLES`.`FechaActual`,`ROLES`.`DireccionIP`,`ROLES`.`ProgramaID`,
		`ROLES`.`Sucursal`,`ROLES`.`NumTransaccion`
		from `microfin`.`ROLES`;

truncate table USUARIOS;

insert into `USUARIOS`
select `USUARIOS`.`Clave`,`USUARIOS`.`RolID`,`USUARIOS`.`Estatus`,
		`USUARIOS`.`LoginsFallidos`,`USUARIOS`.`EstatusSesion`,'','microfin',
		`USUARIOS`.`EmpresaID`,`USUARIOS`.`Usuario`,`USUARIOS`.`FechaActual`,`USUARIOS`.`DireccionIP`,
		`USUARIOS`.`ProgramaID`,`USUARIOS`.`Sucursal`,`USUARIOS`.`NumTransaccion`
		from `microfin`.`USUARIOS` ;


END TerminaStore$$