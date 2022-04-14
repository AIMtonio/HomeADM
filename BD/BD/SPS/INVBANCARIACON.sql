-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVBANCARIACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVBANCARIACON`;DELIMITER $$

CREATE PROCEDURE `INVBANCARIACON`(


	Par_InversionID 		int,
	Par_TipoConsulta		int,

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

)
TerminaStore: BEGIN

	DECLARE Principal int;

	set Principal := 1;

	if(Principal = Par_TipoConsulta)then
		select InversionID,			InstitucionID,								NumCtaInstit,		TipoInversion,	Monto,
				Plazo,				Tasa,										TasaISR,			TasaNeta,		InteresGenerado,
				InteresRecibir,		InteresRetener,								TotalRecibir,		Estatus,		UsuarioID,
				MonedaID,			date(FechaVencimiento)as FechaVencimiento, 	date(FechaInicio)as FechaInicio, 	DiasBase,
				ClasificacionInver,	TipoTitulo,									TipoRestriccion,	TipoDeuda
		from INVBANCARIA where InversionID = Par_InversionID;

	end if;
END TerminaStore$$