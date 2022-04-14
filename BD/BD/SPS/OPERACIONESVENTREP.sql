-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPERACIONESVENTREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPERACIONESVENTREP`;DELIMITER $$

CREATE PROCEDURE `OPERACIONESVENTREP`(
/* SP DE REPORTE TIPO CONTABLE PARA OPERACIONES DE VENTANILLA */
	Par_FechaIni    	DATE,
	Par_FechaFin    	DATE,
	Par_Sucursal    	INT(11),
	Par_Caja        	INT(11),
	Par_Naturaleza  	INT(11),

	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables.
DECLARE Var_Sentencia 		VARCHAR(15000);
DECLARE Var_FecActual 		DATE;
DECLARE Var_NumTransaccion	BIGINT;

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE Ope_EntEfecCta  	INT;
DECLARE Ope_ApSegVida   	INT;
DECLARE Ope_EntSegVida  	INT;
DECLARE Ope_ReTransCaja 	INT;
DECLARE Ope_EnTranCaja  	INT;
DECLARE Ope_RevEntDCred 	INT;
DECLARE Ope_RevEntSegV  	INT;
DECLARE Ope_RevEntCCta  	INT;
DECLARE Ope_RevAbonoCta 	INT;
DECLARE Ope_RevSegVida  	INT;
DECLARE Ope_EntGarLiAd  	INT;
DECLARE Ope_RevGarLiq   	INT;
DECLARE Ope_EntEfDAS   		INT;
DECLARE Ope_SalEfDAS		INT;


DECLARE Ope_DevGarLiq   	INT;
DECLARE Ope_AjustesSob  	INT;
DECLARE Ope_EntPagoServ 	INT;
DECLARE Ope_EntCInvCred 	INT;
DECLARE Ope_EntComTAire 	INT;
DECLARE Ope_EntCApCred  	INT;
DECLARE Ope_EntPagoCre  	INT;
DECLARE Ope_EntGarLiq   	INT;
DECLARE Ope_EntChqSBC   	INT;
DECLARE Ope_DesemCred   	INT;
DECLARE Ope_RetEfectivo 	INT;
DECLARE Ope_CargTranfCta 	INT;
DECLARE Ope_EntEfecFalt  	INT;
DECLARE Ope_EntEfectCam  	INT;

DECLARE Ope_TranCajas   	INT;
DECLARE Ope_DeGarLqAd   	INT;
DECLARE Ope_RevCobroSVi 	INT;
DECLARE Ope_RevAbCta    	INT;
DECLARE Ope_CarCuenPSL 		INT;		-- Operacion de cargo a Cuenta de Ahorro por pago de Servicios en Linea. Cardinal Sistemas Inteligentes

DECLARE Ope_RevSalGarLiq 	INT;
DECLARE Ope_RevCargoCta 	INT;
DECLARE Ope_RevApSegVida 	INT;
DECLARE Ope_SalRecTrCaja 	INT;
DECLARE Ope_CobSegVida   	INT;
DECLARE Ope_DepGarLiq    	INT;
DECLARE Ope_PagCApCred   	INT;
DECLARE Ope_PagoComInv   	INT;
DECLARE Ope_PagoServ     	INT;
DECLARE Ope_SalEfecCam   	INT;
DECLARE Ope_PagCoTAire   	INT;
DECLARE Ope_PagoCred     	INT;
DECLARE Ope_DepCtaSBC    	INT;
DECLARE Ope_SalDesCred   	INT;
DECLARE Ope_SalCargCta   	INT;
DECLARE Ope_AbonoCtaTra  	INT;
DECLARE Ope_AjustFaltant 	INT;
DECLARE Ope_SalSobrante  	INT;
DECLARE Ope_SalGarLiq    	INT;
DECLARE Ope_SalEfecBanc  	INT;
DECLARE Ope_DepCta       	INT;
DECLARE SalApCobRiesgo   	INT;
DECLARE Ope_EntTransCta  	INT;
DECLARE Ope_SalTransCta  	INT;
DECLARE Ope_RevSalDesCrd 	INT;

DECLARE Ope_EntEfSegV    	INT;
DECLARE Ope_CobSegV      	INT;
DECLARE Ope_PagoRem      	INT;
DECLARE Ope_SalEfRem     	INT;
DECLARE Ope_SalPagRemAbCta  INT;
DECLARE Ope_EnvEfBan     	INT;
DECLARE Ope_EntEnvEfBan  	INT;





DECLARE EntAplicaSegAyuda 		INT;
DECLARE SalEfecAplicaSegAyuda	INT;
DECLARE EntPagoOportunidades	INT;
DECLARE SalEfecOportunidades	INT;



DECLARE 	EntPrepagoCredito				INT;
DECLARE 	SalPrepagoCrédito				INT;

DECLARE 	SalPagoRemesaAbonoCta			INT;
DECLARE 	SalPagoOportunAbonoCta			INT;
DECLARE 	EntAplicaChequeSBC				INT;
DECLARE 	SalAplicaChequeSBC				INT;


DECLARE 	SalRevGarLiqCargoCta			INT;
DECLARE 	EntTransfATM					INT;
DECLARE 	SalEfecTransATM					INT;
DECLARE 	EntEfecRecCartCastigada			INT;
DECLARE 	SalRecCarteraCast				INT;
DECLARE 	EntPagoServifun					INT;
DECLARE 	SalEfecServifun					INT;
DECLARE 	EntApoyoEscolar					INT;
DECLARE 	SalEfecApoyoEscolar				INT;
DECLARE 	EntEfecAjusteSobrante			INT;
DECLARE 	SalAjusteSobrante				INT;
DECLARE 	EntAjusteFaltante				INT;
DECLARE 	SalPorFaltante					INT;
DECLARE 	EntChequeEnFirme				INT;
DECLARE 	SalCobroChequeFirme				INT;
DECLARE 	SalChequeRetiroCta				INT;
DECLARE 	SalChequeDevGL					INT;
DECLARE 	SalChequeDesembolso				INT;
DECLARE 	SalChequeDevAportaSoc			INT;
DECLARE 	SalChequeAplicaSegAyuda			INT;
DECLARE 	SalChequeRemesas				INT;
DECLARE 	SalChequeOportun				INT;
DECLARE 	SalChequeServifun				INT;
DECLARE 	SalChequeApoyoEsc				INT;
DECLARE 	SalChequeAplicaCob				INT;
DECLARE 	EntradaAnualidaTD				INT;
DECLARE 	SalAnualidadTD					INT;
DECLARE 	CancelacionSocio				INT;
DECLARE 	SalEfeCanSocio					INT;
DECLARE 	SalChequeCanSocio				INT;
DECLARE 	EntDevGastos					INT;
DECLARE 	SalDevGastos					INT;
DECLARE 	GastosComprobar					INT;
DECLARE 	SalEfeGastosComp				INT;
DECLARE 	SalChequeGastosComp				INT;
DECLARE 	HaberesExmenor					INT;
DECLARE 	SalChequeExmenor				INT;
DECLARE 	SalEfecExmenor					INT;
DECLARE 	EntPagServicios					INT;
DECLARE     SalPagServicios					INT;
DECLARE 	EntAportacionSocio				INT;
DECLARE 	SalAportacionSocio				INT;
-- Asignacion de Constantes
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET Ope_EntEfecCta  := 1;     -- Tipo Operacion : Entrada Efectivo de Cuenta
SET Ope_ApSegVida   := 17;    -- Tipo Operacion : Aplica Seguro de Vida
SET Ope_EntSegVida  := 18;    -- Tipo Operacion : Entrada Efectivo Cobro Seguro de Vida
SET Ope_ReTransCaja := 19;    -- Tipo Operacion : Recepcion de transferencia entre Cajas
SET Ope_EnTranCaja  := 20;    -- Tipo Operacion : Entrada de Efectivo en transferencia entre cajas
SET Ope_RevEntDCred := 55;    -- Tipo Operacion : Reversa Entrada de Desembolso de Credito
SET Ope_RevEntSegV  := 53;    -- Tipo Operacion : Reversa Entrada Efectivo Aplicacion de Seguro de Vida
SET Ope_RevEntCCta  := 51;    -- Tipo Operacion : Reversa Entrada de Efectivo Cargo Cuenta
SET Ope_RevAbonoCta := 47;    -- Tipo Operacion : Reversa de Abono Cuenta
SET Ope_RevSegVida  := 45;    -- Tipo Operacion : Reversa Entrada de efectivo Cobro de Seguro de Vida
SET Ope_EntGarLiAd  := 43;    -- Tipo Operacion : Entrada de Efectivo Garantia Liquida Adicional
SET Ope_RevGarLiq   := 49;    -- Tipo Operacion : Reversa de Garantia Liquida
SET Ope_EntTransCta := 62;    -- Tipo Operacion : Entrada Transferencia entre cuentas
SET Ope_EntEfDAS    := 66;    -- Tipo Operacion : Entrada de Efectivo Por Devolucion de Aportacion Social
SET Ope_SalEfDAS	:= 67;	  -- Tipo Operacion : Salida de Efectivo por Devolucion de Aportacion Social
SET Ope_DevGarLiq   := 15;    -- Tipo Operacion : Devolucion de Garantia Liquida
SET Ope_AjustesSob  := 14;    -- Tipo Operacion : Ajustes Sobrantes
SET Ope_EntPagoServ := 5 ;    -- Tipo Operacion : Entrada de Efectivo Pago de Servicio
SET Ope_EntCInvCred := 4 ;    -- Tipo Operacion : Entrada de Efectivo Comision por Investigacion de Credito
SET Ope_EntComTAire := 7 ;    -- Tipo Operacion : Entrada de Efectivo por Compra de Tiempo aire
SET Ope_EntCApCred  := 3 ;    -- Tipo Operacion : Entrada de Efectivo por comision de Apertura de Credito
SET Ope_EntPagoCre  := 8 ;    -- Tipo Operacion : Entrada de Efectivo Pago Credito
SET Ope_EntGarLiq   := 2 ;    -- Tipo Operacion : Entrada Garantia liquida
SET Ope_EntChqSBC   := 9 ;    -- Tipo Operacion : Entrada Cheque SBC
SET Ope_DesemCred   := 10;    -- Tipo Operacion : Desmbolso de Credito
SET Ope_RetEfectivo := 11;    -- Tipo Operacion : Retiro de Efectivo (Cargo Cuenta)
SET Ope_CargTranfCta:= 12;    -- Tipo Operacion : Cargo Transferencia de Cuenta
SET Ope_EntEfecFalt := 13;    -- Tipo Operacion : Entrada de Efectivo Faltante
SET Ope_EntEfectCam :=  6;    -- Tipo Operacion : Entrada Efectivo Cambio
SET Ope_TranCajas   := 40;    -- Tipo Operacion : Transferencia entre cajas
SET Ope_DeGarLqAd   := 44;    -- Tipo Operacion : Deposito de Garantia Liquida Adicional
SET Ope_RevCobroSVi := 46;    -- Tipo Operacion : Reversa Salida Efectivo Cobro Seguro de Vida
SET Ope_RevAbCta    := 48;    -- Tipo Operacion : Reversa SalidaEfectivo Abono Cuenta
SET Ope_CarCuenPSL  := 131;	  -- Operacion de cargo a Cuenta de Ahorro por pago de Servicios en Linea. Cardinal Sistemas Inteligentes

SET Ope_RevSalGarLiq:= 50;    -- Tipo Operacion : ReversaSalida de Efectivo Garantia liquida
SET Ope_RevCargoCta := 52;    -- Tipo Operacion : Reversa Salida Efectivo Cargo Cuenta
SET Ope_RevApSegVida:= 54;    -- Tipo Operacion : Reversa Salida Efectivo Aplicacion de Seguro de Vida
SET Ope_SalRecTrCaja:= 39;    -- Tipo Operacion : Salida recepcion transferencias entre cajas
SET Ope_CobSegVida  := 38;    -- Tipo Operacion : Cobro de seguro de vida
SET Ope_DepGarLiq   := 22;    -- Tipo Operacion : Deposito Garantia Liquida
SET Ope_PagCApCred  := 23;    -- Tipo Operacion : Pago Comision Por Apertura de Credito
SET Ope_PagoComInv  := 24;    -- Tipo Operacion : Pago Comision investigacion
SET Ope_PagoServ    := 25;    -- Tipo Operacion : Pago Servicio
SET Ope_SalEfecCam  := 26;    -- Tipo Operacion : Salida Efectivo Por Cambio
SET Ope_PagCoTAire  := 27;    -- Tipo Operacion : Compra Tiempo Aire
SET Ope_PagoCred    := 28;    -- Tipo Operacion : Pago CreditoPago
SET Ope_DepCtaSBC   := 29;    -- Tipo Operacion : Deposito cuenta sbc
SET Ope_SalDesCred  := 30;    -- Tipo Operacion : Salida Efectivo Desembolso Credito
SET Ope_SalCargCta  := 31;    -- Tipo Operacion : Salida Efectivo Cargo Cuenta
SET Ope_AbonoCtaTra := 32;    -- Tipo Operacion :  Cuenta Transfer
SET Ope_AjustFaltant:= 33;    -- Tipo Operacion : Ajuste Por FaltanteAbono
SET Ope_SalSobrante := 34;    -- Tipo Operacion : Salida Efectivo Sobrante
SET Ope_SalGarLiq   := 35;    -- Tipo Operacion : Salida Recepcion Garantia liquidaSalida
SET Ope_SalEfecBanc := 36;    -- Tipo Operacion : Salida Recepcion Garantia liquida
SET Ope_DepCta      := 21;    -- Tipo Operacion : Deposito Cuenta
SET SalApCobRiesgo  := 37;    -- Salida de Efectivo Por Aplicacion Cobertura de Riesgo
SET Ope_SalTransCta := 63;    -- Tipo Operacion : Salida Transferencia entre cuentas
SET Ope_RevSalDesCrd := 56;   -- Tipo Operacion :
SET Ope_EntEfSegV    :=68;    -- Tipo Operacion: Entrada efectivo seguro de vida
SET Ope_CobSegV      :=69;    -- Tipo Operacion : Cobro seguro de vida
SET Ope_PagoRem      :=72;    -- Tipo Operacion : Pago Remesa
SET Ope_SalEfRem     :=73;    -- Tipo Operacion : Salida Efectivo Remesa
SET Ope_SalPagRemAbCta  :=82;   --  Salida pago remesa abono a cuenta
SET Ope_EnvEfBan     :=42;      -- Envio Efectivo Banco
SET Ope_EntEnvEfBan  :=41;     -- Entrada Envio Efectivo Banco



SET EntAplicaSegAyuda 		:=70;
SET SalEfecAplicaSegAyuda	:=71;
SET EntPagoOportunidades	:=74;
SET SalEfecOportunidades	:=75;
SET EntAplicaChequeSBC		:=76;
SET SalAplicaChequeSBC		:=77;

SET EntPrepagoCredito			:=78;
SET SalPrepagoCrédito			:=79;

SET SalPagoRemesaAbonoCta		:=82;
SET SalPagoOportunAbonoCta		:=83;  -- Tipo Operacion :  Salida por pago de Oportunidades CArgo a Cuenta
SET SalRevGarLiqCargoCta		:=84;
SET EntTransfATM				:=85;
SET SalEfecTransATM				:=86;
SET EntEfecRecCartCastigada		:=87;
SET SalRecCarteraCast			:=88;
SET EntPagoServifun				:=91;
SET SalEfecServifun				:=92;
SET EntApoyoEscolar				:=95;
SET SalEfecApoyoEscolar			:=96;
SET EntEfecAjusteSobrante		:=97;
SET SalAjusteSobrante			:=98;
SET EntAjusteFaltante			:=99;
SET SalPorFaltante				:=100;
SET EntChequeEnFirme			:=101;
SET SalCobroChequeFirme			:=103;	-- Salida de Efectivo por cobro de Cheque en Firme
SET SalChequeRetiroCta			:=104; -- Salida de Cheque por Retiro de Efectivo en cuenta
SET SalChequeDevGL				:=105; -- Salida de cheque por devolucion de GL
SET SalChequeDesembolso			:=106; -- Salida de cheque por desembolsos
SET SalChequeDevAportaSoc		:=107;	-- Salida de cheque por aportacion Social
SET SalChequeAplicaSegAyuda		:=108;	-- Salida de Cheque por aplizacion del Seguro de Ayuda
SET SalChequeRemesas			:=109;	-- Salida de Cheque por Pago de Remesas
SET SalChequeOportun			:=110; 	-- Salida de Cheque por pago de Oportunides
SET SalChequeServifun			:=111;	-- Salida de Cheque por pago de Remesas
SET SalChequeApoyoEsc			:=112; 	-- Salida de Cheque por AplicaciÃ³n de Apoyo Escolar
SET SalChequeAplicaCob			:=113; 	-- Salida de Cheque por aplicacion de cobertura de riesgo
SET EntradaAnualidaTD			:=114;
SET SalAnualidadTD				:=115;
SET CancelacionSocio			:=116;
SET SalEfeCanSocio				:=117;
SET SalChequeCanSocio			:=118;
SET EntDevGastos				:=119;
SET SalDevGastos				:=122;
SET GastosComprobar				:=123;
SET SalEfeGastosComp			:=120;
SET SalChequeGastosComp			:=121;
SET HaberesExmenor				:=125; -- Tipo Operacion: Entrada pago de haberes Exmenor
SET SalChequeExmenor			:=126; -- Tipo Operacion: Salida Cheque de haberes Exmenor
SET SalEfecExmenor				:=124; -- Tipo Operacion: Salida Efectivo de haberes Exmenor
SET EntPagServicios				:=80;  -- Tipo Operacion: Entrada Efectivo de Pago de Servicios
SET SalPagServicios				:=81;  -- Tipo Operacion: Salida Efectivo de Pago de Servicios
SET EntAportacionSocio			:=64;
SET SalAportacionSocio			:=65;

CALL TRANSACCIONESPRO(Var_NumTransaccion);


DELETE FROM TMPDETCAJASMOV
	WHERE NumTransaccion = Var_NumTransaccion;

DELETE FROM TMPOPVENREP
	WHERE NumTransaccion = Var_NumTransaccion;

SELECT FechaSistema INTO Var_FecActual
	FROM PARAMETROSSIS;

--  --------- UNIONES DE CAJASMOVS E HIS-CAJASMOVS

IF (Var_FecActual BETWEEN Par_FechaIni AND Par_FechaFin ) THEN

	SET Var_Sentencia := '
		INSERT INTO TMPDETCAJASMOV (
			Transaccion,	Fecha,		NomCajero,	Sucursal,		Efectivo,
			MontoSBC,		NumCuenta,	Referencia,	TipoOperacion,	NaturalezaOp,
			CajaID,	NumTransaccion)';

	SET Var_Sentencia:= CONCAT(Var_Sentencia,'(select  CM.Transaccion, CM.Fecha,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' convert(concat(CM.CajaID,"-",usu.NombreCompleto),char)as NomCajero,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' convert(concat(CM.SucursalID,"-",suc.NombreSucurs),char)as Sucursal,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' CM.MontoEnFirme as Efectivo, CM.MontoSBC,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' CM.Instrumento as NumCuenta,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' CM.Referencia,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' CM.TipoOperacion,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' Tip.Naturaleza, CM.CajaID, ', Var_NumTransaccion, ' ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'from  CAJASMOVS CM ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'inner join CAJASVENTANILLA CV on CM.SucursalID = CV.SucursalID and CM.CajaID = CV.CajaID ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'inner join USUARIOS usu on CV.UsuarioID = usu.UsuarioID ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'inner join SUCURSALES suc on CV.SucursalID = suc.SucursalID ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'inner join CAJATIPOSOPERA Tip on CM.TipoOperacion = Tip.Numero ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia, ' where CM.Fecha BETWEEN "',Par_FechaIni,'" and "',Par_FechaFin,'"');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,  ' and CM.SucursalID =',Par_Sucursal,' ');

	IF(Par_Caja != Entero_Cero)THEN
		SET Var_Sentencia:= CONCAT(Var_Sentencia, ' and CM.CajaID = ',Par_Caja,'', ");");
	ELSE
		SET Var_Sentencia:= CONCAT(Var_Sentencia, " );");
	END IF;

	SET @Sentencia1	= (Var_Sentencia);

		PREPARE OPERACIONESVENT1 FROM @Sentencia1;
		EXECUTE OPERACIONESVENT1;
		DEALLOCATE PREPARE OPERACIONESVENT1;

END IF;

-- Verificamos si tenemos que ir al historico
IF (Par_FechaIni < Var_FecActual OR Par_FechaFin < Var_FecActual ) THEN

	SET Var_Sentencia := '
		INSERT INTO TMPDETCAJASMOV (
			Transaccion,	Fecha,		NomCajero,	Sucursal,		Efectivo,
			MontoSBC,		NumCuenta,	Referencia,	TipoOperacion,	NaturalezaOp,
			CajaID,	NumTransaccion	)';

	SET Var_Sentencia:= CONCAT(Var_Sentencia,'(select  CM.Transaccion, CM.Fecha,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' convert(concat(CM.CajaID,"-",usu.NombreCompleto),char)as NomCajero,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' convert(concat(CM.SucursalID,"-",suc.NombreSucurs),char)as Sucursal,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' CM.MontoEnFirme as Efectivo, CM.MontoSBC,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' CM.Instrumento as NumCuenta,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' CM.Referencia,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' CM.TipoOperacion,');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,' Tip.Naturaleza, CM.CajaID, ', Var_NumTransaccion, ' ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'from  `HIS-CAJASMOVS` CM ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'inner join CAJASVENTANILLA CV on CM.SucursalID = CV.SucursalID and CM.CajaID = CV.CajaID ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'inner join USUARIOS usu on CV.UsuarioID = usu.UsuarioID ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'inner join SUCURSALES suc on CV.SucursalID = suc.SucursalID ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,'inner join CAJATIPOSOPERA Tip on CM.TipoOperacion = Tip.Numero ');
	SET Var_Sentencia:= CONCAT(Var_Sentencia, ' where CM.Fecha BETWEEN "',Par_FechaIni,'" and "',Par_FechaFin,'"');
	SET Var_Sentencia:= CONCAT(Var_Sentencia,  ' and CM.SucursalID =',Par_Sucursal,' ');

	IF(Par_Caja != Entero_Cero)THEN
		SET Var_Sentencia:= CONCAT(Var_Sentencia, ' and CM.CajaID = ',Par_Caja,'');
	END IF;

	IF(Par_Naturaleza != Entero_Cero)THEN
		SET Var_Sentencia:= CONCAT(Var_Sentencia, ' and Tip.Naturaleza = ',Par_Naturaleza,' ');
	END IF;

	SET Var_Sentencia:= CONCAT(Var_Sentencia, " );");

	SET @Sentencia1	= (Var_Sentencia);

		PREPARE OPERACIONESVENT1 FROM @Sentencia1;
		EXECUTE OPERACIONESVENT1;
		DEALLOCATE PREPARE OPERACIONESVENT1;

END IF;
-- -------------------- UNIONES PARA SABER A QUE CORRESPONDE LA REFERENCIA SEGUN LA OPERACION --------
SET Var_Sentencia := 'INSERT INTO TMPOPVENREP(
	Transaccion,	Fecha,			NomCajero,	Sucursal,		Efectivo,
	MontoSBC,		NumCuenta,		Referencia,	TipoOperacion,	ClienteID,
	NombreCompleto,	ReferenciaRep,	GrupoCred,	DescripcionOp,	NaturalezaOp,
	CajaID, PolizaID, NombreGrupo,	NumTransaccion,Orden	)';

-- REFERENCIA = CUENTA
SET Var_Sentencia :=CONCAT(Var_Sentencia,'(select TC.Transaccion,     TC.Fecha,       TC.NomCajero, TC.Sucursal,         TC.Efectivo,');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'TC.Montosbc,        TC.NumCuenta,   TC.Referencia,    TC.TipoOperacion,    cli.ClienteID,');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'cli.NombreCompleto, convert(concat(TC. Referencia,"-",CT.DescCorta),char) as ReferenciaRep,',Entero_Cero,',CT.Descripcion,TC.NaturalezaOp');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'  ,TC.CajaID,0," ",', Var_NumTransaccion, ',CT.Orden ');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'  from TMPDETCAJASMOV TC inner join CAJATIPOSOPERA CT on TC.TipoOperacion = CT.Numero');
SET Var_Sentencia:= CONCAT(Var_Sentencia, ' inner join CUENTASAHO cu  on cu.CuentaAhoID = TC.NumCuenta ');
SET Var_Sentencia:= CONCAT(Var_Sentencia, ' inner join CLIENTES cli on  cli.ClienteID = cu.ClienteID');
SET Var_Sentencia:= CONCAT(Var_Sentencia, '  where TC.NumTransaccion = ', Var_NumTransaccion ,' and (TC.TipoOperacion= ',Ope_EntEfecCta,'||TC.TipoOperacion=',Ope_RevEntCCta,'||TC.TipoOperacion=',Ope_RevAbonoCta,'||TC.TipoOperacion=',Ope_RetEfectivo,'||');
SET Var_Sentencia:= CONCAT(Var_Sentencia, ' TC.TipoOperacion =',EntPrepagoCredito,'|| TC.TipoOperacion =',SalPrepagoCrédito,  '|| TC.TipoOperacion= ',Ope_SalTransCta,' || TC.TipoOperacion=',Ope_EntTransCta ,'|| ');
-- Se agrega operacion de cargo a Cuenta de Ahorro por pago de Servicios en Linea.
SET Var_Sentencia:= CONCAT(Var_Sentencia, ' TC.TipoOperacion=',Ope_RevAbCta,'||TC.TipoOperacion=',Ope_RevCargoCta,'||TC.TipoOperacion=',Ope_SalCargCta,'||TC.TipoOperacion=',Ope_CarCuenPSL,'||TC.TipoOperacion=',Ope_DepCta,') ');



SET Var_Sentencia:= CONCAT(Var_Sentencia,' ); ');

SET @Sentencia	= (Var_Sentencia);

PREPARE OPERACIONESVENT FROM @Sentencia;
EXECUTE OPERACIONESVENT;
DEALLOCATE PREPARE OPERACIONESVENT;


-- REFERENCIA= CREDITO..
SET Var_Sentencia := 'INSERT INTO TMPOPVENREP(
	Transaccion,	Fecha,			NomCajero,	Sucursal,		Efectivo,
	MontoSBC,		NumCuenta,		Referencia,	TipoOperacion,	ClienteID,
	NombreCompleto,	ReferenciaRep,	GrupoCred,	DescripcionOp,	NaturalezaOp,
	CajaID, PolizaID, NombreGrupo,	NumTransaccion,Orden	)';

SET Var_Sentencia := CONCAT(Var_Sentencia,'(select  TC.Transaccion,     TC.Fecha,       TC.NomCajero, TC.Sucursal,         TC.Efectivo,');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'TC.Montosbc,        TC.NumCuenta,   TC.Referencia,TC.TipoOperacion,    cli.ClienteID, ');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'cli.NombreCompleto, convert(concat(TC. Referencia,"-",CT.DescCorta),char) as ReferenciaRep, cre.GrupoID,CT.Descripcion,TC.NaturalezaOp');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'  ,TC.CajaID,0,ifnull(Gru.NombreGrupo, ""),', Var_NumTransaccion, ',CT.Orden ');
SET Var_Sentencia:= CONCAT(Var_Sentencia,' from TMPDETCAJASMOV TC, CAJATIPOSOPERA CT, CLIENTES cli, CREDITOS cre');
SET Var_Sentencia:= CONCAT(Var_Sentencia, ' left outer join GRUPOSCREDITO Gru on ifnull(cre.GrupoID,0) = Gru.GrupoID ');

SET Var_Sentencia:= CONCAT(Var_Sentencia, ' where TC.NumTransaccion = ', Var_NumTransaccion ,' and (TC.TipoOperacion =',Ope_ApSegVida,' ||TC.TipoOperacion =',SalApCobRiesgo,' ||TC.TipoOperacion =',Ope_EntSegVida,' ||TC.TipoOperacion =',Ope_RevEntDCred,' ||TC.TipoOperacion =',Ope_RevEntSegV,' ||');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion =',Ope_RevSegVida,'||TC.TipoOperacion =',Ope_EntGarLiAd, '||TC.TipoOperacion =',Ope_RevGarLiq,' ||TC.TipoOperacion =',Ope_DevGarLiq , '|| ');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion =',Ope_EntCApCred,'||TC.TipoOperacion =',Ope_EntPagoCre, '||TC.TipoOperacion =',Ope_EntGarLiq,'||TC.TipoOperacion =',Ope_DesemCred,'    || ');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion =',Ope_DeGarLqAd ,'||TC.TipoOperacion =',Ope_RevCobroSVi,'||TC.TipoOperacion =',Ope_RevSalGarLiq,'||TC.TipoOperacion =',Ope_RevApSegVida,' || ');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion =',Ope_CobSegVida,'||TC.TipoOperacion =',Ope_DepGarLiq, '||TC.TipoOperacion =',Ope_PagCApCred ,'||TC.TipoOperacion =',Ope_PagoCred,'     || ');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion =',Ope_SalDesCred,'||TC.TipoOperacion =',Ope_SalGarLiq,  '||TC.TipoOperacion =',Ope_RevSalDesCrd,') ');

SET Var_Sentencia:= CONCAT(Var_Sentencia,' and TC.TipoOperacion = CT.Numero ');
SET Var_Sentencia:= CONCAT(Var_Sentencia,' and cre.CreditoID = TC.Referencia');
SET Var_Sentencia:= CONCAT(Var_Sentencia,' and cli.ClienteID = cre.ClienteID');

SET Var_Sentencia:= CONCAT(Var_Sentencia,' ); ');

SET @Sentencia	= (Var_Sentencia);

PREPARE OPERACIONESVENT FROM @Sentencia;
EXECUTE OPERACIONESVENT;
DEALLOCATE PREPARE OPERACIONESVENT;


-- REFERENCIA = CLIENTE
SET Var_Sentencia := 'INSERT INTO TMPOPVENREP(
	Transaccion,	Fecha,			NomCajero,	Sucursal,		Efectivo,
	MontoSBC,		NumCuenta,		Referencia,	TipoOperacion,	ClienteID,
	NombreCompleto,	ReferenciaRep,	GrupoCred,	DescripcionOp,	NaturalezaOp,
	CajaID, PolizaID, NombreGrupo,	NumTransaccion,Orden	)';

SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select TC.Transaccion,     TC.Fecha,       TC.NomCajero, TC.Sucursal,         TC.Efectivo,');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'TC.MontoSBC,        TC.NumCuenta,   TC.Referencia,TC.TipoOperacion,    cli.ClienteID,');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'cli.NombreCompleto, convert(concat(TC. Referencia,"-",CT.DescCorta),char) as ReferenciaRep,',Entero_Cero,',CT.Descripcion,TC.NaturalezaOp');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'  ,TC.CajaID,0,"",', Var_NumTransaccion, ',CT.Orden ');
SET Var_Sentencia:= CONCAT(Var_Sentencia,' from TMPDETCAJASMOV TC inner join CAJATIPOSOPERA CT on TC.TipoOperacion = CT.Numero');
SET Var_Sentencia:= CONCAT(Var_Sentencia,' inner join CLIENTES cli on cli.ClienteID = TC.Referencia ');
SET Var_Sentencia:= CONCAT(Var_Sentencia, ' where TC.NumTransaccion = ', Var_NumTransaccion ,' and (TC.TipoOperacion=',Ope_EntEfSegV , ' || TC.TipoOperacion=',Ope_CobSegV,' ||');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion =',EntEfecRecCartCastigada,'|| TC.TipoOperacion =',SalRecCarteraCast,' )');




SET Var_Sentencia:= CONCAT(Var_Sentencia,' ); ');

SET @Sentencia	= (Var_Sentencia);

PREPARE OPERACIONESVENT FROM @Sentencia;
EXECUTE OPERACIONESVENT;
DEALLOCATE PREPARE OPERACIONESVENT;




-- INSTRUMENTO = CLIENTE
SET Var_Sentencia := 'INSERT INTO TMPOPVENREP(
	Transaccion,	Fecha,			NomCajero,	Sucursal,		Efectivo,
	MontoSBC,		NumCuenta,		Referencia,	TipoOperacion,	ClienteID,
	NombreCompleto,	ReferenciaRep,	GrupoCred,	DescripcionOp,	NaturalezaOp,
	CajaID, PolizaID, NombreGrupo,	NumTransaccion,Orden	)';

SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select TC.Transaccion,     TC.Fecha,       TC.NomCajero, TC.Sucursal,         TC.Efectivo,');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'TC.MontoSBC,        TC.NumCuenta,   TC.Referencia,TC.TipoOperacion,    cli.ClienteID,');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'cli.NombreCompleto, convert(concat(TC. Referencia,"-",CT.DescCorta),char) as ReferenciaRep,',Entero_Cero,',CT.Descripcion,TC.NaturalezaOp');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'  ,TC.CajaID,0,"",', Var_NumTransaccion, ',CT.Orden  ');
SET Var_Sentencia:= CONCAT(Var_Sentencia,' from TMPDETCAJASMOV TC inner join CAJATIPOSOPERA CT on TC.TipoOperacion = CT.Numero');
SET Var_Sentencia:= CONCAT(Var_Sentencia,' inner join CLIENTES cli on cli.ClienteID = TC.NumCuenta ');
SET Var_Sentencia:= CONCAT(Var_Sentencia, ' where TC.NumTransaccion = ', Var_NumTransaccion ,' and (TC.TipoOperacion=',SalChequeExmenor ,'|| TC.TipoOperacion=',SalEfecExmenor,' || TC.TipoOperacion=',HaberesExmenor,' ||');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion =',CancelacionSocio,'||TC.TipoOperacion =',SalEfeCanSocio,  '||TC.TipoOperacion =',SalChequeCanSocio,' || ');

SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion =',EntAplicaSegAyuda,'|| TC.TipoOperacion =',SalEfecAplicaSegAyuda,'|| TC.TipoOperacion =',SalChequeAplicaSegAyuda,' ) ');

SET Var_Sentencia:= CONCAT(Var_Sentencia,' ); ');


SET @Sentencia	= (Var_Sentencia);

PREPARE OPERACIONESVENT FROM @Sentencia;
EXECUTE OPERACIONESVENT;
DEALLOCATE PREPARE OPERACIONESVENT;

-- REFERENCIA = NOMBREVACIO
SET Var_Sentencia := 'INSERT INTO TMPOPVENREP(
	Transaccion,	Fecha,			NomCajero,	Sucursal,		Efectivo,
	MontoSBC,		NumCuenta,		Referencia,	TipoOperacion,	ClienteID,
	NombreCompleto,	ReferenciaRep,	GrupoCred,	DescripcionOp,	NaturalezaOp,
	CajaID, PolizaID, NombreGrupo,	NumTransaccion,Orden	)';

SET Var_Sentencia :=CONCAT(Var_Sentencia, '(select TC.Transaccion,     TC.Fecha,       TC.NomCajero, TC.Sucursal,         TC.Efectivo,');
SET Var_Sentencia:= CONCAT(Var_Sentencia,' TC.MontoSBC,        TC.NumCuenta,   TC.Referencia,TC.TipoOperacion,   ',Entero_Cero,',');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'"',Cadena_Vacia, '", convert(concat(TC. Referencia,"-",CT.DescCorta),char) as ReferenciaRep,',Entero_Cero,',CT.Descripcion,TC.NaturalezaOp');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'  ,TC.CajaID,0,"",', Var_NumTransaccion, ',CT.Orden ');
SET Var_Sentencia:= CONCAT(Var_Sentencia,' from TMPDETCAJASMOV TC inner join CAJATIPOSOPERA CT on TC.TipoOperacion = CT.Numero');
SET Var_Sentencia:= CONCAT(Var_Sentencia, ' where TC.NumTransaccion = ', Var_NumTransaccion ,' and(TC.TipoOperacion=',Ope_SalEfecCam ,'|| TC.TipoOperacion=',Ope_PagoRem ,'|| TC.TipoOperacion= ',Ope_SalEfRem,' || TC.TipoOperacion=',Ope_SalPagRemAbCta,' ||');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion=',Ope_ReTransCaja ,'||TC.TipoOperacion=', Ope_EnTranCaja,' || TC.TipoOperacion= ',Ope_EntPagoServ ,'|| TC.TipoOperacion=', Ope_TranCajas,' ||');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion=',Ope_EnvEfBan,' || TC.TipoOperacion=',Ope_EntEnvEfBan,' || TC.TipoOperacion=',Ope_SalEfecBanc,' || ');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion=',Ope_AjustesSob,' || TC.TipoOperacion=',Ope_EntCInvCred ,'|| TC.TipoOperacion=',Ope_EntComTAire ,'||');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion=',Ope_SalRecTrCaja ,'|| TC.TipoOperacion=',Ope_PagoServ,' || TC.TipoOperacion=',Ope_EntEfectCam,' || ');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.TipoOperacion=',Ope_PagCoTAire ,'|| TC.TipoOperacion=',Ope_SalSobrante,') ');

SET Var_Sentencia:= CONCAT(Var_Sentencia,' ); ');

SET @Sentencia	= (Var_Sentencia);

PREPARE OPERACIONESVENT FROM @Sentencia;
EXECUTE OPERACIONESVENT;
DEALLOCATE PREPARE OPERACIONESVENT;

--  Para obtener las operaciones que no se consideraron dentro de la lista
SET Var_Sentencia := 'INSERT INTO TMPOPVENREP(
	Transaccion,	Fecha,			NomCajero,	Sucursal,		Efectivo,
	MontoSBC,		NumCuenta,		Referencia,	TipoOperacion,	ClienteID,
	NombreCompleto,	ReferenciaRep,	GrupoCred,	DescripcionOp,	NaturalezaOp,
	CajaID, PolizaID, NombreGrupo,	NumTransaccion,Orden	)';

SET Var_Sentencia:= CONCAT(Var_Sentencia, 'select TC.Transaccion, TC.Fecha,  TC.NomCajero,  TC.Sucursal, TC.Efectivo,');
SET Var_Sentencia:= CONCAT(Var_Sentencia, 'TC.MontoSBC,    TC.NumCuenta, TC.Referencia, TC.TipoOperacion, ',Entero_Cero,',');
SET Var_Sentencia:= CONCAT(Var_Sentencia, '  "',Cadena_Vacia,'",convert(concat(TC. Referencia,"-",CT.DescCorta),char) as ReferenciaRep, ',Entero_Cero,',   CT.Descripcion,   TC.NaturalezaOp');
SET Var_Sentencia:= CONCAT(Var_Sentencia,'  ,TC.CajaID,0,"",', Var_NumTransaccion, ',CT.Orden ');
SET Var_Sentencia:= CONCAT(Var_Sentencia, ' from TMPDETCAJASMOV TC  inner join CAJATIPOSOPERA CT on TC.TipoOperacion = CT.Numero');

-- Se excluye del reporte la operacion de cargo a Cuenta de Ahorro por pago de Servicios en Linea.
SET Var_Sentencia:= CONCAT(Var_Sentencia, ' where TC.NumTransaccion = ', Var_NumTransaccion ,' and TC.TipoOperacion not in (', Ope_EntEfecCta, ',', Ope_RevEntCCta, ',', Ope_RevAbonoCta, ',', Ope_RetEfectivo, ',',
											Ope_RevAbCta, ',',  Ope_RevCargoCta, ',', Ope_SalCargCta, ',', Ope_DepCta, ',',
											Ope_ApSegVida, ',', Ope_EntSegVida, ',', Ope_RevEntDCred, ',',Ope_RevEntSegV, ',',
											Ope_RevSegVida, ',', Ope_EntCApCred, ',', Ope_DeGarLqAd, ',',
											Ope_CobSegVida, ',', Ope_SalDesCred, ',', Ope_EntSegVida, ',', Ope_EntGarLiAd,',',
											Ope_EntPagoCre, ',', Ope_RevCobroSVi,',', Ope_DepGarLiq, ',', Ope_SalGarLiq, ',',
											Ope_RevGarLiq,',', Ope_EntGarLiq, ',', Ope_RevSalGarLiq, ',', Ope_PagCApCred, ',',
											Ope_RevSalDesCrd, ',', Ope_DevGarLiq, ',', Ope_DesemCred, ',', Ope_RevApSegVida, ',',
											Ope_PagoCred, ',', Ope_EntEfSegV, ',', Ope_CobSegV, ',', Ope_SalEfecCam, ',',
											Ope_PagoRem, ',', Ope_SalEfRem, ',', Ope_SalPagRemAbCta, ',', Ope_ReTransCaja, ',',
											Ope_EnTranCaja, ',', Ope_EntPagoServ, ',', Ope_TranCajas, ',', Ope_EnvEfBan, ',',
											Ope_EntEnvEfBan, ',', Ope_SalEfecBanc, ',', Ope_SalTransCta, ',', Ope_EntTransCta, ',',
											Ope_AjustesSob, ',', Ope_EntCInvCred, ',', Ope_EntComTAire, ',',Ope_SalRecTrCaja ,',',
											Ope_PagoServ, ',', Ope_SalEfecCam, ',', Ope_EntEfectCam, ',', Ope_PagCoTAire, ',',
											Ope_SalSobrante,',',SalChequeExmenor,',',SalEfecExmenor,',', CancelacionSocio, ',',
											SalEfeCanSocio,',', SalChequeCanSocio,',',EntPrepagoCredito,',',SalPrepagoCrédito,',',
											HaberesExmenor, ',',CancelacionSocio, ',',SalEfeCanSocio,',',SalChequeCanSocio,',',
											EntPrepagoCredito, ',',SalPrepagoCrédito,',',EntAplicaSegAyuda, ',',SalEfecAplicaSegAyuda,',',
											SalChequeAplicaSegAyuda,',', EntEfecRecCartCastigada, ',',SalRecCarteraCast,',',Ope_CarCuenPSL,',',
											SalApCobRiesgo);





SET Var_Sentencia:= CONCAT(Var_Sentencia,' );');


SET @Sentencia2	= (Var_Sentencia);

PREPARE OPERACIONESVENT2 FROM @Sentencia2;
EXECUTE OPERACIONESVENT2;
DEALLOCATE PREPARE OPERACIONESVENT2;

-- Actualizamos el nombre del cliente para el pago de Remesas
UPDATE TMPOPVENREP TMP,PAGOREMESAS REM
SET TMP.NombreCompleto = IFNULL(REM.NombreCompleto,Cadena_Vacia),
	TMP.ClienteID	   = IFNULL(REM.ClienteID,0)
	WHERE REM.RemesaFolio = TMP.Referencia
	AND TMP.TipoOperacion IN (Ope_PagoRem,Ope_SalEfRem, SalChequeRemesas, Ope_SalPagRemAbCta);

-- Actualizamos el nombre para pago de  Oportunidades
UPDATE TMPOPVENREP TMP,PAGOPORTUNIDADES OP
SET TMP.NombreCompleto = IFNULL(OP.NombreCompleto,Cadena_Vacia),
	TMP.ClienteID=IFNULL(OP.ClienteID,0)
	WHERE OP.Referencia = TMP.Referencia
	AND TMP.TipoOperacion IN(EntPagoOportunidades,SalEfecOportunidades,SalPagoOportunAbonoCta,SalChequeOportun)
	AND TMP.Transaccion = OP.NumTransaccion;

-- Actualizacion del nombre para el pago Servifun
UPDATE TMPOPVENREP TMP,SERVIFUNENTREGADO SER
SET TMP.NombreCompleto = SER.NombreCompleto,
	TMP.ClienteID=IFNULL(SER.ClienteID,0)
	WHERE TMP.TipoOperacion IN(EntPagoServifun,SalEfecServifun,SalChequeServifun)
	AND TMP.Referencia = SER.ServiFunFolioID ;

-- Pago de Apoyo Escolar
UPDATE TMPOPVENREP TMP,APOYOESCOLARSOL AP,CLIENTES CLI
SET TMP.NombreCompleto = IFNULL(CLI.NombreCompleto,''),
	TMP.ClienteID=IFNULL(AP.ClienteID,0)
	WHERE TMP.Referencia = AP.ApoyoEscSolID
	AND TMP.TipoOperacion IN (EntApoyoEscolar,SalEfecApoyoEscolar,SalChequeApoyoEsc)
	AND CLI.ClienteID = AP.ClienteID;

-- RECEPCION DE CHEQUE (SBC , FIRME) Y APLICACION DE CHEQUE SBC
UPDATE TMPOPVENREP TMP,ABONOCHEQUESBC CHE
SET TMP.NombreCompleto = IFNULL(CHE.NombreReceptor,''),
	TMP.ClienteID=IFNULL(CHE.ClienteID,0)
	WHERE TMP.Transaccion = CHE.NumTransaccion
	AND TMP.TipoOperacion IN (Ope_EntChqSBC,Ope_DepCtaSBC, EntAplicaChequeSBC,SalAplicaChequeSBC);


-- OPERACION DE GASTOS Y ANTICIPOS, Y DEVOLUCION DE GASTOS Y ANTICIPOS
UPDATE TMPOPVENREP TMP,MOVSANTGASTOS GA,EMPLEADOS EMP
SET TMP.NombreCompleto = IFNULL(EMP.NombreCompleto,'')
	WHERE TMP.Transaccion = GA.NumTransaccion
	AND TMP.TipoOperacion IN (EntDevGastos,SalEfeGastosComp,SalChequeGastosComp,SalDevGastos,GastosComprobar)
	AND GA.EmpleadoID = EMP.EmpleadoID;


-- Operaciones de Tarjeta de debito
UPDATE TMPOPVENREP TMP,TARJETADEBITO TAR, CLIENTES CLI
SET TMP.NombreCompleto = IFNULL(CLI.NombreCompleto,''),
	TMP.ClienteID=IFNULL(CLI.ClienteID,0)
	WHERE TMP.Referencia  = TAR.TarjetaDebID
	AND TMP.TipoOperacion IN (EntradaAnualidaTD,SalAnualidadTD)
	AND TAR.ClienteID = CLI.ClienteID;

-- Operaciones de Pago de Servicios
UPDATE TMPOPVENREP TMP,PAGOSERVICIOS PS, CLIENTES CLI
SET TMP.NombreCompleto = IFNULL(CLI.NombreCompleto,''),
	TMP.ClienteID=IFNULL(CLI.CLienteID,0)/*Correccion*/
	WHERE TMP.Transaccion = PS.NumTransaccion
	AND TMP.TipoOperacion IN (EntPagServicios,SalPagServicios)
	AND PS.ClienteID = CLI.ClienteID;

/*Operaciones de Aportacion de Socio*/
UPDATE TMPOPVENREP TMP ,APORTACIONSOCIO AP,CLIENTES CLI
SET TMP.NombreCompleto = IFNULL(CLI.NombreCompleto,''),
	TMP.ClienteID=IFNULL(CLI.ClienteID,0)
WHERE TMP.Transaccion=AP.NumTransaccion
	AND AP.ClienteID = CLI.ClienteID
	AND TMP.TipoOperacion IN (EntAportacionSocio,SalAportacionSocio);

/*Operaciones de Devolucion de Aportacion de Socio*/
UPDATE TMPOPVENREP TMP ,APORTASOCIOMOV AP,CLIENTES CLI
SET TMP.NombreCompleto = IFNULL(CLI.NombreCompleto,''),
	TMP.ClienteID=IFNULL(CLI.ClienteID,0)
WHERE TMP.Transaccion=AP.NumTransaccion
	AND AP.ClienteID = CLI.ClienteID
	AND TMP.TipoOperacion IN (Ope_EntEfDAS,Ope_SalEfDAS,SalChequeDevAportaSoc);


UPDATE TMPOPVENREP Tmp, POLIZACONTABLE Pol SET
	Tmp.PolizaID = Pol.PolizaID
	WHERE Tmp.Fecha = Pol.Fecha
	 AND Tmp.Transaccion = Pol.NumTransaccion
	 AND Tmp.NumTransaccion = Var_NumTransaccion;

UPDATE TMPOPVENREP Tmp, `HIS-POLIZACONTA` Pol SET
	Tmp.PolizaID = Pol.PolizaID
	WHERE Tmp.PolizaID = 0
	 AND Tmp.Fecha = Pol.Fecha
	 AND Tmp.Transaccion = Pol.NumTransaccion
	 AND Tmp.NumTransaccion = Var_NumTransaccion;

SELECT Transaccion,	Fecha,			NomCajero,	Sucursal,		Efectivo,
	MontoSBC,		NumCuenta,		Referencia,	TipoOperacion,	ClienteID,
	NombreCompleto,	ReferenciaRep,	GrupoCred,	DescripcionOp,	NaturalezaOp,
	CajaID, PolizaID, NombreGrupo
	FROM TMPOPVENREP Tmp
	WHERE Tmp.NumTransaccion = Var_NumTransaccion
	ORDER BY Sucursal, CajaID, Fecha, NaturalezaOp,Orden, TipoOperacion, Transaccion;

DELETE FROM TMPDETCAJASMOV
	WHERE NumTransaccion = Var_NumTransaccion;

DELETE FROM TMPOPVENREP
	WHERE NumTransaccion = Var_NumTransaccion;



END TerminaStore$$