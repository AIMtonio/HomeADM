-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLBUROCREDITOAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLBUROCREDITOAACT`;DELIMITER $$

CREATE PROCEDURE `SOLBUROCREDITOAACT`(
Par_Tipo	INT,
Par_RFC	VARCHAR(13),
Par_FolioConsul VARCHAR(30),
Par_NumTransacc bigint
	)
TerminaStore: BEGIN

DECLARE  Entero_Cero		int;
DECLARE  SalidaSI			char(1);
DECLARE  SalidaNO			char(1);
DECLARE  ActualizaBuro		int;
DECLARE  ActualizaCirculo	int;


Set	Entero_Cero		:= 0;
Set SalidaSI		:='S';
Set SalidaNO		:='N';
Set  ActualizaBuro		:=1;
Set  ActualizaCirculo	:=2;

if Par_Tipo = ActualizaBuro then
	Update SOLBUROCREDITO set
	FolioConsulta 	= Par_FolioConsul
		where	RFC 			= Par_RFC
		and 	NumTransaccion	= Par_NumTransacc;
end if;
if Par_Tipo = ActualizaCirculo then
	Update SOLBUROCREDITO set
	FolioConsultaC	= Par_FolioConsul
	where	RFC 			= Par_RFC
	and 	NumTransaccion	= Par_NumTransacc;

end if;



select	'000' as NumErr ,
		'Solicitud Actualizada: ' as ErrMen,
		'folioConsulta' as control,
		 Par_FolioConsul as consecutivo;
END TerminaStore$$