-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BECARGAPAGNOMINACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BECARGAPAGNOMINACON`;DELIMITER $$

CREATE PROCEDURE `BECARGAPAGNOMINACON`(
    Par_FolioCargaID		int(11),
    Par_EmpresaNominaID		int(11),
    Par_TipoCon				int(11),

    Par_EmpresaID       	int(11),
    Aud_Usuario         	int(11),
    Aud_FechaActual     	datetime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int(11),
    Aud_NumTransaccion  	bigint(20)
	)
TerminaStore:BEGIN




DECLARE Con_Principal   int;
DECLARE Con_Monto		int;
DECLARE Est_PorAplicar	char(1);

DECLARE Cadena_Vacia    char(1);
DECLARE	Fecha_Vacia		date;
DECLARE Entero_Cero     int ;


Set Con_Principal   	:= 1;
Set Con_Monto			:= 3;
Set Est_PorAplicar		:='P';

Set Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set Entero_Cero			:= 0;


if(Par_TipoCon = Con_Monto)then

	select sum(Pag.MontoPagos) as MontoPagos
		from BECARGAPAGNOMINA Car
		inner join BEPAGOSNOMINA Pag
		on Car.FolioCargaID=Pag.FolioCargaID
		where Car.FolioCargaID= Par_FolioCargaID
		and Car.EmpresaNominaID=Par_EmpresaNominaID
		and Pag.Estatus=Est_PorAplicar;

end if;


END TerminaStore$$