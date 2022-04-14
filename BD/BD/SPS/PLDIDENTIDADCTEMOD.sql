-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDIDENTIDADCTEMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDIDENTIDADCTEMOD`;DELIMITER $$

CREATE PROCEDURE `PLDIDENTIDADCTEMOD`(
	Par_ClienteID				int(11),
	Par_AplicaCuest				char(1),
	Par_OtroAplDetalle			varchar(200),
	Par_RealizadoOp				char(1),
	Par_FuenteRecursos			char(1),
	Par_FuenteOtraDet			varchar(200),
	Par_ObservacionesEjec		varchar(200),
	Par_NegocioPersona			varchar(45),
	Par_TipoNegocio				char(1),
	Par_TipoOtroNegocio			varchar(100),

	Par_GiroNegocio				varchar(100),
	Par_AniosAntig				int(11),
	Par_MesesAntig				int(11),
	Par_UbicacNegocio			varchar(200),
	Par_EsNegocioPropio			char(1),
	Par_EspecificarNegocio		varchar(200),
	Par_TipoProducto			varchar(500),
	Par_MercadoDeProducto		varchar(200),
	Par_IngresosMensuales		decimal(14,2),
	Par_DependientesEcon		int(11),

	Par_DependienteHijo			int(11),
	Par_DependienteOtro			int(11),
	Par_TipoNuevoNegocio		char(1),
	Par_TipoOtroNuevoNegocio	varchar(100),
	Par_FteNuevosIngresos		varchar(500),
	Par_ParentescoApert			varchar(100),
	Par_ParentescoOtroDet		varchar(200),
	Par_TiempoEnvio				varchar(50),
	Par_CuantoEnvio				decimal(14,2),
	Par_TrabajoActual			varchar(100),

	Par_LugarTrabajoAct			varchar(300),
	Par_CargoTrabajo			varchar(100),
	Par_PeriodoDePago			varchar(100),
	Par_MontoPeriodoPago		decimal(14,2),
	Par_TiempoNuevoNeg			varchar(50),
	Par_TiempoLaborado			varchar(100),
	Par_DependienteEconSA		int(11),
	Par_DependienteHijoSA		int(11),
	Par_DependienteOtroSA		int(11),
	Par_ProveedRecursos			char(1),

	Par_TipoProvRecursos		char(1),
	Par_NombreCompProv			varchar(100),
	Par_DomicilioProv			varchar(300),
	Par_FechaNacProv			date,
	Par_NacionalidadProv		varchar(100),
	Par_RfcProv					varchar(18),
	Par_RazonSocialProvB		varchar(100),
	Par_NacionalidProvB			varchar(100),
	Par_RfcProvB				varchar(18),
	Par_DomicilioProvB			varchar(300),

	Par_PropietarioDinero		char(1),
	Par_PropietarioOtroDet		varchar(100),
	Par_PropietarioNombreCom	varchar(45),
	Par_PropietarioDomicilio	varchar(300),
	Par_PropietarioNacio		varchar(100),
	Par_PropietarioCurp			varchar(18),
	Par_PropietarioRfc			varchar(18),
	Par_PropietarioGener		char(1),
	Par_PropietarioOcupac		varchar(100),
	Par_PropietarioFecha		date,

	Par_PropietarioLugarNac		varchar(100),
	Par_PropietarioEntid		varchar(100),
	Par_PropietarioPais			varchar(100),
	Par_CargoPubPEP				char(1),
	Par_CargoPubPEPDet			varchar(100),
	Par_NivelCargoPEP			char(1),
	Par_Periodo1PEP				varchar(50),
	Par_Periodo2PEP				varchar(50),
	Par_IngresosMenPEP			decimal(14,2),
	Par_FamEnCargoPEP			char(1),

	Par_ParentescoPEP			char(1),
	Par_NombreCompletoPEP		varchar(100),
	Par_ParentescoPEPDet		varchar(100),
	Par_CargoPubPEPDetFam		varchar(100),
	Par_NivelCargoPEPFam		char(1),
	Par_Periodo1PEPFam			varchar(50),
	Par_Periodo2PEPFam			varchar(50),
	Par_ParentescoPEPFam		char(1),
	Par_NombreCtoPEPFam			varchar(100),
	Par_RelacionPEP				char(1),

	Par_NombreRelacionPEP		varchar(100),
	Par_IngresoAdici			varchar(100),
	Par_FuenteIngreOS			varchar(200),
	Par_UbicFteIngreOS			varchar(300),
	Par_EsPropioFteIng			char(1),
	Par_EsPropioFteDet			varchar(100),
	Par_IngMensualesOS			decimal(14,2),
	Par_TipoProdTN				varchar(500),
	Par_MercadoDeProdTN			varchar(200),
	Par_IngresosMensTN			decimal(14,2),

	Par_DependEconTN 			int(11),
	Par_DependHijoTN			int(11),
	Par_DependOtroTN			int(11),

	Par_Salida					char(1),
	inout	Par_NumErr 			int,
	inout	Par_ErrMen  		varchar(350),

	Par_EmpresaID				int(11),
	Aud_Usuario					int(11),
	Aud_FechaActual				datetime,
	Aud_DireccionIP				varchar(15),
	Aud_ProgramaID				varchar(50),
	Aud_Sucursal				int(11),
	Aud_NumTransaccion			bigint(20)
	)
TerminaStore:BEGIN

DECLARE Var_Control			char(20);

DECLARE Entero_Cero			int;
DECLARE Salida_SI			char(1);
DECLARE Radio_Vacio			char(1);


Set Entero_Cero				:= 0;
Set Salida_SI				:= 'S';
Set Radio_Vacio				:= 'X';


Set Var_Control  			:= '';

ManejoErrores:BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-PLDIDENTIDADCTEALT");
    END;

	if (ifnull(Par_ClienteID, Entero_Cero) = Entero_Cero )then
			set	Par_NumErr 	:= 1;
			set	Par_ErrMen	:= "El Número de Cliente Se encuentra Vacio";
			LEAVE ManejoErrores;
	end if;

	if not exists( (select ClienteID from PLDIDENTIDADCTE where ClienteID = Par_ClienteID)) then
			set	Par_NumErr 	:= 2;
			set	Par_ErrMen	:= "El Cliente No ha Realizado el Cuestionario";
			LEAVE ManejoErrores;
	end if;

	set Aud_FechaActual:= now();
	set Par_FteNuevosIngresos := ifnull(Par_FteNuevosIngresos, Radio_Vacio);
	set Par_ParentescoApert   := ifnull(Par_ParentescoApert, Radio_Vacio);
	set Par_NegocioPersona    := ifnull(Par_NegocioPersona, Radio_Vacio);
	set Par_TipoNegocio		  := ifnull(Par_TipoNegocio, Radio_Vacio);
	set Par_EsNegocioPropio	  := ifnull(Par_EsNegocioPropio, Radio_Vacio);
	set Par_TipoNuevoNegocio  := ifnull(Par_TipoNuevoNegocio, Radio_Vacio);
	set Par_TipoProvRecursos  := ifnull(Par_TipoProvRecursos, Radio_Vacio);
	set Par_IngresoAdici	  := ifnull(Par_IngresoAdici, Radio_Vacio);
	set Par_EsPropioFteIng	  := ifnull(Par_EsPropioFteIng, Radio_Vacio);
	set Par_RelacionPEP		  := ifnull(Par_RelacionPEP, Radio_Vacio);
	set Par_FamEnCargoPEP	  := ifnull(Par_FamEnCargoPEP, Radio_Vacio);
	set Par_NivelCargoPEP	  := ifnull(Par_NivelCargoPEP, Radio_Vacio);
	set Par_ParentescoPEP 	  := ifnull(Par_ParentescoPEP, Radio_Vacio);
	set Par_NivelCargoPEPFam  := ifnull(Par_NivelCargoPEPFam, Radio_Vacio);
	set Par_ParentescoPEPFam  := ifnull(Par_ParentescoPEPFam, Radio_Vacio);
	set Par_proveedRecursos	  := ifnull(Par_proveedRecursos, Radio_Vacio);
	set Par_PropietarioDinero := ifnull(Par_PropietarioDinero, Radio_Vacio);
	set Par_FuenteRecursos	  := ifnull(Par_FuenteRecursos, Radio_Vacio);
	set Par_CargoPubPEP		  := ifnull(Par_CargoPubPEP,Radio_Vacio);

	update PLDIDENTIDADCTE set
			AplicaCuest  		= Par_AplicaCuest,
			OtroAplDetalle 		= Par_OtroAplDetalle,
			RealizadoOp			= Par_RealizadoOp,
			FuenteRecursos		= Par_FuenteRecursos,
			FuenteOtraDet		= Par_FuenteOtraDet,
			ObservacionesEjec	= Par_ObservacionesEjec,
			NegocioPersona		= Par_NegocioPersona,
			TipoNegocio			= Par_TipoNegocio,
			TipoOtroNegocio		= Par_TipoOtroNegocio,
			GiroNegocio			= Par_GiroNegocio,

			AniosAntig			= Par_AniosAntig,
			MesesAntig			= Par_MesesAntig,
			UbicacNegocio		= Par_UbicacNegocio,
			EsNegocioPropio		= Par_EsNegocioPropio,
			EspecificarNegocio  = Par_EspecificarNegocio,
			TipoProducto		= Par_TipoProducto,
			MercadoDeProducto	= Par_MercadoDeProducto,
			IngresosMensuales	= Par_IngresosMensuales,
			DependientesEcon	= Par_DependientesEcon,
			DependienteHijo		= Par_DependienteHijo,

			DependienteOtro		= Par_DependienteOtro,
			TipoNuevoNegocio	= Par_TipoNuevoNegocio,
			TipoOtroNuevoNegocio= Par_TipoOtroNuevoNegocio,
			FteNuevosIngresos	= Par_FteNuevosIngresos,
			ParentescoApert		= Par_ParentescoApert,
			ParentescoOtroDet	= Par_ParentescoOtroDet,
			TiempoEnvio			= Par_TiempoEnvio,
			CuantoEnvio			= Par_CuantoEnvio,
			TrabajoActual		= Par_TrabajoActual,
			LugarTrabajoAct		= Par_LugarTrabajoAct,

			CargoTrabajo		= Par_CargoTrabajo,
			PeriodoDePago		= Par_PeriodoDePago,
			MontoPeriodoPago	= Par_MontoPeriodoPago,
			TiempoNuevoNeg		= Par_TiempoNuevoNeg,
			TiempoLaborado		= Par_TiempoLaborado,
			DependienteEconSA	= Par_DependienteEconSA,
			DependienteHijoSA	= Par_DependienteHijoSA,
			DependienteOtroSA	= Par_DependienteOtroSA,
			ProveedRecursos		= Par_ProveedRecursos,
			TipoProvRecursos	= Par_TipoProvRecursos,

			NombreCompProv		= Par_NombreCompProv,
			DomicilioProv		= Par_DomicilioProv,
			FechaNacProv		= Par_FechaNacProv,
			NacionalidadProv	= Par_NacionalidadProv,
			RfcProv				= Par_RfcProv,
			RazonSocialProvB	= Par_RazonSocialProvB,
			NacionalidProvB		= Par_NacionalidProvB,
			RfcProvB			= Par_RfcProvB,
			DomicilioProvB		= Par_DomicilioProvB,
			PropietarioDinero	= Par_PropietarioDinero,

			PropietarioOtroDet	= Par_PropietarioOtroDet,
			PropietarioNombreCom= Par_PropietarioNombreCom,
			PropietarioDomicilio= Par_PropietarioDomicilio,
			PropietarioNacio	= Par_PropietarioNacio,
			PropietarioCurp		= Par_PropietarioCurp,
			PropietarioRfc		= Par_PropietarioRfc,
			PropietarioGener	= Par_PropietarioGener,
			PropietarioOcupac	= Par_PropietarioOcupac,
			PropietarioFecha	= Par_PropietarioFecha,
			PropietarioLugarNac	= Par_PropietarioLugarNac,

			PropietarioEntid	= Par_PropietarioEntid,
			PropietarioPais		= Par_PropietarioPais,
			CargoPubPEP			= Par_CargoPubPEP,
			CargoPubPEPDet		= Par_CargoPubPEPDet,
			NivelCargoPEP		= Par_NivelCargoPEP,
			Periodo1PEP			= Par_Periodo1PEP,
			Periodo2PEP			= Par_Periodo2PEP,
			IngresosMenPEP		= Par_IngresosMenPEP,
			FamEnCargoPEP		= Par_FamEnCargoPEP,
			ParentescoPEP		= Par_ParentescoPEP,

			NombreCompletoPEP	= Par_NombreCompletoPEP,
			ParentescoPEPDet	= Par_ParentescoPEPDet,
			CargoPubPEPDetFam	= Par_CargoPubPEPDetFam,
			NivelCargoPEPFam	= Par_NivelCargoPEPFam,
			Periodo1PEPFam		= Par_Periodo1PEPFam,
			Periodo2PEPFam		= Par_Periodo2PEPFam,
			ParentescoPEPFam	= Par_ParentescoPEPFam,
			NombreCtoPEPFam		= Par_NombreCtoPEPFam,
			RelacionPEP			= Par_RelacionPEP,
			NombreRelacionPEP	= Par_NombreRelacionPEP,

			IngresoAdici		= Par_IngresoAdici,
			FuenteIngreOS		= Par_FuenteIngreOS,
			UbicFteIngreOS		= Par_UbicFteIngreOS,
			EsPropioFteIng		= Par_EsPropioFteIng,
			EsPropioFteDet		= Par_EsPropioFteDet,
			IngMensualesOS		= Par_IngMensualesOS,
			TipoProdTN			= Par_TipoProdTN,
			MercadoDeProdTN		= Par_MercadoDeProdTN,
			IngresosMensTN		= Par_IngresosMensTN,
			DependEconTN		= Par_DependEconTN,

			DependHijoTN		= Par_DependHijoTN,
			DependOtroTN		= Par_DependOtroTN,
			EmpresaID			= Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion where ClienteID = Par_ClienteID;

	set  Par_NumErr  := 000;
	set  Par_ErrMen  := concat("Datos del Cliente Modificados Correctamente: ", convert(Par_ClienteID, char));
	set  Var_Control := 'clienteID';

END ManejoErrores;

if (Par_Salida = Salida_SI) then
	select Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			Var_Control	  as control;
		LEAVE TerminaStore;
end if;

END Terminastore$$