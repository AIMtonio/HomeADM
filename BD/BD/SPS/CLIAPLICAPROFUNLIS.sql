-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPLICAPROFUNLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPLICAPROFUNLIS`;DELIMITER $$

CREATE PROCEDURE `CLIAPLICAPROFUNLIS`(

	Par_NombreComp		varchar(100),
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Lis_Registrado	int;
DECLARE Lis_Autorizado  int;
DECLARE Est_Registrado  char(1);
DECLARE Est_Autorizado  char(1);


Set Lis_Registrado    := 1;
Set Lis_Autorizado    := 2;
Set Est_Registrado    :='R';
set Est_Autorizado    :='A';


if(Par_NumLis = Lis_Registrado) then
    select  cp.ClienteID,    c.NombreCompleto
    from    CLIENTESPROFUN cp,
			CLIENTES c
    where   cp.ClienteID	=   c.ClienteID
	and		c.NombreCompleto   like concat("%", Par_NombreComp, "%")
    and     cp.Estatus		=   Est_Registrado
    limit 0, 15;
end if;

if(Par_NumLis = Lis_Autorizado) then
	select  cp.ClienteID, c.NombreCompleto
	from    CLIAPLICAPROFUN cp,
			CLIENTES c
	where   cp.ClienteID = c.ClienteID
	and c.NombreCompleto like concat("%", Par_NombreComp, "%")
	and  cp.Estatus = Est_Autorizado
	limit 0, 15;

end if;

END TerminaStore$$