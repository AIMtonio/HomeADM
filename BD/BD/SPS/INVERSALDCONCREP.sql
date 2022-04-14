-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSALDCONCREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSALDCONCREP`;DELIMITER $$

CREATE PROCEDURE `INVERSALDCONCREP`(
/* REPORTE DE SALDOS Y CONCILIACION DE INVERSIONES */
	Par_Fecha	   		DATE,		-- FECHA DE GENERACION DEL REPORTE
    /* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),

	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

-- DECLARACION DE CONSTANTES
DECLARE EstatusVig 	CHAR(1);
DECLARE EstatusPag 	CHAR(1);
DECLARE ConCargo 	CHAR(1);
DECLARE ConAbono 	CHAR(1);
DECLARE	Entero_Cero	INT(11);
DECLARE	TMovimiento	INT(11);

-- ASIGNACION DE CONSTANTES
SET EstatusVig		:='N';
SET EstatusPag		:='P';
SET ConCargo	 	:='C';
SET ConAbono	 	:='A';
SET Entero_Cero		:= 0;
SET TMovimiento		:= 100;

DROP TABLE IF EXISTS TMPSALDOSINVERSIONES;
CREATE TEMPORARY TABLE TMPSALDOSINVERSIONES(
	MonedaID			INT(11),
	TipoInversionID		INT(11),
	InversionID			INT(11),
	FechaInicio			DATE,
	FechaVencimiento 	DATE,
	Estatus 			CHAR(1),
	FechaMov			DATE,
	Monto				DECIMAL(18,2),
	InteresGenerado		DECIMAL(18,2),
	InteresRecibir		DECIMAL(18,2),
	InteresRetener		DECIMAL(18,2),
	CargosProv			DECIMAL(18,2),
	AbonosProv			DECIMAL(18,2),
	SaldoProvison		DECIMAL(18,2),
	INDEX(MonedaID,TipoInversionID,InversionID)
);

INSERT INTO TMPSALDOSINVERSIONES(
	MonedaID,		TipoInversionID,		InversionID,		FechaInicio,			FechaVencimiento,
    Estatus,		FechaMov,				Monto,				InteresGenerado,		InteresRecibir,
    InteresRetener,	CargosProv,				AbonosProv,			SaldoProvison)
SELECT
	Inv.MonedaID,	Inv.TipoInversionID,	Inv.InversionID,	Inv.FechaInicio,		Inv.FechaVencimiento,
    Inv.Estatus,	Mov.Fecha,				Inv.Monto,			Inv.InteresGenerado,	Inv.InteresRecibir,
	Inv.InteresRetener,
	(IF(Mov.NatMovimiento=ConCargo,Mov.Monto,Entero_Cero)) AS Cargos,
	(IF(Mov.NatMovimiento=ConAbono,Mov.Monto,Entero_Cero)) AS Abonos,
	(IF(Mov.NatMovimiento=ConCargo,Mov.Monto,Entero_Cero))-(IF(Mov.NatMovimiento=ConAbono,Mov.Monto,Entero_Cero))AS saldoProvision
	FROM INVERSIONES Inv INNER JOIN INVERSIONESMOV Mov ON (Inv.InversionID=Mov.InversionID)
	WHERE Inv.Estatus IN (EstatusVig,EstatusPag)
		AND (Inv.FechaInicio <= Par_Fecha OR Inv.FechaVencimiento <= Par_Fecha)
		AND Mov.TipoMovInvID = TMovimiento ;

SELECT SalInv.MonedaID,								SalInv.TipoInversionID,
	   SUM(SalInv.Monto) AS capital,				SUM(SalInv.InteresGenerado) AS intgenerado,
	   SUM(SalInv.InteresRecibir) AS intrecibir,	SUM(SalInv.InteresRetener) AS InteresRetener,
       SUM(SalInv.SaldoProvison) AS SaldoProvison
	FROM TMPSALDOSINVERSIONES SalInv
	WHERE SalInv.FechaMov <= Par_Fecha
	GROUP BY SalInv.TipoInversionID,SalInv.MonedaID;

DROP TABLE IF EXISTS TMPSALDOSINVERSIONES;

END TerminaStore$$