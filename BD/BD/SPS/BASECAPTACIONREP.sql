-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BASECAPTACIONREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BASECAPTACIONREP`;
DELIMITER $$

CREATE PROCEDURE `BASECAPTACIONREP`(

	Par_FechaCorte 		DATE,       		-- Fecha de Corte en la que se consulta
	Par_NumReporte      TINYINT UNSIGNED,	-- Numero de Reporte (Excel o CSV)


	Aud_EmpresaID 		INT(11),			-- Parametros de Auditoria
	Aud_Usuario 		INT(11),			-- Parametros de Auditoria
	Aud_FechaActual 	DATE,				-- Parametros de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID 		VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal 		INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Rep_Excel       	INT;
DECLARE Rep_Csv				INT;
DECLARE Cadena_Vacia 		CHAR(1);
DECLARE Cadena_NO 			CHAR(2);
DECLARE Cadena_N 			CHAR(1);
DECLARE Vista 				CHAR(1);
DECLARE Ahorro 				CHAR(1);
DECLARE Fecha_Vacia 		DATE;
DECLARE Fecha_Sistema 		DATE;
DECLARE Par_FechaCorteAho 	DATE;
DECLARE Entero_Cero 		INT;
DECLARE Entero_Uno 			INT;
DECLARE Decimal_Cero 		DECIMAL(12,2);
DECLARE FactorPorcentaje 	DECIMAL(14,2);
DECLARE Vencimiento_Cap 	VARCHAR(50);
DECLARE Plazo_Cap 			VARCHAR(50);
DECLARE Sin_Rendimiento 	VARCHAR(50);
DECLARE Inversion_Vigente	CHAR(1);
DECLARE PagoRend_Mensual 	VARCHAR(7);
DECLARE PagoRend_Vencim 	VARCHAR(3);
DECLARE Cliente_Inst 		INT;
DECLARE Estado_Cancelada 	CHAR(1);
DECLARE Estado_Activa 		CHAR(1);
DECLARE Concepto_Capital 	INT;
DECLARE Con_FechaNula 		CHAR(20);
DECLARE EsAhorro 			VARCHAR(50);
DECLARE EsInversion 		VARCHAR(50);
DECLARE NoAplica 			VARCHAR(9);
DECLARE Var_DiasInversion	DECIMAL(14,2);
DECLARE Var_InicioPeriodo	DATE;
DECLARE Par_NumErr 			CHAR(20);
DECLARE Par_ErrMen 			CHAR(250);
DECLARE Nacional 			VARCHAR(8);
DECLARE Extranjero 			VARCHAR(10);
DECLARE Persona_Moral 		CHAR(1);
DECLARE FechaCorteInv 		DATE;
DECLARE Tipo_CtaAhorro		INT;
DECLARE Tipo_Inversion		INT;
DECLARE Var_FechaHisInv		DATE;
DECLARE Var_FechaMaxHis		DATE;

-- Asignacion de Constantes
SET Rep_Excel       	:= 	1;
SET Rep_Csv				:= 	2;
SET Cadena_Vacia 		:= '';
SET Cadena_NO 			:= 'NO';
SET Cadena_N 			:= 'N';
SET Vista 				:= 'V';
SET Ahorro 				:='A';
SET Fecha_Vacia 		:= '1900-01-01';
SET Entero_Cero 		:= 0;
SET Entero_Uno 			:= 1;
SET Decimal_Cero 		:= 0.0;
SET FactorPorcentaje 	:= 100;
SET Vencimiento_Cap		:= 'A LA VISTA';
SET Plazo_Cap			:= '1';
SET Sin_Rendimiento 	:= '0.00';
SET Inversion_Vigente	:= 'N';
SET PagoRend_Mensual	:= 'MENSUAL';
SET PagoRend_Vencim		:= 'LAV';
SET Cliente_Inst 		:= 1;
SET Estado_Cancelada	:= 'C';
SET Estado_Activa		:= 'A';
SET Concepto_Capital	:= 1;
SET Con_FechaNula		:= '1900-01-01 00:00:00';
SET EsAhorro 			:= 'DEPOSITOS DE AHORRO';
SET EsInversion 		:= 'A PLAZO';
SET NoAplica 			:= 'NO APLICA';
SET Nacional 			:= 'MEXICANO';
SET Extranjero 			:= 'EXTRANJERO';
SET Persona_Moral 		:= 'M';
SET	Tipo_CtaAhorro		:= 1;				-- Tipo de Instrumento: Cuenta de Ahorro
SET	Tipo_Inversion		:= 2;				-- Tipo de Instrumento: Inversion a Plazo


	SET FechaCorteInv 		:= DATE_ADD(Par_FechaCorte, INTERVAL 1 DAY);

	SELECT DiasInversion INTO Var_DiasInversion
		FROM PARAMETROSSIS;

	SET Var_InicioPeriodo:= DATE_FORMAT(Par_FechaCorte, '%Y-%m-01');

	SELECT FechaSistema INTO Fecha_Sistema
		FROM PARAMETROSSIS;


    select max(FechaCorte) into Var_FechaHisInv
		from HISINVERSIONES
        where FechaCorte <= Par_FechaCorte;

    set Var_FechaHisInv := ifnull(Var_FechaHisInv,Fecha_Vacia);

	DROP TABLE IF EXISTS BaseCap;
	CREATE TABLE BaseCap (
		NumCliente 				INT(11),
		NumCuenta 				BIGINT(12),
		NombreCliente			VARCHAR(200),
		NombreSucursal			VARCHAR(200),
		NumeroSucursal			INT(11),
		TipoDeposito			VARCHAR(200),
		TipoInversion			VARCHAR(200),
		FechaApertura			DATE,
		FechaVencimiento		DATE,
		Plazo 					INT(11),
		FormaPagRendimientos	VARCHAR(20),
		TasaAnual 				DECIMAL(14,4),
		DiasPorVencer 			INT(11),
		FechaUltDeposito 		DATE,
		MontoUltDeposito 		DECIMAL(14,2),
		Capital 				DECIMAL(14,2),
		IntDevengados 			DECIMAL(14,2),
		IntDevengadosMes 		DECIMAL(14,2),
		SaldoPromedio 			DECIMAL(14,2),
		SaldoTotalCieMes 		DECIMAL(14,2),
		GarantiaLiquida 		DECIMAL(14,2),
		PorcentajeGarantia 		DECIMAL(14,4),
		Producto 				VARCHAR(300),
		TipoPersona 			VARCHAR(2),
		GradoRiesgo 			CHAR(1),
		Actividad 				VARCHAR(300),
		Nacionalidad 			VARCHAR(50),
		FechaNacimiento 		DATE,
		RFC 					VARCHAR(13),
		Localidad 				VARCHAR(200),
		MontoCreditos			DECIMAL(14,2),
		TipoInstrumento			INT,
		PRIMARY KEY (NumCliente, NumCuenta, TipoInstrumento),
        index idx_tipo_in (NumCuenta,TipoInstrumento)
	);

	CREATE INDEX BaseCap_1 ON BaseCap (NumCuenta);


	-- --------------------------------------------------------------------------------------
	-- INVERSIONES A PLAZO, PRLV
	-- --------------------------------------------------------------------------------------
	INSERT INTO BaseCap (
		NumCliente,				NumCuenta,			NombreCliente,		NombreSucursal, 	NumeroSucursal,
		TipoDeposito,			TipoInversion,		FechaApertura, 		FechaVencimiento,	Plazo,
		FormaPagRendimientos,	TasaAnual,			FechaUltDeposito,	MontoUltDeposito,	Capital,
		GarantiaLiquida,		PorcentajeGarantia,	Producto, 			TipoPersona,		GradoRiesgo,
		Actividad, 				Nacionalidad,		FechaNacimiento, 	RFC,				Localidad,
		DiasPorVencer,			IntDevengados,		SaldoTotalCieMes,	IntDevengadosMes,	SaldoPromedio,
		MontoCreditos,			TipoInstrumento)

	SELECT 	Inv.ClienteID AS NumCliente,
			Inv.InversionID AS NumCuenta,
			Cli.NombreCompleto AS NombreCliente,
			suc.NombreSucurs AS NombreSucursal,
			Cli.SucursalOrigen AS NumeroSucursal,
			EsInversion AS TipoDeposito,
			Cat.Descripcion AS TipoInversion,
			Inv.FechaInicio AS FechaApertura,
			Inv.FechaVencimiento AS FechaVencimiento,
			Inv.Plazo AS Plazo,
			PagoRend_Vencim AS FormaPagRendimientos,
			ROUND(Inv.Tasa / FactorPorcentaje, 4) AS TasaAnual,
			Inv.FechaInicio AS FechaUltDeposito,
			Inv.Monto AS MontoUltDeposito,
			Inv.Monto AS Capital,
			Decimal_Cero AS GarantiaLiquida,
			Decimal_Cero AS PorcentajeGarantia,
			CONVERT(CONCAT('Inversion a Plazo Fijo',' A ', Inv.Plazo, ' DIAS'),CHAR) AS Producto,
			Cli.TipoPersona AS TipoPersona,
			Cli.NivelRiesgo AS GradoRiesgo,
			Act.Descripcion AS Actividad,
			CASE WHEN Cli.Nacion = Cadena_N THEN Nacional
				 ELSE Extranjero
			END AS Nacionalidad,
			CASE WHEN Cli.TipoPersona = Persona_Moral THEN Cli.FechaConstitucion
				 ELSE Cli.FechaNacimiento
			END AS FechaNacimiento,
			Cli.RFCOficial,
			IFNULL(Loc.NombreLocalidad,Cadena_Vacia),
			DATEDIFF(Inv.FechaVencimiento, Par_FechaCorte) AS DiasPorVencer,
			Entero_Cero AS IntDevengados,
			Inv.Monto   AS SaldoTotalCieMes,
			Entero_Cero AS IntDevengadosMes,

			Inv.Monto + ROUND(Tasa * Inv.Monto/(FactorPorcentaje * Var_DiasInversion),2) AS SaldoPromedio,
			Entero_Cero AS MontoCreditos,
			Tipo_Inversion AS TipoInstrumento
		FROM INVERSIONES Inv
		INNER JOIN CLIENTES Cli ON Cli.ClienteID = Inv.ClienteID
		INNER JOIN CATINVERSION Cat ON Cat.TipoInversionID = Inv.TipoInversionID
		INNER JOIN SUCURSALES suc ON suc.SucursalID = Cli.SucursalOrigen
		INNER JOIN ACTIVIDADESINEGI Act ON Act.ActividadINEGIID = Cli.ActividadINEGI
		LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
		LEFT OUTER JOIN LOCALIDADREPUB Loc ON Loc.EstadoID = Dir.EstadoID AND Loc.MunicipioID = Dir.MunicipioID AND Loc.LocalidadID = Dir.LocalidadID

		WHERE Inv.ClienteID<>Cliente_Inst
		  AND Inv.FechaInicio <= Par_FechaCorte
		  AND (Inv.Estatus = 'N'
				OR (	Inv.Estatus = 'P'
					AND Inv.FechaVencimiento != '1900-01-01'
					AND Inv.FechaVencimiento > Par_FechaCorte)
				OR ( 	Inv.Estatus = 'C'
					AND Inv.FechaVenAnt != '1900-01-01'
					AND Inv.FechaVenAnt > Par_FechaCorte) )
		  AND Dir.Oficial = 'S';

        -- Acualiza el saldo inicial
        update BaseCap cap, HISINVERSIONES his
			set cap.IntDevengados		= his.SaldoProvision,
				cap.SaldoTotalCieMes	= cap.SaldoTotalCieMes + his.SaldoProvision
        where cap.NumCuenta = his.InversionID
        and his.FechaCorte = Var_FechaHisInv;

        -- Saldos
		drop table if exists TMP_SALDOSINVER;
		create temporary table TMP_SALDOSINVER(
			InversionID 	int primary key,
            MontoInteres 	decimal(18,2),
            DevengadoMes 	decimal(18,2),
            PagadoMes 		decimal(18,2)
        );

        insert into TMP_SALDOSINVER
		select InversionID,sum(case when NatMovimiento = 'A' then Monto * -1 else Monto end) as Monto,
			   sum(case when NatMovimiento = 'C' then Monto else 0 end) as DevengadoMes,
			   sum(case when NatMovimiento = 'A' then Monto else 0 end) as PagadoMes
		from INVERSIONESMOV WHERE Fecha > Var_FechaHisInv and Fecha <= Par_FechaCorte
		group by InversionID;

		update BaseCap cap, TMP_SALDOSINVER his
			set cap.IntDevengados		= cap.IntDevengados + his.MontoInteres ,
				cap.SaldoTotalCieMes	= cap.SaldoTotalCieMes + his.MontoInteres	,
                cap.IntDevengadosMes    = his.DevengadoMes
        where cap.NumCuenta = his.InversionID;

	-- --------------------------------------------------------------------------------------
	-- CUENTAS DE AHORRO
	-- --------------------------------------------------------------------------------------
	SET Var_FechaMaxHis := (SELECT MAX(Fecha) FROM `HIS-CUENTASAHO` );
	SET Var_FechaMaxHis := IFNULL(Var_FechaMaxHis,Fecha_Vacia);

	IF (Par_FechaCorte < Fecha_Sistema) THEN

		SET Par_FechaCorteAho := (SELECT MAX(Fecha) FROM `HIS-CUENTASAHO` WHERE Fecha <= Par_FechaCorte);

		INSERT INTO BaseCap (
			NumCliente,				NumCuenta, 			NombreCliente,		NombreSucursal, 	NumeroSucursal,
			TipoDeposito,			TipoInversion, 		FechaApertura,		FechaVencimiento,	Plazo,
			FormaPagRendimientos,	TasaAnual,			Capital,			IntDevengados, 		SaldoTotalCieMes,
			GarantiaLiquida,		PorcentajeGarantia, Producto, 			TipoPersona,		GradoRiesgo,
			Actividad,				Nacionalidad,		FechaNacimiento,	RFC,				Localidad,
			DiasPorVencer,			IntDevengadosMes, 	SaldoPromedio,		FechaUltDeposito,	MontoUltDeposito,
			MontoCreditos,			TipoInstrumento)

		SELECT	His.ClienteID AS NumCliente,
				His.CuentaAhoID AS NumCuenta,
				Cli.NombreCompleto AS NombreCliente,
				Suc.NombreSucurs AS NombreSucursal,
				SucursalOrigen AS NumeroSucursal,
				CASE WHEN Tip.ClasificacionConta = Vista THEN Vencimiento_Cap
					 WHEN Tip.ClasificacionConta = Ahorro THEN EsAhorro
				END AS TipoDeposito,
				Cadena_Vacia AS TipoInversion,
				IFNULL(His.FechaApertura, Fecha_Vacia) AS FechaApertura,
				IFNULL(His.Fecha, Fecha_Vacia) AS FechaVencimiento,
				Entero_Uno AS Plazo,
				CASE WHEN Tip.GeneraInteres = 'S' THEN PagoRend_Mensual
					 ELSE Cadena_Vacia
				END AS FormaPagRendimientos,
				CASE WHEN Tip.GeneraInteres = 'S' THEN ROUND(His.TasaInteres / FactorPorcentaje, 4)
				     ELSE Entero_Cero
				END AS TasaAnual,

				His.Saldo AS Capital,
				Decimal_Cero AS IntDevengados,
				His.Saldo AS SaldoTotalCieMes,
				Decimal_Cero AS GarantiaLiquida,
				Decimal_Cero AS PorcentajeGarantia,
				Tip.Descripcion AS Producto,
				Cli.TipoPersona AS TipoPersona,
				Cli.NivelRiesgo AS GradoRiesgo,
				Act.Descripcion AS Actividad,

				CASE WHEN Cli.Nacion = Cadena_N THEN Nacional
					 ELSE Extranjero
				END AS Nacionalidad,
				CASE WHEN Cli.TipoPersona = Persona_Moral THEN Cli.FechaConstitucion
					 ELSE Cli.FechaNacimiento
				END AS FechaNacimiento,
				Cli.RFCOficial,
				IFNULL(Loc.NombreLocalidad, Cadena_Vacia),
				Entero_Cero AS DiasPorVencer,
				Decimal_Cero AS IntDevengadosMes,
				His.SaldoProm AS SaldoPromedio,
				Fecha_Vacia AS FechaUltDeposito,
				Entero_Cero AS MontoUltDeposito,
				Entero_Cero AS MontoCreditos,
				Tipo_CtaAhorro AS TipoInstrumento

		FROM `HIS-CUENTASAHO` His
		INNER JOIN TIPOSCUENTAS Tip ON His.TipoCuentaID = Tip.TipoCuentaID
		INNER JOIN CLIENTES Cli ON Cli.ClienteID = His.ClienteID
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID = His.SucursalID
		INNER JOIN ACTIVIDADESINEGI Act ON Act.ActividadINEGIID = Cli.ActividadINEGI
		LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
		LEFT OUTER JOIN LOCALIDADREPUB Loc ON Loc.EstadoID = Dir.EstadoID AND Loc.MunicipioID = Dir.MunicipioID AND Loc.LocalidadID = Dir.LocalidadID
		WHERE His.ClienteID <> Cliente_Inst
		  AND Tip.TipoCuentaID = His.TipoCuentaID
		  AND His.ClienteID = Cli.ClienteID
		  AND Suc.SucursalID = His.SucursalID
		  AND Act.ActividadINEGIID = Cli.ActividadINEGI
		  AND His.Fecha = Par_FechaCorteAho
		  AND Dir.Oficial = 'S'
		  AND (His.Estatus IN ('A', 'B'));

        IF Par_FechaCorteAho < Par_FechaCorte THEN
			INSERT INTO BaseCap (
				NumCliente,				NumCuenta, 			NombreCliente,		NombreSucursal, 	NumeroSucursal,
				TipoDeposito,			TipoInversion, 		FechaApertura,		FechaVencimiento,	Plazo,
				FormaPagRendimientos,	TasaAnual,			Capital,			IntDevengados, 		SaldoTotalCieMes,
				GarantiaLiquida,		PorcentajeGarantia, Producto, 			TipoPersona,		GradoRiesgo,
				Actividad,				Nacionalidad,		FechaNacimiento,	RFC,				Localidad,
				DiasPorVencer,			IntDevengadosMes, 	SaldoPromedio,		FechaUltDeposito,	MontoUltDeposito,
				MontoCreditos,			TipoInstrumento)
			SELECT	His.ClienteID AS NumCliente,
					His.CuentaAhoID AS NumCuenta,
					Cli.NombreCompleto AS NombreCliente,
					Suc.NombreSucurs AS NombreSucursal,
					SucursalOrigen AS NumeroSucursal,
					CASE WHEN Tip.ClasificacionConta = Vista THEN Vencimiento_Cap
						 WHEN Tip.ClasificacionConta = Ahorro THEN EsAhorro
					END AS TipoDeposito,
					Cadena_Vacia AS TipoInversion,
					IFNULL(His.FechaApertura, Fecha_Vacia) AS FechaApertura,
					Par_FechaCorte AS FechaVencimiento,
					Entero_Uno AS Plazo,
					CASE WHEN Tip.GeneraInteres = 'S' THEN PagoRend_Mensual
						 ELSE Cadena_Vacia
					END AS FormaPagRendimientos,
					CASE WHEN Tip.GeneraInteres = 'S' THEN ROUND(His.TasaInteres / FactorPorcentaje, 4)
						 ELSE Entero_Cero
					END AS TasaAnual,
					Decimal_Cero AS Capital,
					Decimal_Cero AS IntDevengados,
					Decimal_Cero AS SaldoTotalCieMes,
					Decimal_Cero AS GarantiaLiquida,
					Decimal_Cero AS PorcentajeGarantia,
					Tip.Descripcion AS Producto,
					Cli.TipoPersona AS TipoPersona,
					Cli.NivelRiesgo AS GradoRiesgo,
					Act.Descripcion AS Actividad,
					CASE WHEN Cli.Nacion = Cadena_N THEN Nacional
						 ELSE Extranjero
					END AS Nacionalidad,
					CASE WHEN Cli.TipoPersona = Persona_Moral THEN Cli.FechaConstitucion
						 ELSE Cli.FechaNacimiento
					END AS FechaNacimiento,
					Cli.RFCOficial,
					IFNULL(Loc.NombreLocalidad, Cadena_Vacia),
					Entero_Cero AS DiasPorVencer,
					Decimal_Cero AS IntDevengadosMes,
					Decimal_Cero AS SaldoPromedio,
					Fecha_Vacia AS FechaUltDeposito,
					Entero_Cero AS MontoUltDeposito,
					Entero_Cero AS MontoCreditos,
					Tipo_CtaAhorro AS TipoInstrumento
			FROM CUENTASAHO His
			INNER JOIN TIPOSCUENTAS Tip ON His.TipoCuentaID = Tip.TipoCuentaID
			INNER JOIN CLIENTES Cli ON Cli.ClienteID = His.ClienteID
			INNER JOIN SUCURSALES Suc ON Suc.SucursalID = His.SucursalID
			INNER JOIN ACTIVIDADESINEGI Act ON Act.ActividadINEGIID = Cli.ActividadINEGI
			LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
			LEFT OUTER JOIN LOCALIDADREPUB Loc ON Loc.EstadoID = Dir.EstadoID AND Loc.MunicipioID = Dir.MunicipioID AND Loc.LocalidadID = Dir.LocalidadID
			WHERE His.ClienteID <> Cliente_Inst
			  AND Tip.TipoCuentaID = His.TipoCuentaID
			  AND His.ClienteID = Cli.ClienteID
			  AND Suc.SucursalID = His.SucursalID
			  AND Act.ActividadINEGIID = Cli.ActividadINEGI
			  AND Dir.Oficial = 'S'
              AND His.FechaApertura > Par_FechaCorteAho and His.FechaApertura <= Par_FechaCorte ;
			drop table if exists tmp_saldo_aho_mes;
            create temporary table tmp_saldo_aho_mes(
				CuentaAhoID bigint primary key,
                Saldo 		decimal(16,2)
            );
            IF Par_FechaCorte > Var_FechaMaxHis THEN
	            insert into tmp_saldo_aho_mes
	            SELECT
	            cap.NumCuenta, sum(case when mov.NatMovimiento = 'A' then mov.CantidadMov else (mov.CantidadMov * -1) end) as Saldo
	            FROM CUENTASAHOMOV mov,BaseCap cap
	            WHERE cap.NumCuenta =  mov.CuentaAhoID
	            and cap.TipoInstrumento = Tipo_CtaAhorro
	            and mov.Fecha > Par_FechaCorteAho and mov.Fecha <= Par_FechaCorte
	            group by cap.NumCuenta;
	ELSE
	        	insert into tmp_saldo_aho_mes
	            SELECT
	            cap.NumCuenta, sum(case when mov.NatMovimiento = 'A' then mov.CantidadMov else (mov.CantidadMov * -1) end) as Saldo
	            FROM `HIS-CUENAHOMOV` mov,BaseCap cap
	            WHERE cap.NumCuenta =  mov.CuentaAhoID
	            and cap.TipoInstrumento = Tipo_CtaAhorro
	            and mov.Fecha > Par_FechaCorteAho and mov.Fecha <= Par_FechaCorte
	            group by cap.NumCuenta;

	        END IF;
            update BaseCap cap,tmp_saldo_aho_mes sal
				set cap.Capital = cap.Capital + sal.Saldo,
					cap.SaldoTotalCieMes = cap.SaldoTotalCieMes + sal.Saldo
			where cap.NumCuenta = sal.CuentaAhoID
            and cap.TipoInstrumento = Tipo_CtaAhorro;
        END IF;
	ELSE
		INSERT INTO BaseCap (
			NumCliente, 			NumCuenta, 			NombreCliente,		NombreSucursal, 	NumeroSucursal,
			TipoDeposito,			TipoInversion, 		FechaApertura,		FechaVencimiento,	Plazo,
			FormaPagRendimientos, 	TasaAnual,			Capital,			IntDevengados, 		SaldoTotalCieMes,
			GarantiaLiquida,		PorcentajeGarantia, Producto, 			TipoPersona,		GradoRiesgo,
			Actividad, 				Nacionalidad,		FechaNacimiento,	RFC,				Localidad,
			DiasPorVencer,			IntDevengadosMes,	SaldoPromedio,		FechaUltDeposito,	MontoUltDeposito,
			MontoCreditos,			TipoInstrumento)

		SELECT 	His.ClienteID AS NumCliente,
				His.CuentaAhoID AS NumCuenta,
				Cli.NombreCompleto AS NombreCliente,
				Suc.NombreSucurs AS NombreSucursal,
				SucursalOrigen AS NumeroSucursal,
				CASE WHEN Tip.ClasificacionConta = Vista THEN Vencimiento_Cap
					 WHEN Tip.ClasificacionConta = Ahorro THEN EsAhorro
				END AS TipoDeposito,
				Cadena_Vacia AS TipoInversion,
			IFNULL(His.FechaApertura, Fecha_Vacia) AS FechaApertura,
			Fecha_Vacia AS FechaVencimiento,
			Entero_Uno AS Plazo,
			CASE WHEN Tip.GeneraInteres='S' THEN PagoRend_Mensual
				 ELSE Cadena_Vacia
			END AS FormaPagRendimientos,
			CASE WHEN Tip.GeneraInteres = 'S' THEN ROUND(IFNULL(Tas.Tasa, Entero_Cero) / FactorPorcentaje, 4)
				 ELSE Entero_Cero
			END AS TasaAnual,
			His.Saldo AS Capital,
			Decimal_Cero AS IntDevengados,
			His.Saldo AS SaldoTotalCieMes,
			Decimal_Cero AS GarantiaLiquida,
			Decimal_Cero AS PorcentajeGarantia,
			Tip.Descripcion AS Producto,
			Cli.TipoPersona AS TipoPersona,
			Cli.NivelRiesgo AS GradoRiesgo,
			Act.Descripcion AS Actividad,
			CASE WHEN Cli.Nacion = Cadena_N THEN Nacional
				 ELSE Extranjero
			END AS Nacionalidad,
			CASE WHEN Cli.TipoPersona = Persona_Moral THEN Cli.FechaConstitucion
				 ELSE Cli.FechaNacimiento
			END AS FechaNacimiento,
			Cli.RFCOficial,
			IFNULL(Loc.NombreLocalidad,Cadena_Vacia),
			Entero_Cero AS DiasPorVencer,
			Decimal_Cero AS IntDevengadosMes,
			His.SaldoProm AS SaldoPromedio,
			Fecha_Vacia AS FechaUltDeposito,
			Entero_Cero AS MontoUltDeposito,
			Entero_Cero AS MontoCreditos,
			Tipo_CtaAhorro AS TipoInstrumento

		FROM CUENTASAHO His
		INNER JOIN TIPOSCUENTAS Tip ON His.TipoCuentaID = Tip.TipoCuentaID
		INNER JOIN CLIENTES Cli ON Cli.ClienteID = His.ClienteID
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID = His.SucursalID
		LEFT JOIN TASASAHORRO Tas ON Tas.TipoCuentaID = Tip.TipoCuentaID AND Tas.TipoPersona = Cli.TipoPersona AND
									 Tas.MonedaID = His.MonedaID AND His.SaldoProm BETWEEN Tas.MontoInferior AND Tas.MontoSuperior


		INNER JOIN ACTIVIDADESINEGI Act ON Act.ActividadINEGIID = Cli.ActividadINEGI
		LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID AND  Dir.Oficial = 'S'
		LEFT OUTER JOIN LOCALIDADREPUB Loc ON Loc.EstadoID = Dir.EstadoID AND Loc.MunicipioID = Dir.MunicipioID AND Loc.LocalidadID = Dir.LocalidadID
		WHERE His.ClienteID <> Cliente_Inst
		  AND His.FechaApertura <= Par_FechaCorte
		  AND His.Estatus IN ('A', 'B');

	END IF;


	-- --------------------------------------------------------------------------------------
	-- CUENTAS DE AHORRO, FECHA Y MONTO DE ULTIMO MOVIMIENTO
	-- --------------------------------------------------------------------------------------
	DROP TABLE IF EXISTS TMPFECHADEPOSITO;
	CREATE TEMPORARY TABLE TMPFECHADEPOSITO (
		Fecha		DATE,
		CantidadMov	DECIMAL(12,2),
		CuentaAhoID	BIGINT(12),
		NumeroMov	BIGINT(20),
		PRIMARY KEY (CuentaAhoID)
	);

	CREATE INDEX TMPFECHADEPOSITO_1 ON TMPFECHADEPOSITO (CuentaAhoID);

	-- La Consulta es de este Mes
	IF (Par_FechaCorte >= DATE_FORMAT(Fecha_Sistema, '%Y-%m-01')) THEN

		INSERT INTO TMPFECHADEPOSITO
			SELECT MAX(H.Fecha) AS Fecha, Entero_Cero, H.CuentaAhoID, MAX(H.NumeroMov)
				FROM CUENTASAHOMOV H,
					  BaseCap F
				WHERE H.CuentaAhoID = F.NumCuenta
				  AND H.NatMovimiento = 'A'
				  AND H.TipoMovAhoID IN (10, 102, 14, 16, 12, 23)
				  AND H.Fecha <= Par_FechaCorte
				GROUP BY H.CuentaAhoID;

		UPDATE TMPFECHADEPOSITO Tem, CUENTASAHOMOV Mov SET
			Tem.CantidadMov = Mov.CantidadMov

			WHERE Tem.CuentaAhoID = Mov.CuentaAhoID
			  AND Tem.Fecha = Mov.Fecha
			  AND Tem.NumeroMov = Mov.NumeroMov;

		UPDATE BaseCap F, TMPFECHADEPOSITO H SET
			F.FechaUltDeposito = H.Fecha,
			F.MontoUltDeposito = H.CantidadMov

			WHERE F.NumCuenta = H.CuentaAhoID;

		DROP TABLE IF EXISTS TMPFECHADEPOSITO;


	END IF;

	DROP TABLE IF EXISTS TMPFECHADEPOSITO;
	CREATE TEMPORARY TABLE TMPFECHADEPOSITO (
		Fecha		DATE,
		CantidadMov	DECIMAL(12,2),
		CuentaAhoID	BIGINT(12),
		NumeroMov	BIGINT(20),
		PRIMARY KEY (CuentaAhoID)
	);

	CREATE INDEX TMPFECHADEPOSITO_1 ON TMPFECHADEPOSITO (CuentaAhoID);


	INSERT INTO TMPFECHADEPOSITO
		SELECT MAX(Mov.Fecha) AS Fecha, Entero_Cero, Mov.CuentaAhoID, MAX(Mov.NumeroMov)
			FROM BaseCap Tem,
				`HIS-CUENAHOMOV` Mov

			WHERE Tem.FechaUltDeposito = Fecha_Vacia			-- Si ya tiene una Fecha, que no Busque de nuevo
			  AND Mov.CuentaAhoID = Tem.NumCuenta
			  AND Mov.NatMovimiento = 'A'
			  AND Mov.TipoMovAhoID IN (10, 102, 14, 16, 12, 23)
			  AND Mov.Fecha < Fecha_Sistema
			GROUP BY Mov.CuentaAhoID;


	UPDATE TMPFECHADEPOSITO Tem, `HIS-CUENAHOMOV` Mov SET
		Tem.CantidadMov = Mov.CantidadMov

		WHERE Tem.CuentaAhoID = Mov.CuentaAhoID
		  AND Tem.Fecha = Mov.Fecha
		  AND Tem.NumeroMov = Mov.NumeroMov;

	UPDATE BaseCap F, TMPFECHADEPOSITO H SET
		F.FechaUltDeposito = H.Fecha,
		F.MontoUltDeposito = H.CantidadMov

		WHERE F.NumCuenta = H.CuentaAhoID;

	DROP TABLE IF EXISTS TMPFECHADEPOSITO;

	-- --------------------------------------------------------------------------------------
	-- GARANTIA LIQUIDA. INVERSIONES
	-- --------------------------------------------------------------------------------------

	DROP TABLE IF EXISTS TMPCREDITOINVGARFOC;
	CREATE TEMPORARY TABLE TMPCREDITOINVGARFOC(
		MontoEnGar		DECIMAL(12,2),
		NumCuenta		INT(11),
		MontoCredito	DECIMAL(14,2),
		PRIMARY KEY (NumCuenta)
	);
	CREATE INDEX INDEX_TMPCREDITOINVGARFOC_1 ON TMPCREDITOINVGARFOC (NumCuenta);

	-- Garantias de Inversiones Actuales
	INSERT INTO TMPCREDITOINVGARFOC
		SELECT	SUM(T.MontoEnGar) AS MontoEnGar,
				T.InversionID AS NumCuenta,
				SUM(Cre.MontoCredito) AS MontoCredito
		FROM BaseCap F,
			 CREDITOINVGAR T,
			 CREDITOS Cre
		WHERE F.NumCuenta = T.InversionID
		  AND FechaAsignaGar <= Par_FechaCorte
		  AND T.CreditoID = Cre.CreditoID
		  AND F.TipoInstrumento = Tipo_Inversion
		  AND (	Cre.Estatus IN ('V', 'B')
				OR	(		Cre.Estatus IN ('P', 'K')
					  AND	Cre.FechTerminacion > Par_FechaCorte
					)
				)
		GROUP BY T.InversionID;


	UPDATE BaseCap F, TMPCREDITOINVGARFOC T SET
		F.GarantiaLiquida = T.MontoEnGar,
		F.MontoCreditos	= T.MontoCredito,
		F.PorcentajeGarantia = (T.MontoEnGar / T.MontoCredito) * FactorPorcentaje

		WHERE F.NumCuenta = T.NumCuenta
        AND F.TipoInstrumento = Tipo_Inversion;

	DROP TABLE IF EXISTS TMPCREDITOINVGARFOC;

	-- Garantias de Inversiones del Historico
	DROP TABLE IF EXISTS TMPHISCREDITOINVGAR;
	CREATE TEMPORARY TABLE TMPHISCREDITOINVGAR(
		MontoEnGar 		DECIMAL(12,2),
		NumCuenta 		INT(11),
		MontoCredito	DECIMAL(14,2),
		PRIMARY KEY (NumCuenta)
	);
	CREATE INDEX INDEX_TMPHISCREDITOINVGAR_1 ON TMPHISCREDITOINVGAR (NumCuenta);

	INSERT INTO TMPHISCREDITOINVGAR
		SELECT	SUM(Gar.MontoEnGar) AS MontoEnGar,
				Gar.InversionID AS NumCuenta,
				SUM(Cre.MontoCredito) AS MontoCredito
		FROM BaseCap Tmp,
			 HISCREDITOINVGAR Gar,
			 CREDITOS Cre

		WHERE Gar.Fecha > Par_FechaCorte
		  AND Gar.FechaAsignaGar <= Par_FechaCorte

		  AND Gar.InversionID = Tmp.NumCuenta
		  AND Gar.CreditoID = Cre.CreditoID
		  AND Tmp.TipoInstrumento = Tipo_Inversion
		  AND (	Cre.Estatus IN ('V', 'B')
				OR	(		Cre.Estatus IN ('P', 'K')
					  AND	Cre.FechTerminacion > Par_FechaCorte
					)
				)
		GROUP BY Gar.InversionID;

	UPDATE BaseCap Tmp, TMPHISCREDITOINVGAR Gar SET
		Tmp.GarantiaLiquida 	= IFNULL(Tmp.GarantiaLiquida, Decimal_Cero) + Gar.MontoEnGar,
		Tmp.MontoCreditos		= IFNULL(Tmp.MontoCreditos, Decimal_Cero) + Gar.MontoCredito,
		Tmp.PorcentajeGarantia 	= (	(IFNULL(Tmp.GarantiaLiquida, Decimal_Cero) + Gar.MontoEnGar) /
									(IFNULL(Tmp.MontoCreditos, Decimal_Cero) + Gar.MontoCredito)) * FactorPorcentaje

		WHERE Gar.NumCuenta = Tmp.NumCuenta
        AND Tmp.TipoInstrumento = Tipo_Inversion;

	DROP TABLE IF EXISTS TMPHISCREDITOINVGAR;

	-- Garantias de Cuentas de Ahorro

	DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;
	CREATE TEMPORARY TABLE TMPMONTOGARCUENTAS (
		CuentaAhoID		BIGINT(12),
		Saldo			DECIMAL(12,2),
		MontoCredito	DECIMAL(14,2),
		PRIMARY KEY (CuentaAhoID)
	);

	CREATE INDEX id_indexCuentaAhoID ON TMPMONTOGARCUENTAS (CuentaAhoID);

	INSERT INTO TMPMONTOGARCUENTAS
		SELECT 	blo.CuentaAhoID AS CuentaAhoID,
				SUM(CASE WHEN blo.NatMovimiento = 'B' THEN IFNULL(blo.MontoBloq, Entero_Cero)
						 ELSE IFNULL(blo.MontoBloq, Entero_Cero) * -1
					END)  AS Saldo,
				SUM(Cre.MontoCredito) AS MontoCredito
		FROM BLOQUEOS blo
		LEFT OUTER JOIN CREDITOS Cre ON Cre.CreditoID = blo.Referencia
		WHERE DATE(blo.FechaMov) <= Par_FechaCorte
		  AND blo.TiposBloqID = 8
		GROUP BY blo.CuentaAhoID;

	UPDATE BaseCap Tmp, TMPMONTOGARCUENTAS Blo SET
		Tmp.GarantiaLiquida = IFNULL(Tmp.GarantiaLiquida, Decimal_Cero) + Blo.Saldo,
		Tmp.PorcentajeGarantia = (Blo.Saldo / Blo.MontoCredito) * FactorPorcentaje

		WHERE Tmp.NumCuenta = Blo.CuentaAhoID
		  AND Tmp.TipoInstrumento = Tipo_CtaAhorro;

	DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;

	-- ------------------------------------------------------------------------------------------------------------------------

	IF( Par_NumReporte = Rep_Excel) THEN

		SELECT	NumCliente,	NumCuenta,	NombreCliente,	NombreSucursal, NumeroSucursal,
				Producto, TipoPersona,	GradoRiesgo, 	Actividad, 		Localidad, Nacionalidad,
				DATE_FORMAT(FechaNacimiento, '%d/%m/%Y') AS FechaNacimiento,
				IFNULL(RFC, Cadena_Vacia) AS RFC,	TipoDeposito,
				TipoInversion,
				DATE_FORMAT(FechaApertura, '%d/%m/%Y') AS FechaApertura,
				DATE_FORMAT(FechaVencimiento, '%d/%m/%Y') AS FechaVencimiento,
				Plazo, FormaPagRendimientos,

				CASE WHEN IFNULL(TasaAnual, Entero_Cero) <= Entero_Cero THEN Sin_Rendimiento
					 ELSE CONVERT(TasaAnual, CHAR)
				END AS TasaAnual,

				DiasPorVencer,
				CASE WHEN IFNULL(FechaUltDeposito, Fecha_Vacia) = Fecha_Vacia THEN Cadena_Vacia
					 ELSE DATE_FORMAT(FechaUltDeposito, '%d/%m/%Y')
				END AS FechaUltDeposito,

				CASE WHEN IFNULL(MontoUltDeposito, Entero_Cero) = Entero_Cero THEN Cadena_Vacia
					 ELSE CONVERT(MontoUltDeposito, CHAR)
				END AS MontoUltDeposito,


				ROUND(Capital,2) AS Capital,
				ROUND(IntDevengados,2) AS IntDevengados,
				ROUND(IntDevengadosMes, 2) AS IntDevengadosMes, SaldoPromedio,
				ROUND(IFNULL(Capital,0),2) + ROUND(IFNULL(IntDevengados,0),2) AS SaldoTotalCieMes,
				CASE WHEN GarantiaLiquida > Decimal_Cero THEN CONVERT(GarantiaLiquida, CHAR)
					 ELSE Cadena_NO
				END AS GarantiaLiquida,
				CASE WHEN PorcentajeGarantia > Decimal_Cero THEN CONVERT(PorcentajeGarantia,CHAR)
					 ELSE Cadena_Vacia END AS PorcentajeGarantia

			FROM BaseCap
			ORDER BY NumCliente, NumCuenta;
	ELSE



		SELECT	CONCAT(CONVERT(NumCliente, CHAR),';',
					   CONVERT(NumCuenta, CHAR),';',
						NombreCliente,';',
						NombreSucursal, ';',
					   CONVERT(NumeroSucursal, CHAR),';',
					    Producto,';',TipoPersona,';',GradoRiesgo,';',Actividad, ';', Localidad,';',Nacionalidad,';',
						DATE_FORMAT(IFNULL(FechaNacimiento, Fecha_Vacia), '%d/%m/%Y'),';',
						IFNULL(RFC, Cadena_Vacia),';', TipoDeposito,';', TipoInversion,';',
						DATE_FORMAT(IFNULL(FechaApertura, Fecha_Vacia), '%d/%m/%Y'),';',
						DATE_FORMAT(IFNULL(FechaVencimiento, Fecha_Vacia), '%d/%m/%Y'),';',
						CONVERT(Plazo, CHAR),';',
						FormaPagRendimientos,';',
						CONVERT(CASE WHEN IFNULL(TasaAnual, Entero_Cero) <= Entero_Cero THEN Sin_Rendimiento
								 ELSE CONVERT(TasaAnual, CHAR)
							END, CHAR),';',

						CONVERT(DiasPorVencer, CHAR),';',
						CASE WHEN IFNULL(FechaUltDeposito, Fecha_Vacia) = Fecha_Vacia THEN Cadena_Vacia
							ELSE DATE_FORMAT(FechaUltDeposito, '%d/%m/%Y')
						END,';',
						CASE WHEN IFNULL(MontoUltDeposito, Entero_Cero) = Entero_Cero THEN Cadena_Vacia
							 ELSE CONVERT(MontoUltDeposito, CHAR)
						END,';',
						CONVERT(ROUND(IFNULL(Capital, Entero_Cero),2), CHAR),';',
						CONVERT(ROUND(IFNULL(IntDevengados, Entero_Cero),2), CHAR),';',
						CONVERT(ROUND(IFNULL(IntDevengadosMes, Entero_Cero), 2) , CHAR),';',
						CONVERT(ROUND(IFNULL(SaldoPromedio, Entero_Cero), 2), CHAR),';',
						CONVERT(ROUND(IFNULL(Capital,Entero_Cero),2) + ROUND(IFNULL(IntDevengados,Entero_Cero),2), CHAR),';',

						CASE WHEN IFNULL(GarantiaLiquida,Entero_Cero) > Decimal_Cero THEN CONVERT(GarantiaLiquida, CHAR)
							 ELSE Cadena_NO
						END, ';',

						CASE WHEN IFNULL(PorcentajeGarantia, Entero_Cero) > Decimal_Cero THEN CONVERT(PorcentajeGarantia,CHAR)
							  ELSE Cadena_Vacia
						END ) AS Valor

			FROM BaseCap
			ORDER BY NumCliente, NumCuenta;


	END IF;

	DROP TABLE IF EXISTS BaseCap;


END TerminaStore$$