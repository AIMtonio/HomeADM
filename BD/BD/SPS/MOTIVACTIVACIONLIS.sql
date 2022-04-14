-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MOTIVACTIVACIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `MOTIVACTIVACIONLIS`;DELIMITER $$

CREATE PROCEDURE `MOTIVACTIVACIONLIS`(

	Par_MotivoActivaID	varchar(100),
	Par_TipoMovimiento	int(11),
	Par_Descripcion		varchar(150),
	Par_NumLis			tinyint unsigned,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
    	)
TerminaStore: BEGIN

    DECLARE Lis_Principal		int;
    DECLARE Lis_Foranea			int;
    DECLARE Lis_Combo			int;
    DECLARE Lis_InacNoMue		int;
    DECLARE MotivoMuerte		int;
    DECLARE TipoInactivacion	int;


    Set	Lis_Principal		:= 1;
    Set	Lis_Foranea			:= 2;
    Set	Lis_Combo			:= 3;
    Set	Lis_InacNoMue		:= 4;
    Set	MotivoMuerte		:= 2;
    Set	TipoInactivacion	:= 2;


    if(Par_NumLis = Lis_Principal) then
        select MotivoActivaID,Descripcion
        from MOTIVACTIVACION
        where TipoMovimiento = Par_TipoMovimiento and Descripcion like concat("%", Par_Descripcion, "%")
        limit 0, 15;
    end if;

    if(Par_NumLis = Lis_Combo) then
        select MotivoActivaID,Descripcion
        from MOTIVACTIVACION
        where TipoMovimiento = Par_TipoMovimiento;
    end if;


    if(Par_NumLis = Lis_InacNoMue) then
        select MotivoActivaID,	Descripcion
			from MOTIVACTIVACION
			where TipoMovimiento = TipoInactivacion
			 and	MotivoActivaID != MotivoMuerte ;
    end if;

END TerminaStore$$