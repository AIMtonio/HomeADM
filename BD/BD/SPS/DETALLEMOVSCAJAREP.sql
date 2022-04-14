-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEMOVSCAJAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEMOVSCAJAREP`;DELIMITER $$

CREATE PROCEDURE `DETALLEMOVSCAJAREP`(
    Par_SucursalID      int,
    Par_CajaID          int,
    Par_Fecha           date,
    Par_TipoOperacion	int,

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Var_Monto		varchar(100);
DECLARE Var_Movimiento	varchar(100);
DECLARE Var_Referencia	varchar(100);
DECLARE Var_MontoTotal	decimal(14,2);

DECLARE Var_Encabezado  varchar(400);
DECLARE Var_NumeroMovs  int;
DECLARE Var_MontoMovs   decimal(14,2);
DECLARE Nat_Anterior    int;
DECLARE Var_MontoTotMov decimal(14,2);

DECLARE Var_Numero      int;
DECLARE Var_Descripcion varchar(500);
DECLARE Var_Naturaleza  int;
DECLARE Var_BalActEfe   decimal(14,2);
DECLARE Var_DifEntSal   decimal(14,2);
DECLARE Var_NomCajero   varchar(250);
DECLARE Var_SucursalCaja	int;
DECLARE Var_Hora		Time;
DECLARE Var_NombreCliente      varchar(200);


DECLARE Entero_Cero     int;
DECLARE Var_Vacio       char(1);
DECLARE Tipo_Encabezado char(1);
DECLARE Tipo_Detalle    char(1);
DECLARE Estilo_cursiva  char(1);
DECLARE Nat_Entrada     int;
DECLARE Nat_Salida      int;

DECLARE Ope_EntEfecCta  int;
DECLARE Ope_ApSegVida   int;
DECLARE Ope_EntSegVida  int;
DECLARE Ope_ReTransCaja int;
DECLARE Ope_EnTranCaja  int;
DECLARE Ope_RevEntDCred int;
DECLARE Ope_RevEntSegV  int;
DECLARE Ope_RevEntCCta  int;
DECLARE Ope_RevAbonoCta int;
DECLARE Ope_RevSegVida  int;
DECLARE Ope_EntGarLiAd  int;
DECLARE Ope_RevGarLiq   int;


DECLARE Ope_DevGarLiq   int;
DECLARE Ope_AjustesSob  int;
DECLARE Ope_EntPagoServ int;
DECLARE Ope_EntCInvCred int;
DECLARE Ope_EntComTAire int;
DECLARE Ope_EntCApCred  int;
DECLARE Ope_EntPagoCre  int;
DECLARE Ope_EntGarLiq   int;
DECLARE Ope_EntChqSBC   int;
DECLARE Ope_DesemCred   int;
DECLARE Ope_RetEfectivo int;
DECLARE Ope_CargTranfCta int;
DECLARE Ope_EntEfecFalt  int;
DECLARE Ope_EntEfectCam  int;

DECLARE Ope_TranCajas   int;
DECLARE Ope_DeGarLqAd   int;
DECLARE Ope_RevCobroSVi int;
DECLARE Ope_RevAbCta    int;

DECLARE Ope_RevSalGarLiq int;
DECLARE Ope_RevCargoCta int;
DECLARE Ope_RevApSegVida int;
DECLARE Ope_SalRecTrCaja int;
DECLARE Ope_CobSegVida   int;
DECLARE Ope_DepGarLiq    int;
DECLARE Ope_PagCApCred   int;
DECLARE Ope_PagoComInv   int;
DECLARE Ope_PagoServ     int;
DECLARE Ope_SalEfecCam   int;
DECLARE Ope_PagCoTAire   int;
DECLARE Ope_PagoCred     int;
DECLARE Ope_DepCtaSBC    int;
DECLARE Ope_SalDesCred   int;
DECLARE Ope_SalCargCta   int;
DECLARE Ope_AbonoCtaTra  int;
DECLARE Ope_AjustFaltant int;
DECLARE Ope_SalSobrante  int;
DECLARE Ope_SalGarLiq    int;
DECLARE Ope_SalEfecBanc  int;
DECLARE Ope_DepCta       int;
DECLARE SalApCobRiesgo   int;
DECLARE Ope_EntTransCta  int;
DECLARE Ope_SalTransCta  int;
DECLARE Ope_RevSalDesCrd int;


DECLARE CURSORDETALLEMOVS CURSOR FOR
select MontoEnFirme, CT.Descripcion as Movimiento, CM. Referencia,CM. FechaActual, cli.NombreCompleto
        from CAJASMOVS CM
		inner join CAJATIPOSOPERA CT on CM.TipoOperacion = CT.Numero
		inner join MONEDAS M on CM.MonedaID = M.MonedaId
		inner join CUENTASAHO cu on cu.CuentaAhoID = CM.Instrumento
		inner join CLIENTES cli on  cli.ClienteID = cu.ClienteID
		where CM.Fecha         = Par_Fecha
          and CM.SucursalID    = Var_SucursalCaja
          and CM.CajaID        = Par_CajaID
          and CM.TipoOperacion = Par_TipoOperacion;
DECLARE CURSORDETALLEM CURSOR FOR
select MontoEnFirme, CT.Descripcion as Movimiento, CM. Referencia,CM. FechaActual, cli.NombreCompleto
        from CAJASMOVS CM
		inner join CAJATIPOSOPERA CT on CM.TipoOperacion = CT.Numero
		inner join MONEDAS M on CM.MonedaID = M.MonedaId
		inner join CREDITOS cre on cre.CreditoID = CM.Referencia
		inner join CLIENTES cli on  cli.ClienteID = cre.ClienteID
        	where CM.Fecha         = Par_Fecha
          and CM.SucursalID    = Var_SucursalCaja
          and CM.CajaID        = Par_CajaID
          and CM.TipoOperacion = Par_TipoOperacion;


DECLARE CURSORDETALLEMOVSTRANS CURSOR FOR
select MontoEnFirme, CT.Descripcion as Movimiento, CM. Referencia,CM. FechaActual
        from CAJASMOVS CM
		inner join CAJATIPOSOPERA CT on CM.TipoOperacion = CT.Numero
		inner join MONEDAS M on CM.MonedaID = M.MonedaId
        	where CM.Fecha         = Par_Fecha
          and CM.SucursalID    = Var_SucursalCaja
          and CM.CajaID        = Par_CajaID
          and CM.TipoOperacion = Par_TipoOperacion;


set Entero_Cero     := 0;
set Var_Vacio       := '';
set Tipo_Encabezado := 'E';
set Tipo_Detalle    := 'D';
Set Nat_Entrada     := 1;
Set Nat_Salida      := 2;


set Ope_EntEfecCta  := 1;
set Ope_ApSegVida   := 17;
set Ope_EntSegVida  := 18;
set Ope_ReTransCaja := 19;
set Ope_EnTranCaja  := 20;
set Ope_RevEntDCred := 55;
set Ope_RevEntSegV  := 53;
set Ope_RevEntCCta  := 51;
set Ope_RevAbonoCta := 47;
set Ope_RevSegVida  := 45;
set Ope_EntGarLiAd  := 43;
set Ope_RevGarLiq   := 49;
set Ope_EntTransCta := 62;


set Ope_DevGarLiq   := 15;
set Ope_AjustesSob  := 14;
set Ope_EntPagoServ := 5 ;
set Ope_EntCInvCred := 4 ;
set Ope_EntComTAire := 7 ;
set Ope_EntCApCred  := 3 ;
set Ope_EntPagoCre  := 8 ;
set Ope_EntGarLiq   := 2 ;
set Ope_EntChqSBC   := 9 ;
set Ope_DesemCred   := 10;
set Ope_RetEfectivo := 11;
set Ope_CargTranfCta:= 12;
set Ope_EntEfecFalt := 13;
set Ope_EntEfectCam :=  6;
set Ope_TranCajas   := 40;
set Ope_DeGarLqAd   := 44;
set Ope_RevCobroSVi := 46;
set Ope_RevAbCta    := 48;

set Ope_RevSalGarLiq:= 50;
set Ope_RevCargoCta := 52;
set Ope_RevApSegVida:= 54;
set Ope_SalRecTrCaja:= 39;
set Ope_CobSegVida  := 38;
set Ope_DepGarLiq   := 22;
set Ope_PagCApCred  := 23;
set Ope_PagoComInv  := 24;
set Ope_PagoServ    := 25;
set Ope_SalEfecCam  := 26;
set Ope_PagCoTAire  := 27;
set Ope_PagoCred    := 28;
set Ope_DepCtaSBC   := 29;
set Ope_SalDesCred  := 30;
set Ope_SalCargCta  := 31;
set Ope_AbonoCtaTra := 32;
set Ope_AjustFaltant:= 33;
set Ope_SalSobrante := 34;
set Ope_SalGarLiq   := 35;
set Ope_SalEfecBanc := 36;
set Ope_DepCta      := 21;
set SalApCobRiesgo  := 37;
set Ope_SalTransCta := 63;
set Ope_RevSalDesCrd := 56;



DROP TABLE IF EXISTS TMPDETALLEARQ;
CREATE TEMPORARY TABLE TMPDETALLEARQ(
    `Tmp_Descripcion`   varchar(500),
    `Tmp_Tipo`          char(1),
    `Tmp_Estilo`        char(1)
);


select SucursalID into Var_SucursalCaja
		from CAJASVENTANILLA
		where CajaID        =   Par_CajaID;

insert TMPDETALLEARQ
	select concat('TIRA AUDITORA DEL DIA:  ',Par_Fecha) as Movimiento, Var_Vacio, Var_Vacio;
	insert TMPDETALLEARQ values(
		Var_Vacio, Var_Vacio, Var_Vacio);

	insert TMPDETALLEARQ
		select concat('TIPO OPERACION:  ',CT.Descripcion) as Movimiento, Var_Vacio, Var_Vacio
			from CAJATIPOSOPERA CT
			where Numero = Par_TipoOperacion limit 1;

 case Par_TipoOperacion

when Ope_EntEfecCta   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_ApSegVida    then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_EntSegVida   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_EntCApCred   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_ReTransCaja  then Set Var_Descripcion := concat('Referencia',LPAD('Hora',61, ' '),LPAD('Monto Total', 34, ' '));
when Ope_EnTranCaja   then Set Var_Descripcion := concat('Referencia',LPAD('Hora',61, ' '),LPAD('Monto Total', 34, ' '));
when Ope_RevEntDCred  then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_RevEntSegV   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_RevEntCCta   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_RevAbonoCta  then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_RevSegVida   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_EntGarLiAd   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_RevGarLiq    then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_DevGarLiq    then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_AjustesSob   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_EntPagoServ  then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_EntCInvCred  then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_EntComTAire  then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_EntPagoCre   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_EntGarLiq    then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_EntChqSBC    then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_DesemCred    then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_RetEfectivo  then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_CargTranfCta then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_EntEfecFalt  then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_EntEfectCam  then Set Var_Descripcion := concat('Referencia',LPAD('Hora',61, ' '),LPAD('Monto Total', 34, ' '));
when Ope_EntTransCta  then Set Var_Descripcion := concat('Referencia',LPAD('Hora',61, ' '),LPAD('Monto Total', 34, ' '));

when Ope_SalTransCta  then Set Var_Descripcion := concat('Referencia',LPAD('Hora',61, ' '),LPAD('Monto Total', 34, ' '));
when Ope_TranCajas    then Set Var_Descripcion := concat('Referencia',LPAD('Hora',61, ' '),LPAD('Monto Total', 34, ' '));
when Ope_DeGarLqAd    then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_RevCobroSVi  then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_RevAbCta     then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_RevSalGarLiq then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_RevCargoCta  then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_RevApSegVida then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_SalRecTrCaja then Set Var_Descripcion := concat('Referencia',LPAD('Hora',61, ' '),LPAD('Monto Total', 34, ' '));
when Ope_CobSegVida   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_DepGarLiq    then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_PagCApCred   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_PagoComInv   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_PagoServ     then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_SalEfecCam   then Set Var_Descripcion := concat('Referencia',LPAD('Hora',61, ' '),LPAD('Monto Total', 34, ' '));
when Ope_PagCoTAire   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_PagoCred     then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_DepCtaSBC    then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_SalDesCred   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_SalCargCta   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_AbonoCtaTra  then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_AjustFaltant then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_SalSobrante  then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_SalGarLiq    then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_DepCta       then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when SalApCobRiesgo   then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
when Ope_RevSalDesCrd then Set Var_Descripcion := concat('Referencia',LPAD('Nombre',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
else Set Var_Descripcion := concat('Referencia',LPAD(' ',35, ' '),LPAD('Hora',25, ' '),LPAD('Monto Total', 35, ' '));
end case ;

  insert TMPDETALLEARQ values(
		Var_Descripcion, Var_Vacio, Var_Vacio);
set Var_MontoTotal := Entero_Cero;


case
	when Par_TipoOperacion=Ope_EntEfecCta||Par_TipoOperacion=Ope_RevEntCCta||Par_TipoOperacion=Ope_RevAbonoCta||Par_TipoOperacion=Ope_RetEfectivo||
		Par_TipoOperacion=Ope_RevAbCta||Par_TipoOperacion=Ope_RevCargoCta||Par_TipoOperacion=Ope_SalCargCta||Par_TipoOperacion=Ope_DepCta then

		OPEN CURSORDETALLEMOVS;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP

			FETCH CURSORDETALLEMOVS into
				Var_Monto, Var_Movimiento, Var_Referencia,Var_Hora,Var_NombreCliente;
				set Var_Descripcion  := Var_Vacio;
				set Var_Descripcion := concat(Var_Descripcion,  RPAD(Var_Referencia, 16, ' '));
			 	set Var_Descripcion := concat(Var_Descripcion,  RPAD(Var_NombreCliente, 50, ' '));
				set Var_Descripcion := concat(Var_Descripcion, LPAD(Var_Hora,5,' '));
				set Var_Descripcion := concat(Var_Descripcion,  LPAD(format(Var_Monto, 2), 34, ' '));

				Set Var_MontoTotal := Var_MontoTotal + Var_Monto;
				insert TMPDETALLEARQ values(
					Var_Descripcion, Var_Vacio, Var_Vacio);
			End LOOP;
		END;

		CLOSE CURSORDETALLEMOVS;

			set Var_Descripcion  := RPAD(' ', 90, ' ');
			set Var_Descripcion  := concat(Var_Descripcion,  LPAD(' ', 20, ' '));

	when  Par_TipoOperacion =Ope_ApSegVida ||Par_TipoOperacion =Ope_EntSegVida ||Par_TipoOperacion =Ope_RevEntDCred  ||Par_TipoOperacion =Ope_RevEntSegV   ||
		  Par_TipoOperacion =Ope_RevSegVida||Par_TipoOperacion =Ope_EntGarLiAd ||Par_TipoOperacion =Ope_RevGarLiq    ||Par_TipoOperacion =Ope_DevGarLiq    ||
	      Par_TipoOperacion =Ope_EntCApCred||Par_TipoOperacion =Ope_EntPagoCre ||Par_TipoOperacion =Ope_EntGarLiq    ||Par_TipoOperacion =Ope_DesemCred    ||
          Par_TipoOperacion =Ope_DeGarLqAd ||Par_TipoOperacion =Ope_RevCobroSVi||Par_TipoOperacion =Ope_RevSalGarLiq ||Par_TipoOperacion =Ope_RevApSegVida ||
		  Par_TipoOperacion =Ope_CobSegVida||Par_TipoOperacion =Ope_DepGarLiq  ||Par_TipoOperacion =Ope_PagCApCred   ||Par_TipoOperacion =Ope_PagoCred     ||
		  Par_TipoOperacion =Ope_SalDesCred||Par_TipoOperacion =Ope_SalGarLiq  ||Par_TipoOperacion =Ope_RevSalDesCrd  then
		OPEN CURSORDETALLEM;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP

			FETCH CURSORDETALLEM into
				Var_Monto, Var_Movimiento, Var_Referencia,Var_Hora,Var_NombreCliente;
				set Var_Descripcion  := Var_Vacio;
				set Var_Descripcion := concat(Var_Descripcion,  RPAD(Var_Referencia, 16, ' '));
				set Var_Descripcion := concat(Var_Descripcion,  RPAD(Var_NombreCliente, 50, ' '));
				set Var_Descripcion := concat(Var_Descripcion, LPAD(Var_Hora,5,' '));
				set Var_Descripcion := concat(Var_Descripcion,  LPAD(format(Var_Monto, 2), 34, ' '));

				Set Var_MontoTotal := Var_MontoTotal + Var_Monto;
				insert TMPDETALLEARQ values(
					Var_Descripcion, Var_Vacio, Var_Vacio);

			End LOOP;
		END;

		CLOSE CURSORDETALLEM;
			set Var_Descripcion  := RPAD(' ', 90, ' ');
			set Var_Descripcion  := concat(Var_Descripcion,  LPAD(' ', 20, ' '));
	else
		OPEN CURSORDETALLEMOVSTRANS;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP

				FETCH CURSORDETALLEMOVSTRANS into
					Var_Monto, Var_Movimiento, Var_Referencia,Var_Hora;
					set Var_Descripcion  := Var_Vacio;
					set Var_Descripcion := concat(Var_Descripcion,  RPAD(Var_Referencia, 16, ' '));
					set Var_Descripcion := concat(Var_Descripcion, LPAD(Var_Hora,55,' '));
					set Var_Descripcion := concat(Var_Descripcion,  LPAD(format(Var_Monto, 2), 34, ' '));

					Set Var_MontoTotal := Var_MontoTotal + Var_Monto;
					insert TMPDETALLEARQ values(
						Var_Descripcion, Var_Vacio, Var_Vacio);


				End LOOP;
			END;

			CLOSE CURSORDETALLEMOVSTRANS;
				set Var_Descripcion  := RPAD(' ', 90, ' ');
				set Var_Descripcion  := concat(Var_Descripcion,  LPAD(' ', 20, ' '));
				insert TMPDETALLEARQ values(
					Var_Descripcion, Var_Vacio, Var_Vacio);
end case ;

	set Var_Descripcion  := RPAD('TOTAL ', 70, ' ');
	set Var_Descripcion := concat(Var_Descripcion, LPAD('$',17,' '));
	set Var_Descripcion  := concat(Var_Descripcion,  LPAD(format(Var_MontoTotal, 2), 18, ' '));
	insert TMPDETALLEARQ values(
		Var_Descripcion, Var_Vacio, Var_Vacio  );

	select  Tmp_Descripcion, Tmp_Tipo, Tmp_Estilo
		from TMPDETALLEARQ;

	drop table TMPDETALLEARQ;

END TerminaStore$$