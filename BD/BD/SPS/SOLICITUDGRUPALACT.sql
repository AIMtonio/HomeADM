-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDGRUPALACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDGRUPALACT`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDGRUPALACT`(


	Par_GrupoID				int(10),
	Par_PlazoID         	varchar(20),
	Par_TipoPagCap      	char(1),
	Par_FrecInter       	char(1),
	Par_FrecCapital     	char(1),

	Par_PeriodInt       	int,
	Par_PeriodCap       	int,
	Par_DiaPagInt       	char(1),
	Par_DiaPagCap       	char(1),
	Par_DiaMesInter     	int,

	Par_DiaMesCap       	int,
	Par_NumAmorti       	int,
	Par_NumAmortInt     	int(11),
	Par_FechaVencim     	date,
	Par_SolicitudCreditoID	int(11),

	Par_ProductoCreditoID	int(11),
	Par_MontoSolicitado		decimal(14,2),
	Par_Estatus				char(1),
	Par_ForCobroSegVida 	char(1),
	Par_DescuentoSeguro		decimal(12,2),
	Par_MontoSegOriginal 	decimal(12,2),
	Par_NumAct          	tinyint unsigned,

	Par_Salida          	char(1),
	inout Par_NumErr    	int,
	inout Par_ErrMen    	varchar(400),
	Par_EmpresaID       	int(11),
	Aud_Usuario         	int,

	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal        	int,
	Aud_NumTransaccion  	bigint
	)
TerminaStore: BEGIN


DECLARE Var_ClienteID			int;
DECLARE Var_MontoSeguro 		decimal(12,2);
DECLARE Var_Control				varchar(500);
DECLARE Var_ForCobroComAper		char(1);
DECLARE Var_CalcInteres			char(1);
DECLARE Var_AjusFecUlAmoVen		char(1);
DECLARE Var_AjusFecExigVenc		char(1);
DECLARE Var_FactorMora			decimal(12,4);
DECLARE Var_PorcGarLiq			decimal(14,12);
DECLARE Var_InstitutFondID		int(11);
DECLARE Var_TipoCalInteres		int(11);
DECLARE Var_TipoPagoSeguro		char(1);
DECLARE Var_FecInHabTomar		char(1);
DECLARE Var_ProdCredOriginal	int(11);
DECLARE Var_RequiereGarantia	char(1);
DECLARE Var_RequiereAvales		char(1);
DECLARE Var_ReqSeguroVida		char(1);
DECLARE Var_ProspectoID			int(11);
DECLARE Var_NumCredCte			int(11);
DECLARE Var_NumCredGrupo		int(11);
DECLARE Var_FechaSistema		date;
DECLARE Var_ComisAp				decimal(14,2);
DECLARE Var_IVAComisAp			decimal(14,2);
DECLARE Var_TasaFija			decimal(14,2);
DECLARE Var_MontoGarLiq			decimal(14,2);
DECLARE Var_MontoAuto			decimal(14,2);
DECLARE Var_ProducAutoComite	char(1);
DECLARE Var_ValidaAutComite		char(1);
DECLARE Var_MontoPoliza			decimal(14,2);
DECLARE Var_Modalidad			char(1);
DECLARE Var_MontoPolSeg			decimal(14,2);
DECLARE Var_MontoPolizaSeguro	decimal(14,2);


DECLARE Entero_Cero     	int;
DECLARE Decimal_Cero    	decimal(12,2);
DECLARE Cadena_Vacia    	char(1);
DECLARE Fecha_Vacia     	date;
DECLARE SalidaNO        	char(1);
DECLARE SalidaSI        	char(1);
DECLARE EstatusInactivo		char(1);
DECLARE Act_Calendario		int(11);
DECLARE ValidaSolLibera		int;
DECLARE ValorSI				char(1);
DECLARE ValorNO				char(1);
DECLARE EstatusEliminado	char(1);
DECLARE EstatusRechazado	char(1);
DECLARE EstatusCancelado	char(1);
DECLARE NOAutorizaComite	char(1);
DECLARE CliFuncionario		char(1);
DECLARE CliEmpleado			char(1);
DECLARE RelacionGrado1		int(2);
DECLARE RelacionGrado2		int(2);
DECLARE SIValidaAutComite	char(1);
DECLARE	TipoDocNoEntregado	int(11);
DECLARE DocNORecibido		char(1);
DECLARE	EstatusCancelada	char(1);
DECLARE EstatusInactiva		char(1);
DECLARE SiReqSeguro			char(1);
DECLARE ModUnico			char(1);
DECLARE CapitalCreciente	CHAR(1);


set Entero_Cero     	:= 0;
set Decimal_Cero    	:= 0.0;
set Fecha_Vacia     	:= '1900-01-01';
set Cadena_Vacia    	:= '';
set SalidaSI        	:= 'S';
set SalidaNO        	:= 'N';
set EstatusInactivo		:= 'I';
set Act_Calendario		:= 1;
set ValidaSolLibera		:=4;
set ValorSI				:='S';
set ValorNO				:='N';
set Par_NumErr			:= 0;
set Par_ErrMen			:= '';
set EstatusEliminado	:='E';
set EstatusRechazado	:='R';
set EstatusCancelado	:='C';
set NOAutorizaComite	:='N';
set CliFuncionario		:='O';
set CliEmpleado			:='E';
set RelacionGrado1		:=1;
set RelacionGrado2		:=2;
set SIValidaAutComite	:='S';
Set	TipoDocNoEntregado	:= 9999;
set DocNORecibido		:='N';
set	EstatusCancelada	:='C';
set EstatusInactiva		:='I';
set	SiReqSeguro			:='S';
set ModUnico			:='U';
SET CapitalCreciente	:= 'C';

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			set Par_NumErr = 999;
			set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
									 "estamos trabajando para resolverla. Disculpe las molestias que ",
									 "esto le ocasiona. Ref: SP-SOLICITUDGRUPALACT");
		END;


if(Par_NumAct = Act_Calendario) then
if(ifnull(Par_ProductoCreditoID,Entero_Cero) = Entero_Cero )then
		set Par_NumErr :=02;
		set Par_ErrMen := "El Producto de Credito se encuentra Vacio";
        set Var_Control := 'productoCreditoID' ;
	LEAVE ManejoErrores;
end if;

if exists (select ProducCreditoID
			from PRODUCTOSCREDITO
			where EsGrupal='N'
			and ProducCreditoID= Par_ProductoCreditoID )then
	set Par_NumErr :=03;
	set Par_ErrMen := "El Producto de Credito indicado no es Grupal.";
    set Var_Control := 'clienteID' ;
	LEAVE ManejoErrores;
end if;


select		TipoPagoSeguro,		ForCobroComAper,		CalcInteres,		FactorMora,			InstitutFondID,
			TipoCalInteres,		RequiereGarantia,		RequiereAvales,		ReqSeguroVida, 		ifnull(AutorizaComite, 'N'),
			MontoPolSegVida,	Modalidad

	into	Var_TipoPagoSeguro,	Var_ForCobroComAper,	Var_CalcInteres,	Var_FactorMora,		Var_InstitutFondID,
			Var_TipoCalInteres, Var_RequiereGarantia,	Var_RequiereAvales,	Var_ReqSeguroVida, 	Var_ProducAutoComite,
			Var_MontoPoliza,	Var_Modalidad
	from PRODUCTOSCREDITO
	where ProducCreditoID = Par_ProductoCreditoID;




	select MontoPolSegVida	into   Var_MontoPolSeg
	from   ESQUEMASEGUROVIDA
		   where ProducCreditoID = Par_ProductoCreditoID
		   and TipoPagoSeguro = Par_ForCobroSegVida;



select		ClienteID,ProspectoID,		ProductoCreditoID
	into	Var_ClienteID,Var_ProspectoID,	Var_ProdCredOriginal
	from SOLICITUDCREDITO
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID;


select		AjusFecUlAmoVen,		AjusFecExigVenc,		FecInHabTomar
	into 	Var_AjusFecUlAmoVen,	Var_AjusFecExigVenc,	Var_FecInHabTomar
	from CALENDARIOPROD
		where ProductoCreditoID =Par_ProductoCreditoID ;


select  FechaSistema into Var_FechaSistema from PARAMETROSSIS limit 1;

set Var_ClienteID   := ifnull(Var_ClienteID, Entero_Cero);
if(Var_ClienteID > Entero_Cero)then
	if exists(select Estatus from CLIENTES
				where ClienteID =Var_ClienteID
				and Estatus= EstatusInactivo) then
		set Par_NumErr :=04;
		set Par_ErrMen := "El safilocale.cliente se encuentra Inactivo";
        set Var_Control := 'clienteID' ;
		LEAVE ManejoErrores;
	end if;
end if;


set Var_ValidaAutComite := (SELECT ValidaAutComite FROM PARAMETROSSIS);
if(Var_ValidaAutComite = SIValidaAutComite)then
	if(Var_ProducAutoComite = NOAutorizaComite)then
		if(Var_ClienteID > Entero_Cero)then
			if exists (SELECT ClienteID
								FROM CLIENTES
								WHERE ClienteID = Var_ClienteID
									AND (Clasificacion = CliFuncionario
									OR Clasificacion = CliEmpleado)
									and Par_Estatus not in(EstatusCancelada,EstatusEliminado))then
				set Par_NumErr :=05;
				set Par_ErrMen := concat('El Producto de Credito No aplica para las caracteristicas del safilocale.cliente ', convert(Var_ClienteID,char),' Indicado');
				set Var_Control := 'clienteID' ;
				LEAVE ManejoErrores;
			end if;

			if exists (SELECT Cli.ClienteID
					FROM RELACIONCLIEMPLEADO Rel,
					 CLIENTES Cli,
					 TIPORELACIONES Tip
					WHERE Cli.ClienteID = Rel.RelacionadoID
						AND  Rel.ClienteID = Var_ClienteID
						AND	Rel.ParentescoID = Tip.TipoRelacionID
						AND (Tip.Grado = RelacionGrado1 OR Tip.Grado = RelacionGrado2)
						AND (Cli.Clasificacion = CliFuncionario OR Cli.Clasificacion = CliEmpleado)
						and Par_Estatus not in(EstatusCancelada,EstatusEliminado))then
				set Par_NumErr :=06;
				set Par_ErrMen := concat('El Producto de Credito No aplica para las caracteristicas del safilocale.cliente ', convert(Var_ClienteID,char));
				set Var_Control := 'clienteID';
				LEAVE TerminaStore;
			end if;
		else
			if Exists(SELECT ProspectoID FROM PROSPECTOS
										WHERE ProspectoID = Var_ProspectoID
											AND (Clasificacion = CliFuncionario
											OR Clasificacion = CliEmpleado)
											and Par_Estatus not in(EstatusCancelada,EstatusEliminado))then
				set Par_NumErr :=07;
				set Par_ErrMen := concat('El Producto de Credito No aplica para las caracteristicas del Prospecto ', convert(Var_ProspectoID, char));
				set Var_Control := 'clienteID';
				LEAVE TerminaStore;
			end if;
		end if;
	end if;
end if;


if(ifnull(Par_PlazoID, Entero_Cero))= Entero_Cero then
	set Par_NumErr :=07;
	set Par_ErrMen := 'El Plazo se encuentra Vacio';
	set Var_Control := 'plazoID';
	LEAVE TerminaStore;
end if;




	update SOLICITUDCREDITO Sol set
			Sol.PlazoID				= Par_PlazoID,
			Sol.FrecuenciaCap		= Par_FrecCapital,
			Sol.PeriodicidadCap		= Par_PeriodCap,
			Sol.FrecuenciaInt		= Par_FrecInter,
			Sol.PeriodicidadInt		= Par_PeriodInt,

			Sol.TipoPagoCapital		= Par_TipoPagCap,
			Sol.NumAmortizacion		= Par_NumAmorti,
			Sol.DiaPagoInteres		= Par_DiaPagInt,
			Sol.DiaPagoCapital		= Par_DiaPagCap,
			Sol.DiaMesInteres		= Par_DiaMesInter,

			Sol.DiaMesCapital		= Par_DiaMesCap,
			Sol.NumAmortInteres		= Par_NumAmortInt,
			Sol.FechaVencimiento	=Par_FechaVencim,

			Sol.ForCobroSegVida		= Par_ForCobroSegVida,
			Sol.ForCobroComAper		= Var_ForCobroComAper,
			Sol.CalcInteresID		= Var_CalcInteres,
			Sol.FactorMora			= Var_FactorMora,
			Sol.AjusFecUlVenAmo		= Var_AjusFecUlAmoVen,
			Sol.AjusFecExiVen		= Var_AjusFecExigVenc,
			Sol.FechaInhabil		= Var_FecInHabTomar,
			Sol.TipoCalInteres		= Var_TipoCalInteres,

			Sol.DescuentoSeguro		= Par_DescuentoSeguro,
			Sol.MontoSegOriginal	= Par_MontoSegOriginal,

			Sol.EmpresaID			= Par_EmpresaID,
			Sol.Usuario				= Aud_Usuario,
			Sol.FechaActual			= Aud_FechaActual,
			Sol.DireccionIP			= Aud_DireccionIP,
			Sol.ProgramaID			= Aud_ProgramaID,

			Sol.Sucursal			= Aud_Sucursal,
			Sol.NumTransaccion		= Aud_NumTransaccion
		where Sol.SolicitudCreditoID = Par_SolicitudCreditoID;

		IF(Par_TipoPagCap != CapitalCreciente)THEN
			UPDATE SOLICITUDCREDITO Sol SET MontoCuota = Decimal_Cero
			WHERE Sol.SolicitudCreditoID = Par_SolicitudCreditoID;
		END IF;



if(Var_ProdCredOriginal <> Par_ProductoCreditoID)then
	if(Var_RequiereGarantia = ValorNO)then
		delete from ASIGNAGARANTIAS where SolicitudCreditoID =Par_SolicitudCreditoID;
	end if;
	if(Var_RequiereAvales = ValorNO)then
		delete from AVALESPORSOLICI where SolicitudCreditoID =Par_SolicitudCreditoID;
	end if;
	if(Var_ReqSeguroVida = ValorNO)then
		delete from SEGUROVIDA where SolicitudCreditoID =Par_SolicitudCreditoID;
	end if;


	update SOLICIDOCENT
		set	Comentarios	= Cadena_Vacia,
            TipoDocumentoID = TipoDocNoEntregado,
            DocRecibido     = DocNORecibido
		where   SolicitudCreditoID  = Par_SolicitudCreditoID;


	delete from ESQUEMAAUTFIRMA
		where SolicitudCreditoID = Par_SolicitudCreditoID;

	if(Par_Estatus = EstatusCancelada)then
		set Par_Estatus := EstatusCancelada;
	else
		set Par_Estatus	:= EstatusInactiva;
	end if;


	update SOLICITUDCREDITO Sol set
			Sol.ProductoCreditoID 	= Par_ProductoCreditoID,
			Sol.FechaAutoriza		= Fecha_Vacia,
			Sol.MontoAutorizado		= Entero_Cero,
			Sol.Estatus				= Par_Estatus,

			Sol.ForCobroSegVida		= Par_ForCobroSegVida,
			Sol.ForCobroComAper		= Var_ForCobroComAper,
			Sol.CalcInteresID		= Var_CalcInteres,
			Sol.FactorMora			= Var_FactorMora,
			Sol.AjusFecUlVenAmo		= Var_AjusFecUlAmoVen,
			Sol.AjusFecExiVen		= Var_AjusFecExigVenc,

			Sol.FechaInhabil		= Var_FecInHabTomar,
			Sol.UsuarioAutoriza		=Entero_Cero,
			Sol.InstitFondeoID		= Var_InstitutFondID,
			Sol.TipoCalInteres		= Var_TipoCalInteres,
			Sol.FechaInicio			=Var_FechaSistema,

			Sol.DescuentoSeguro		= Par_DescuentoSeguro,
			Sol.MontoSegOriginal	= Par_MontoSegOriginal,

			Sol.EmpresaID			= Par_EmpresaID,
			Sol.Usuario				= Aud_Usuario,
			Sol.FechaActual			= Aud_FechaActual,
			Sol.DireccionIP			= Aud_DireccionIP,

			Sol.ProgramaID			= Aud_ProgramaID,
			Sol.Sucursal			= Aud_Sucursal,
			Sol.NumTransaccion		= Aud_NumTransaccion
		where Sol.SolicitudCreditoID = Par_SolicitudCreditoID;



end if;

	if(Par_Estatus <> EstatusCancelada and  Par_Estatus <> EstatusEliminado)then

			call RECALAUTOSOLCREPRO(
					Par_SolicitudCreditoID, Par_MontoSolicitado,	Aud_Sucursal,	SalidaNO,			Par_NumErr,
					Par_ErrMen,				Var_ComisAp,			Var_IVAComisAp,	Var_TasaFija,		Var_MontoSeguro,
					Var_MontoGarLiq,		Var_MontoAuto,			Var_PorcGarLiq,	Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

			if(Par_NumErr <> Entero_Cero)then
				LEAVE ManejoErrores;
			end if;


			CALL CRECALCULOCICLOPRO(
					Var_ClienteID,		 Var_ProspectoID,		Par_ProductoCreditoID,		 Par_GrupoID,		 Var_NumCredCte,
					Var_NumCredGrupo,	 SalidaNO,				Par_EmpresaID,		 		 Aud_Usuario,		 Aud_FechaActual,
					Aud_DireccionIP,	 Aud_ProgramaID,		Aud_Sucursal,				 Aud_NumTransaccion);


			update SOLICITUDCREDITO Sol set
				Sol.MontoSolici			= Var_MontoAuto,
				Sol.MontoPorComAper		= Var_ComisAp,
				Sol.IVAComAper			= Var_IVAComisAp,
				Sol.TasaFija			= Var_TasaFija,
				Sol.AporteCliente		=Var_MontoGarLiq,
				Sol.PorcGarLiq			=Var_PorcGarLiq,
				Sol.MontoSeguroVida		=Var_MontoSeguro,
				Sol.CicloGrupo			=Var_NumCredGrupo,
				Sol.MontoSegOriginal    = ROUND(Var_MontoSeguro / (1 - (DescuentoSeguro / 100)), 2)
			where Sol.SolicitudCreditoID = Par_SolicitudCreditoID;


if(Var_ReqSeguroVida = SiReqSeguro)then
	if(Var_Modalidad = ModUnico)then
		set Var_MontoPolizaSeguro := Var_MontoPoliza;
	else
		set Var_MontoPolizaSeguro := Var_MontoPolSeg;
	end if;

	update SEGUROVIDA set
			MontoPoliza = Var_MontoPolizaSeguro,
			ForCobroSegVida = Par_ForCobroSegVida
			where SolicitudCreditoID = Par_SolicitudCreditoID;
end if;


			update INTEGRAGRUPOSCRE set
				Ciclo			= Var_NumCredCte
				where GrupoID	= Par_GrupoID
				and SolicitudCreditoID = Par_SolicitudCreditoID;
end if;


	if(Par_Estatus = EstatusEliminado)then
		update INTEGRAGRUPOSCRE set
				Estatus = EstatusRechazado
				where GrupoID= Par_GrupoID
				and SolicitudCreditoID = Par_SolicitudCreditoID;
		update SOLICITUDCREDITO set
			Estatus = EstatusCancelado
			where SolicitudCreditoID=Par_SolicitudCreditoID;
	end if;

	set Par_NumErr		:= 0;
	set Par_ErrMen		:= "Condiciones Modificadas Correctamente.";

end if;

END ManejoErrores;

if( Par_Salida=  SalidaSI) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			'grupoID' as control,
			Entero_Cero as consecutivo;
end if;

END TerminaStore$$