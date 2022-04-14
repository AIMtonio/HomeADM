-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEAFONDEADORREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEAFONDEADORREP`;

DELIMITER $$
CREATE PROCEDURE `LINEAFONDEADORREP`(
	Par_InstitutFondID		INT(12),		-- Numero de Institucion de Fondeo
	Par_LineaFondeoID		INT(12),		-- Numero de Linea de Fondeo
	Par_CreditoFondeoID		INT(12),		-- Numero de Credito de Fondeo

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore:BEGIN

	/*DECLARACION DE CONSTANTES */
	DECLARE Var_Sentencia		VARCHAR(2000);
	DECLARE	Entero_Cero			INT;
	DECLARE	Decimal_Cero		DECIMAL(14,2);
	DECLARE	Pago_Credito		VARCHAR(100);
	DECLARE	Var_OtorgaCredito	VARCHAR(100);
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE	Nat_Abono			CHAR(1);

	/*ASIGNACION DE CONSTANTES */
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.00;
	SET Pago_Credito		:= 'PAGO DE CREDITO PASIVO';
	SET Var_OtorgaCredito 	:= 'OTORGAMIENTO DE CREDITO PASIVO';
	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';


	/*se crea tabla temporal */
	DROP TABLE IF EXISTS TMPLINFONREP;

	CREATE TEMPORARY TABLE TMPLINFONREP(
		TipoMovFonID    INT(11) ,
		FechaAplicacion DATE,
		CreditoFondeoID INT(11),
		Amortizacion    VARCHAR(10),
		Descripcion     VARCHAR(100),
		Capital         DECIMAL(14,2),
		Interes         DECIMAL(14,2),
		Moratorio       DECIMAL(14,2),
		Comisiones      DECIMAL(14,2),
		IVA             DECIMAL(14,2),
		Retencion       DECIMAL(14,2));

	-- Disposiciones u Otorgamientos
	SET Var_Sentencia := CONCAT('
		INSERT INTO TMPLINFONREP(
			TipoMovFonID,					FechaAplicacion,	CreditoFondeoID,
			Amortizacion,										Descripcion,
			Capital,						Interes,			Moratorio,			Comisiones,		IVA,
			Retencion)
		SELECT
			Crm.TipoMovFonID,	Crm.FechaAplicacion,			Crm.CreditoFondeoID,
			CONCAT("1-",CONVERT(Fon.NumAmortizacion, CHAR)),	Crm.Descripcion,
			SUM(Crm.Cantidad) AS Capital,	0,					0,					0,				0,
			0
		FROM CREDITOFONDMOVS Crm
		INNER JOIN CREDITOFONDEO Fon ON Crm.CreditoFondeoID = Fon.CreditoFondeoID
		WHERE Crm.TipoMovFonID IN (1,2)
		  AND Crm.Descripcion = "', Var_OtorgaCredito, '"');

	SET Par_CreditoFondeoID := IFNULL(Par_CreditoFondeoID,Entero_Cero);
	IF( Par_CreditoFondeoID != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT( Var_Sentencia,'
		  AND Fon.CreditoFondeoID = ',CONVERT(Par_CreditoFondeoID,CHAR));
	END IF;

	SET Par_LineaFondeoID := IFNULL(Par_LineaFondeoID,Entero_Cero);
	IF( Par_LineaFondeoID != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
		  AND Fon.LineaFondeoID = ',CONVERT(Par_LineaFondeoID,CHAR));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, '
		GROUP BY Crm.CreditoFondeoID, Crm.TipoMovFonID, Crm.FechaAplicacion, Crm.Descripcion;');

	SET @Sentencia := (Var_Sentencia);
	PREPARE STLINEAFONDEADORREP FROM @Sentencia;
	EXECUTE STLINEAFONDEADORREP;

	-- Devengamiento de Interes
	SET Var_Sentencia := '
		INSERT INTO TMPLINFONREP(
			TipoMovFonID,					FechaAplicacion,			CreditoFondeoID,
			Amortizacion,					Descripcion,
			Capital,						Interes,					Moratorio,			Comisiones,		IVA,
			Retencion)
		SELECT
			10,								MAX(Crm.FechaAplicacion),	Crm.CreditoFondeoID,
			Crm.AmortizacionID,				"DEVENGAMIENTO DE INTERES",
			0,								SUM(Crm.Cantidad), 			0,					0, 				0,
			0
		FROM CREDITOFONDMOVS Crm
		INNER JOIN CREDITOFONDEO Fon ON Crm.CreditoFondeoID = Fon.CreditoFondeoID
		WHERE Crm.TipoMovFonID = 10
		  AND Crm.NatMovimiento = "C"
		  AND Crm.Descripcion IN ("CIERRE DIARO CARTERA PASIVA","CIERRE DIARIO CARTERA PASIVA")';

	SET Par_CreditoFondeoID := IFNULL(Par_CreditoFondeoID,Entero_Cero);
	IF( Par_CreditoFondeoID != Entero_Cero )THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
		  AND Fon.CreditoFondeoID = ',CONVERT(Par_CreditoFondeoID,CHAR));
	END IF;

	SET Par_LineaFondeoID := IFNULL(Par_LineaFondeoID,Entero_Cero);
	IF( Par_LineaFondeoID != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
		  AND Fon.LineaFondeoID = ',CONVERT(Par_LineaFondeoID,CHAR));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, '
		GROUP BY Crm.CreditoFondeoID, Crm.AmortizacionID');

	SET @Sentencia	:= (Var_Sentencia);
	PREPARE STLINEAFONDEADORREP FROM @Sentencia;
	EXECUTE STLINEAFONDEADORREP;

	-- Comisiones por Falta de Pago
	SET Var_Sentencia := '
		INSERT INTO TMPLINFONREP(
			TipoMovFonID,					FechaAplicacion,			CreditoFondeoID,
			Amortizacion,					Descripcion,
			Capital,						Interes,					Moratorio,			Comisiones,			IVA,
			Retencion)
		SELECT
			40,								MAX(Crm.FechaAplicacion),	Crm.CreditoFondeoID,
			Crm.AmortizacionID,				"COMISION FALTA DE PAGO",
			0,								0, 							0,					SUM(Crm.Cantidad),	0,
			0
		FROM CREDITOFONDMOVS Crm
		INNER JOIN CREDITOFONDEO Fon ON Crm.CreditoFondeoID = Fon.CreditoFondeoID
		WHERE Crm.TipoMovFonID = 40
		  AND Crm.NatMovimiento = "C"';

	SET Par_CreditoFondeoID := IFNULL(Par_CreditoFondeoID,Entero_Cero);
	IF( Par_CreditoFondeoID != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
		  AND Fon.CreditoFondeoID = ',CONVERT(Par_CreditoFondeoID,CHAR));
	END IF;

	SET Par_LineaFondeoID := IFNULL(Par_LineaFondeoID,Entero_Cero);
	IF( Par_LineaFondeoID != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
		  AND Fon.LineaFondeoID = ',CONVERT(Par_LineaFondeoID,CHAR));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, '
		GROUP BY Crm.CreditoFondeoID, Crm.AmortizacionID');

	SET @Sentencia	:= (Var_Sentencia);
	PREPARE STLINEAFONDEADORREP FROM @Sentencia;
	EXECUTE STLINEAFONDEADORREP;

	-- Interes Moratorio
	SET Var_Sentencia := '
		INSERT INTO TMPLINFONREP(
			TipoMovFonID,					FechaAplicacion,			CreditoFondeoID,
			Amortizacion,					Descripcion,
			Capital,						Interes,					Moratorio,			Comisiones,			IVA,
			Retencion)
		SELECT
			40,								MAX(Crm.FechaAplicacion),	Crm.CreditoFondeoID,
			Crm.AmortizacionID,				"INTERES MORATORIO",
			0,								0, 							SUM(Crm.Cantidad), 	0,					0,
			0
		FROM CREDITOFONDMOVS Crm
		INNER JOIN CREDITOFONDEO Fon ON Crm.CreditoFondeoID = Fon.CreditoFondeoID
		WHERE Crm.TipoMovFonID = 15
		  AND Crm.NatMovimiento = "C"';

	SET Par_CreditoFondeoID := IFNULL(Par_CreditoFondeoID,Entero_Cero);
	IF( Par_CreditoFondeoID != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
		  AND Fon.CreditoFondeoID = ',CONVERT(Par_CreditoFondeoID,CHAR));
	END IF;

	SET Par_LineaFondeoID := IFNULL(Par_LineaFondeoID,Entero_Cero);
	IF( Par_LineaFondeoID != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
		  AND Fon.LineaFondeoID = ',CONVERT(Par_LineaFondeoID,CHAR));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, '
		GROUP BY Crm.CreditoFondeoID, Crm.AmortizacionID');

	SET @Sentencia	:= (Var_Sentencia);
	PREPARE STLINEAFONDEADORREP FROM @Sentencia;
	EXECUTE STLINEAFONDEADORREP;

	-- PAGOS REALIZADOS
	SET Var_Sentencia := '
		INSERT INTO TMPLINFONREP(
			TipoMovFonID,					FechaAplicacion,			CreditoFondeoID,
			Amortizacion,					Descripcion,
			Capital,
			Interes,
			Moratorio,
			Comisiones,
			IVA,
			Retencion)
		SELECT
			900, 							MAX(Crm.FechaAplicacion),	Crm.CreditoFondeoID,
			Crm.AmortizacionID,				"PAGO",
			SUM(CASE WHEN Crm.TipoMovFonID = 1 OR Crm.TipoMovFonID = 2 THEN Crm.Cantidad
					 ELSE 0
				END),
			SUM(CASE WHEN Crm.TipoMovFonID = 10 OR Crm.TipoMovFonID = 11 THEN Crm.Cantidad
					 ELSE 0
				END),
			SUM(CASE WHEN Crm.TipoMovFonID = 15 THEN Crm.Cantidad
					 ELSE 0
				END),
			SUM(CASE WHEN Crm.TipoMovFonID = 40 THEN Crm.Cantidad
					 ELSE 0
				END),
			SUM(CASE WHEN Crm.TipoMovFonID = 20 OR Crm.TipoMovFonID = 21 OR Crm.TipoMovFonID = 20 THEN Crm.Cantidad
					 ELSE 0
				END),
			SUM(CASE WHEN Crm.TipoMovFonID = 30 THEN Crm.Cantidad
					 ELSE 0
				END)
		FROM CREDITOFONDMOVS Crm
		INNER JOIN CREDITOFONDEO Fon ON Crm.CreditoFondeoID = Fon.CreditoFondeoID
		WHERE Crm.Descripcion = "PAGO DE CREDITO PASIVO"';

	SET Par_CreditoFondeoID := IFNULL(Par_CreditoFondeoID,Entero_Cero);
	IF( Par_CreditoFondeoID != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
		  AND Fon.CreditoFondeoID = ',CONVERT(Par_CreditoFondeoID,CHAR));
	END IF;

	SET Par_LineaFondeoID := IFNULL(Par_LineaFondeoID,Entero_Cero);
	IF( Par_LineaFondeoID != Entero_Cero ) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,'
		  AND Fon.LineaFondeoID = ',CONVERT(Par_LineaFondeoID,CHAR));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, '
		GROUP BY Crm.CreditoFondeoID, Crm.AmortizacionID, Transaccion');


	SET @Sentencia := (Var_Sentencia);
	PREPARE STLINEAFONDEADORREP FROM @Sentencia;
	EXECUTE STLINEAFONDEADORREP;

	DEALLOCATE PREPARE STLINEAFONDEADORREP;

	SELECT	TipoMovFonID,	Amortizacion,	FechaAplicacion,	CreditoFondeoID,	Descripcion,	Capital,
			Interes,		Moratorio,		Comisiones,			IVA,				Retencion
	FROM TMPLINFONREP
	ORDER BY FechaAplicacion,TipoMovFonID;

	DROP TABLE IF EXISTS TMPLINFONREP;

END  TerminaStore$$