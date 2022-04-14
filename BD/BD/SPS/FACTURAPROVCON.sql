-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURAPROVCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTURAPROVCON`;
DELIMITER $$


CREATE PROCEDURE `FACTURAPROVCON`(
	Par_NoFactura		VARCHAR(20),
	Par_ProveedorID		INT,
	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)

TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE	Con_Principal		INT;
DECLARE	Con_Foranea			INT;
DECLARE Con_FactProv		INT;
DECLARE Con_Anticipo    	INT;
DECLARE Con_PolizaFactura 	INT;
DECLARE Con_PeriodoVig		INT;
DECLARE Con_FactDisper		INT;
DECLARE Con_FactAnticipo	INT;
DECLARE PolizaID			INT;
DECLARE EstatusPeriodo		CHAR(1);
DECLARE Estatus_Cancelado   CHAR(1);

-- Declaracion de Variables
DECLARE Var_FechaFact		DATE;
DECLARE Var_PrimerDiaMes	DATE;


-- Asignacion de constantes
SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.00;
SET	Con_Principal		:= 1;-- Consulta principal
SET	Con_Foranea			:= 2;-- Consulta foranea
SET	Con_Anticipo		:= 3;-- Consulta anticipo
SET Con_PolizaFactura 	:= 4;-- Consulta poliza de la factura
SET Con_PeriodoVig		:= 5;-- Consulta periodo contable vigente
SET Con_FactDisper 		:= 6;-- Consulta si la factura ya esta en una dispersion
SET Con_FactAnticipo	:= 7;-- Consulta si la factura ya esta en un anticipo
SET Estatus_Cancelado	:= 'C';

 -- Consulta principal de factura
 IF(Par_NumCon = Con_Principal) THEN
 	SELECT	F.ProveedorID,		F.NoFactura,		F.FechaFactura,		F.Estatus,			F.CondicionesPago,
 			F.FechaProgPago,	F.FechaVencimient,	F.SaldoFactura,		F.TotalGravable,	F.TotalFactura,
 			F.SubTotal,			F.RutaImagenFact,	F.RutaXMLFact,		F.MotivoCancela,	F.FechaCancelacion,
			F.PagoAnticipado,	F.CenCostoManualID,	F.ProrrateaImp,		F.TipoPagoAnt,		F.CenCostoAntID,
			F.EmpleadoID,		F.FolioUUID, 		SUM( CASE WHEN I.GravaRetiene = 'G' THEN IFNULL(D.ImporteImpuesto,Decimal_Cero) ELSE Decimal_Cero END) AS TotGravado,
 													SUM( CASE WHEN I.GravaRetiene = 'R' THEN IFNULL(D.ImporteImpuesto,Decimal_Cero) ELSE Decimal_Cero END) AS TotRetenido,
			IFNULL(BI.FolioCargaID, 0) AS FolioCargaID,
            IFNULL(BI.FolioFacturaID,0) AS FolioFacturaID,
            IFNULL(BI.MesSubirFact, 0) AS MesSubirFact
 	FROM FACTURAPROV F 
    LEFT JOIN DETALLEIMPFACT D ON F.ProveedorID = D.ProveedorID AND F.NoFactura 	= D.NoFactura
	LEFT JOIN IMPUESTOS I ON I.ImpuestoID = D.ImpuestoID
    LEFT JOIN BITACORACARGAFACT BI ON BI.Folio= F.NoFactura
 	WHERE   F.NoFactura = Par_NoFactura
	    AND F.ProveedorID = Par_ProveedorID
	GROUP BY F.NoFactura,		F.ProveedorID,		F.FechaFactura,		F.Estatus,			F.CondicionesPago,
			 F.FechaProgPago,	F.FechaVencimient,	F.SaldoFactura,		F.TotalGravable,	F.TotalFactura,
			 F.SubTotal,		F.RutaImagenFact,	F.RutaXMLFact,		F.MotivoCancela,	F.FechaCancelacion,
			 F.PagoAnticipado,	F.CenCostoManualID,	F.ProrrateaImp,		F.TipoPagoAnt,		F.CenCostoAntID,
			 F.EmpleadoID,		F.FolioUUID, 		BI.FolioCargaID, 	BI.FolioFacturaID,	BI.MesSubirFact
	LIMIT 1;
 END IF;

 -- Consulta Foranea de factura
 IF(Par_NumCon = Con_Foranea) THEN
 	SELECT	ProveedorID,		NoFactura,			FechaFactura,		Estatus,		CondicionesPago,
 			FechaProgPago,		FechaVencimient,	SaldoFactura,		TotalGravable,	TotalFactura,
 			SubTotal
 		FROM FACTURAPROV
 		WHERE  NoFactura = Par_NoFactura;
 END IF;

 -- Consulta anticipo
 IF(Par_NumCon = Con_Anticipo) THEN
 SELECT	Fac.ProveedorID,		Fac.NoFactura,			Fac.FechaFactura,		Fac.Estatus,
 		Fac.CondicionesPago,	Fac.FechaProgPago,		Fac.FechaVencimient,	Fac.SaldoFactura,
 		Fac.TotalGravable,		Fac.TotalFactura,		Fac.SubTotal,			Fac.RutaImagenFact,
		Fac.RutaXMLFact,		Fac.MotivoCancela,		Fac.FechaCancelacion, 	Req.Estatus
 	FROM FACTURAPROV Fac
 	LEFT JOIN REQGASTOSUCURMOV Req ON Fac.ProveedorID=Req.ProveedorID
 		AND	Req.NoFactura=Fac.NoFactura
 	WHERE   Fac.NoFactura  = Par_NoFactura
 		AND Fac.ProveedorID = Par_ProveedorID;
 END IF;

 IF(Par_NumCon = Con_PolizaFactura) THEN

 	(SELECT DET.PolizaID
 		FROM FACTURAPROV FAC, DETALLEPOLIZA DET
 		WHERE FAC.ProveedorID = Par_ProveedorID
 		AND FAC.NoFactura = Par_NoFactura
 		AND DET.Fecha = FAC.FechaFactura
 		AND trim(DET.Referencia) = FAC.NoFactura
 		AND FAC.NumTransaccion = DET.NumTransaccion)
 	UNION
 	(SELECT DET.PolizaID
 		FROM FACTURAPROV FAC, `HIS-DETALLEPOL` DET
 		WHERE FAC.ProveedorID = Par_ProveedorID
 		AND FAC.NoFactura = Par_NoFactura
 		AND DET.Fecha = FAC.FechaFactura
 		AND trim(DET.Referencia) = FAC.NoFactura
 		AND FAC.NumTransaccion = DET.NumTransaccion)
 	LIMIT 1;

 END IF;

 IF(Par_NumCon = Con_PeriodoVig) THEN
 	SELECT FechaFactura
 	INTO Var_FechaFact
 	FROM FACTURAPROV
 	WHERE ProveedorID  	= Par_ProveedorID
 	AND NoFactura     = Par_NoFactura;

 SET Var_PrimerDiaMes := CONVERT(DATE_ADD(Var_FechaFact, INTERVAL -1*(DAY(Var_FechaFact))+1 DAY),DATE);


 	SELECT 	Estatus
    INTO EstatusPeriodo
 	FROM PERIODOCONTABLE
 	WHERE Inicio = Var_PrimerDiaMes;

    SET EstatusPeriodo := IFNULL(EstatusPeriodo,Cadena_Vacia);
    SELECT EstatusPeriodo;

 END IF;

 IF(Par_NumCon = Con_FactDisper) THEN
		SELECT COUNT(D.FacturaProvID)AS NumDisp
		FROM FACTURAPROV F INNER JOIN DISPERSIONMOV D ON  F.FacturaProvID=D.FacturaProvID
		WHERE F.NoFactura= Par_NoFactura
		AND F.ProveedorID = Par_ProveedorID;

 END IF;

 IF(Par_NumCon = Con_FactAnticipo) THEN
 		SELECT COUNT(NoFactura)AS NumAnticipos
 		FROM ANTICIPOFACTURA
 		WHERE NoFactura= Par_NoFactura
 		AND ProveedorID = Par_ProveedorID
		AND EstatusAnticipo != Estatus_Cancelado;

 END IF;


 END TerminaStore$$