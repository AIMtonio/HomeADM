-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONREP`;
DELIMITER $$


CREATE PROCEDURE `DISPERSIONREP`(

	Par_FechaInicio			DATE,
	Par_FechaFin			DATE,
	Par_InstitucionID		INT(11),
	Par_CuentaAhoID			BIGINT(12),
	Par_EstatusEnc  		CHAR(1),
	Par_EstatusDet 			CHAR(1),
	Par_Sucursal			INT(11),
	Par_FormaPago			INT(11),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATE,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

	)

TerminaStore :BEGIN



DECLARE Var_Sentencia 	VARCHAR(5000);
DECLARE Var_Cadvacia 	CHAR(1);
DECLARE Entero_Cero		INT(11);
DECLARE Mes_Enero 		INT(11);
DECLARE Mes_Diciembre  	INT(11);


SET Var_Cadvacia 		:= '';
SET Entero_Cero 		:= 0;
SET Mes_Enero 			:= 1;
SET Mes_Diciembre 		:= 12;


SET Par_InstitucionID 	:= IFNULL(Par_InstitucionID,Entero_Cero);
SET Par_CuentaAhoID  	:= IFNULL(Par_CuentaAhoID,Entero_Cero);
SET Par_EstatusEnc 		:= IFNULL(Par_EstatusEnc,Var_Cadvacia);
SET Par_EstatusDet 		:= IFNULL(Par_EstatusDet,Var_Cadvacia);
SET Par_Sucursal  		:= IFNULL(Par_Sucursal,Entero_Cero);
SET Par_FormaPago		:= IFNULL(Par_FormaPAgo,Entero_Cero);


DROP TABLE IF EXISTS TMPDISPERSIONES;

SET Var_Sentencia := ' CREATE TEMPORARY TABLE TMPDISPERSIONES (SELECT CONVERT(LPAD(Enc.FolioOperacion, 8,"0"), CHAR) AS FolioOperacion,DATE(Enc.FechaOperacion) AS FechaOperacion, ';
SET Var_Sentencia :=CONCAT(Var_Sentencia,' Enc.InstitucionID,Inst.NombreCorto, Enc.NumCtaInstit AS CuentaAhoID,Cli.NombreCompleto AS NombreCompletoCli,  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' CASE WHEN Enc.Estatus="C" THEN "CERRADA"   ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHEN Enc.Estatus="A" THEN "ABIERTA" END AS EstatusEnc ,  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' Enc.Sucursal,Suc.NombreSucurs, CASE WHEN Mov.CuentaCargo = 0 THEN "" WHEN Mov.CuentaCargo != 0 THEN ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' CONVERT(LPAD(Mov.CuentaCargo, 11,"0"), CHAR) END AS CuentaCargo, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' CASE WHEN Mov.CuentaCargo = 0 THEN "" ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHEN Mov.CuentaCargo != 0 THEN Clien.NombreCompleto END AS NombreCompleto, ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' Mov.Descripcion AS DescriMov,Mov.Referencia,     ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' Mov.TipoMovDispID,Tipo.Descripcion,   ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' CASE WHEN Mov.FormaPago=1 THEN "SPEI"  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHEN Mov.FormaPago=2 THEN "CHEQUE"');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHEN Mov.FormaPago=3 THEN "BANCA ELECTRONICA"');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHEN Mov.FormaPago=4 THEN "TARJETA EMPRESARIAL"');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHEN Mov.FormaPago=5 THEN "ORDEN DE PAGO"');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHEN Mov.FormaPago=6 THEN "TRAN. SANTANDER" END AS FormaPago, Mov.Monto,  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' IFNULL(Mov.CuentaDestino,"")AS CuentaDestino,Mov.NombreBenefi,  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' CASE WHEN Mov.Estatus="P" THEN "PENDIENTE"  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHEN Mov.Estatus="A" THEN "AUTORIZADA"  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHEN Mov.Estatus="N" THEN "NO APLICADA"  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHEN Mov.Estatus="E" THEN "EXPORTADA"  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' END AS EstatusDet, Mov.NumTransaccion, IFNULL(Cat.Descripcion,"SIN CONCEPTO") AS Concepto,');

SET Var_Sentencia :=CONCAT(Var_Sentencia,' Mov.DispersionID,Mov.ClaveDispMov,Mov.FormaPago AS FormaPagoID, Mov.EstatusResSanta');

SET Var_Sentencia :=CONCAT(Var_Sentencia,' FROM DISPERSION  Enc  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN INSTITUCIONES Inst ON Inst.InstitucionID = Enc.InstitucionID  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN  CUENTASAHO Cue ON Cue.CuentaAhoID = Enc.CuentaAhoID  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN CLIENTES Cli ON Cli.ClienteID=Cue.ClienteID  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN  SUCURSALES Suc ON Suc.SucursalID=Enc.Sucursal  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN DISPERSIONMOV Mov ON Mov.DispersionID =  Enc.FolioOperacion  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' LEFT OUTER JOIN  CUENTASAHO Cuent ON Cuent.CuentaAhoID = Mov.CuentaCargo  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' LEFT OUTER JOIN CLIENTES Clien ON Clien.ClienteID=Cuent.ClienteID   ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN TIPOSMOVTESO Tipo ON Tipo.TipoMovTesoID=Mov.TipoMovDispID  ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' LEFT OUTER JOIN CATCONCEPTOSDISPERSION Cat ON Mov.ConceptoDispersion = Cat.ConceptoDispersionID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' WHERE DATE(Enc.FechaOperacion) >=? AND ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' DATE(Enc.FechaOperacion) <=? ');

IF(Par_InstitucionID != Entero_Cero) THEN
	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Enc.InstitucionID = ',CONVERT(Par_InstitucionID,CHAR));
END IF;

IF(Par_CuentaAhoID != Entero_Cero) THEN
	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Enc.NumCtaInstit = ',CONVERT(Par_CuentaAhoID,CHAR));
END IF;

IF(Par_EstatusEnc != Var_Cadvacia) THEN
	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Enc.Estatus="',CONVERT(Par_EstatusEnc,CHAR),'" ');
END IF;

IF(Par_EstatusDet != Var_Cadvacia) THEN
	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Mov.Estatus="',CONVERT(Par_EstatusDet,CHAR),'" ');
END IF;

IF(Par_Sucursal != Entero_Cero) THEN
	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' AND Enc.Sucursal =',CONVERT(Par_Sucursal,CHAR));
END IF;

IF (Par_FormaPago != Entero_Cero ) THEN
	SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Mov.FormaPago = ',CONVERT(Par_FormaPago,CHAR));
END IF;

	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ORDER BY Enc.Sucursal,Enc.InstitucionID ,Enc.NumCtaInstit, ');
	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' Enc.FechaOperacion,Mov.ClaveDispMov);');


SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

   PREPARE STDISPERSIONREP FROM @Sentencia;
   EXECUTE STDISPERSIONREP USING @FechaInicio, @FechaFin;
   DEALLOCATE PREPARE STDISPERSIONREP;


ALTER TABLE TMPDISPERSIONES ADD COLUMN PolizaID INT(11) AFTER NumTransaccion;
drop table IF EXISTS TMPDISPERSIONESAUX;
CREATE TEMPORARY TABLE TMPDISPERSIONESAUX(
PolizaID INT(11),
NumTransaccion 	BIGINT(20));

INSERT INTO TMPDISPERSIONESAUX (PolizaID,NumTransaccion)
	SELECT PC.PolizaID, PC.NumTransaccion
					FROM POLIZACONTABLE PC
					INNER JOIN TMPDISPERSIONES TM ON TM.NumTransaccion=PC.NumTransaccion;


DROP TABLE IF EXISTS TMPDISPERHISAUX;
CREATE TEMPORARY TABLE TMPDISPERHISAUX(
PolizaID INT(11),
NumTransaccion 	BIGINT(20));

INSERT INTO TMPDISPERHISAUX (PolizaID,NumTransaccion)


		SELECT HPC.PolizaID, HPC.NumTransaccion
				FROM `HIS-POLIZACONTA` HPC
				INNER JOIN TMPDISPERSIONES TM ON TM.NumTransaccion=HPC.NumTransaccion;

UPDATE TMPDISPERSIONES Dis,
		TMPDISPERSIONESAUX TD
		SET Dis.PolizaID=TD.PolizaID
		WHERE Dis.NumTransaccion=TD.NumTransaccion;

UPDATE TMPDISPERSIONES Dis,
		TMPDISPERHISAUX TH
		SET Dis.PolizaID=TH.PolizaID
		WHERE Dis.NumTransaccion=TH.NumTransaccion;

ALTER TABLE TMPDISPERSIONES ADD COLUMN EstatusRef VARCHAR(20) AFTER Concepto;

UPDATE TMPDISPERSIONES Dis
INNER JOIN REFORDENPAGOSAN Ref ON Dis.DispersionID = Ref.FolioOperacion AND Dis.ClaveDispMov = Ref.ClaveDispMov
SET Dis.EstatusRef =  CASE 	WHEN Ref.Estatus = "G" THEN "GENERADA"
							WHEN Ref.Estatus = "E" THEN "ENVIADA"
							WHEN Ref.Estatus = "V" THEN "VENCIDA"
							WHEN Ref.Estatus = "M" THEN "MODIFICADO"
							WHEN Ref.Estatus = "C" THEN "CANCELADO"
							WHEN Ref.Estatus = "O" THEN "EJECUTADO"
							WHEN Ref.Estatus = "P" THEN "EN PROCESO"
							WHEN Ref.Estatus = "R" THEN "PROGRAMADO"
						ELSE "" END
WHERE Dis.FormaPagoID = 5;

ALTER TABLE TMPDISPERSIONES ADD COLUMN EstatusTraSan VARCHAR(100) AFTER EstatusRef;

UPDATE TMPDISPERSIONES Dis
INNER JOIN CATSTATUSDISPERSIONES Cat ON Dis.EstatusResSanta = Cat.CodigoID SET
	EstatusTraSan = UPPER(Cat.Descripcion)
WHERE Dis.FormaPagoID = 6;

SELECT  FolioOperacion, 	FechaOperacion,	InstitucionID, 	NombreCorto,	CuentaAhoID,
		NombreCompletoCli, 	EstatusEnc, 	Sucursal, 		NombreSucurs,	CuentaCargo,
		NombreCompleto, 	DescriMov, 		Referencia,     TipoMovDispID,	Descripcion,
		FormaPago,			Monto,			CuentaDestino,	NombreBenefi,	EstatusDet,
		NumTransaccion,		PolizaID,		Concepto,		EstatusRef,		EstatusTraSan
FROM TMPDISPERSIONES;
END TerminaStore$$