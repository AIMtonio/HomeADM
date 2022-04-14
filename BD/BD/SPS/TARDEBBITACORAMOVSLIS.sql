-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBBITACORAMOVSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBBITACORAMOVSLIS`;
DELIMITER $$


CREATE PROCEDURE `TARDEBBITACORAMOVSLIS`(
	Par_TarjetaDebID		CHAR(16),
	Par_TipoOperacionID		CHAR(2),
	Par_FechaInicio			DATE,
	Par_FechaFin			DATE,
    Par_NumLis         		TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
		)

TerminaStore: BEGIN

DECLARE Cadena_Vacia    	char(1);
DECLARE Fecha_Vacia     	date;
DECLARE Entero_Cero     	int;
DECLARE Decimal_Cero		decimal(12,2);

DECLARE CompraNormal    	varchar(20);
DECLARE RetiroEfectivo    	varchar(50);
DECLARE CompraRetiroEfec 	varchar(20);
DECLARE ConsultaSaldo   	varchar(30);
DECLARE AjusteCompra		varchar(20);
DECLARE CompraTpoAire		varchar(50);


DECLARE Est_Activada 		int;
DECLARE Est_Bloqueada 		int;
DECLARE EstatusCanc 		int;
DECLARE Est_Expirada 		int;
DECLARE Est_Procesado    	char(1);
DECLARE Lis_Principal   	int;
DECLARE Lis_OperTarjeta   	int;
DECLARE Lis_Checkout		int;
DECLARE BloqTarDeb			int;
DECLARE MovBloqueo			char(1);
DECLARE OpeCompraNormal		char(2);
DECLARE OpeRetiroEfectivo	char(2);
DECLARE OpeConsultaSaldo	char(2);
DECLARE OpeCompraRetiro		char(2);
DECLARE OpeCompraTpoAire	char(2);
DECLARE OpeAjusteCompra		char(2);
DECLARE Compra_Normal		char(2);
DECLARE Checkin_Cero		char(1);
DECLARE MonedaPesos			char(3);
DECLARE Checkin_Uno			char(1);
DECLARE DesCompraNormal		varchar(16);
DECLARE TipoMens			char(4);
DECLARE PuntoEntradas		varchar(10);

DECLARE Tipo_CompraNor		int(11);
DECLARE Tipo_RetEfe			int(11);
DECLARE Tipo_ComRetEfe		int(11);
DECLARE Tipo_IvaComRetEfe	int(11);
DECLARE Tipo_ComRet			int(11);
DECLARE Tipo_ComConSal		int(11);
DECLARE Tipo_IvaComConSal	int(11);
DECLARE Tipo_RevComNor		int(11);
DECLARE Tipo_RevRetEfe		int(11);
DECLARE Tipo_RevComRet		int(11);
DECLARE Tipo_RevIvaComRetEfe int(11);
DECLARE Tipo_RevComConSal	int(11);
DECLARE Tipo_Rev_IvaComConSal int(11);
DECLARE Tipo_ComTpoAire		int(11);
DECLARE Tipo_ComComTpoAire	int(11);
DECLARE Tipo_IvaComTpoAire	int(11);
DECLARE Tipo_RevComTpoAire	int(11);
DECLARE Tipo_AjusteCompra	int(11);
DECLARE Var_FechaSistema		date;
DECLARE Llave_AutorizaTerceroTranTD		VARCHAR(50);	-- Llave AutorizaTerceroTranTD
DECLARE Var_AutorizaTerceroTranTD		VARCHAR(200);	-- Variable para almacenar el valor del campo AutorizaTerceroTranTD
DECLARE Con_SI							CHAR(1);		-- Constante SI
DECLARE Con_NO 							CHAR(1);		-- Constante NO
DECLARE Tran_PreAutorizacion			INT(11);		-- Transaccion de tipo preautorizacion
DECLARE Tran_ReAutorizacion				INT(11);		-- Transaccion de tipo reautorizacion

Set Entero_Cero     	:= 0;
Set Decimal_Cero		:= '0.00';
Set Cadena_Vacia    	:= '';
Set Fecha_Vacia     	:= '1900-01-01';

Set OpeCompraNormal		:= '00';
Set OpeRetiroEfectivo	:= '01';
Set OpeConsultaSaldo	:= '31';
Set OpeCompraRetiro		:= '09';
Set OpeCompraTpoAire	:= '10';
Set OpeAjusteCompra		:= '02';

Set CompraNormal    	:= 'COMPRA POS';
Set RetiroEfectivo  	:= 'RETIRO EN EFECTIVO ATM';
Set CompraRetiroEfec	:= 'RETIRO EN COMPRA POS';
Set ConsultaSaldo   	:= 'CONSULTA DE SALDO ATM';
Set AjusteCompra		:= 'AJUSTE DE COMPRA';
Set CompraTpoAire		:= 'COMPRA DE TIEMPO AIRE';
set DesCompraNormal		:='COMPRA NORMAL';
set TipoMens            :='1220';
set PuntoEntradas		:='WORKBENCH';

Set Est_Procesado       := 'P';
set Compra_Normal		:='00';
set Checkin_Cero		:= '0';
set MonedaPesos			:='484';
set Checkin_Uno			:='1';

Set Lis_Principal   	:= 1;
Set Lis_OperTarjeta   	:= 2;
set Lis_Checkout		:= 3;

Set Est_Activada        := 7;
Set Est_Bloqueada		:= 8;
Set EstatusCanc         := 9;
Set Est_Expirada        := 10;

Set Tipo_CompraNor		:= 17;
Set Tipo_RetEfe			:= 20;
Set Tipo_ComRetEfe		:= 21;
Set Tipo_IvaComRetEfe	:= 22;
Set Tipo_ComRet			:= 87;
Set Tipo_ComConSal		:= 86;
Set Tipo_IvaComConSal	:= 88;
Set Tipo_RevComNor		:= 90;
Set Tipo_RevRetEfe		:= 91;
Set Tipo_RevComRet		:= 92;
Set Tipo_RevIvaComRetEfe:= 93;
Set Tipo_RevComConSal	:= 94;
Set Tipo_Rev_IvaComConSal:=95;
Set Tipo_ComTpoAire		:= 96;
Set Tipo_ComComTpoAire	:= 97;
Set Tipo_IvaComTpoAire	:= 98;
Set Tipo_RevComTpoAire	:= 99;
Set Tipo_AjusteCompra	:= 106;
Set BloqTarDeb			:=3;
Set MovBloqueo			:='B';
set Var_FechaSistema			:= ifnull((select FechaSistema from PARAMETROSSIS),'1900-01-01');
SET Con_NO						:= 'N';             -- Constante NO
SET Con_SI						:= 'S';             -- Constante SI
SET Llave_AutorizaTerceroTranTD	:= 'AutorizaTerceroTranTD';
SET Tran_PreAutorizacion		:= 14;
SET Tran_ReAutorizacion			:= 15;

-- Se obtiene la bandera de autorizacion de terceros
SET Var_AutorizaTerceroTranTD	:= IFNULL( FNPARAMTARJETAS(Llave_AutorizaTerceroTranTD), Con_NO);


	if(Par_NumLis = Lis_Principal) then

		if(Par_TipoOperacionID = OpeCompraNormal) then
			SELECT
				DATE(FechaHrOpe) as Fecha, LPAD(NumTransaccion, 6, '0') as NumeroTran, MontoOpe,
				CASE TipoOperacionID
					WHEN OpeCompraNormal THEN CompraNormal
					WHEN OpeRetiroEfectivo THEN RetiroEfectivo
					WHEN OpeCompraTpoAire THEN CompraTpoAire
					WHEN OpeConsultaSaldo THEN ConsultaSaldo
					WHEN OpeAjusteCompra THEN AjusteCompra
					WHEN OpeCompraRetiro THEN CompraRetiroEfec
				END AS Operacion,
				TerminalID, NombreUbicaTer, DatosTiempoAire
			FROM TARDEBBITACORAMOVS
			WHERE TarjetaDebID = Par_TarjetaDebID AND Estatus = Est_Procesado AND TipoOperacionID = OpeCompraNormal
				AND DATE(FechaHrOpe) >= DATE(Par_FechaInicio) AND DATE(FechaHrOpe) <= DATE(Par_FechaFin);
		end if;

		if(Par_TipoOperacionID = OpeRetiroEfectivo) then
			SELECT
				DATE(FechaHrOpe) as Fecha, LPAD(NumTransaccion, 6, '0') as NumeroTran, MontoOpe,
				CASE TipoOperacionID
					WHEN OpeCompraNormal THEN CompraNormal
					WHEN OpeRetiroEfectivo THEN RetiroEfectivo
					WHEN OpeCompraTpoAire THEN CompraTpoAire
					WHEN OpeConsultaSaldo THEN ConsultaSaldo
					WHEN OpeAjusteCompra THEN AjusteCompra
					WHEN OpeCompraRetiro THEN CompraRetiroEfec
				END AS Operacion,
				TerminalID, NombreUbicaTer, DatosTiempoAire
			FROM TARDEBBITACORAMOVS
			WHERE TarjetaDebID = Par_TarjetaDebID AND Estatus = Est_Procesado AND TipoOperacionID = OpeRetiroEfectivo
				AND DATE(FechaHrOpe) >= DATE(Par_FechaInicio) AND DATE(FechaHrOpe) <= DATE(Par_FechaFin);
		end if;

		if(Par_TipoOperacionID = OpeCompraRetiro) then
			SELECT
				DATE(FechaHrOpe) as Fecha, LPAD(NumTransaccion, 6, '0') as NumeroTran, MontoOpe,
				CASE TipoOperacionID
					WHEN OpeCompraNormal THEN CompraNormal
					WHEN OpeRetiroEfectivo THEN RetiroEfectivo
					WHEN OpeCompraTpoAire THEN CompraTpoAire
					WHEN OpeConsultaSaldo THEN ConsultaSaldo
					WHEN OpeAjusteCompra THEN AjusteCompra
					WHEN OpeCompraRetiro THEN CompraRetiroEfec
				END AS Operacion,
				TerminalID, NombreUbicaTer, DatosTiempoAire
			FROM TARDEBBITACORAMOVS
			WHERE TarjetaDebID = Par_TarjetaDebID AND Estatus = Est_Procesado AND TipoOperacionID = OpeCompraRetiro
				AND DATE(FechaHrOpe) >= DATE(Par_FechaInicio) AND DATE(FechaHrOpe) <= DATE(Par_FechaFin);
		end if;

		if(Par_TipoOperacionID = OpeConsultaSaldo) then
			SELECT
				DATE(FechaHrOpe) as Fecha, LPAD(NumTransaccion, 6, '0') as NumeroTran, MontoOpe,
				CASE TipoOperacionID
					WHEN OpeCompraNormal THEN CompraNormal
					WHEN OpeRetiroEfectivo THEN RetiroEfectivo
					WHEN OpeCompraTpoAire THEN CompraTpoAire
					WHEN OpeConsultaSaldo THEN ConsultaSaldo
					WHEN OpeAjusteCompra THEN AjusteCompra
					WHEN OpeCompraRetiro THEN CompraRetiroEfec
				END AS Operacion,
				TerminalID, NombreUbicaTer, DatosTiempoAire
			FROM TARDEBBITACORAMOVS
			WHERE TarjetaDebID = Par_TarjetaDebID AND Estatus = Est_Procesado AND TipoOperacionID = OpeConsultaSaldo
				AND DATE(FechaHrOpe) >= DATE(Par_FechaInicio) AND DATE(FechaHrOpe) <= DATE(Par_FechaFin);

		end if;

		if(Par_TipoOperacionID = OpeCompraTpoAire) then
			SELECT
				DATE(FechaHrOpe) as Fecha, LPAD(NumTransaccion, 6, '0') as NumeroTran, MontoOpe,
				CASE TipoOperacionID
					WHEN OpeCompraNormal THEN CompraNormal
					WHEN OpeRetiroEfectivo THEN RetiroEfectivo
					WHEN OpeCompraTpoAire THEN CompraTpoAire
					WHEN OpeConsultaSaldo THEN ConsultaSaldo
					WHEN OpeAjusteCompra THEN AjusteCompra
					WHEN OpeCompraRetiro THEN CompraRetiroEfec
				END AS Operacion,
				TerminalID, NombreUbicaTer, DatosTiempoAire
			FROM TARDEBBITACORAMOVS
			WHERE TarjetaDebID = Par_TarjetaDebID AND Estatus = Est_Procesado AND TipoOperacionID = OpeCompraTpoAire
				AND DATE(FechaHrOpe) >= DATE(Par_FechaInicio) AND DATE(FechaHrOpe) <= DATE(Par_FechaFin);
		end if;

		if(Par_TipoOperacionID = OpeAjusteCompra) then
			SELECT
				DATE(FechaHrOpe) as Fecha, LPAD(NumTransaccion, 6, '0') as NumeroTran, MontoOpe,
				CASE TipoOperacionID
					WHEN OpeCompraNormal THEN CompraNormal
					WHEN OpeRetiroEfectivo THEN RetiroEfectivo
					WHEN OpeCompraTpoAire THEN CompraTpoAire
					WHEN OpeConsultaSaldo THEN ConsultaSaldo
					WHEN OpeAjusteCompra THEN AjusteCompra
					WHEN OpeCompraRetiro THEN CompraRetiroEfec
				END AS Operacion,
				TerminalID, NombreUbicaTer, DatosTiempoAire
			FROM TARDEBBITACORAMOVS
			WHERE TarjetaDebID = Par_TarjetaDebID AND Estatus = Est_Procesado AND TipoOperacionID = OpeAjusteCompra
				AND DATE(FechaHrOpe) >= DATE(Par_FechaInicio) AND DATE(FechaHrOpe) <= DATE(Par_FechaFin);
		end if;

	end if;


	if(Par_NumLis = Lis_OperTarjeta) then

		SELECT
			DATE(FechaHrOpe) as Fecha, LPAD(NumTransaccion, 6, '0') as NumeroTran, MontoOpe,
			CASE TipoOperacionID
				WHEN OpeCompraNormal THEN CompraNormal
				WHEN OpeRetiroEfectivo THEN RetiroEfectivo
				WHEN OpeCompraTpoAire THEN CompraTpoAire
				WHEN OpeConsultaSaldo THEN ConsultaSaldo
				WHEN OpeAjusteCompra THEN AjusteCompra
				WHEN OpeCompraRetiro THEN CompraRetiroEfec
			END AS Operacion,
			TerminalID, NombreUbicaTer, DatosTiempoAire
		FROM TARDEBBITACORAMOVS
		WHERE TarjetaDebID = Par_TarjetaDebID AND Estatus = Est_Procesado
			AND DATE(FechaHrOpe) >= DATE(Par_FechaInicio) AND DATE(FechaHrOpe) <= DATE(Par_FechaFin);
	end if;

	IF(Par_NumLis = Lis_Checkout)THEN

		-- CUANDO LA BANDERA ESTA APAGADA, NO SUFRE CAMBIOS LA LSITA ACTUAL
		IF(Var_AutorizaTerceroTranTD = Con_NO)THEN
			DROP TABLE IF EXISTS TMP_TARDEBBITACORAMOVS;
			CREATE TEMPORARY TABLE TMP_TARDEBBITACORAMOVS
				SELECT *	FROM TARDEBBITACORAMOVS tdm
							WHERE  tdm.TipoOperacionID = Compra_Normal
							AND tdm.CheckIn = Checkin_Cero
								AND tdm.Estatus = Est_Procesado
								AND  EXISTS( SELECT  t.CodigoAprobacion
												FROM TARDEBBITACORAMOVS t
												WHERE t.CodigoAprobacion = tdm.NumTransaccion AND Estatus=Est_Procesado)=Entero_Cero;


			DROP TABLE IF EXISTS TMP_BLOQUEOS;
			CREATE TEMPORARY TABLE TMP_BLOQUEOS
				SELECT * FROM BLOQUEOS WHERE NatMovimiento=MovBloqueo AND TiposBloqID =BloqTarDeb AND FolioBloq =Entero_Cero;

			DELETE FROM TMP_TARDEBBITACORAMOVS WHERE NumTransaccion NOT IN (SELECT NumTransaccion FROM TMP_BLOQUEOS);



			SELECT tdm.TarjetaDebID, CASE (tdm.TipoOperacionID)
						WHEN Compra_Normal THEN DesCompraNormal END AS TipoOperacionID, td.ClienteID,cli.NombreCompleto, td.CuentaAhoID,PuntoEntradas AS PuntoEntrada,
						tdm.MontoOpe,	TipoMens AS TipoMensaje, tdm.OrigenInst,Var_FechaSistema AS FechaSistema, tdm.NumTransaccion, tdm.GiroNegocio,
						MonedaPesos AS CodigoMonOpe, tdm.NombreUbicaTer, Checkin_Uno AS CheckIn, tdm.NumTransaccion AS CodigoAprobacion,
						tdm.TarDebMovID,					Con_NO AS EsIsotrx
						FROM TMP_TARDEBBITACORAMOVS tdm
						INNER JOIN TARJETADEBITO td
						ON tdm.TarjetaDebID = td.TarjetaDebID
						INNER JOIN CLIENTES cli
						ON td.ClienteID =cli.ClienteID;
		END IF;

		-- SI LA BANDERA SE ENCUENTRA PRENDIDA, SE CONSULTA OTRAS CONDICIONES
		IF(Var_AutorizaTerceroTranTD = Con_SI)THEN
			DROP TABLE IF EXISTS TMP_TARDEBBITACORAMOVS;
			CREATE TEMPORARY TABLE TMP_TARDEBBITACORAMOVS
			SELECT	MAX(TarDebMovID) AS TarDebMovID,	MAX(TipoMensaje),						MAX(TipoOperacionID) AS TipoOperacionID,	MAX(TarjetaDebID) AS TarjetaDebID,	MAX(OrigenInst) AS OrigenInst,
					MAX(MontoOpe) AS MontoOpe,			MAX(FechaHrOpe),						MAX(NumeroTran),							MAX(GiroNegocio) AS GiroNegocio,	MAX(PuntoEntrada),
					MAX(TerminalID),					MAX(NombreUbicaTer) AS NombreUbicaTer,	MAX(NIP),									MAX(CodigoMonOpe),					MAX(MontosAdiciona),
					MAX(MontoSurcharge),				MAX(MontoLoyaltyfee), 					MAX(Referencia),							MAX(DatosTiempoAire),				MAX(EstatusConcilia),
					MAX(FolioConcilia),					MAX(DetalleConciliaID),					MAX(TransEnLinea),							MAX(CheckIn),						CodigoAprobacion,
					MAX(Estatus),						MAX(EmisorID),							MAX(MensajeID),								MAX(ModoEntrada),					MAX(ResultadoOperacion),
					MAX(EstatusOperacion), 				MAX(FechaOperacion),					MAX(HoraOperacion),							MAX(CodigoRespuesta),				MAX(CodigoRechazo),
					MAX(NumeroCuenta), 					MAX(MontoRemplazo),						MAX(SaldoDisponible),						MAX(ProDiferimiento), 				MAX(ProNumeroPagos),
					MAX(ProTipoPlan),	 				MAX(OriCodigoAutorizacion),				MAX(OriFechaTransaccion),					MAX(OriHoraTransaccion),			MAX(DesNumeroCuenta),
					MAX(DesNumeroTarjeta), 				MAX(TrsClaveRastreo),					MAX(TrsInstitucionRemitente),				MAX(TrsNombreEmisor), 				MAX(TrsTipoCuentaRemitente),
					MAX(TrsCuentaRemitente),			MAX(TrsConceptoPago),					MAX(TrsReferenciaNumerica),					MAX(EmpresaID), 					MAX(Usuario),
					MAX(FechaActual),					MAX(DireccionIP),						MAX(ProgramaID),							MAX(Sucursal),						MAX(NumTransaccion) AS NumTransaccion
			FROM TARDEBBITACORAMOVS tdm
			WHERE  tdm.TipoOperacionID IN(Tran_PreAutorizacion,Tran_ReAutorizacion)
			AND tdm.CheckIn = Checkin_Cero
			AND tdm.Estatus = Est_Procesado
			GROUP BY tdm.CodigoAprobacion;

			DROP TABLE IF EXISTS TMP_BLOQUEOS;
			CREATE TEMPORARY TABLE TMP_BLOQUEOS
			SELECT * FROM BLOQUEOS WHERE NatMovimiento = MovBloqueo AND TiposBloqID = BloqTarDeb AND FolioBloq = Entero_Cero;

			-- SE BORRAN AQUELLAS CUENTAS QUE NO SE ENCUENTRAN BLOQUEADAS
			DELETE FROM TMP_TARDEBBITACORAMOVS WHERE NumTransaccion NOT IN (SELECT NumTransaccion FROM TMP_BLOQUEOS);

			SELECT tdm.TarjetaDebID,					Cat.Descripcion AS TipoOperacionID,
					td.ClienteID,						cli.NombreCompleto, 					td.CuentaAhoID,				PuntoEntradas AS PuntoEntrada,
					tdm.MontoOpe,						TipoMens AS TipoMensaje,				tdm.OrigenInst,				Var_FechaSistema AS FechaSistema,	tdm.NumTransaccion,		tdm.GiroNegocio,
					MonedaPesos AS CodigoMonOpe,		tdm.NombreUbicaTer,						Checkin_Uno AS CheckIn,		tdm.CodigoAprobacion AS CodigoAprobacion,
					tdm.TarDebMovID,					Con_SI AS EsIsotrx
			FROM TMP_TARDEBBITACORAMOVS tdm
			INNER JOIN TARJETADEBITO td ON tdm.TarjetaDebID = td.TarjetaDebID
			INNER JOIN CATTIPOPERACIONISOTRX Cat ON tdm.TipoOperacionID = Cat.CodigoOperacion
			INNER JOIN CLIENTES cli	ON td.ClienteID =cli.ClienteID;
		END IF;

	END IF;
END TerminaStore$$