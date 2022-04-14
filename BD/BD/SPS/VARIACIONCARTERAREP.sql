-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VARIACIONCARTERAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `VARIACIONCARTERAREP`;DELIMITER $$

CREATE PROCEDURE `VARIACIONCARTERAREP`(

	Par_Anio			int(11),
	Par_Mes				int(11),

	Par_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion	bigint(20)
	)
BEGIN


DECLARE Var_IniMes			date;
DECLARE Var_FinMes			date;
DECLARE Var_FinMesAnt		date;
DECLARE Var_SalCapVig		decimal(16,2);
DECLARE Var_SalCapAtr		decimal(16,2);

DECLARE Var_SalIntVig		decimal(16,2);
DECLARE Var_SalIntAtr		decimal(16,2);
DECLARE Var_TotVigente		decimal(16,2);
DECLARE Var_NumCreVig		int;
DECLARE Var_SalCapVen		decimal(16,2);

DECLARE Var_SalIntVen		decimal(16,2);
DECLARE Var_TotVencido		decimal(16,2);
DECLARE Var_NumCreVen		int;
DECLARE Var_AntSalCapVig	decimal(16,2);
DECLARE Var_AntSalCapAtr	decimal(16,2);

DECLARE Var_AntSalIntVig	decimal(16,2);
DECLARE Var_AntSalIntAtr	decimal(16,2);
DECLARE Var_AntTotVigente	decimal(16,2);
DECLARE Var_AntNumCreVig	int;
DECLARE Var_AntSalCapVen	decimal(16,2);

DECLARE Var_AntSalIntVen	decimal(16,2);
DECLARE Var_AntTotVencido	decimal(16,2);
DECLARE Var_AntNumCreVen	int;
DECLARE Var_CreOtorga		decimal(16,2);
DECLARE Var_CreNumOtorga	int;

DECLARE Var_IntDevMes		decimal(16,2);
DECLARE	Var_CapitalRegula	decimal(16,2);
DECLARE	Var_IntRegula		decimal(16,2);
DECLARE	Var_NumCreRegula	int;
DECLARE	Var_MonVigPag		decimal(16,2);

DECLARE	Var_NumVigPag		int;
DECLARE	Var_MonVenPag		decimal(16,2);
DECLARE	Var_NumVenPag		int;
DECLARE	Var_MtoRegula		decimal(16,2);
DECLARE	Var_CapPasVenc		decimal(16,2);

DECLARE	Var_IntPasVen		decimal(16,2);
DECLARE	Var_NumCrePasVen	int;
DECLARE	Var_TotPasVenc		decimal(16,2);

DECLARE	Var_TotCastigo		decimal(16,2);
DECLARE	Var_CapCastigo		decimal(16,2);
DECLARE	Var_IntCastigo		decimal(16,2);
DECLARE	Var_NumCreCas		int;
DECLARE Var_PagIntNoCon		decimal(16,2);

DECLARE Var_PagCapVNE		decimal(16,2);
DECLARE	Var_TotPagVNE		decimal(16,2);
DECLARE Var_NumPagTotVNE	int;
DECLARE Var_NumPagCapVNE	int;
DECLARE Var_PagMoraVig		decimal(16,2);

DECLARE	Var_PagMoraVen			decimal(16,2);
DECLARE Var_TotIncremCarVig		decimal(16,2);
DECLARE Var_CredIncremCarVig	int;
DECLARE Var_TotDecremCarVig		decimal(16,2);
DECLARE Var_CredDecremCarVig	int;

DECLARE Var_CredIntDev       	int;
DECLARE Var_TotDecremCarVen     decimal(16,2);
DECLARE Var_CredDecremCarVen    int;


DECLARE Cadena_Vacia		char(1);
DECLARE Fecha_Vacia			date;
DECLARE Entero_Cero			int;

DECLARE Est_Vigente			char(1);
DECLARE Est_Vencido			char(1);
DECLARE Est_Castigado		char(1);
DECLARE Est_Pagado			char(1);

DECLARE NatMovCargo     	char(1);
DECLARE NatMovAbono     	char(1);
DECLARE DescPagoCred    	varchar(50);
DECLARE CierreCartera   	varchar(50);
DECLARE Regularizacion  	varchar(50);
DECLARE GeneraInterMora 	varchar(100);
DECLARE TrasCartVencida 	varchar(100);
DECLARE IntProvisionado 	int;
DECLARE IntMoratorio 		int;
DECLARE CapOrdinario 		int;
DECLARE CapVenNoExig		int;
DECLARE IntDevNoCont		int;
DECLARE IntMoraVenc			int;
DECLARE CapVencido			int;
DECLARE IntVencido          int;


Set Cadena_Vacia		:= '';
Set Fecha_Vacia			:= '1900-01-01';
Set Entero_Cero			:= 0;

Set Est_Vigente			:= 'V';
Set Est_Vencido			:= 'B';
Set Est_Castigado		:= 'K';
Set Est_Pagado			:= 'P';

Set NatMovCargo     	:= 'C';
Set NatMovAbono     	:= 'A';
Set DescPagoCred    	:= 'PAGO DE CREDITO';
Set CierreCartera		:= 'CIERRE DIARO CARTERA';
Set Regularizacion  	:= 'REGULARIZACION DE CREDITO';
Set GeneraInterMora 	:= 'GENERACION INTERES MORATORIO';
Set TrasCartVencida 	:= 'TRASPASO A CARTERA VENCIDA';
Set IntProvisionado 	:= 14;
Set IntMoratorio    	:= 15;
Set CapOrdinario		:= 1;
Set CapVenNoExig    	:= 4;
Set IntDevNoCont    	:= 13;
Set IntMoraVenc     	:= 16;
Set CapVencido      	:= 3;
Set IntVencido     	 	:= 12;

set Var_IniMes	:= convert(concat(convert(Par_Anio, char), "-", convert(Par_Mes, char), "-01"), date);
set Var_FinMes	:= date_add(date_add(Var_IniMes, interval 1 Month), interval -1 Day);
set Var_FinMesAnt := date_add(Var_IniMes, interval -1 Day);

select max(FechaCorte) into Var_FinMes
	from SALDOSCREDITOS Sal
	where Sal.FechaCorte <= Var_FinMes;

select max(FechaCorte) into Var_FinMesAnt
	from SALDOSCREDITOS Sal
	where Sal.FechaCorte <= Var_FinMesAnt;




select	sum(SalCapVigente),		sum(SalCapAtrasado),
		sum(SalIntProvision + SalMoratorios),	sum(SalIntAtrasado),
		sum(case when EstatusCredito = Est_Vigente then 1 else Entero_Cero end),
		sum(SalCapVencido+SalCapVenNoExi), 	sum(SalIntVencido + SaldoMoraVencido),
		sum(case when EstatusCredito = Est_Vencido then 1 else Entero_Cero end)

		into Var_SalCapVig, Var_SalCapAtr, Var_SalIntVig, Var_SalIntAtr, Var_NumCreVig,
			 Var_SalCapVen,	Var_SalIntVen,	Var_NumCreVen

	from SALDOSCREDITOS
	where FechaCorte = Var_FinMes;

set	Var_SalCapVig	:= ifnull(Var_SalCapVig,Entero_Cero);
set Var_SalCapAtr	:= ifnull(Var_SalCapAtr,Entero_Cero);
set Var_SalIntVig	:= ifnull(Var_SalIntVig,Entero_Cero);
set Var_SalIntAtr	:= ifnull(Var_SalIntAtr,Entero_Cero);
set Var_NumCreVig	:= ifnull(Var_NumCreVig,Entero_Cero);
set Var_NumCreVen	:= ifnull(Var_NumCreVen,Entero_Cero);

set Var_TotVigente	:= Var_SalCapVig + Var_SalCapAtr + Var_SalIntVig + Var_SalIntAtr;
set	Var_TotVencido	:= ifnull(Var_SalCapVen,Entero_Cero) + ifnull(Var_SalIntVen,Entero_Cero);




select	sum(SalCapVigente),		sum(SalCapAtrasado),
		sum(SalIntProvision + SalMoratorios),	sum(SalIntAtrasado),
		sum(case when EstatusCredito = Est_Vigente then 1 else Entero_Cero end),
		sum(SalCapVencido+SalCapVenNoExi), 	sum(SalIntVencido + SaldoMoraVencido),
		sum(case when EstatusCredito = Est_Vencido then 1 else Entero_Cero end)

		into Var_AntSalCapVig,	Var_AntSalCapAtr,	Var_AntSalIntVig, Var_AntSalIntAtr, Var_AntNumCreVig,
			 Var_AntSalCapVen,	Var_AntSalIntVen,	Var_AntNumCreVen

	from SALDOSCREDITOS
	where FechaCorte = Var_FinMesAnt;


set	Var_AntSalCapVig	:= ifnull(Var_AntSalCapVig, Entero_Cero);
set Var_AntSalCapAtr	:= ifnull(Var_AntSalCapAtr, Entero_Cero);
set Var_AntSalIntVig	:= ifnull(Var_AntSalIntVig, Entero_Cero);
set Var_AntSalIntAtr	:= ifnull(Var_AntSalIntAtr, Entero_Cero);
set Var_AntNumCreVig	:= ifnull(Var_AntNumCreVig, Entero_Cero);

set Var_AntSalCapVen	:= ifnull(Var_AntSalCapVen, Entero_Cero);
set Var_AntSalIntVen	:= ifnull(Var_AntSalIntVen, Entero_Cero);
set Var_AntNumCreVen	:= ifnull(Var_AntNumCreVen, Entero_Cero);


set Var_AntTotVigente	:= Var_AntSalCapVig + Var_AntSalCapAtr + Var_AntSalIntVig + Var_AntSalIntAtr;
set Var_AntTotVencido	:= Var_AntSalCapVen + Var_AntSalIntVen;





select sum(MontoCredito), count(CreditoID) into Var_CreOtorga, Var_CreNumOtorga
	from CREDITOS Cre
	where ifnull(Cre.FechaMinistrado, Fecha_Vacia) between Var_IniMes and Var_FinMes
	  and Cre.Estatus in (Est_Vigente, Est_Vencido, Est_Pagado, Est_Castigado);


set Var_CreOtorga		:= ifnull(Var_CreOtorga, Entero_Cero);
set Var_CreNumOtorga	:= ifnull(Var_CreNumOtorga, Entero_Cero);





select sum(Cantidad) into Var_IntDevMes
	from CREDITOSMOVS Mov
		  FORCE INDEX (`CREDITOSMOVS_1`)
	where Mov.FechaOperacion between Var_IniMes and Var_FinMes
	  and NatMovimiento = NatMovCargo
	  and TipoMovCreID in (IntProvisionado,IntMoratorio)
	  and Descripcion = CierreCartera;

set Var_IntDevMes := ifnull(Var_IntDevMes, Entero_Cero);





select count(distinct Transaccion),
	   sum(case when TipoMovCreID = CapOrdinario then Cantidad else Entero_Cero end),
	   sum(case when TipoMovCreID = IntProvisionado then Cantidad else Entero_Cero end) into

		Var_NumCreRegula, Var_CapitalRegula, Var_IntRegula

	from CREDITOSMOVS Mov
	where Mov.FechaOperacion between Var_IniMes and Var_FinMes
      and TipoMovCreID in (CapOrdinario,IntProvisionado)
	  and NatMovimiento = NatMovCargo
	 and Descripcion = Regularizacion;

set Var_CapitalRegula	:= ifnull(Var_CapitalRegula, Entero_Cero);
set Var_IntRegula		:= ifnull(Var_IntRegula, Entero_Cero);

set Var_IntDevMes := Var_IntDevMes + Var_IntRegula;


set Var_NumCreRegula := ifnull(Var_NumCreRegula, Entero_Cero);




select sum(Det.MontoCapAtr + Det.MontoCapOrd + Det.MontoIntAtr + Det.MontoIntOrd),
	   sum(case when (Det.MontoCapAtr + Det.MontoCapOrd +
					  Det.MontoIntAtr + Det.MontoIntOrd ) > Entero_Cero
				 then 1
				 else Entero_Cero end),
		sum(Det.MontoCapVen + Det.MontoIntVen),

	   sum(case when (Det.MontoCapVen + Det.MontoIntVen) > Entero_Cero
				 then 1
				 else Entero_Cero end)
		into Var_MonVigPag, Var_NumVigPag, Var_MonVenPag, Var_NumVenPag
	from DETALLEPAGCRE Det
	where FechaPago between Var_IniMes and Var_FinMes;

set	Var_MonVigPag	:= ifnull(Var_MonVigPag, Entero_Cero);
set	Var_NumVigPag	:= ifnull(Var_NumVigPag, Entero_Cero);

set	Var_MonVenPag	:= ifnull(Var_MonVenPag, Entero_Cero);
set	Var_NumVenPag	:= ifnull(Var_NumVenPag, Entero_Cero);



select	count(CreditoID),
		sum(case when TipoMovCreID = CapVenNoExig then 1 else Entero_Cero end),
		sum(Cantidad),
		sum(case when TipoMovCreID = IntDevNoCont then Cantidad else Entero_Cero end),
        sum(case when TipoMovCreID = CapVenNoExig then Cantidad else Entero_Cero end) into

        Var_NumPagTotVNE,	Var_NumPagCapVNE, Var_TotPagVNE, Var_PagIntNoCon, Var_PagCapVNE

	from CREDITOSMOVS
	FORCE INDEX (`CREDITOSMOVS_1`)
    where FechaOperacion between Var_IniMes and Var_FinMes
    and TipoMovCreID in (CapVenNoExig,IntDevNoCont)
	and NatMovimiento = NatMovAbono
    and Descripcion = DescPagoCred;



set Var_NumPagTotVNE	:= ifnull(Var_NumPagTotVNE, Entero_Cero);
set Var_NumPagCapVNE	:= ifnull(Var_NumPagCapVNE, Entero_Cero);
set Var_TotPagVNE		:= ifnull(Var_TotPagVNE, Entero_Cero);
set Var_PagCapVNE		:= ifnull(Var_PagCapVNE, Entero_Cero);


set	Var_MonVigPag	:= Var_MonVigPag - Var_TotPagVNE;

set	Var_NumVigPag	:= Var_NumVigPag - Var_NumPagTotVNE ;

set	Var_MonVenPag	:= Var_MonVenPag + Var_PagCapVNE;
set	Var_NumVenPag	:= Var_NumVenPag + Var_NumPagCapVNE;


select	sum(case when TipoMovCreID = IntMoratorio then Cantidad else Entero_Cero end),
        sum(case when TipoMovCreID = IntMoraVenc then Cantidad else Entero_Cero end) into

       Var_PagMoraVig,		Var_PagMoraVen

	from CREDITOSMOVS
		 FORCE INDEX (`CREDITOSMOVS_1`)
    where FechaOperacion between Var_IniMes and Var_FinMes
    and TipoMovCreID in (IntMoratorio,IntMoraVenc)
	and NatMovimiento = NatMovAbono
    and Descripcion = DescPagoCred;

set	Var_PagMoraVig		:= ifnull(Var_PagMoraVig, Entero_Cero);
set	Var_PagMoraVen		:= ifnull(Var_PagMoraVen, Entero_Cero);

set	Var_MonVigPag	:= Var_MonVigPag + Var_PagMoraVig;
set	Var_MonVenPag	:= Var_MonVenPag + Var_PagMoraVen;




select sum(Mov.Cantidad),
	   count(Mov.CreditoID) into Var_TotPasVenc, Var_NumCrePasVen
	from CREDITOSMOVS Mov
		 FORCE INDEX (`CREDITOSMOVS_1`)
	where Mov.FechaOperacion between Var_IniMes and Var_FinMes
	  and Mov.NatMovimiento = NatMovCargo
	  and Mov.TipoMovCreID in (CapVencido, CapVenNoExig, IntVencido,IntMoraVenc)
      and (	(Mov.Descripcion = CierreCartera
         and Mov.Referencia = GeneraInterMora
         and  Mov.TipoMovCreID = IntVencido)

		or (Mov.Descripcion = CierreCartera
         and Mov.Referencia = TrasCartVencida)

		or (Mov.Descripcion = TrasCartVencida
         and Mov.Referencia = TrasCartVencida) );

set Var_TotPasVenc		:= ifnull(Var_TotPasVenc, Entero_Cero);
set Var_NumCrePasVen	:= ifnull(Var_NumCrePasVen, Entero_Cero);

set Var_MtoRegula	:= Var_CapitalRegula;





select sum(CapitalCastigado), sum(InteresCastigado), count(CreditoID) into
		Var_CapCastigo, Var_IntCastigo, Var_NumCreCas
	from CRECASTIGOS Cas
	where Fecha between Var_IniMes and Var_FinMes;

set Var_CapCastigo	:= ifnull(Var_CapCastigo, Entero_Cero);
set Var_IntCastigo	:= ifnull(Var_IntCastigo, Entero_Cero);
set Var_NumCreCas	:= ifnull(Var_NumCreCas, Entero_Cero);

set Var_TotCastigo := Var_CapCastigo + Var_IntCastigo;

set Var_TotIncremCarVig		:= Var_CreOtorga + Var_IntDevMes + Var_MtoRegula;
set Var_CredIncremCarVig	:= Var_CreNumOtorga + Var_NumCreRegula;

set Var_TotDecremCarVig		:= Var_MonVigPag + Var_TotPasVenc;
set Var_CredDecremCarVig	:= Var_NumVigPag + Var_NumCrePasVen;

set Var_CredIntDev       	:= ifnull(Var_CredIntDev, Entero_Cero);

set Var_TotDecremCarVen     := Var_MtoRegula + Var_MonVenPag + Var_TotCastigo;
set Var_CredDecremCarVen    := Var_NumCreRegula + Var_NumVenPag +  + Var_NumCreCas;


select	Var_AntTotVigente,		Var_AntNumCreVig,		Var_CreOtorga, 			Var_CreNumOtorga, 		Var_IntDevMes,
		Var_MtoRegula, 			Var_NumCreRegula,		Var_MonVigPag,			Var_NumVigPag,			Var_TotPasVenc,
		Var_NumCrePasVen,		Var_TotVigente,			Var_NumCreVig,			Var_AntTotVencido,		Var_AntNumCreVen,
		Var_MonVenPag, 			Var_NumVenPag,			Var_TotVencido,			Var_NumCreVen,			Var_TotIncremCarVig,
		Var_CredIncremCarVig, 	Var_TotDecremCarVig, 	Var_CredDecremCarVig,	Var_CredIntDev,
		Var_TotDecremCarVen,	Var_CredDecremCarVen,	Var_TotCastigo,			Var_NumCreCas;

END$$