-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTAARCHIVOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTAARCHIVOSREP`;DELIMITER $$

CREATE PROCEDURE `CUENTAARCHIVOSREP`(
	Par_CuentaAhoID			bigint(12),
	Par_NumRep			tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE	Rep_CtaArc	int;

Set		Rep_CtaArc	:= 1;

if(Par_NumRep = Rep_CtaArc) then
	select	CuentaAhoID,		TipoDocumento, 		ArchivoCtaID,
			Consecutivo, 		Observacion,   	      Recurso
	from		CUENTAARCHIVOS
	where	CuentaAhoID = Par_CuentaAhoID ;
end if;

END$$