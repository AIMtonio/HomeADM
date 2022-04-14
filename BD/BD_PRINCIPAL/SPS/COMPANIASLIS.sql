-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMPANIASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMPANIASLIS`;DELIMITER $$

CREATE PROCEDURE `COMPANIASLIS`(
	Par_NumLis			int(11),
	Par_RazonSocial		varchar(50),
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
)
TerminaStore: BEGIN

DECLARE Lis_Origen      int;
DECLARE Lis_Principal	int;

Set Lis_Origen         := 1;
Set Lis_Principal      := 2;


if(Par_NumLis = Lis_Origen) then
    select  Desplegado,OrigenDatos
        from COMPANIA;

end if;


if(Par_NumLis = Lis_Principal) then
    select  CompaniaID,RazonSocial,DireccionCompleta,OrigenDatos, Prefijo
        from COMPANIA
		where RazonSocial like concat("%",Par_RazonSocial,"%");
end if;


END TerminaStore$$