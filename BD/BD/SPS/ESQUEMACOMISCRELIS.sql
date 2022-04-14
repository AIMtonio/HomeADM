-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACOMISCRELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMACOMISCRELIS`;DELIMITER $$

CREATE PROCEDURE `ESQUEMACOMISCRELIS`(
	Par_ProducCreditoID 	int(11),
	Par_NumLis			tinyint unsigned,
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia	date;
DECLARE	Entero_Cero	int;
DECLARE	Lis_Principal	int;
DECLARE	Monto		char(1);


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia	:= '1900-01-01';
Set	Entero_Cero	:= 0;
Set	Lis_Principal	:= 1;
Set	Monto		:= 'M';

if(Par_NumLis = Lis_Principal) then
	select	EsquemaComID,	MontoInicial,	MontoFinal,	TipoComision,
		case when TipoComision = Monto then
		round(Comision,2)
		ELSE Comision
			END
	from ESQUEMACOMISCRE
where  ProducCreditoID =Par_ProducCreditoID;
end if;

END TerminaStore$$