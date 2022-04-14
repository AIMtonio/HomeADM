-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ROLESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ROLESLIS`;DELIMITER $$

CREATE PROCEDURE `ROLESLIS`(
	Par_NomRol		varchar(45),
	Par_NumLis		tinyint unsigned,
	Par_EmpresaID		int,

	Aud_Usuario		int,
	Aud_FechaActual	DateTime,
	Aud_DireccionIP	varchar(15),
	Aud_ProgramaID	varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Lis_Principal   int;
DECLARE Lis_Todos       int;


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Lis_Principal   := 1;
Set Lis_Todos       := 2;

if(Par_NumLis = Lis_Principal) then
	select	`RolID`,		`NombreRol`
	from ROLES
	where  NombreRol like concat("%", Par_NomRol, "%")
	limit 0, 15;
end if;

if(Par_NumLis = Lis_Todos) then
    select  `RolID`,    `Descripcion`
        from ROLES;
end if;


END TerminaStore$$