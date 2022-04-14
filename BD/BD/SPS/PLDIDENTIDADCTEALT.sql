-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDIDENTIDADCTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDIDENTIDADCTEALT`;DELIMITER $$

CREATE PROCEDURE `PLDIDENTIDADCTEALT`(
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
			set	Par_ErrMen	:= "El Número de Cliente se encuentra Vacio";
			LEAVE ManejoErrores;
	end if;

	if exists( (select ClienteID from PLDIDENTIDADCTE where ClienteID = Par_ClienteID)) then
			set	Par_NumErr 	:= 2;
			set	Par_ErrMen	:= "El Cliente Ya ha realizado el Cuestionario";
			LEAVE ManejoErrores;
	end if;

	set Aud_FechaActual:= now();

	set Par_FteNuevosIngresos := ifnull(Par_FteNuevosIngresos,Radio_Vacio);
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

	insert into PLDIDENTIDADCTE (
		ClienteID,			AplicaCuest,		OtroAplDetalle,		 RealizadoOp,		  FuenteRecursos,
		FuenteOtraDet,		ObservacionesEjec,	NegocioPersona,		 TipoNegocio,		  TipoOtroNegocio,
		GiroNegocio,		AniosAntig,			MesesAntig,		  	 UbicacNegocio,	  	  EsNegocioPropio,
		EspecificarNegocio,	TipoProducto,		MercadoDeProducto,	 IngresosMensuales,	  DependientesEcon,
		DependienteHijo,	DependienteOtro,	TipoNuevoNegocio,	 TipoOtroNuevoNegocio,FteNuevosIngresos,
		ParentescoApert,	ParentescoOtroDet,	TiempoEnvio,		 CuantoEnvio,		  TrabajoActual,
		LugarTrabajoAct,	CargoTrabajo,		PeriodoDePago,		 MontoPeriodoPago,	  TiempoNuevoNeg,
		TiempoLaborado,		DependienteEconSA,	DependienteHijoSA,	 DependienteOtroSA,	  ProveedRecursos,
		TipoProvRecursos,	NombreCompProv,		DomicilioProv,		 FechaNacProv,		  NacionalidadProv,
		RfcProv,			RazonSocialProvB,	NacionalidProvB,	 RfcProvB,			  DomicilioProvB,
		PropietarioDinero,	PropietarioOtroDet,	PropietarioNombreCom,PropietarioDomicilio,PropietarioNacio,
		PropietarioCurp,	PropietarioRfc,		PropietarioGener,	 PropietarioOcupac,	  PropietarioFecha,
		PropietarioLugarNac,PropietarioEntid,	PropietarioPais,	 CargoPubPEP,		  CargoPubPEPDet,
		NivelCargoPEP,		Periodo1PEP,		Periodo2PEP,		 IngresosMenPEP,	  FamEnCargoPEP,
		ParentescoPEP,		NombreCompletoPEP,	ParentescoPEPDet,	 CargoPubPEPDetFam,	  NivelCargoPEPFam,
		Periodo1PEPFam,		Periodo2PEPFam,	  	ParentescoPEPFam,	 NombreCtoPEPFam,	  RelacionPEP,
		NombreRelacionPEP,	IngresoAdici,		FuenteIngreOS,		 UbicFteIngreOS,	  EsPropioFteIng,
		EsPropioFteDet,		IngMensualesOS,		TipoProdTN,			 MercadoDeProdTN, 	  IngresosMensTN,
		DependEconTN,		DependHijoTN,		DependOtroTN,		 EmpresaID,			  Usuario,
		FechaActual,		DireccionIP,		ProgramaID,			 Sucursal,			 NumTransaccion
		) values (
		Par_ClienteID,			Par_AplicaCuest,		Par_OtroAplDetalle,		 Par_RealizadoOp,		  Par_FuenteRecursos,
		Par_FuenteOtraDet,		Par_ObservacionesEjec,	Par_NegocioPersona,		 Par_TipoNegocio,		  Par_TipoOtroNegocio,
		Par_GiroNegocio,		Par_AniosAntig,			Par_MesesAntig,		  	 Par_UbicacNegocio,		  Par_EsNegocioPropio,
		Par_EspecificarNegocio,	Par_TipoProducto,		Par_MercadoDeProducto,	 Par_IngresosMensuales,	  Par_DependientesEcon,
		Par_DependienteHijo,	Par_DependienteOtro,	Par_TipoNuevoNegocio,	 Par_TipoOtroNuevoNegocio,Par_FteNuevosIngresos,
		Par_ParentescoApert,	Par_ParentescoOtroDet,	Par_TiempoEnvio,		 Par_CuantoEnvio,		  Par_TrabajoActual,
		Par_LugarTrabajoAct,	Par_CargoTrabajo,		Par_PeriodoDePago,		 Par_MontoPeriodoPago,	  Par_TiempoNuevoNeg,
		Par_TiempoLaborado,		Par_DependienteEconSA,	Par_DependienteHijoSA,	 Par_DependienteOtroSA,	  Par_ProveedRecursos,
		Par_TipoProvRecursos,	Par_NombreCompProv,		Par_DomicilioProv,		 Par_FechaNacProv,		  Par_NacionalidadProv,
		Par_RfcProv,			Par_RazonSocialProvB,	Par_NacionalidProvB,	 Par_RfcProvB,			  Par_DomicilioProvB,
		Par_PropietarioDinero,	Par_PropietarioOtroDet,	Par_PropietarioNombreCom,Par_PropietarioDomicilio,Par_PropietarioNacio,
		Par_PropietarioCurp,	Par_PropietarioRfc,		Par_PropietarioGener,	 Par_PropietarioOcupac,	  Par_PropietarioFecha,
		Par_PropietarioLugarNac,Par_PropietarioEntid,	Par_PropietarioPais,	 Par_CargoPubPEP,		  Par_CargoPubPEPDet,
		Par_NivelCargoPEP,		Par_Periodo1PEP,		Par_Periodo2PEP,		 Par_IngresosMenPEP,	  Par_FamEnCargoPEP,
		Par_ParentescoPEP,		Par_NombreCompletoPEP,	Par_ParentescoPEPDet,	 Par_CargoPubPEPDetFam,	  Par_NivelCargoPEPFam,
		Par_Periodo1PEPFam,		Par_Periodo2PEPFam,	  	Par_ParentescoPEPFam,	 Par_NombreCtoPEPFam,	  Par_RelacionPEP,
		Par_NombreRelacionPEP,	Par_IngresoAdici,		Par_FuenteIngreOS,		 Par_UbicFteIngreOS,	  Par_EsPropioFteIng,
		Par_EsPropioFteDet,		Par_IngMensualesOS,		Par_TipoProdTN,			 Par_MercadoDeProdTN,	  Par_IngresosMensTN,
		Par_DependEconTN,		Par_DependHijoTN,		Par_DependOtroTN, 		 Par_EmpresaID,			  Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			  Aud_NumTransaccion
	);
	set  Par_NumErr  := 000;
	set  Par_ErrMen  := concat("Datos del Cliente Guardados Correctamente: ", convert(Par_ClienteID, char));
	set  Var_Control := 'clienteID';

END ManejoErrores;

if (Par_Salida = Salida_SI) then
	select Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			Var_Control	  as control;
		LEAVE TerminaStore;
end if;

END Terminastore$$