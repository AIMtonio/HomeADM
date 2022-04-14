-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOA3011REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOA3011REP`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOA3011REP`(

	Par_Anio           		INT,
	Par_Mes					INT,
	Par_NumRep				TINYINT UNSIGNED,


    Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN


DECLARE Var_FechaSistema			DATE;
DECLARE Fecha3MesAnt				DATE;
DECLARE Var_FechaInicio				DATE;
DECLARE Var_FechaFin				DATE;
DECLARE Var_FechaCorteMax			DATE;
DECLARE Var_ClaveEntidad			VARCHAR(300);



DECLARE Rep_Excel				INT(1);
DECLARE Rep_Csv					INT(1);
DECLARE Entero_Cero				INT(2);
DECLARE Decimal_Cero			DECIMAL(2,2);
DECLARE Cadena_Vacia			CHAR(1);
DECLARE Str_Tabulador			VARCHAR(20);
DECLARE Var_SI					CHAR(1);
DECLARE Femenino				CHAR(1);
DECLARE Masculino				CHAR(1);
DECLARE Estatus_Activo			CHAR(1);
DECLARE Estatus_Vigente			CHAR(1);
DECLARE Estatus_Inactivo		CHAR(1);
DECLARE TarjetaD_Activa			INT(1);
DECLARE TarjetaD_Bloqueada		INT(1);
DECLARE TarjetaD_Cancelada		INT(1);
DECLARE Estatus_Pagado			CHAR(1);
DECLARE Estatus_Cancelado		CHAR(1);
DECLARE Estatus_Aperturado		CHAR(1);
DECLARE Clave_Formulario		INT(11);
DECLARE Clasif_CreComercial		CHAR(1);
DECLARE	Clasif_CreConsumo		CHAR(1);
DECLARE Clasif_CreVivienda		CHAR(1);
DECLARE Subclasif_Microcredito	INT(4);
DECLARE Subclasif_TarCredito	INT(4);
DECLARE Credito_Vigente			CHAR(1);
DECLARE Credito_Vencido			CHAR(1);
DECLARE Var_NO					CHAR(1);
DECLARE Cliente_Inst        	INT;
DECLARE VarMontoAporta			DECIMAL(14,2);


SET Rep_Excel				:= 1;
SET Rep_Csv					:= 2;
SET Entero_Cero				:= 0;
SET Decimal_Cero			:= 0.0;
SET Cadena_Vacia			:= '';
SET Str_Tabulador   		:= '     ';
SET Var_SI					:= 'S';
SET Femenino				:= 'F';
SET Masculino				:= 'M';
SET Estatus_Activo			:= 'A';
SET Estatus_Vigente			:= 'N';
SET Estatus_Inactivo		:= 'I';
SET TarjetaD_Activa			:= 7;
SET TarjetaD_Bloqueada		:= 8;
SET TarjetaD_Cancelada		:= 9;
SET Estatus_Pagado			:= 'P';
SET Estatus_Cancelado		:= 'C';
SET Estatus_Aperturado		:= 'A';
SET Clave_Formulario		:= 3011;
SET Clasif_CreComercial		:= 'C';
SET Clasif_CreConsumo		:= 'O';
SET Clasif_CreVivienda		:= 'H';
SET Subclasif_Microcredito 	:= 103;
SET Subclasif_TarCredito 	:= 201;
SET Credito_Vigente			:= 'V';
SET Credito_Vencido			:= 'B';
SET Var_NO					:= 'N';
SET Cliente_Inst		:= (SELECT ClienteInstitucion FROM PARAMETROSSIS LIMIT 1);



SELECT	FechaSistema,		MontoAportacion
 INTO	Var_FechaSistema,	VarMontoAporta
FROM PARAMETROSSIS LIMIT 1;

SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
SET Var_FechaFin 		:= DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY );
SET Var_FechaCorteMax	:= (SELECT MAX(FechaCorte) FROM SALDOSCREDITOS WHERE FechaCorte <= Var_FechaFin);
SET Var_ClaveEntidad	:= (SELECT Ins.ClaveEntidad FROM PARAMETROSSIS Par, INSTITUCIONES Ins WHERE Par.InstitucionID = Ins.InstitucionID);

DELETE FROM TMPREGULATORIOA3011	WHERE NumTransaccion = Aud_NumTransaccion;
DELETE FROM TMPREGCLIENTES		WHERE NumTransaccion = Aud_NumTransaccion;







INSERT INTO TMPREGCLIENTES (
	ClienteID,		EstadoID,	MunicipioID,  	Sexo,			FechaAlta,			NumTransaccion)
SELECT
	Cli.ClienteID,		Cli.EstadoID,  Entero_Cero,  Cli.Sexo,		Cli.FechaAlta,		Aud_NumTransaccion
	FROM	CLIENTES			Cli
	WHERE	Cli.FechaAlta <= Var_FechaFin
	AND ClienteID <> Cliente_Inst
	AND (Cli.Estatus = Estatus_Activo
			OR	(Cli.Estatus = Estatus_Inactivo AND Cli.FechaBaja > Var_FechaFin)
		)
	AND EsMenorEdad = Var_No	;




DROP TABLE IF EXISTS TMPDIRECCLIENTES3011CERO;
CREATE TEMPORARY TABLE TMPDIRECCLIENTES3011CERO
SELECT	Dir.ClienteID,		Dir.EstadoID,	Aud_NumTransaccion,	Dir.CP AS CodigoPostal
	FROM	DIRECCLIENTE	Dir,
			TMPREGCLIENTES	Tmp
	WHERE 	Dir.Oficial = Var_SI
		AND	Tmp.ClienteID	= Dir.ClienteID
		AND	Tmp.NumTransaccion	=	Aud_NumTransaccion
	GROUP BY Dir.ClienteID, Dir.EstadoID, Dir.CP;
CREATE INDEX id_indexClienteID ON TMPDIRECCLIENTES3011CERO (ClienteID);

DROP TABLE IF EXISTS TMPDIRECCLIENTES3011;
CREATE TEMPORARY TABLE TMPDIRECCLIENTES3011
(SELECT	Dir.ClienteID,		Dir.EstadoID,	Aud_NumTransaccion,	Dir.CP AS CodigoPostal
	FROM DIRECCLIENTE Dir,
			TMPREGCLIENTES	Tmp
	WHERE 	Dir.Oficial = Var_SI
		AND	Tmp.ClienteID		= Dir.ClienteID
		AND	Tmp.NumTransaccion	=	Aud_NumTransaccion
	GROUP BY Dir.ClienteID, Dir.EstadoID, Dir.CP)
UNION ALL
(SELECT	Dir.ClienteID,		Dir.EstadoID,	Aud_NumTransaccion,	Dir.CP AS CodigoPostal
	FROM	DIRECCLIENTE Dir,
			TMPREGCLIENTES	Tmp
	WHERE 	IFNULL(Dir.Oficial,'') != 'S'
		AND	Tmp.ClienteID	= Dir.ClienteID
		AND	Dir.ClienteID  NOT IN (SELECT ClienteID FROM TMPDIRECCLIENTES3011CERO)
		AND	Tmp.NumTransaccion	=	Aud_NumTransaccion
	GROUP BY Dir.ClienteID, Dir.EstadoID, Dir.CP);
CREATE INDEX id_indexClienteID ON TMPDIRECCLIENTES3011 (ClienteID);


UPDATE	TMPREGCLIENTES			Tmp,
		TMPDIRECCLIENTES3011	Cli			SET
	Tmp.EstadoID		=	Cli.EstadoID,
	Tmp.CodigoPostal	=	Cli.CodigoPostal
WHERE	Tmp.ClienteID		=	Cli.ClienteID
	AND	Tmp.NumTransaccion	=	Aud_NumTransaccion;



SET Var_FechaCorteMax	:= (SELECT MAX(Fecha) FROM `HIS-CUENTASAHO` WHERE Fecha <= Var_FechaFin);
DELETE FROM TMPREGHISCUENTASAHO WHERE NumTransaccion = Aud_NumTransaccion;
INSERT INTO TMPREGHISCUENTASAHO (
	CuentaAhoID,		ClienteID,		Saldo,				EstadoID,		CodigoPostal,		NumTransaccion)
SELECT
	Cue.CuentaAhoID,	Cue.ClienteID,	Cue.SaldoIniMes,	Entero_Cero,				Entero_Cero,					Aud_NumTransaccion
	FROM	`HIS-CUENTASAHO`	Cue
		WHERE	Cue.ClienteID <> Cliente_Inst
			AND Cue.Fecha	= Var_FechaCorteMax;



DROP TABLE IF EXISTS TMPDIRECCLIENTES3011DOS;
CREATE TEMPORARY TABLE TMPDIRECCLIENTES3011DOS
SELECT	Dir.ClienteID,		Dir.EstadoID,	Dir.CP AS CodigoPostal,	Dir.ColoniaID,	Aud_NumTransaccion
	FROM	DIRECCLIENTE		Dir,
			TMPREGHISCUENTASAHO	Tmp
	WHERE 	Dir.Oficial = Var_SI
		AND	Tmp.ClienteID	= Dir.ClienteID
		AND	Tmp.NumTransaccion	=	Aud_NumTransaccion
	GROUP BY Dir.ClienteID, Dir.EstadoID, Dir.CP, Dir.ColoniaID;
CREATE INDEX id_indexClienteID ON TMPDIRECCLIENTES3011DOS (ClienteID);

DROP TABLE IF EXISTS TMPDIRECCLIENTES3011;
CREATE TEMPORARY TABLE TMPDIRECCLIENTES3011
(SELECT	Dir.ClienteID,		Dir.EstadoID,		Dir.CP AS CodigoPostal,	Dir.ColoniaID,	Aud_NumTransaccion
	FROM DIRECCLIENTE Dir,
			TMPREGHISCUENTASAHO	Tmp
	WHERE 	Dir.Oficial 	= Var_SI
		AND	Tmp.ClienteID		= Dir.ClienteID
		AND	Tmp.NumTransaccion	=	Aud_NumTransaccion
	GROUP BY Dir.ClienteID, Dir.EstadoID, Dir.CP, Dir.ColoniaID)
UNION ALL
(SELECT	Dir.ClienteID,		Dir.EstadoID,		Dir.CP AS CodigoPostal,	Dir.ColoniaID,	Aud_NumTransaccion
	FROM	DIRECCLIENTE Dir,
			TMPREGHISCUENTASAHO	Tmp
	WHERE 	IFNULL(Dir.Oficial,'') != 'S'
		AND	Tmp.ClienteID	= Dir.ClienteID
		AND	Dir.ClienteID  NOT IN (SELECT ClienteID FROM TMPDIRECCLIENTES3011DOS)
		AND	Tmp.NumTransaccion	=	Aud_NumTransaccion
	GROUP BY Dir.ClienteID,	Dir.EstadoID, Dir.CP, Dir.ColoniaID);
CREATE INDEX id_indexClienteID ON TMPDIRECCLIENTES3011 (ClienteID);



UPDATE	TMPREGHISCUENTASAHO			Tmp,
		TMPDIRECCLIENTES3011	Cli			SET
	Tmp.EstadoID		=	Cli.EstadoID,
	Tmp.CodigoPostal	=	Cli.CodigoPostal,
	Tmp.ColoniaID		=	Cli.ColoniaID
WHERE	Tmp.ClienteID		=	Cli.ClienteID
	AND	Tmp.NumTransaccion	=	Aud_NumTransaccion;





DELETE FROM TMPREGULATORIO3011MU;
INSERT INTO TMPREGULATORIO3011MU (
	NumTransaccion,			Periodo,				ClaveEntidad,			ClaveFormulario,		EstadoID,
	CodigoPostal,			ClaveMunicipio,			NumContratoTDRecar,		SaldoAcumTDRecar)
SELECT
	Aud_NumTransaccion,		Par_Mes,				Var_ClaveEntidad,		Clave_Formulario,		Cli.EstadoID,
	Cli.CodigoPostal,		Cli.CodigoPostal,		Entero_Cero,			Decimal_Cero
	FROM TMPREGCLIENTES Cli
	WHERE Cli.NumTransaccion	= Aud_NumTransaccion
GROUP BY Cli.EstadoID,	Cli.CodigoPostal;





INSERT INTO TMPREGULATORIO3011MU (
	NumTransaccion,			Periodo,			ClaveEntidad,			ClaveFormulario,		EstadoID,
			CodigoPostal,		NumContratoTDRecar,		SaldoAcumTDRecar)
SELECT
	Aud_NumTransaccion,		Par_Mes,			Var_ClaveEntidad,		Clave_Formulario,		Cli.EstadoID,
			Cli.CodigoPostal,	Entero_Cero,			Decimal_Cero
	FROM TMPREGHISCUENTASAHO	Cli
GROUP BY EstadoID,	CodigoPostal;



INSERT INTO TMPREGULATORIO3011MU (
	NumTransaccion,			Periodo,			ClaveEntidad,			ClaveFormulario,		EstadoID,
				CodigoPostal,		ClaveMunicipio,			NumContratoTDRecar,		SaldoAcumTDRecar)
SELECT
	Aud_NumTransaccion,		Par_Mes,			Var_ClaveEntidad,		Clave_Formulario,		Suc.EstadoID,
			Suc.CP,				Suc.CP,					Entero_Cero,			Decimal_Cero
	FROM SUCURSALES Suc
GROUP BY EstadoID,	 CP;

DELETE FROM TMPREGULATORIO3011MU WHERE IFNULL(CodigoPostal,Entero_Cero) = Entero_Cero;



INSERT INTO TMPREGULATORIOA3011 (
	NumTransaccion,			Periodo,				ClaveEntidad,			ClaveFormulario,		EstadoID,
				CodigoPostal,			ClaveMunicipio,			NumContratoTDRecar,		SaldoAcumTDRecar)
SELECT
	Aud_NumTransaccion,		Par_Mes,				Var_ClaveEntidad,		Clave_Formulario,		EstadoID,
				CodigoPostal,			CodigoPostal,			Entero_Cero,			Decimal_Cero
	FROM TMPREGULATORIO3011MU Cli
GROUP BY Cli.EstadoID,	Cli.CodigoPostal;




DROP TABLE IF EXISTS TMPSUCURSALESNUM3011;
CREATE TEMPORARY TABLE TMPSUCURSALESNUM3011
SELECT COUNT(Suc.SucursalID) AS NumeroSuc,Suc.EstadoID,Suc.CP AS CodigoPostal
FROM SUCURSALES Suc WHERE Suc.SucursalID <> 1
AND Suc.Estatus = 'A'
GROUP BY Suc.EstadoID,Suc.CP;

UPDATE	TMPREGULATORIOA3011 	Tmp,
		TMPSUCURSALESNUM3011	Suc		SET
	Tmp.NumSucursales = NumeroSuc
WHERE	Tmp.NumTransaccion	= Aud_NumTransaccion
AND		Tmp.CodigoPostal	= Suc.CodigoPostal;

DROP TABLE IF EXISTS TMPNUMEROCAJEROS3011;
CREATE  TEMPORARY TABLE TMPNUMEROCAJEROS3011
SELECT COUNT(Atm.CajeroID) AS Numero,Suc.EstadoID,	Suc.CP AS CodigoPostal
	FROM CATCAJEROSATM Atm,
			SUCURSALES		Suc
	WHERE 	Suc.SucursalID = Atm.SucursalID
		AND (Atm.Estatus = Estatus_Activo
				OR
			(Atm.Estatus != Estatus_Activo AND Atm.FechaBaja > Var_FechaFin))
		AND Atm.FechaAlta <= Var_FechaFin
	GROUP BY Suc.EstadoID,	Suc.CP;


UPDATE TMPREGULATORIOA3011 Tmp,
	TMPNUMEROCAJEROS3011	Atm
	SET Tmp.NumCajerosATM = Atm.Numero
WHERE Tmp.NumTransaccion = Aud_NumTransaccion
AND Tmp.EstadoID		= Atm.EstadoID
AND	Tmp.CodigoPostal	= Atm.CodigoPostal;



DROP TABLE IF EXISTS	TMPNUMEROCLIENTES3011;
CREATE TEMPORARY TABLE TMPNUMEROCLIENTES3011
SELECT	COUNT(Cli.ClienteID) AS NumHombre,
		Cli.EstadoID,		Cli.CodigoPostal
	FROM	TMPREGCLIENTES Cli
	WHERE	Cli.NumTransaccion = Aud_NumTransaccion AND Cli.Sexo = Masculino
	GROUP BY Cli.EstadoID,		Cli.CodigoPostal;
CREATE INDEX id_indexEstadoID		ON TMPNUMEROCLIENTES3011 (EstadoID);
CREATE INDEX id_indexCodigoPostal	ON TMPNUMEROCLIENTES3011 (CodigoPostal);

UPDATE	TMPREGULATORIOA3011		Tmp,
		TMPNUMEROCLIENTES3011	Cli	SET
	Tmp.NumHombres = Cli.NumHombre
WHERE	Tmp.NumTransaccion		= Aud_NumTransaccion
	AND Tmp.EstadoID			= Cli.EstadoID
	AND Tmp.CodigoPostal		= Cli.CodigoPostal;


DROP TABLE IF EXISTS	TMPNUMEROCLIENTES3011;
CREATE TEMPORARY TABLE TMPNUMEROCLIENTES3011
SELECT	 COUNT(Cli.ClienteID) AS NumMujeres ,
		Cli.EstadoID,		Cli.CodigoPostal
	FROM	TMPREGCLIENTES Cli
	WHERE	Cli.NumTransaccion = Aud_NumTransaccion AND Cli.Sexo = Femenino
	GROUP BY Cli.EstadoID,		Cli.CodigoPostal;
CREATE INDEX id_indexEstadoID		ON TMPNUMEROCLIENTES3011 (EstadoID);
CREATE INDEX id_indexCodigoPostal	ON TMPNUMEROCLIENTES3011 (CodigoPostal);

UPDATE	TMPREGULATORIOA3011		Tmp,
		TMPNUMEROCLIENTES3011	Cli	SET
	Tmp.NumMujeres = Cli.NumMujeres
WHERE	Tmp.NumTransaccion		= Aud_NumTransaccion
	AND Tmp.EstadoID			= Cli.EstadoID
	AND Tmp.CodigoPostal		= Cli.CodigoPostal;


DROP TABLE IF EXISTS TMPAPORTACIONSOC3011;
CREATE TEMPORARY TABLE TMPAPORTACIONSOC3011
SELECT COUNT(Cli.ClienteID) *VarMontoAporta AS MontoAportacion,	Cli.CodigoPostal , Cli.EstadoID
FROM	APORTACIONSOCIO Apo,
		TMPREGCLIENTES	Cli
WHERE	Cli.ClienteID		= Apo.ClienteID
	AND Cli.NumTransaccion 	= Aud_NumTransaccion
GROUP BY Cli.EstadoID,	Cli.CodigoPostal;
CREATE INDEX id_indexEstadoID		ON TMPAPORTACIONSOC3011 (EstadoID);
CREATE INDEX id_indexCodigoPostal	ON TMPAPORTACIONSOC3011 (CodigoPostal);


UPDATE	TMPREGULATORIOA3011		Tmp	,
		TMPAPORTACIONSOC3011	Apo	SET
	Tmp.ParteSocial = MontoAportacion
WHERE	Tmp.NumTransaccion = Aud_NumTransaccion
	AND Tmp.EstadoID 		= Apo.EstadoID
	AND Tmp.CodigoPostal 	= Apo.CodigoPostal;



DROP TABLE IF EXISTS TMPMOVAHORROHIS;
	CREATE TEMPORARY TABLE TMPMOVAHORROHIS (
	SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN 'C' THEN Mov.CantidadMov * -1 ELSE Mov.CantidadMov END) AS Saldo
		FROM `HIS-CUENAHOMOV` Mov
		WHERE Mov.Fecha >= Var_FechaInicio
		  AND Mov.Fecha <= Var_FechaFin
		GROUP BY Mov.CuentaAhoID);
	CREATE INDEX id_indexCuentaAhoID ON TMPMOVAHORROHIS (CuentaAhoID);


UPDATE	TMPREGHISCUENTASAHO	F,
		TMPMOVAHORROHIS		H	SET
	F.Saldo				= F.Saldo	+	H.Saldo
WHERE	F.CuentaAhoID	= H.CuentaAhoID
	AND	NumTransaccion	= Aud_NumTransaccion;


DROP TABLE IF EXISTS TMPMOVAHORROHIS;
CREATE TEMPORARY TABLE TMPMOVAHORROHIS (
	SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN 'C' THEN Mov.CantidadMov * -1 ELSE Mov.CantidadMov END) AS Saldo
		FROM CUENTASAHOMOV Mov
		WHERE Mov.Fecha <= Var_FechaFin
		AND Mov.FechaActual <= DATE_ADD(Var_FechaFin, INTERVAL 2 DAY)
		GROUP BY Mov.CuentaAhoID);
CREATE INDEX id_indexCuentaAhoID ON TMPMOVAHORROHIS (CuentaAhoID);

UPDATE	TMPREGHISCUENTASAHO	F,
		TMPMOVAHORROHIS		H	SET
	F.Saldo				= F.Saldo	+	H.Saldo
WHERE	F.CuentaAhoID	= H.CuentaAhoID
	AND	NumTransaccion	= Aud_NumTransaccion;
DROP TABLE IF EXISTS TMPMOVAHORROHIS;




DELETE FROM TMPREGHISCUENTASAHO WHERE Saldo = Entero_Cero;

DROP TABLE IF EXISTS TMPACUMCUENTAS3011;
CREATE TEMPORARY TABLE TMPACUMCUENTAS3011
	SELECT	COUNT(Cue.CuentaAhoID) AS NumCuentas,		ROUND(SUM(Cue.Saldo),Entero_Cero) AS Saldo,
			Cue.EstadoID,			Cue.CodigoPostal
		FROM TMPREGHISCUENTASAHO Cue
		WHERE Cue.NumTransaccion = Aud_NumTransaccion
		AND Cue.Saldo > Entero_Cero
	GROUP BY Cue.EstadoID,Cue.CodigoPostal;

CREATE INDEX id_indexEstadoID		ON TMPACUMCUENTAS3011 (EstadoID);
CREATE INDEX id_indexCodigoPostal	ON TMPACUMCUENTAS3011 (CodigoPostal);


UPDATE	TMPREGULATORIOA3011 Tmp,
		TMPACUMCUENTAS3011	Cue SET
	Tmp.NumContrato = NumCuentas
WHERE 	Tmp.EstadoID 		= Cue.EstadoID
	AND Tmp.CodigoPostal	= Cue.CodigoPostal
	AND	Tmp.NumTransaccion	= Aud_NumTransaccion;

UPDATE	TMPREGULATORIOA3011 Tmp,
		TMPACUMCUENTAS3011	Cue SET
	Tmp.SaldoAcum = Saldo
WHERE 	Tmp.EstadoID 		= Cue.EstadoID
	AND Tmp.CodigoPostal	= Cue.CodigoPostal
	AND	Tmp.NumTransaccion	= Aud_NumTransaccion;





DROP TABLE IF EXISTS TMPACUMULADOTD3011 ;
CREATE TEMPORARY TABLE TMPACUMULADOTD3011
SELECT SUM(Cue.Saldo) AS Saldo,	Tar.ClienteID,	Cli.CodigoPostal,	Cli.EstadoID,	COUNT(Tar.TarjetaDebID) AS NumTarjetas
FROM	TMPREGHISCUENTASAHO Cue,
		TMPREGCLIENTES Cli,
		TARJETADEBITO Tar
WHERE	Cue.ClienteID	= Cli.ClienteID
	AND Cli.ClienteID	= Tar.ClienteID
	AND Cue.CuentaAhoID	= Tar.CuentaAhoID
	AND (Tar.Estatus = TarjetaD_Activa
			OR
		 (Tar.Estatus = TarjetaD_Bloqueada AND Tar.FechaBloqueo > Var_FechaFin)
			OR
		 (Tar.Estatus = TarjetaD_Cancelada AND Tar.FechaCancelacion > Var_FechaFin)
		)
	AND Tar.FechaActivacion <= Var_FechaFin
	AND CONVERT(CONCAT(CONVERT(SUBSTRING(Tar.FechaVencimiento,4,5), CHAR), '-',CONVERT(SUBSTRING(Tar.FechaVencimiento,1,2), CHAR),'-', '1'), DATE) > Var_FechaFin
	AND Cli.NumTransaccion = Aud_NumTransaccion
GROUP BY Cli.CodigoPostal, Tar.ClienteID, Cli.EstadoID;
CREATE INDEX id_indexClienteID ON TMPACUMULADOTD3011 (ClienteID);

UPDATE	TMPREGULATORIOA3011 Tmp,
		TMPACUMULADOTD3011	Sal		SET
	Tmp.SaldoAcumTD = Sal.Saldo,
	Tmp.NumContratoTD = Sal.NumTarjetas
WHERE 	Tmp.NumTransaccion	= Aud_NumTransaccion
	AND Tmp.EstadoID		= Sal.EstadoID
	AND Tmp.CodigoPostal	= Sal.CodigoPostal;


DROP TABLE IF EXISTS TMPACUMULADOTD3011 ;




DROP TABLE IF EXISTS TMPACUMULADOTD3011 ;
CREATE TEMPORARY TABLE TMPACUMULADOTD3011
SELECT	COUNT(Inv.InversionID) AS NumeroInversiones,	ROUND(SUM(Inv.Monto),Entero_Cero) + ROUND(SUM(Inv.SaldoProvision),Entero_Cero)	AS SaldoAcum,
		Cli.EstadoID,									Cli.CodigoPostal
	FROM	HISINVERSIONES Inv,
			TMPREGCLIENTES Cli
WHERE	Inv.FechaCorte		= Var_FechaFin
	AND	Inv.ClienteID		= Cli.ClienteID
	AND Inv.Estatus			= Estatus_Vigente
	AND Cli.NumTransaccion	= Aud_NumTransaccion
GROUP BY Cli.EstadoID,	Cli.CodigoPostal;
CREATE INDEX id_indexEstadoID		ON TMPACUMULADOTD3011 (EstadoID);
CREATE INDEX id_indexCodigoPostal	ON TMPACUMULADOTD3011 (CodigoPostal);

UPDATE	TMPREGULATORIOA3011 Tmp,
		TMPACUMULADOTD3011	Sal		SET
	Tmp.NumContratoPlazo	= Sal.NumeroInversiones,
	Tmp.SaldoAcumPlazo		= Sal.SaldoAcum
WHERE 	Tmp.NumTransaccion	= Aud_NumTransaccion
	AND	Tmp.EstadoID		= Sal.EstadoID
	AND Tmp.CodigoPostal	= Sal.CodigoPostal;

DROP TABLE IF EXISTS TMPACUMULADOTD3011 ;


SET Var_FechaCorteMax   := (SELECT MAX(FechaCorte) FROM SALDOSCREDITOS WHERE FechaCorte <= Var_FechaFin);


DELETE FROM TMPREGCREDITOS WHERE NumTransaccion	= NumTransaccion;

DROP TABLE IF EXISTS TMPREPCREDITOS30112;
CREATE TEMPORARY TABLE TMPREPCREDITOS30112(
		CreditoID			BIGINT(12),
		ClienteID			INT(11),
		Clasificacion		CHAR(1),
		SubClasif			INT(11),
		CodigoPostal		VARCHAR(5),
		EstadoID			INT(11),
		SalCapVigente		DECIMAL(14,2),
		SalCapVencido		DECIMAL(14,2)
);

CREATE INDEX id_indexCreditoID ON TMPREPCREDITOS30112 (CreditoID);
CREATE INDEX id_indexClienteID ON TMPREPCREDITOS30112 (ClienteID);


INSERT INTO TMPREPCREDITOS30112
SELECT	Cre.CreditoID,			Cre.ClienteID,		Des.Clasificacion,		Des.SubClasifID AS SubClasif,
		'' AS CodigoPostal,	Entero_Cero  AS EstadoID,
		Cre.SalCapVigente+Cre.SalCapAtrasado+Cre.SalIntOrdinario+Cre.SalIntProvision+Cre.SalIntAtrasado+Cre.SalMoratorios,
		Cre.SalCapVencido+Cre.SalCapVenNoExi+Cre.SalIntVencido+Cre.SaldoMoraVencido
	FROM CALRESCREDITOS Cli,
		 SALDOSCREDITOS Cre,
		 DESTINOSCREDITO Des
	WHERE	Cli.Fecha			=	Var_FechaCorteMax
		AND Cre.FechaCorte 		=	Cli.Fecha
		AND	Cli.CreditoID		=	Cre.CreditoID
		AND Cre.DestinoCreID	=	Des.DestinoCreID;






DROP TABLE IF EXISTS TMPREPCREDITOS3011;
CREATE TEMPORARY TABLE TMPREPCREDITOS3011(
		CreditoID			BIGINT(11),
		NumTransaccion		BIGINT(20),
		Clasificacion		CHAR(1),
		SubClasif			INT(11),
		EstadoID			INT(11),
		CodigoPostal		VARCHAR(5),
		ClienteID			INT(11),
		SalCapVigente		DECIMAL(14,2),
		SalCapVencido		DECIMAL(14,2)
);

CREATE INDEX id_indexCreditoID ON TMPREPCREDITOS3011 (CreditoID);
CREATE INDEX id_indexClienteID ON TMPREPCREDITOS3011 (ClienteID);

INSERT INTO TMPREPCREDITOS3011
SELECT	Cre.CreditoID,		Aud_NumTransaccion,		Cre.Clasificacion,	Cre.SubClasif,		Tmp.EstadoID,
		Tmp.CodigoPostal,		Cre.ClienteID,		SalCapVigente,		SalCapVencido
	FROM 	TMPREPCREDITOS30112	Cre
	LEFT OUTER JOIN TMPREGCLIENTES		Tmp ON 	Cre.ClienteID		=	Tmp.ClienteID
	AND		Tmp.NumTransaccion	=	Aud_NumTransaccion;



DROP TABLE IF EXISTS TMPREPCREDITOS30113;
CREATE TEMPORARY TABLE TMPREPCREDITOS30113
SELECT DISTINCT(Dir.ClienteID) AS ClienteID,	Dir.EstadoID,	Dir.CP AS CodigoPostal
	FROM	DIRECCLIENTE	Dir,
			TMPREPCREDITOS3011	Tmp
	WHERE	Dir.ClienteID 				= Tmp.ClienteID
	AND		IFNULL(Tmp.CodigoPostal,Cadena_Vacia)	= Cadena_Vacia;




UPDATE	TMPREPCREDITOS3011 Tmp,
		TMPREPCREDITOS30113	Dir	SET
	Tmp.EstadoID		=	Dir.EstadoID,
	Tmp.CodigoPostal	=	Dir.CodigoPostal
WHERE  Dir.ClienteID = Tmp.ClienteID;


INSERT INTO TMPREGCREDITOS (
		NumCreditos,			NumTransaccion,			Clasificacion,					SubClasif,			EstadoID,
		CodigoPostal,			SalCapVigente,					SalCapVencido)
SELECT	COUNT(Cre.CreditoID),	Cre.NumTransaccion,		Cre.Clasificacion,				Cre.SubClasif,		Cre.EstadoID,
		Cre.CodigoPostal,		ROUND(SUM(Cre.SalCapVigente),Entero_Cero),ROUND(SUM(Cre.SalCapVencido),Entero_Cero)
	FROM 	TMPREPCREDITOS3011	Cre
GROUP BY Cre.EstadoID,	Cre.CodigoPostal,	Cre.Clasificacion, Cre.NumTransaccion, Cre.SubClasif;



UPDATE	TMPREGULATORIOA3011 Tmp,
		TMPREGCREDITOS		Cre		SET
	Tmp.NumCreditos		=	Cre.NumCreditos,
	Tmp.SaldoVigenteCre =	Cre.SalCapVigente,
	Tmp.SaldoVencidoCre =	Cre.SalCapVencido
WHERE Tmp.NumTransaccion	= Aud_NumTransaccion
	AND	Tmp.NumTransaccion	= Cre.NumTransaccion
	AND Tmp.EstadoID 		= Cre.EstadoID
	AND Tmp.CodigoPostal	= Cre.CodigoPostal
	AND	Cre.Clasificacion = Clasif_CreComercial
	AND Cre.SubClasif != Subclasif_Microcredito	;



UPDATE	TMPREGULATORIOA3011 Tmp,
		TMPREGCREDITOS		Cre		SET
	Tmp.NumMicroCreditos		=	Cre.NumCreditos,
	Tmp.SaldoVigenteMicroCre	=	Cre.SalCapVigente,
	Tmp.SaldoVencidoMicroCre 	=	Cre.SalCapVencido
WHERE Tmp.NumTransaccion	= Aud_NumTransaccion
	AND	Tmp.NumTransaccion	= Cre.NumTransaccion
	AND Tmp.EstadoID 		= Cre.EstadoID
	AND Tmp.CodigoPostal	= Cre.CodigoPostal
	AND	Cre.SubClasif		= Subclasif_Microcredito	;




UPDATE	TMPREGULATORIOA3011 Tmp,
		TMPREGCREDITOS		Cre		SET
	Tmp.NumCreConsumo				=	Cre.NumCreditos,
	Tmp.SaldoVigenteCreConsumo		=	Cre.SalCapVigente,
	Tmp.SaldoVencidoCreConsumo		=	Cre.SalCapVencido
WHERE Tmp.NumTransaccion	= Aud_NumTransaccion
	AND	Tmp.NumTransaccion	= Cre.NumTransaccion
	AND Tmp.EstadoID 		= Cre.EstadoID
	AND Tmp.CodigoPostal	= Cre.CodigoPostal
	AND	Cre.Clasificacion 	= Clasif_CreConsumo;




UPDATE	TMPREGULATORIOA3011 Tmp,
		TMPREGCREDITOS		Cre		SET
	Tmp.NumCreVivienda				=	Cre.NumCreditos,
	Tmp.SaldoVigenteCreVivienda		=	Cre.SalCapVigente,
	Tmp.SaldoVencidoCreVivienda		=	Cre.SalCapVencido
WHERE Tmp.NumTransaccion	= Aud_NumTransaccion
	AND	Tmp.NumTransaccion	= Cre.NumTransaccion
	AND Tmp.EstadoID 		= Cre.EstadoID
	AND Tmp.CodigoPostal	= Cre.CodigoPostal
	AND	Cre.Clasificacion = Clasif_CreVivienda
	AND Cre.SubClasif != Subclasif_Microcredito			;



UPDATE	TMPREGULATORIOA3011 Tmp,
		TMPREGCREDITOS		Cre		SET
	Tmp.NumContratoTC		=	Cre.NumCreditos,
	Tmp.SaldoVigenteTC 		= 	Cre.SalCapVigente,
	Tmp.SaldoVencidoTC 		= 	Cre.SalCapVencido
WHERE Tmp.NumTransaccion	= Aud_NumTransaccion
	AND	Tmp.NumTransaccion	= Cre.NumTransaccion
	AND Tmp.EstadoID 		= Cre.EstadoID
	AND Tmp.CodigoPostal	= Cre.CodigoPostal
	AND Cre.SubClasif = Subclasif_TarCredito			;



SET Fecha3MesAnt := (SELECT DATE_SUB(Var_FechaInicio, INTERVAL 2 MONTH));


DROP TABLE IF EXISTS	TMPREMESASACUMULADO3011;
CREATE TEMPORARY TABLE	TMPREMESASACUMULADO3011
SELECT COUNT(Rem.RemesaFolio)AS NumeroRemesas,	 SUM(Rem.Monto) AS Monto ,Suc.EstadoID,Suc.CP AS ClaveMunicipio
	FROM PAGOREMESAS Rem,
		 SUCURSALES Suc
	WHERE Rem.SucursalID = Suc.SucursalID
		AND Rem.Fecha BETWEEN Fecha3MesAnt AND Var_FechaFin
	GROUP BY Suc.EstadoID,Suc.CP;


UPDATE	TMPREGULATORIOA3011		Tmp,
		TMPREMESASACUMULADO3011	Rem SET
	Tmp.NumRemesas		= NumeroRemesas,
	Tmp.MontoRemesas	= Monto
WHERE 	Tmp.NumTransaccion	= Aud_NumTransaccion
	AND Tmp.EstadoID 		= Rem.EstadoID
	AND Tmp.ClaveMunicipio	= Rem.ClaveMunicipio;




IF(Par_NumRep = Rep_Excel) THEN
	SELECT 	Periodo,			ClaveEntidad,							ClaveFormulario,			EstadoID,			ClaveMunicipio AS MunicipioID,
			IFNULL(NumSucursales, Entero_Cero)  								AS NumSucursales,			IFNULL(NumCajerosATM, Entero_Cero) 						AS NumCajerosATM,
			IFNULL(NumMujeres,Entero_Cero) 	    								AS NumMujeres,				IFNULL(NumHombres,	Entero_Cero) 						AS NumHombres,
			ROUND(IFNULL(ParteSocial, Decimal_Cero), Entero_Cero)				AS ParteSocial,				IFNULL(NumContrato, Entero_Cero) 						AS NumContrato,
			ROUND(IFNULL(SaldoAcum, Decimal_Cero), Entero_Cero)					AS SaldoAcum,				IFNULL(NumContratoPlazo, Entero_Cero) 					AS NumContratoPlazo,
			ROUND(IFNULL(SaldoAcumPlazo, Decimal_Cero), Entero_Cero)			AS SaldoAcumPlazo,			IFNULL(NumContratoTD, Entero_Cero) 						AS NumContratoTD,
			ROUND(IFNULL(SaldoAcumTD, Decimal_Cero), Entero_Cero)				AS SaldoAcumTD,				IFNULL(NumContratoTDRecar, Entero_Cero) 				AS NumContratoTDRecar,
			ROUND(IFNULL(SaldoAcumTDRecar, Decimal_Cero), Entero_Cero)			AS SaldoAcumTDRecar,		IFNULL(NumCreditos, Entero_Cero) 						AS NumCreditos,
			ROUND(IFNULL(SaldoVigenteCre, Decimal_Cero), Entero_Cero)			AS SaldoVigenteCre,			ROUND(IFNULL(SaldoVencidoCre, Decimal_Cero), Entero_Cero)			AS SaldoVencidoCre,
			IFNULL(NumMicroCreditos, Entero_Cero)							    AS NumMicroCreditos,		ROUND(IFNULL(SaldoVigenteMicroCre, Decimal_Cero), Entero_Cero) 		AS SaldoVigenteMicroCre,
			ROUND(IFNULL(SaldoVencidoMicroCre, Decimal_Cero), Entero_Cero)		AS SaldoVencidoMicroCre,	IFNULL(NumContratoTC, Entero_Cero) 									AS NumContratoTC,
			ROUND(IFNULL(SaldoVigenteTC, Decimal_Cero), Entero_Cero)			AS SaldoVigenteTC,			ROUND(IFNULL(SaldoVencidoTC, Decimal_Cero), Entero_Cero)			AS SaldoVencidoTC,
			IFNULL(NumCreConsumo, Entero_Cero)									AS NumCreConsumo,			ROUND(IFNULL(SaldoVigenteCreConsumo, Decimal_Cero), Entero_Cero) 	AS SaldoVigenteCreConsumo,
			ROUND(IFNULL(SaldoVencidoCreConsumo, Decimal_Cero), Entero_Cero)	AS SaldoVencidoCreConsumo,	IFNULL(NumCreVivienda, Entero_Cero) 								AS NumCreVivienda,
			ROUND(IFNULL(SaldoVigenteCreVivienda, Decimal_Cero), Entero_Cero)	AS SaldoVigenteCreVivienda,	ROUND(IFNULL(SaldoVencidoCreVivienda, Decimal_Cero), Entero_Cero)	AS SaldoVencidoCreVivienda,
			IFNULL(NumRemesas, Entero_Cero) 									AS NumRemesas,				ROUND(IFNULL(MontoRemesas, Decimal_Cero), Entero_Cero)			AS MontoRemesas
		FROM TMPREGULATORIOA3011
		WHERE NumTransaccion = Aud_NumTransaccion;
END IF;


IF(Par_NumRep = Rep_Csv) THEN
	SELECT
			CONCAT(ClaveFormulario,';', EstadoID, ';',
					IFNULL(ClaveMunicipio, Cadena_Vacia),';',
					IFNULL(NumSucursales, Entero_Cero),';',
					IFNULL(NumCajerosATM, Entero_Cero),';',
					IFNULL(NumMujeres,Entero_Cero),';',
					IFNULL(NumHombres,	Entero_Cero),';',
					ROUND(IFNULL(ParteSocial, Decimal_Cero), Entero_Cero),';',
					IFNULL(NumContrato, Entero_Cero),';',
					ROUND(IFNULL(SaldoAcum, Decimal_Cero), Entero_Cero),';',
					IFNULL(NumContratoPlazo, Entero_Cero),';',
					ROUND(IFNULL(SaldoAcumPlazo, Decimal_Cero), Entero_Cero),';',
					IFNULL(NumContratoTD, Entero_Cero),';',
					ROUND(IFNULL(SaldoAcumTD, Decimal_Cero), Entero_Cero),';',
					IFNULL(NumContratoTDRecar, Entero_Cero),';',
					ROUND(IFNULL(SaldoAcumTDRecar, Decimal_Cero), Entero_Cero),';',
					IFNULL(NumCreditos, Entero_Cero),';',
					ROUND(IFNULL(SaldoVigenteCre, Decimal_Cero), Entero_Cero),';',
					ROUND(IFNULL(SaldoVencidoCre, Decimal_Cero), Entero_Cero),';',
					IFNULL(NumMicroCreditos, Entero_Cero),';',
					ROUND(IFNULL(SaldoVigenteMicroCre, Decimal_Cero), Entero_Cero),';',
					ROUND(IFNULL(SaldoVencidoMicroCre, Decimal_Cero), Entero_Cero),';',
					IFNULL(NumContratoTC, Entero_Cero),';',
					ROUND(IFNULL(SaldoVigenteTC, Decimal_Cero), Entero_Cero),';',
					ROUND(IFNULL(SaldoVencidoTC, Decimal_Cero), Entero_Cero),';',
					IFNULL(NumCreConsumo, Entero_Cero),';',
					ROUND(IFNULL(SaldoVigenteCreConsumo, Decimal_Cero), Entero_Cero),';',
					ROUND(IFNULL(SaldoVencidoCreConsumo, Decimal_Cero), Entero_Cero),';',
					IFNULL(NumCreVivienda, Entero_Cero) ,';',
					ROUND(IFNULL(SaldoVigenteCreVivienda, Decimal_Cero), Entero_Cero),';',
					ROUND(IFNULL(SaldoVencidoCreVivienda, Decimal_Cero), Entero_Cero), ';',
					IFNULL(NumRemesas, Entero_Cero), ';',
					ROUND(IFNULL(MontoRemesas, Decimal_Cero), Entero_Cero) ) AS Valor
		FROM TMPREGULATORIOA3011
		WHERE NumTransaccion = Aud_NumTransaccion;
END IF;





DELETE FROM TMPREGCLIENTES WHERE NumTransaccion = Aud_NumTransaccion;
DELETE FROM TMPREGCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;
DELETE FROM TMPREGHISCUENTASAHO WHERE NumTransaccion = Aud_NumTransaccion;
DELETE FROM TMPREGULATORIOA3011 WHERE NumTransaccion = Aud_NumTransaccion;
DROP TABLE IF EXISTS TMPDIRECCLIENTES3011;

DELETE FROM TMPREGULATORIOA3011 WHERE NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$