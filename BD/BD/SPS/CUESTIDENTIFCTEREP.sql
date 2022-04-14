-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUESTIDENTIFCTEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUESTIDENTIFCTEREP`;DELIMITER $$

CREATE PROCEDURE `CUESTIDENTIFCTEREP`(
	Par_ClienteID		bigint(20),
	Par_UsuarioLog		int(11),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint(20)


	)
TerminaStore:BEGIN

DECLARE Var_DireccionOficialCte		varchar(500);
DECLARE Var_LineaNegocioI 	int(11);
DECLARE Var_SumaIngresos 	decimal(14,2);
DECLARE Var_LineaNegocioE	int(11);
DECLARE Var_SumaEgresos		decimal(14,2);
DECLARE Var_LeyendaEncRep	varchar(100);
DECLARE Var_GrupoID			int(11);
DECLARE Var_NombreGrupo		varchar(200);
DECLARE Var_CliArchID		int;
DECLARE Var_RecursoFotoCte	varchar(10000);

DECLARE Var_SucursalOrigen	int(5);
DECLARE Var_ClienteID		int(11);
DECLARE Var_PromotorActual  int(6);
DECLARE Var_NombrePromotor	varchar(100);
DECLARE Var_NombreCompleto	varchar(200);
DECLARE Var_NombreSucurs	varchar(50);
DECLARE Var_EstadoCivil		varchar(80);
DECLARE Var_Descripcion		text;
DECLARE Var_Nacion			varchar(100);
DECLARE Var_RFCOficial		char(13);
DECLARE Var_Curp			char(18);
DECLARE Var_Sexo			char(10);
DECLARE Var_FechaAlta		date;
DECLARE Var_NomConyuge		varchar(200);
DECLARE Var_NacionConyu		varchar(15);
DECLARE Var_OcupacionCony	varchar(200);


DECLARE Des_Soltero			varchar(50);
DECLARE Des_CasBieSep		varchar(50);
DECLARE Des_CasBieMan		varchar(50);
DECLARE Des_CasCapitu		varchar(50);
DECLARE Des_Viudo			varchar(50);
DECLARE Des_Divorciad		varchar(50);
DECLARE Des_Seperados		varchar(50);
DECLARE Des_UnionLibre		varchar(50);

DECLARE Est_Soltero     	char(2);
DECLARE Est_CasBieSep   	char(2);
DECLARE Est_CasBieMan   	char(2);
DECLARE Est_CasCapitu   	char(2);
DECLARE Est_Viudo      		char(2);
DECLARE Est_Divorciad   	char(2);
DECLARE Est_Seperados   	char(2);
DECLARE Est_UnionLibre  	char(2);

DECLARE  Nacional			char(1);
DECLARE  Extranjero			char(1);

DECLARE Ingresos			char(1);
DECLARE Egresos				char(1);
DECLARE EncRepCuestCte		int(11);

DECLARE Femenino			char(1);
DECLARE Masculino			char(1);
DECLARE EstatusActivo		char(1);
DECLARE Est_Vigente			char(1);

DECLARE TipoDocumentoImg	int;
DECLARE Entero_Cero			int;
DECLARE Si					char(1);



set Des_Soltero     := 'SOLTERO(A)';
set Des_CasBieSep   := 'CASADO(A) BIENES SEPARADOS';
set Des_CasBieMan   := 'CASADO(A) BIENES MANCOMUNADOS';
set Des_CasCapitu   := 'CASADO(A) BIENES MANCOMUNADOS CON CAPITULACION';
set Des_Viudo       := 'VIUDO(A)';
set Des_Divorciad   := 'DOVORCIADO(A)';
set Des_Seperados   := 'SEPERADO(A)';
set Des_UnionLibre  := 'UNION LIBRE';

set Est_Soltero     := 'S';
set Est_CasBieSep   := 'CS';
set Est_CasBieMan   := 'CM';
set Est_CasCapitu   := 'CC';
set Est_Viudo       := 'V';
set Est_Divorciad   := 'D';
set Est_Seperados   :='SE';
set Est_UnionLibre  := 'U';

set Nacional		:='N';
set Extranjero		:='E';
set Ingresos		:='I';
set Egresos			:='E';
set EncRepCuestCte	:=1;

set Femenino		:='F';
set Masculino		:='M';
set	EstatusActivo	:='A';

set Est_Vigente		:='V';
Set TipoDocumentoImg:= 1;
set Entero_Cero		:=0;
set Si				:='S';

select DireccionCompleta into Var_DireccionOficialCte
	from DIRECCLIENTE
		where ClienteID=Par_ClienteID
		and Oficial=Si
		limit 1;

select distinct(Cte.LinNegID),SUM(Monto) into Var_LineaNegocioI, Var_SumaIngresos
	from CLIDATSOCIOE Cte,
		CATDATSOCIOE	dat
		where Cte.ClienteID=Par_ClienteID
		and Cte.CatSocioEID=dat.CatSocioEID
		and dat.Tipo=Ingresos
		group by Cte.LinNegID
		limit 1;

select distinct(Cte.LinNegID),SUM(Monto) into Var_LineaNegocioE, Var_SumaEgresos
	from CLIDATSOCIOE Cte,
		CATDATSOCIOE	dat
		where Cte.ClienteID=Par_ClienteID
		and Cte.CatSocioEID=dat.CatSocioEID
		and dat.Tipo=Egresos
		group by Cte.LinNegID
		limit 1;

select LeyendaEnc into Var_LeyendaEncRep
	from ENCABEZADOREP
	where EncabezadoID=EncRepCuestCte;

select intcre.GrupoID, gr.NombreGrupo into Var_GrupoID, Var_NombreGrupo
		from	CREDITOS cre,
				INTEGRAGRUPOSCRE intcre,
				GRUPOSCREDITO gr
		where intcre.ClienteID=Par_ClienteID
			and intcre.Estatus=EstatusActivo
			and cre.GrupoID=intcre.GrupoID
			and cre.ClienteID=intcre.ClienteID
			and	cre.Estatus=Est_Vigente
			and gr.GrupoID=cre.GrupoID;



    select  max(ClienteArchivosID) into Var_CliArchID
        from CLIENTEARCHIVOS
        where ClienteID     = Par_ClienteID
          and TipoDocumento = TipoDocumentoImg;
		set Var_CliArchID   := ifnull(Var_CliArchID, Entero_Cero);

    select   Recurso  into Var_RecursoFotoCte
        from CLIENTEARCHIVOS
        where ClienteArchivosID = Var_CliArchID;


select cte.SucursalOrigen,		cte.ClienteID,		cte.PromotorActual,
		pro.NombrePromotor,		cte.NombreCompleto,	suc.NombreSucurs,
		case when EstadoCivil=Est_Soltero  then Des_Soltero
				when  EstadoCivil=Est_CasBieSep then Des_CasBieSep
				when EstadoCivil=Est_CasBieMan then Des_CasBieMan
				when EstadoCivil=Est_CasCapitu then Des_CasCapitu
				when EstadoCivil=Est_Viudo		then Des_Viudo
				when EstadoCivil=Est_Divorciad then Est_Divorciad
				when EstadoCivil=Est_Seperados then Des_Seperados
				when EstadoCivil=Est_UnionLibre then Est_UnionLibre
			end,ocu.Descripcion ,
		case when cte.Nacion=Nacional then 'NACIONAL'
			when cte.Nacion=Extranjero then 'EXTRANJERO'
			end,cte.CURP,
		case when cte.Sexo =Femenino then 'FEMENINO'
			when  cte.Sexo =Masculino then 'MASCULINO'
			END,cte.RFCOficial, cte.FechaAlta
		into  Var_SucursalOrigen, Var_ClienteID, 	Var_PromotorActual, Var_NombrePromotor,
			  Var_NombreCompleto, Var_NombreSucurs,	Var_EstadoCivil,	Var_Descripcion,
			  Var_Nacion,		  Var_Curp,			Var_Sexo,			Var_RFCOficial,
			  Var_FechaAlta
		from CLIENTES cte
			left join PROMOTORES pro ON pro.PromotorID=cte.PromotorActual
			left join SUCURSALES suc ON suc.SucursalID=SucursalOrigen
			left join OCUPACIONES ocu ON ocu.OcupacionID=cte.OcupacionID
			left join PAISES	pais ON pais.PaisID=cte.LugarNacimiento
			where cte.ClienteID = Par_ClienteID;

select CLI.NombreCompleto, case CLI.Nacion
							when 'N' then 'MEXICANA'
							when 'E' then 'EXTRANJERA' end,	OCU.Descripcion
		into Var_NomConyuge, Var_NacionConyu, Var_OcupacionCony
	from SOCIODEMOCONYUG SOC inner join CLIENTES CLI on SOC.ClienteConyID=CLI.ClienteID
							 inner join OCUPACIONES OCU on CLI.OcupacionID = OCU.OcupacionID
								where SOC.ClienteID=Par_ClienteID;

select Var_SucursalOrigen as SucursalOrigen, 	Var_ClienteID as ClienteID, 		  Var_PromotorActual as PromotorActual,
	   Var_NombrePromotor as NombrePromotor,	Var_NombreCompleto as NombreCompleto, Var_NombreSucurs as NombreSucurs,
	   Var_EstadoCivil as EstadoCivil, 			Var_Descripcion as Descripcion,		  Var_Nacion as Nacion,
	   Var_Curp as Curp,						Var_Sexo as Sexo,					  Var_RFCOficial as Var_RFCOficial,
	   Var_DireccionOficialCte,					Var_SumaIngresos,					  Var_SumaEgresos,
	   Var_NombreGrupo,							Var_RecursoFotoCte,					  Var_FechaAlta as FechaAlta,
	   Var_LeyendaEncRep,						AplicaCuest,						  OtroAplDetalle,
	   RealizadoOp,								FuenteRecursos,
	   FuenteOtraDet,			ObservacionesEjec,	NegocioPersona,		TipoNegocio,			TipoOtroNegocio,
	   GiroNegocio,				AniosAntig,			MesesAntig,				UbicacNegocio,
	   EsNegocioPropio,			EspecificarNegocio,	TipoProducto,		MercadoDeProducto,		IngresosMensuales,
	   DependientesEcon,		DependienteHijo,	DependienteOtro,	TipoNuevoNegocio,		TipoOtroNuevoNegocio,
	   FteNuevosIngresos,		ParentescoApert,	ParentescoOtroDet,	TiempoEnvio,			CuantoEnvio,
	   TrabajoActual,			LugarTrabajoAct,	CargoTrabajo,		PeriodoDePago,			MontoPeriodoPago,
	   TiempoNuevoNeg,			TiempoLaborado,		DependienteEconSA,	DependienteHijoSA,		DependienteOtroSA,
 	   ProveedRecursos,			TipoProvRecursos,	NombreCompProv,		DomicilioProv,			FechaNacProv,
	   NacionalidadProv,		RfcProv,			RazonSocialProvB,	NacionalidProvB,		RfcProvB,
 	   DomicilioProvB,			PropietarioDinero,	PropietarioOtroDet,	PropietarioNombreCom,	PropietarioDomicilio,
	   PropietarioNacio,		PropietarioCurp,	PropietarioRfc,		PropietarioGener,		PropietarioOcupac,
	   PropietarioFecha,		PropietarioLugarNac,PropietarioEntid,	PropietarioPais,		CargoPubPEP,
	   CargoPubPEPDet,			NivelCargoPEP,		Periodo1PEP,		Periodo2PEP,			IngresosMenPEP,
 	   FamEnCargoPEP,			ParentescoPEP,		NombreCompletoPEP,	ParentescoPEPDet,
	   CargoPubPEPDetFam,		NivelCargoPEPFam,	Periodo1PEPFam,		Periodo2PEPFam,			ParentescoPEPFam,
	   NombreCtoPEPFam,			RelacionPEP,
	   NombreRelacionPEP,		IngresoAdici,		FuenteIngreOS,		UbicFteIngreOS,			EsPropioFteIng,
 	   EsPropioFteDet,			IngMensualesOS,		TipoProdTN,			MercadoDeProdTN,		IngresosMensTN,
	   DependEconTN,			DependHijoTN,		DependOtroTN,		Var_NomConyuge,			Var_NacionConyu,
	   Var_OcupacionCony
	from PLDIDENTIDADCTE where ClienteID=Par_ClienteID;



END TerminaStore$$