-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEISOLDESREMCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEISOLDESREMCON`;DELIMITER $$

CREATE PROCEDURE `SPEISOLDESREMCON`(



	Par_SpeiSolDesID    bigint(20),
	Par_NumCon		    tinyint unsigned,

	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)

	)
TerminaStore: BEGIN


DECLARE	 Cadena_Vacia		char(1);
DECLARE	 Fecha_Vacia		date;
DECLARE	 Hora_Vacia 		time;
DECLARE	 Entero_Cero		int;
DECLARE	 Decimal_Cero		decimal(12,2);
DECLARE  Par_NumErr      	int;
DECLARE  Par_ErrMen      	varchar(400);
DECLARE  SalidaNO        	char(1);
DECLARE  SalidaSI        	char(1);
DECLARE	 Con_Principal	    int;
DECLARE	 Con_Pendiente		int;
DECLARE	 Est_Pendiente		char(1);
DECLARE	 Var_FechaSistema 	date;


Set	Cadena_Vacia		    := '';
Set	Fecha_Vacia			    := '1900-01-01';
Set	Hora_Vacia			    := '00:00:00';
Set	Entero_Cero			    := 0;
Set	Decimal_Cero		    := 0.0;
Set SalidaSI        	    := 'S';
Set SalidaNO        	    := 'N';
Set Par_NumErr  		    := 0;
Set Par_ErrMen  		    := '';
Set	Con_Principal		    := 1;
Set Con_Pendiente			:= 2;
Set	Est_Pendiente			:= 'P';

set Var_FechaSistema :=(select FechaSistema from PARAMETROSSIS);

if(Par_NumCon = Con_Principal) then
   Select SpeiSolDesID, date(FechaRegistro) as FechaRegistro,  date(FechaProceso) as FechaProceso, Estatus, Usuario
	from  SPEISOLDESREM
	where SpeiSolDesID = Par_SpeiSolDesID;

end if;

if(Par_NumCon = Con_Pendiente) then
	Select SpeiSolDesID
	from  SPEISOLDESREM
	where	Estatus	= Est_Pendiente and
    DATE(FechaRegistro) = Var_FechaSistema
    order by SpeiSolDesID, SpeiSolDesID asc
    limit 0,1;

end if;



END TerminaStore$$