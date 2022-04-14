-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BECARGAPAGNOMINALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BECARGAPAGNOMINALIS`;DELIMITER $$

CREATE PROCEDURE `BECARGAPAGNOMINALIS`(
    Par_FolioCargaID		int(11),
    Par_EmpresaNominaID		int(11),
    Par_TipoLis				int(11),

    Par_EmpresaID       	int(11),
    Aud_Usuario         	int(11),
    Aud_FechaActual     	datetime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int(11),
    Aud_NumTransaccion  	bigint(20)
	)
TerminaStore:BEGIN




DECLARE Lis_Principal   int;
DECLARE Lis_Combo		int;
DECLARE Est_NoProcesado	char(1);

DECLARE Cadena_Vacia    char(1);
DECLARE	Fecha_Vacia		date;
DECLARE Entero_Cero     int ;


Set Lis_Principal   	:= 1;
Set Lis_Combo			:= 2;
Set Est_NoProcesado		:= 'N';

Set Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set Entero_Cero			:= 0;


if(Par_TipoLis = Lis_Combo)then

	select Car.FolioCargaID
		from BECARGAPAGNOMINA Car
		inner join INSTITNOMINA Ins
		on Car.EmpresaNominaID=Ins.InstitNominaID
		where Car.Estatus = Est_NoProcesado
		and Car.EmpresaNominaID=Par_EmpresaNominaID
		and Car.NumPagosError=Entero_Cero
      and Car.NumPagosExito>Entero_Cero;

end if;

END TerminaStore$$