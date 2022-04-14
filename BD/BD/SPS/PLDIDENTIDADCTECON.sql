-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDIDENTIDADCTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDIDENTIDADCTECON`;DELIMITER $$

CREATE PROCEDURE `PLDIDENTIDADCTECON`(
Par_ClienteID		int(11),
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
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE Con_Principal 	tinyint unsigned;




Set Cadena_Vacia 		:= '';
Set Fecha_Vacia		 	:= '1900-01-01';
Set Entero_Cero			:= 0;
Set Con_Principal	:= 1;

if(Par_NumCon=Con_Principal) then
	select 	ClienteID,			AplicaCuest,		OtroAplDetalle,			RealizadoOp,			FuenteRecursos,
			FuenteOtraDet,		ObservacionesEjec,	NegocioPersona,			TipoNegocio,			TipoOtroNegocio,
			GiroNegocio,		AniosAntig,			MesesAntig,				UbicacNegocio,			EsNegocioPropio,
			EspecificarNegocio,	TipoProducto,		MercadoDeProducto,		IngresosMensuales,		DependientesEcon,
			DependienteHijo,	DependienteOtro,	TipoNuevoNegocio,		TipoOtroNuevoNegocio,	FteNuevosIngresos,
			ParentescoApert,	ParentescoOtroDet,	TiempoEnvio,			CuantoEnvio,			TrabajoActual,
			LugarTrabajoAct,	CargoTrabajo,		PeriodoDePago,			MontoPeriodoPago,		TiempoNuevoNeg,
			TiempoLaborado,		DependienteEconSA,	DependienteHijoSA,		DependienteOtroSA,		ProveedRecursos,
			TipoProvRecursos,	NombreCompProv,		DomicilioProv,			FechaNacProv,			NacionalidadProv,
			RfcProv,			RazonSocialProvB,	NacionalidProvB,		RfcProvB,				DomicilioProvB,
			PropietarioDinero,	PropietarioOtroDet,	PropietarioNombreCom,	PropietarioDomicilio,	PropietarioNacio,
			PropietarioCurp,	PropietarioRfc,		PropietarioGener,		PropietarioOcupac,		PropietarioFecha,
			PropietarioLugarNac,PropietarioEntid,	PropietarioPais,		CargoPubPEP,			CargoPubPEPDet,
			NivelCargoPEP,		Periodo1PEP,		Periodo2PEP,			IngresosMenPEP,			FamEnCargoPEP,
			ParentescoPEP,		NombreCompletoPEP,	ParentescoPEPDet,		CargoPubPEPDetFam,		NivelCargoPEPFam,
			Periodo1PEPFam,		Periodo2PEPFam,		ParentescoPEPFam,		NombreCtoPEPFam,		RelacionPEP,
			NombreRelacionPEP,	IngresoAdici,		FuenteIngreOS,			UbicFteIngreOS,			EsPropioFteIng,
			EsPropioFteDet,		IngMensualesOS,		TipoProdTN,				MercadoDeProdTN,		IngresosMensTN,
			DependEconTN,		DependHijoTN,		DependOtroTN
			from PLDIDENTIDADCTE where ClienteID=Par_ClienteID;
end if;

END TerminaStore$$