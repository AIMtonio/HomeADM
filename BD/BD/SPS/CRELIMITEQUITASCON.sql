-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRELIMITEQUITASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRELIMITEQUITASCON`;
DELIMITER $$

CREATE PROCEDURE `CRELIMITEQUITASCON`(
	Par_ProducCreditoID	int(11),
	Par_ClavePuestoID	varchar(10),
	Par_NumCon			tinyint unsigned,

	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)

	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal	int;
DECLARE	Con_ProCreClaPu	int;
DECLARE 	Con_ProdsCreApli int;


Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Con_Principal		:= 1;
Set	Con_ProCreClaPu		:= 2;
Set Con_ProdsCreApli	:= 3;

if(Par_NumCon = Con_Principal) then

select ProducCreditoID			,ClavePuestoID			,LimMontoCap	,LimPorcenCap,
		LimMontoIntere			,LimPorcenIntere		,LimMontoMorato	,LimPorcenMorato,
		LimMontoAccesorios		,LimPorcenAccesorios	,NumMaxCondona	,NumTransaccion,
		LimMontoNotasCargos		,LimPorcenNotasCargos
from 	CRELIMITEQUITAS
		where 	ProducCreditoID = Par_ProducCreditoID;

end if;


if(Par_NumCon = Con_ProCreClaPu) then
	select 	ProducCreditoID,	ClavePuestoID,			LimMontoCap,		LimPorcenCap,	LimMontoIntere,
			LimPorcenIntere,	LimMontoMorato,			LimPorcenMorato,	LimMontoAccesorios,	LimPorcenAccesorios,
			NumMaxCondona,		LimMontoNotasCargos,	LimPorcenNotasCargos
			from 	CRELIMITEQUITAS
			where 	ProducCreditoID = Par_ProducCreditoID
			 and	ClavePuestoID	= Par_ClavePuestoID;
end if;


if(Par_NumCon  = Con_ProdsCreApli)then

SELECT distinct ProducCreditoID FROM  CRELIMITEQUITAS
		where Numtransaccion	=	Aud_NumTransaccion;

end if;


END TerminaStore$$