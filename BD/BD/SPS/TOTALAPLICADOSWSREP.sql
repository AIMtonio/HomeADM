DELIMITER ;
DROP PROCEDURE IF EXISTS `TOTALAPLICADOSWSREP`;

DELIMITER $$
CREATE PROCEDURE `TOTALAPLICADOSWSREP`(
	Par_FechaInicio			DATE,
	Par_FechaFin			DATE,

	Par_InstitNominaID		INT(11),
	Par_ConvenioNominaID	INT(11),

	Par_NumRep				TINYINT UNSIGNED,

	/* Parametros de Auditoria */
  	Par_EmpresaID           INT(11),
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,

	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)

)
TerminaStore :BEGIN

	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Rep_Excel			INT;



	DECLARE Var_Sentencia	VARCHAR(50000);


	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Rep_Excel			:= 1;


	IF Par_NumRep = Rep_Excel THEN
		SET Var_Sentencia := CONCAT("
		SELECT 	Tot.FechaPago, 	Prod.ProducCreditoID,	Prod.NombreComercial AS DescProducto,	Cred.CreditoID,	IFNULL(Nom.InstitNominaID,0),		IFNULL(Nom.NombreInstit,'') AS DescInstNomina,
		IFNULL(Con.ConvenioNominaID,0), 	IFNULL(Con.Descripcion,'') AS ConvNominaDesc,		Cli.ClienteID,	Cli.NombreCompleto AS NombreCliente,		Cli.RFCOficial AS RFC,
		Cred.CuentaID AS CuentaAhoID,			Cue.SaldoDispon,		Cue.SaldoBloq,	Cue.Saldo AS SaldoTotal,				IFNULL(Inst.InstitucionID,0),
		IFNULL(Inst.NombreCorto,'') AS NombreInst,		IFNULL(Sol.ClabeCtaDomici,'') AS CuentaCLABE,
		SUM(ROUND(IFNULL(Det.MontoCapOrd, 0),2) + ROUND(IFNULL(Det.MontoCapAtr, 0),2)+ROUND(IFNULL(Det.MontoCapVen, 0),2)) AS Capital,
		SUM(ROUND(IFNULL(Det.MontoIntOrd, 0),2) + ROUND(IFNULL(Det.MontoIntAtr, 0),2)+ROUND(IFNULL(Det.MontoIntVen, 0),2)+ROUND(IFNULL(Det.MontoIntMora, 0),2)) AS Interes,
		SUM(ROUND(IFNULL(Det.MontoIVA, 0),2)) AS IvaInteres, 		SUM(ROUND(IFNULL(Det.MontoAccesorios, 0),2)) AS Accesorios,		SUM(ROUND(IFNULL(Det.MontoIVAAccesorios,0),2)) AS IVAAccesorios,
		SUM(ROUND(IFNULL(Det.MontoNotasCargo, 0),2)) AS NotasCargo,	SUM(ROUND(IFNULL(Det.MontoIVANotasCargo, 0),2)) AS IVANotaCargo,	SUM(ROUND(IFNULL(Det.MontoTotPago,0),2)) AS TotalPagado,
		ABS((SUM(ROUND(IFNULL(Det.MontoTotPago, 0),2))-Tot.TotalOperacion)) AS ImportePenApli,Tot.TotalOperacion,
		IFNULL(Det.FechaPago, '') AS FechaAplicacion,
		CtaTeso.InstitucionID,		InstTeso.NombreCorto AS NombreInstPago,		CtaTeso.NumCtaInstit AS CuentaPago,
		Pol.Concepto AS ConceptoPago, Tot.NumTransaccion AS MovimientoID, Tot.OrigenPago

		FROM TOTALAPLICADOSWSPAG Tot
		INNER JOIN CREDITOS Cred ON Tot.CreditoID = Cred.CreditoID
		INNER JOIN SOLICITUDCREDITO Sol ON Cred.SolicitudCreditoID = Sol.SolicitudCreditoID
		INNER JOIN PRODUCTOSCREDITO Prod ON Cred.ProductoCreditoID = Prod.ProducCreditoID
		INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
		INNER JOIN CUENTASAHO Cue ON Cred.CuentaID = Cue.CuentaAhoID
		INNER JOIN CUENTASAHOTESO CtaTeso ON Tot.InstitPagoID = CtaTeso.NumCtaInstit
		INNER JOIN INSTITUCIONES InstTeso  ON CtaTeso.InstitucionID = InstTeso.InstitucionID
		LEFT JOIN INSTITNOMINA Nom ON Sol.InstitucionNominaID = Nom.InstitNominaID
		LEFT JOIN CONVENIOSNOMINA Con ON Nom.InstitNominaID = Con.InstitNominaID AND Sol.ConvenioNominaID = Con.ConvenioNominaID
		LEFT JOIN CUENTASTRANSFER CtaT ON Sol.ClabeCtaDomici = CtaT.Clabe AND CtaT.InstitucionID != 0
		LEFT JOIN INSTITUCIONES Inst ON CtaT.InstitucionID = Inst.ClaveParticipaSpei
		LEFT JOIN DETALLEPAGCRE Det ON Det.CreditoID = Tot.CreditoID AND Det.NumTransaccion = Tot.NumTransaccion
		LEFT JOIN POLIZACONTABLE Pol ON  Tot.NumTransaccion = Pol.NumTransaccion
		WHERE Tot.FechaPago BETWEEN '",Par_FechaInicio,"' AND '",Par_FechaFin,"'");

		IF Par_InstitNominaID != Entero_Cero THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia," AND Nom.InstitNominaID = ",Par_InstitNominaID);
		END IF;

		IF Par_ConvenioNominaID != Entero_Cero THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia," AND Con.ConvenioNominaID = ",Par_ConvenioNominaID);
		END IF;


		SET Var_Sentencia := CONCAT(Var_Sentencia," GROUP BY Tot.FechaPago,			Prod.ProducCreditoID,	Prod.NombreComercial,	Cred.CreditoID,	Nom.InstitNominaID,		Nom.NombreInstit,
				Con.ConvenioNominaID, 	Con.Descripcion,		Cli.ClienteID,	Cli.NombreCompleto,		Cli.RFCOficial,
				Cred.CuentaID,			Cue.SaldoDispon,		Cue.SaldoBloq,	Cue.Saldo,				Inst.InstitucionID,
				Inst.NombreCorto,		Sol.ClabeCtaDomici,Det.FechaPago,Tot.TotalOperacion,
				CtaTeso.InstitucionID,		InstTeso.NombreCorto,		CtaTeso.NumCtaInstit,
				Pol.Concepto,Tot.NumTransaccion,Tot.OrigenPago;");

		SET @Sentencia	= (Var_Sentencia);

		PREPARE TOTALAPLICADOSWSREP FROM @Sentencia;
		EXECUTE TOTALAPLICADOSWSREP;


	END IF;

END TerminaStore$$