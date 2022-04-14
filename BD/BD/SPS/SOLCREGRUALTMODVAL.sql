-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLCREGRUALTMODVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLCREGRUALTMODVAL`;DELIMITER $$

CREATE PROCEDURE `SOLCREGRUALTMODVAL`(

	Par_Solicitud       int,
	Par_ProspectoID     bigint(20),
	Par_ClienteID       int,

	Par_GrupoID         int(10),
	Par_Cargo      		int(11),

	Par_Salida          char(1),
	inout Par_NumErr    int,
	inout Par_ErrMen    varchar(400),
	Par_EmpresaID       int(11),
	Aud_Usuario         int,
	Aud_FechaActual     DateTime,
	Aud_DireccionIP     varchar(15),
	Aud_ProgramaID      varchar(50),
	Aud_Sucursal        int,
	Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Var_ProCreID	int(11);
DECLARE Var_PlazoID		varchar(20);
DECLARE Var_CalIntID	int(11);
DECLARE Var_FrecCap		char(1);
DECLARE Var_PeriodCap	int(11);
DECLARE Var_FrecInt		char(1);
DECLARE Var_PeriodInt	int(11);
DECLARE Var_TipPagCap	char(1);
DECLARE Var_NumAmor		int(11);
DECLARE Var_DiaPagInt	char(1);
DECLARE Var_DiaPagCap	char(1);
DECLARE Var_DiaMesInt	int(11);
DECLARE Var_DiaMesCap 	int(11);
DECLARE Var_AjVenAmo	char(1);
DECLARE Var_AjExiVen	char(1);
DECLARE Var_FecIna		char(1);
DECLARE Var_TiCalInt	int(11);
DECLARE Var_NumAmorInt	int(11);
DECLARE Var_NumIntegra  int(11);

DECLARE Var_IntSolCreID bigint;
DECLARE Var_IntGrupoID  int;
DECLARE Var_IntEstatus  char(1);
DECLARE Var_DesCargo    varchar(45);

DECLARE Par_PlazoID    	int;
DECLARE Par_CalcInteres int;
DECLARE Par_FechInhabil char(1);
DECLARE Par_AjuFecExiVe char(1);
DECLARE Par_AjFUlVenAm  char(1);
DECLARE Par_TipoPagCap  char(1);
DECLARE Par_FrecInter   char(1);
DECLARE Par_FrecCapital char(1);
DECLARE Par_PeriodInt   int;
DECLARE Par_PeriodCap   int;
DECLARE Par_DiaPagInt   char(1);
DECLARE Par_DiaPagCap   char(1);
DECLARE Par_DiaMesInter int;
DECLARE Par_DiaMesCap   int;
DECLARE Par_NumAmorti   int;
DECLARE Par_TipoCalInt  int(11);
DECLARE Par_NumAmortInt int(11);
DECLARE Par_ProduCredID	int(11);
DECLARE varControl      char(15);


DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(12,2);
DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Salida_NO       char(1);
DECLARE Salida_SI       char(1);
DECLARE Estatus_Ina     char(1);
DECLARE Estatus_Activo  char(1);
declare PagoMensual		char(1);
declare PagoBimestral	char(1);
declare PagoTrimestral	char(1);
declare PagoTetrames	char(1);
declare PagoSemestral	char(1);
DECLARE Int_Activo      char(1);


set Entero_Cero     := 0;
set Decimal_Cero    := 0.0;
set Fecha_Vacia     := '1900-01-01';
set Cadena_Vacia    := '';
Set Salida_SI       := 'S';
Set Salida_NO       := 'N';
Set Estatus_Ina		:= 'I';
Set Estatus_Activo  := 'A';
set PagoMensual		:= 'M';
set PagoBimestral	:= 'B';
set PagoTrimestral	:= 'T';
set PagoTetrames	:= 'R';
set PagoSemestral	:= 'E';
Set Int_Activo      := 'A';


Set Par_NumErr		:= 0;
Set Par_ErrMen		:= '';


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			Set Par_NumErr = 999;
			set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								"estamos trabajando para resolverla. Disculpe las molestias que ",
								"esto le ocasiona. Ref: SP-SOLCREGRUALTMODVAL.");
			END;

select 	SC.ProductoCreditoID,	SC.PlazoID,				SC.CalcInteresID,	SC.FrecuenciaCap,	SC.PeriodicidadCap,
		SC.FrecuenciaInt,		SC.PeriodicidadInt,		SC.TipoPagoCapital,	SC.NumAmortizacion,	SC.DiaPagoInteres,
		SC.DiaPagoCapital,		SC.DiaMesInteres,		SC.DiaMesCapital,	SC.AjusFecUlVenAmo,	SC.AjusFecExiVen,
		SC.FechaInhabil,		SC.TipoCalInteres,		SC.NumAmortInteres
into	Par_ProduCredID,		Par_PlazoID,			Par_CalcInteres,	Par_FrecCapital,	Par_PeriodCap,
		Par_FrecInter,			Par_PeriodInt,			Par_TipoPagCap,		Par_NumAmorti,		Par_DiaPagInt,
		Par_DiaPagCap,			Par_DiaMesInter,		Par_DiaMesCap,		Par_AjFUlVenAm,		Par_AjuFecExiVe,
		Par_FechInhabil,		Par_TipoCalInt,			Par_NumAmortInt
from SOLICITUDCREDITO SC
where SC.SolicitudCreditoID = Par_Solicitud;


set Par_ProduCredID	:=ifnull(Par_ProduCredID,Entero_Cero);
set Par_PlazoID		:=ifnull(Par_PlazoID, Entero_Cero);
set Par_CalcInteres	:=ifnull(Par_CalcInteres,Entero_Cero );
set Par_FrecCapital	:=ifnull(Par_FrecCapital,Cadena_Vacia);
set Par_PeriodCap	:=ifnull(Par_PeriodCap,Entero_Cero );
set	Par_FrecInter	:=ifnull(Par_FrecInter,Cadena_Vacia);
set	Par_PeriodInt	:=ifnull(Par_PeriodInt,Entero_Cero);
set	Par_TipoPagCap	:=ifnull(Par_TipoPagCap,Cadena_Vacia);
set	Par_NumAmorti	:=ifnull(Par_NumAmorti, Entero_Cero);
set	Par_DiaPagInt	:=ifnull(Par_DiaPagInt,Cadena_Vacia);
set	Par_DiaPagCap	:=ifnull(Par_DiaPagCap,Cadena_Vacia );
set	Par_DiaMesInter	:=ifnull(Par_DiaMesInter,Entero_Cero);
set	Par_DiaMesCap	:=ifnull(Par_DiaMesCap,Entero_Cero);
set	Par_AjFUlVenAm	:=ifnull(Par_AjFUlVenAm,Cadena_Vacia);
set	Par_AjuFecExiVe	:=ifnull(Par_AjuFecExiVe,Cadena_Vacia);
set	Par_FechInhabil	:=ifnull(Par_FechInhabil,Cadena_Vacia);
set	Par_TipoCalInt	:=ifnull(Par_TipoCalInt,Entero_Cero);
set	Par_NumAmortInt	:=ifnull(Par_NumAmortInt,Entero_Cero);



SELECT	min(SC.ProductoCreditoID),	min(SC.PlazoID),			min(SC.CalcInteresID),	min(SC.FrecuenciaCap),		min(SC.PeriodicidadCap),
		min(SC.FrecuenciaInt),		min(SC.PeriodicidadInt),	min(SC.TipoPagoCapital),min(SC.NumAmortizacion),	min(SC.DiaPagoInteres),
		min(SC.DiaPagoCapital),		min(SC.DiaMesInteres),		min(SC.DiaMesCapital),	min(SC.AjusFecUlVenAmo),	min(SC.AjusFecExiVen),
		min(SC.FechaInhabil),		min(SC.TipoCalInteres),		min(SC.NumAmortInteres),count(Ing.GrupoID)
INTO	Var_ProCreID,				Var_PlazoID,				Var_CalIntID,			Var_FrecCap,				Var_PeriodCap,
		Var_FrecInt,				Var_PeriodInt,				Var_TipPagCap,			Var_NumAmor,				Var_DiaPagInt,
		Var_DiaPagCap,				Var_DiaMesInt,				Var_DiaMesCap,			Var_AjVenAmo,				Var_AjExiVen,
		Var_FecIna,					Var_TiCalInt,				Var_NumAmorInt,			Var_NumIntegra
	from INTEGRAGRUPOSCRE Ing,
         SOLICITUDCREDITO SC
    where Ing.GrupoID = Par_GrupoID
      and Ing.Estatus = Int_Activo
      and Ing.SolicitudCreditoID = SC.SolicitudCreditoID
      and SC.SolicitudCreditoID != Par_Solicitud
      group by Ing.GrupoID;



set Var_ProCreID	:=ifnull(Var_ProCreID,Entero_Cero);
set	Var_PlazoID		:=ifnull(Var_PlazoID,Cadena_Vacia);
set	Var_CalIntID	:=ifnull(Var_CalIntID,Entero_Cero);
set	Var_FrecCap		:=ifnull(Var_FrecCap,Cadena_Vacia);
set	Var_PeriodCap	:=ifnull(Var_PeriodCap, Entero_Cero);
set Var_FrecInt		:=ifnull(Var_FrecInt,Cadena_Vacia);
set Var_PeriodInt	:=ifnull(Var_PeriodInt,Entero_Cero);
set	Var_TipPagCap	:=ifnull(Var_TipPagCap, Cadena_Vacia);
set Var_NumAmor		:=ifnull(Var_NumAmor,Entero_Cero );
set Var_DiaPagInt	:=ifnull(Var_DiaPagInt,Cadena_Vacia);
set Var_DiaPagCap	:=ifnull(Var_DiaPagCap,Cadena_Vacia);
set	Var_DiaMesInt 	:=ifnull(Var_DiaMesInt, Entero_Cero);
set	Var_DiaMesCap 	:=ifnull(Var_DiaMesCap,Entero_Cero );
set	Var_AjVenAmo	:=ifnull(Var_AjVenAmo,Cadena_Vacia );
set	Var_AjExiVen 	:=ifnull(Var_AjExiVen,Cadena_Vacia);
set	Var_FecIna 		:=ifnull(Var_FecIna,Cadena_Vacia);
set	Var_TiCalInt 	:=ifnull(Var_TiCalInt, Entero_Cero);
set	Var_NumAmorInt	:=ifnull(Var_NumAmorInt, Entero_Cero);
set	Var_NumIntegra	:=ifnull(Var_NumIntegra,Entero_Cero);


if(Var_NumIntegra > Entero_Cero) then

    if(ifnull(Var_ProCreID, Entero_Cero) != ifnull(Par_ProduCredID, Entero_Cero) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe tener el mismo Producto de Credito que los demas Integrantes.");
        set varControl  := 'productoCreditoID' ;
         LEAVE ManejoErrores;
    end if;

    if(ifnull(Par_PlazoID, Entero_Cero) != ifnull(Var_PlazoID, Entero_Cero) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe tener el mismo Plazo que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;

    if(ifnull(Var_CalIntID, Entero_Cero) != ifnull(Par_CalcInteres, Entero_Cero) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe tener el mismo calculo de Interes que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;

    if(ifnull(Var_FrecCap, Cadena_Vacia) != ifnull(Par_FrecCapital, Cadena_Vacia) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe tener la misma Frecuencia de Capital que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;

    if(ifnull(Var_PeriodCap, Entero_Cero) != ifnull(Par_PeriodCap, Entero_Cero) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe tener la misma Periodicidad de Capital que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;

    if(ifnull(Var_FrecInt, Cadena_Vacia) != ifnull(Par_FrecInter, Cadena_Vacia) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe tener la misma Frecuencia de Interes que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;

    if(ifnull(Var_PeriodInt, Entero_Cero) != ifnull(Par_PeriodInt, Entero_Cero) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe tener la misma Periodicidad de Interes que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;

    if(Var_FrecCap = PagoMensual or Var_FrecCap = PagoBimestral  or Var_FrecCap = PagoTrimestral or  Var_FrecCap = PagoTetrames or Var_FrecCap = PagoSemestral)then
        if(ifnull(Var_DiaPagCap, Cadena_Vacia) != ifnull(Par_DiaPagCap, Cadena_Vacia) ) then
            set Par_NumErr  := '012';
            set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                            " debe tener el mismo Dia de Pago de Capital que los demas Integrantes.",
                            'Dia Pago Grupo ', Var_DiaPagCap);
            set varControl  := 'grupoID' ;
             LEAVE ManejoErrores;
        end if;
        if(ifnull(Par_DiaPagCap, Cadena_Vacia) != 'F') then
            if(ifnull(Var_DiaMesCap, Entero_Cero) != ifnull(Var_DiaMesCap, Entero_Cero) ) then
                set Par_NumErr  := '013';
                set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                                " debe tener el mismo Dia de Mes de Capital que los demas Integrantes.");
                set varControl  := 'grupoID' ;
                 LEAVE ManejoErrores;
            end if;
        end if;
    end if;

    if(Var_FrecInt = PagoMensual or Var_FrecInt = PagoBimestral  or Var_FrecInt = PagoTrimestral or  Var_FrecInt = PagoTetrames or Var_FrecInt = PagoSemestral)then
        if(ifnull(Var_DiaPagInt, Cadena_Vacia) != ifnull(Var_DiaPagInt, Cadena_Vacia) ) then
            set Par_NumErr  := '012';
            set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                            " debe tener el mismo Dia de Pago de Interes que los demas Integrantes.",
                            'Dia Pago Grupo ', Var_DiaPagInt);
            set varControl  := 'grupoID' ;
             LEAVE ManejoErrores;
        end if;
        if(ifnull(Var_DiaPagInt, Cadena_Vacia) != 'F') then
            if(ifnull(Var_DiaMesInt, Entero_Cero) != ifnull(Var_DiaMesInt, Entero_Cero) ) then
                set Par_NumErr  := '013';
                set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                                " debe tener el mismo Dia de Mes de Interes que los demas Integrantes.");
                set varControl  := 'grupoID' ;
                 LEAVE ManejoErrores;
            end if;
        end if;
    end if;

    if(ifnull(Var_TipPagCap, Cadena_Vacia) != ifnull(Par_TipoPagCap, Cadena_Vacia) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe tener el mismo Tipo de Pago de Capital que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;

    if(ifnull(Var_NumAmor, Entero_Cero) != ifnull(Par_NumAmorti, Entero_Cero) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe tener el mismo numero de Cuotas de Capital que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;

    if(ifnull(Var_NumAmorInt, Entero_Cero) != ifnull(Par_NumAmortInt, Entero_Cero) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe tener el mismo numero de Cuotas de Interes que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;


    if(ifnull(Var_AjVenAmo, Cadena_Vacia) != ifnull(Par_AjFUlVenAm, Cadena_Vacia) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe Ajustar Fecha de Vencimiento de Credito a Fecha de Ultima Amortizacion igual que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;


    if(ifnull(Var_AjExiVen, Cadena_Vacia) != ifnull(Par_AjuFecExiVe, Cadena_Vacia) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe ajustar Fecha Exigíble a la de Vencimiento igual que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;

    if(ifnull(Var_FecIna, Cadena_Vacia) != ifnull(Par_FechInhabil, Cadena_Vacia) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe tener el mismo valor en ajustar Fecha Inhabil que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;

    if(ifnull(Var_TiCalInt, Entero_Cero) != ifnull(Par_TipoCalInt, Entero_Cero	) ) then
        set Par_NumErr  := '007';
        set Par_ErrMen  := concat("La Solicitud ", convert(Par_Solicitud, char),
                        " debe tener el mismo valor en Tipo Cal. Interes que los demas Integrantes.");
        set varControl  := 'grupoID' ;
         LEAVE ManejoErrores;
    end if;
end if;

END ManejoErrores;

if (Par_Salida = Salida_SI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'grupoID' as control,
            Entero_Cero as consecutivo;
end if;



END TerminaStore$$