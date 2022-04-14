-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETOPEALRIESPLDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETOPEALRIESPLDREP`;DELIMITER $$

CREATE PROCEDURE `DETOPEALRIESPLDREP`(
	Par_FechaIni			date,
	Par_FechaFin			date,
	Par_Sucursal			int,
	Par_ProNRiesgoCteID	char(3),
	Par_MotivoNRiesgoID	char(3),
	Par_Escalamiento		char(1),
	Par_Seguimiento		char(1),

	Par_EmpresaID		int,
	Aud_Usuario		int,
	Aud_FechaActual	DateTime,
	Aud_DireccionIP	varchar(15),
	Aud_ProgramaID	varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

select	Det.OpeAltoRiesgoID,		Det.ContratoID,		Det.ConsecContrato,		Det.ClienteID,
		Cli.NombreCompleto,		Det.UsuarioID,		Det.FechaDeteccion,		Det.SucursalManeja,
		Suc.NombreSucurs,			Det.MotivoNRiesgoID,	Mor.Descripcion as MorDescri,
		Det.ProNRiesgoCteID,		Nir.Descripcion as NorDescri,
		Det.CveInstrumento,		Det.ModuloInstrumento,	Det.MontoOperacion,
		Det.MonedaID,				Mon.DescriCorta,		Det.TuvoEscalam,			Det.ConsecEscalam,
		Det.TuvoSeguim,			Det.ConsecSeguim,		ModuloInstrumento

	from DETOPEALRIESPLD Det,
		 PRONRIESGCTEPLD Nir,
		 MOTIVNRIESGOCTE Mor,
		 CLIENTES Cli,
		 SUCURSALES Suc,
		 MONEDAS Mon
	where	Det.ClienteID			= Cli.ClienteID
	  and	FechaDeteccion		>= Par_FechaIni
	  and	FechaDeteccion		<= Par_FechaFin
	  and	Det.ProNRiesgoCteID	= Nir.ProNriesgoCteID
	  and	Det.MotivoNRiesgoID	= Mor.MotivoNRiesgoID
	  and	Det.SucursalManeja	= Suc.SucursalID
	  and 	Det.MonedaID			= Mon.MonedaId;


END TerminaStore$$