-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBBITACORAMOVSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBBITACORAMOVSREP`;DELIMITER $$

CREATE PROCEDURE `TARDEBBITACORAMOVSREP`(
	Par_TarjetaDebID    	char(16),
	Par_TipoOperacionID		char(2),
	Par_FechaInicio			date,
	Par_FechaFin			date,
	Par_TipoReporte         tinyint unsigned,

    Par_EmpresaID       	int,
    Aud_Usuario         	int,
    Aud_FechaActual     	date,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint

	)
TerminaStore: BEGIN


DECLARE CompraNormal    	varchar(30);
DECLARE RetiroEfectivo    	varchar(30);
DECLARE CompraRetiroEfec 	varchar(30);
DECLARE ConsultaSaldo   	varchar(30);
DECLARE CompraTpoAire   	varchar(30);
DECLARE AjusteCompra		varchar(30);

DECLARE Est_Activada 		int;
DECLARE Est_Bloqueada 		int;
DECLARE EstatusCanc 		int;
DECLARE Est_Expirada 		int;
DECLARE Est_Procesado   	char(1);
DECLARE Est_Registrado		char(1);
DECLARE Rep_Principal       int(11);
DECLARE Rep_OperTarjeta     int(11);
DECLARE Rep_MovsTarDeb     	int(11);
DECLARE Rep_MovsTarExitosos int;
DECLARE Rep_MovsRechachazados int;


DECLARE OpeCompraNormal		char(2);
DECLARE OpeRetiroEfectivo	char(2);
DECLARE OpeConsultaSaldo	char(2);
DECLARE OpeCompraRetiro		char(2);
DECLARE OpeCompraTpoAire	char(2);
DECLARE OpeAjusteCompra		char(2);


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
DECLARE MovExitoso			varchar(30);
DECLARE MovRechazado		varchar(30);

Set CompraNormal    	:= 'COMPRA POS';
Set RetiroEfectivo  	:= 'RETIRO EN EFECTIVO ATM';
Set CompraRetiroEfec	:= 'RETIRO EN COMPRA POS';
Set ConsultaSaldo   	:= 'CONSULTA DE SALDO ATM';
Set CompraTpoAire   	:= 'COMPRA DE TIEMPO AIRE ATM';
Set AjusteCompra	   	:= 'AJUSTE DE COMPRA';
Set MovExitoso          := 'EXITOSO';
Set MovRechazado        := 'RECHAZADO';

Set Est_Procesado       := 'P';
Set Est_Registrado      := 'R';
Set Est_Activada        := 7;
Set Est_Bloqueada		:= 8;
Set EstatusCanc         := 9;
Set Est_Expirada        := 10;
Set Rep_Principal       := 1;
Set Rep_OperTarjeta     := 2;
Set Rep_MovsTarDeb		:= 3;
Set Rep_MovsTarExitosos := 4;
Set Rep_MovsRechachazados := 5;

Set OpeCompraNormal		:= '00';
Set OpeRetiroEfectivo	:= '01';
Set OpeConsultaSaldo	:= '31';
Set OpeCompraRetiro		:= '09';
Set OpeCompraTpoAire	:= '10';
Set OpeAjusteCompra		:= '02';

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


if(Par_TipoReporte = Rep_Principal) then

	if(Par_TipoOperacionID = OpeCompraNormal) then
		SELECT
			Tar.TarjetaDebID, LPAD(Cli.ClienteID, 11, '0') as ClienteID, Cli.NombreCompleto, Cli.CorpRelacionado, LPAD(convert(Tar.CuentaAhoID, CHAR),11,'0') as CuentaAhoID,
			TpoCta.Descripcion as TipoCuenta, TpoTar.TipoTarjetaDebID,TpoTar.Descripcion as TipoTarjeta,
			date(Movs.FechaHrOpe) as Fecha,
			CASE Movs.TipoOperacionID
				WHEN OpeCompraNormal THEN CompraNormal
				WHEN OpeRetiroEfectivo THEN RetiroEfectivo
				WHEN OpeCompraTpoAire THEN CompraTpoAire
				WHEN OpeConsultaSaldo THEN ConsultaSaldo
				WHEN OpeAjusteCompra THEN AjusteCompra
				WHEN OpeCompraRetiro THEN CompraRetiroEfec
				END as Operacion,
			LPAD(Movs.NumTransaccion, 6, '0') as NumeroTran, Movs.MontoOpe as MontoOpe, Corp.RazonSocial,
			Movs.TerminalID, Movs.NombreUbicaTer, Movs.DatosTiempoAire
		FROM TARDEBBITACORAMOVS Movs
		INNER JOIN TARJETADEBITO Tar ON Movs.TarjetaDebID = Tar.TarjetaDebID
		INNER JOIN CUENTASAHO Cta ON Tar.CuentaAhoID = Cta.CuentaAhoID
		INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
		INNER JOIN TIPOSCUENTAS TpoCta ON Cta.TipoCuentaID = TpoCta.TipoCuentaID
		INNER JOIN TIPOTARJETADEB TpoTar ON Tar.TipoTarjetaDebID = TpoTar.TipoTarjetaDebID
		LEFT JOIN CLIENTES Corp ON Cli.CorpRelacionado = Corp.ClienteID
		WHERE Movs.TarjetaDebID = Par_TarjetaDebID AND Movs.TipoOperacionID = OpeCompraNormal AND Movs.Estatus = Est_Procesado
			AND DATE(Movs.FechaHrOpe) >= DATE(Par_FechaInicio) and DATE(Movs.FechaHrOpe) <= DATE(Par_FechaFin);
	end if;

	if(Par_TipoOperacionID = OpeRetiroEfectivo) then
		SELECT
			Tar.TarjetaDebID, LPAD(Cli.ClienteID, 11, '0') as ClienteID, Cli.NombreCompleto, Cli.CorpRelacionado, LPAD(convert(Tar.CuentaAhoID, CHAR),11,'0') as CuentaAhoID,
			TpoCta.Descripcion as TipoCuenta, TpoTar.TipoTarjetaDebID,TpoTar.Descripcion as TipoTarjeta,
			date(Movs.FechaHrOpe) as Fecha,
			CASE Movs.TipoOperacionID
				WHEN OpeCompraNormal THEN CompraNormal
				WHEN OpeRetiroEfectivo THEN RetiroEfectivo
				WHEN OpeCompraTpoAire THEN CompraTpoAire
				WHEN OpeConsultaSaldo THEN ConsultaSaldo
				WHEN OpeAjusteCompra THEN AjusteCompra
				WHEN OpeCompraRetiro THEN CompraRetiroEfec
				END as Operacion,
			LPAD(Movs.NumTransaccion, 6, '0') as NumeroTran, Movs.MontoOpe as MontoOpe, Corp.RazonSocial,
			Movs.TerminalID, Movs.NombreUbicaTer, Movs.DatosTiempoAire
		FROM TARDEBBITACORAMOVS Movs
		INNER JOIN TARJETADEBITO Tar ON Movs.TarjetaDebID = Tar.TarjetaDebID
		INNER JOIN CUENTASAHO Cta ON Tar.CuentaAhoID = Cta.CuentaAhoID
		INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
		INNER JOIN TIPOSCUENTAS TpoCta ON Cta.TipoCuentaID = TpoCta.TipoCuentaID
		INNER JOIN TIPOTARJETADEB TpoTar ON Tar.TipoTarjetaDebID = TpoTar.TipoTarjetaDebID
		LEFT JOIN CLIENTES Corp ON Cli.CorpRelacionado = Corp.ClienteID
		WHERE Movs.TarjetaDebID = Par_TarjetaDebID AND Movs.TipoOperacionID = OpeRetiroEfectivo AND Movs.Estatus = Est_Procesado
			AND DATE(Movs.FechaHrOpe) >= DATE(Par_FechaInicio) and DATE(Movs.FechaHrOpe) <= DATE(Par_FechaFin);
	end if;

	if(Par_TipoOperacionID = OpeCompraRetiro) then
		SELECT
			Tar.TarjetaDebID, LPAD(Cli.ClienteID, 11, '0') as ClienteID, Cli.NombreCompleto, Cli.CorpRelacionado, LPAD(convert(Tar.CuentaAhoID, CHAR),11,'0') as CuentaAhoID,
			TpoCta.Descripcion as TipoCuenta, TpoTar.TipoTarjetaDebID,TpoTar.Descripcion as TipoTarjeta,
			date(Movs.FechaHrOpe) as Fecha,
			CASE Movs.TipoOperacionID
				WHEN OpeCompraNormal THEN CompraNormal
				WHEN OpeRetiroEfectivo THEN RetiroEfectivo
				WHEN OpeCompraTpoAire THEN CompraTpoAire
				WHEN OpeConsultaSaldo THEN ConsultaSaldo
				WHEN OpeAjusteCompra THEN AjusteCompra
				WHEN OpeCompraRetiro THEN CompraRetiroEfec
				END as Operacion,
			LPAD(Movs.NumTransaccion, 6, '0') as NumeroTran, Movs.MontoOpe as MontoOpe, Corp.RazonSocial,
			Movs.TerminalID, Movs.NombreUbicaTer, Movs.DatosTiempoAire
		FROM TARDEBBITACORAMOVS Movs
		INNER JOIN TARJETADEBITO Tar ON Movs.TarjetaDebID = Tar.TarjetaDebID
		INNER JOIN CUENTASAHO Cta ON Tar.CuentaAhoID = Cta.CuentaAhoID
		INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
		INNER JOIN TIPOSCUENTAS TpoCta ON Cta.TipoCuentaID = TpoCta.TipoCuentaID
		INNER JOIN TIPOTARJETADEB TpoTar ON Tar.TipoTarjetaDebID = TpoTar.TipoTarjetaDebID
		LEFT JOIN CLIENTES Corp ON Cli.CorpRelacionado = Corp.ClienteID
		WHERE Movs.TarjetaDebID = Par_TarjetaDebID AND Movs.TipoOperacionID = OpeCompraRetiro AND Movs.Estatus = Est_Procesado
			AND DATE(Movs.FechaHrOpe) >= DATE(Par_FechaInicio) and DATE(Movs.FechaHrOpe) <= DATE(Par_FechaFin);
	end if;

	if(Par_TipoOperacionID = OpeConsultaSaldo) then
		SELECT
			Tar.TarjetaDebID, LPAD(Cli.ClienteID, 11, '0') as ClienteID, Cli.NombreCompleto, Cli.CorpRelacionado, LPAD(convert(Tar.CuentaAhoID, CHAR),11,'0') as CuentaAhoID,
			TpoCta.Descripcion as TipoCuenta, TpoTar.TipoTarjetaDebID,TpoTar.Descripcion as TipoTarjeta,
			date(Movs.FechaHrOpe) as Fecha,
			CASE Movs.TipoOperacionID
				WHEN OpeCompraNormal THEN CompraNormal
				WHEN OpeRetiroEfectivo THEN RetiroEfectivo
				WHEN OpeCompraTpoAire THEN CompraTpoAire
				WHEN OpeConsultaSaldo THEN ConsultaSaldo
				WHEN OpeAjusteCompra THEN AjusteCompra
				WHEN OpeCompraRetiro THEN CompraRetiroEfec
				END as Operacion,
			LPAD(Movs.NumTransaccion, 6, '0') as NumeroTran, Movs.MontoOpe as MontoOpe, Corp.RazonSocial,
			Movs.TerminalID, Movs.NombreUbicaTer, Movs.DatosTiempoAire
		FROM TARDEBBITACORAMOVS Movs
		INNER JOIN TARJETADEBITO Tar ON Movs.TarjetaDebID = Tar.TarjetaDebID
		INNER JOIN CUENTASAHO Cta ON Tar.CuentaAhoID = Cta.CuentaAhoID
		INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
		INNER JOIN TIPOSCUENTAS TpoCta ON Cta.TipoCuentaID = TpoCta.TipoCuentaID
		INNER JOIN TIPOTARJETADEB TpoTar ON Tar.TipoTarjetaDebID = TpoTar.TipoTarjetaDebID
		LEFT JOIN CLIENTES Corp ON Cli.CorpRelacionado = Corp.ClienteID
		WHERE Movs.TarjetaDebID = Par_TarjetaDebID AND Movs.TipoOperacionID = OpeConsultaSaldo AND Movs.Estatus = Est_Procesado
			AND DATE(Movs.FechaHrOpe) >= DATE(Par_FechaInicio) and DATE(Movs.FechaHrOpe) <= DATE(Par_FechaFin);
	end if;

	if(Par_TipoOperacionID = OpeCompraTpoAire) then
		SELECT
			Tar.TarjetaDebID, LPAD(Cli.ClienteID, 11, '0') as ClienteID, Cli.NombreCompleto, Cli.CorpRelacionado, LPAD(convert(Tar.CuentaAhoID, CHAR),11,'0') as CuentaAhoID,
			TpoCta.Descripcion as TipoCuenta, TpoTar.TipoTarjetaDebID,TpoTar.Descripcion as TipoTarjeta,
			date(Movs.FechaHrOpe) as Fecha,
			CASE Movs.TipoOperacionID
				WHEN OpeCompraNormal THEN CompraNormal
				WHEN OpeRetiroEfectivo THEN RetiroEfectivo
				WHEN OpeCompraTpoAire THEN CompraTpoAire
				WHEN OpeConsultaSaldo THEN ConsultaSaldo
				WHEN OpeAjusteCompra THEN AjusteCompra
				WHEN OpeCompraRetiro THEN CompraRetiroEfec
				END as Operacion,
			LPAD(Movs.NumTransaccion, 6, '0') as NumeroTran, Movs.MontoOpe as MontoOpe, Corp.RazonSocial,
			Movs.TerminalID, Movs.NombreUbicaTer, Movs.DatosTiempoAire
		FROM TARDEBBITACORAMOVS Movs
		INNER JOIN TARJETADEBITO Tar ON Movs.TarjetaDebID = Tar.TarjetaDebID
		INNER JOIN CUENTASAHO Cta ON Tar.CuentaAhoID = Cta.CuentaAhoID
		INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
		INNER JOIN TIPOSCUENTAS TpoCta ON Cta.TipoCuentaID = TpoCta.TipoCuentaID
		INNER JOIN TIPOTARJETADEB TpoTar ON Tar.TipoTarjetaDebID = TpoTar.TipoTarjetaDebID
		LEFT JOIN CLIENTES Corp ON Cli.CorpRelacionado = Corp.ClienteID
		WHERE Movs.TarjetaDebID = Par_TarjetaDebID AND Movs.TipoOperacionID = OpeCompraTpoAire AND Movs.Estatus = Est_Procesado
			AND DATE(Movs.FechaHrOpe) >= DATE(Par_FechaInicio) and DATE(Movs.FechaHrOpe) <= DATE(Par_FechaFin);
	end if;

	if(Par_TipoOperacionID = OpeAjusteCompra) then
		SELECT
			Tar.TarjetaDebID, LPAD(Cli.ClienteID, 11, '0') as ClienteID, Cli.NombreCompleto, Cli.CorpRelacionado, LPAD(convert(Tar.CuentaAhoID, CHAR),11,'0') as CuentaAhoID,
			TpoCta.Descripcion as TipoCuenta, TpoTar.TipoTarjetaDebID,TpoTar.Descripcion as TipoTarjeta,
			date(Movs.FechaHrOpe) as Fecha,
			CASE Movs.TipoOperacionID
				WHEN OpeCompraNormal THEN CompraNormal
				WHEN OpeRetiroEfectivo THEN RetiroEfectivo
				WHEN OpeCompraTpoAire THEN CompraTpoAire
				WHEN OpeConsultaSaldo THEN ConsultaSaldo
				WHEN OpeAjusteCompra THEN AjusteCompra
				WHEN OpeCompraRetiro THEN CompraRetiroEfec
				END as Operacion,
			LPAD(Movs.NumTransaccion, 6, '0') as NumeroTran, Movs.MontoOpe as MontoOpe, Corp.RazonSocial,
			Movs.TerminalID, Movs.NombreUbicaTer, Movs.DatosTiempoAire
		FROM TARDEBBITACORAMOVS Movs
		INNER JOIN TARJETADEBITO Tar ON Movs.TarjetaDebID = Tar.TarjetaDebID
		INNER JOIN CUENTASAHO Cta ON Tar.CuentaAhoID = Cta.CuentaAhoID
		INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
		INNER JOIN TIPOSCUENTAS TpoCta ON Cta.TipoCuentaID = TpoCta.TipoCuentaID
		INNER JOIN TIPOTARJETADEB TpoTar ON Tar.TipoTarjetaDebID = TpoTar.TipoTarjetaDebID
		LEFT JOIN CLIENTES Corp ON Cli.CorpRelacionado = Corp.ClienteID
		WHERE Movs.TarjetaDebID = Par_TarjetaDebID AND Movs.TipoOperacionID = OpeAjusteCompra AND Movs.Estatus = Est_Procesado
			AND DATE(Movs.FechaHrOpe) >= DATE(Par_FechaInicio) and DATE(Movs.FechaHrOpe) <= DATE(Par_FechaFin);
	end if;

end if;

if(Par_TipoReporte = Rep_OperTarjeta) then
	SELECT
		Tar.TarjetaDebID, LPAD(Cli.ClienteID, 11, '0') as ClienteID, Cli.NombreCompleto, Cli.CorpRelacionado, LPAD(convert(Tar.CuentaAhoID, CHAR),11,'0') as CuentaAhoID,
		TpoCta.Descripcion as TipoCuenta, TpoTar.TipoTarjetaDebID,TpoTar.Descripcion as TipoTarjeta,
		date(Movs.FechaHrOpe) as Fecha,
		CASE Movs.TipoOperacionID
			WHEN OpeCompraNormal THEN CompraNormal
			WHEN OpeRetiroEfectivo THEN RetiroEfectivo
			WHEN OpeCompraTpoAire THEN CompraTpoAire
			WHEN OpeConsultaSaldo THEN ConsultaSaldo
			WHEN OpeAjusteCompra THEN AjusteCompra
			WHEN OpeCompraRetiro THEN CompraRetiroEfec
			END as Operacion,
		LPAD(Movs.NumTransaccion, 6, '0') as NumeroTran, Movs.MontoOpe as MontoOpe, Corp.RazonSocial,
		Movs.TerminalID, Movs.NombreUbicaTer, Movs.DatosTiempoAire
	FROM TARDEBBITACORAMOVS Movs
	INNER JOIN TARJETADEBITO Tar ON Movs.TarjetaDebID = Tar.TarjetaDebID
	INNER JOIN CUENTASAHO Cta ON Tar.CuentaAhoID = Cta.CuentaAhoID
	INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
	INNER JOIN TIPOSCUENTAS TpoCta ON Cta.TipoCuentaID = TpoCta.TipoCuentaID
	INNER JOIN TIPOTARJETADEB TpoTar ON Tar.TipoTarjetaDebID = TpoTar.TipoTarjetaDebID
	LEFT JOIN CLIENTES Corp ON Cli.CorpRelacionado = Corp.ClienteID
	WHERE Movs.TarjetaDebID = Par_TarjetaDebID AND Movs.Estatus = Est_Procesado
		AND DATE(Movs.FechaHrOpe) >= DATE(Par_FechaInicio) and DATE(Movs.FechaHrOpe) <= DATE(Par_FechaFin);

end if;

if(Par_TipoReporte = Rep_MovsTarDeb) then

select date(tmov.FechaHrOpe) as Fecha, tmov.TarjetaDebID,
			CASE tmov.TipoOperacionID
				WHEN OpeCompraNormal THEN CompraNormal
				WHEN OpeRetiroEfectivo THEN RetiroEfectivo
				WHEN OpeCompraTpoAire THEN CompraTpoAire
				WHEN OpeConsultaSaldo THEN ConsultaSaldo
				WHEN OpeAjusteCompra THEN AjusteCompra
				WHEN OpeCompraRetiro THEN CompraRetiroEfec

				END as Operacion, tmov.NumTransaccion as Aud_NumTransaccion,
			    tmov.MontoOpe, tmov.TerminalID, tmov.NombreUbicaTer,

			CASE tmov.Estatus
				WHEN Est_Procesado THEN MovExitoso
				WHEN Est_Registrado THEN MovRechazado
			END as TipoEstatus

		from TARDEBBITACORAMOVS tmov
	    WHERE DATE(FechaHrOpe) >= DATE(Par_FechaInicio) and DATE(FechaHrOpe) <= DATE(Par_FechaFin);

end if;

if(Par_TipoReporte = Rep_MovsTarExitosos) then

SELECT date(FechaHrOpe) as Fecha, TarjetaDebID,
			CASE TipoOperacionID
				WHEN OpeCompraNormal   THEN CompraNormal
				WHEN OpeRetiroEfectivo THEN RetiroEfectivo
				WHEN OpeCompraTpoAire THEN CompraTpoAire
				WHEN OpeConsultaSaldo THEN ConsultaSaldo
				WHEN OpeAjusteCompra  THEN AjusteCompra
				WHEN OpeCompraRetiro  THEN CompraRetiroEfec

		END as Operacion,    NumTransaccion as Aud_NumTransaccion, MontoOpe,
				TerminalID, NombreUbicaTer,
			CASE Estatus
				WHEN Est_Procesado THEN MovExitoso
				WHEN Est_Registrado THEN MovRechazado
			END as TipoEstatus
		FROM TARDEBBITACORAMOVS
	 	WHERE DATE(FechaHrOpe) >= DATE(Par_FechaInicio) and DATE(FechaHrOpe) <= DATE(Par_FechaFin)
		AND Estatus = Est_Procesado;
end if;


if(Par_TipoReporte = Rep_MovsRechachazados) then

SELECT date(FechaHrOpe) as Fecha, TarjetaDebID,
			CASE TipoOperacionID
				WHEN OpeCompraNormal THEN CompraNormal
				WHEN OpeRetiroEfectivo THEN RetiroEfectivo
				WHEN OpeCompraTpoAire THEN CompraTpoAire
				WHEN OpeConsultaSaldo THEN ConsultaSaldo
				WHEN OpeAjusteCompra THEN AjusteCompra
				WHEN OpeCompraRetiro THEN CompraRetiroEfec

				END as Operacion, NumTransaccion as Aud_NumTransaccion, MontoOpe,
			TerminalID, NombreUbicaTer,
			CASE Estatus
				WHEN Est_Procesado THEN MovExitoso
				WHEN Est_Registrado THEN MovRechazado
			END as TipoEstatus
		FROM TARDEBBITACORAMOVS
	 	WHERE DATE(FechaHrOpe) >= DATE(Par_FechaInicio) and DATE(FechaHrOpe) <= DATE(Par_FechaFin)
		AND Estatus = Est_Registrado;
end if;
END TerminaStore$$