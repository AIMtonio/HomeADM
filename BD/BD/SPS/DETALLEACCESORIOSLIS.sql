-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEACCESORIOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEACCESORIOSLIS`;
DELIMITER $$

CREATE PROCEDURE `DETALLEACCESORIOSLIS`(
# =====================================================================================
# ----- SP QUE LISTA LOS ACCESORIOS COBRADOS POR CREDITO  -----------------
# =====================================================================================
	Par_SolicitudCreditoID		BIGINT(20),			# Numero de Solicitud de Credito
    Par_CreditoID				BIGINT(20),			# Numero de Credito
	Par_NumLis					TINYINT UNSIGNED,	# Numero de Lista

    # Parametros de Auditoria
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(12),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

	# Declaracion de Variables
	DECLARE Var_ProductoCreditoID	INT(11);	# Producto de Credito
	DECLARE Var_Plazo				INT(11);	# Plazo del Credito
    DECLARE Var_CicloCliente		INT(11);	# Ciclo Actual del Cliente
    DECLARE Var_ClienteID			INT(11);	# Numero de Cliente
    DECLARE Var_ConvenioNominaID	INT(11);		-- Numero de Convenio de Nomina
    DECLARE Var_MontoCreSol			DECIMAL(12,2); 	-- Monto de Credito o Solicitud
    DECLARE Var_NumAccesorios		INT(11);		-- Variable para almacenar el numero de accesorios diferentes considerados en una simulacion o un credito
    DECLARE Var_EncabezadoLista		VARCHAR(5000);	-- Variable para almacenar el encabezado para el grid de detalle de accesorios
    DECLARE Var_NumAmortizacion		INT(11);		-- Variable para almacenar un numero de amortizaciones por simulacion
    DECLARE Var_GeneraInteres		CHAR(1);		-- Variable para indicar si el accesorio genera interes o no

	# Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1); 		# Constante Cadena Vacía
	DECLARE	Fecha_Vacia				DATE; 			# Constante Fecha Vacía
	DECLARE	Entero_Cero				INT; 			# Constante Entero Cero
	DECLARE Entero_Uno				INT(11);		-- Constante Entero Uno
	DECLARE Decimal_Cero			DECIMAL(12,2); 	# Constante Decimal Cero
	DECLARE CobroFinanciado			CHAR(1); 		# Constante Cobro Financiado : F
	DECLARE CobroAnticipado			CHAR(1); 		# Constante Cobro Anticipado : A
	DECLARE	Lis_Principal 			INT(11); 		# Constante Lista Principal 1
	DECLARE Lis_AccesoriosCred		INT(11); 		# Constante Lista Accesorios por Crédito
    DECLARE Lis_AccesSolicid 		INT(11); 		# Constante Lista Accesorios por Solicitud
    DECLARE Salida_NO				CHAR(1);		# Salida SI
    DECLARE Var_CadenaSI			CHAR(1);		-- Cadena SI
    DECLARE Var_CadenaNO			CHAR(1);		-- Cadena No
    DECLARE Var_LisAccSimulacion	INT(11);		-- Lista de desglose de accesorios para la simulación de solicitudes

	# Asignacion de Constantes
	SET Cadena_Vacia			:= '';				# Constante: Cadena Vacia
	SET Fecha_Vacia 			:= '1900-01-01';	# Constante: Fecha Vacia
	SET Entero_Cero				:= 0;				# Constante: Entero Cero
	SET Entero_Uno				:= 1;				-- Constante Entero Uno
	SET Decimal_Cero			:= 0.0;				# Constante: DECIMAL Cerp
	SET Lis_Principal 			:= 3;				# Lista Principal
	SET Lis_AccesoriosCred		:= 4;				# Lista de Accesorios del Credito
    SET Lis_AccesSolicid		:= 5;				# Lista de Accesorios por Solicitud de Crédito
	SET CobroFinanciado			:= 'F';				# Forma de cobro FINANCIADO
	SET CobroAnticipado			:= 'A';				# Forma de Cobro ANTICIPADO
    SET Salida_NO				:= 'N';				# Constante Salida: SI
    SET Var_CadenaSI			:= 'S';				-- Cadena S de SI
    SET Var_CadenaNO			:= 'N';				-- Cadena N de No
	SET Var_LisAccSimulacion	:= 6;				-- Lista de desglose de accesorios para la simulación de solicitudes


	IF(Par_NumLis = Lis_Principal) THEN

		# LISTA LOS ACCESORIOS QUE SON COBRADOS POR UN CREDITO
		IF(Par_CreditoID > Entero_Cero) THEN

			SELECT 	ProductoCreditoID,	PlazoID,	ClienteID, ConvenioNominaID, MontoCredito
				INTO Var_ProductoCreditoID,	Var_Plazo,	Var_ClienteID,	Var_ConvenioNominaID, Var_MontoCreSol
				FROM CREDITOS
				WHERE CreditoID = Par_CreditoID;


			# Se obtiene el ciclo del Cliente
			 CALL CRECALCULOCICLOPRO(
				Var_ClienteID,		Entero_Cero,		Var_ProductoCreditoID,	Entero_Cero,	Var_CicloCliente,
				Entero_Cero,		Salida_NO,			Par_EmpresaID,			Aud_Usuario,	Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			(SELECT  Det.AccesorioID, Det.TipoFormaCobro, Det.MontoAccesorio, Det.MontoIVAAccesorio, Det.CobraIVA, Ac.NombreCorto
				FROM DETALLEACCESORIOS Det
				INNER JOIN ACCESORIOSCRED Ac
				ON	Det.AccesorioID = Ac.AccesorioID
				WHERE CreditoID = Par_CreditoID
				AND Det.TipoFormaCobro<>CobroFinanciado)

			UNION

			# OBTIENE LOS ACCESORIOS COBRADOR POR CREDITO CUANDO LA FORMA DE COBRO ES FINANCIADO
			 (SELECT	Esq.AccesorioID, 	Esq.TipoFormaCobro AS TipoFormaCobro,	Decimal_Cero AS MontoAccesorio,	Decimal_Cero AS MontoIVAAccesorio,
						Esq.CobraIVA,		Ac.NombreCorto
				FROM ESQUEMAACCESORIOSPROD Esq
					INNER JOIN ESQCOBROACCESORIOS EsqAc
					ON 	Esq.AccesorioID = EsqAc.AccesorioID
					AND Esq.ProductoCreditoID = EsqAc.ProductoCreditoID
					INNER JOIN ACCESORIOSCRED Ac
					ON 	Esq.AccesorioID = Ac.AccesorioID
					AND EsqAc.AccesorioID = Ac.AccesorioID
					INNER JOIN PRODUCTOSCREDITO Pro
					ON Pro.ProducCreditoID = Esq.ProductoCreditoID
					LEFT JOIN CONVENIOSNOMINA Con
					ON EsqAc.ConvenioID = Con.ConvenioNominaID
					AND Esq.InstitNominaID = Con.InstitNominaID
				WHERE Esq.ProductoCreditoID = Var_ProductoCreditoID
				  AND EsqAc.PlazoID 		= Var_Plazo
				  AND Esq.TipoFormaCobro 	= CobroFinanciado
				  AND Var_CicloCliente 		>= EsqAc.CicloIni
				  AND Var_CicloCliente 		<= EsqAc.CicloFin
				  AND EsqAc.ConvenioID 		= Var_ConvenioNominaID
				  AND Var_MontoCreSol 		BETWEEN EsqAc.MontoMin AND EsqAc.MontoMax
				  AND ((Pro.ProductoNomina = Var_CadenaSI
                  AND EsqAc.ConvenioID = Con.ConvenioNominaID
                  AND Esq.InstitNominaID = Con.InstitNominaID)
                  OR (Pro.ProductoNomina = Var_CadenaNO))
				)
				  ORDER  BY TipoFormaCobro;

		ELSE
		# LISTA LOS ACCESORIOS QUE SON COBRADOS POR SOLICITUD DE CREDITO
			SELECT ProductoCreditoID,	PlazoID, ClienteID, ConvenioNominaID, MontoSolici
				INTO Var_ProductoCreditoID,	Var_Plazo,	Var_ClienteID, Var_ConvenioNominaID, Var_MontoCreSol
				FROM SOLICITUDCREDITO
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;


            # Se obtiene el ciclo del Cliente
			 CALL CRECALCULOCICLOPRO(
				Var_ClienteID,		Entero_Cero,		Var_ProductoCreditoID,	Entero_Cero,	Var_CicloCliente,
				Entero_Cero,		Salida_NO,			Par_EmpresaID,			Aud_Usuario,	Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


			(SELECT  Det.AccesorioID, Det.TipoFormaCobro,	Det.MontoAccesorio, Det.MontoIVAAccesorio, Det.CobraIVA, Ac.NombreCorto
				FROM DETALLEACCESORIOS Det
				INNER JOIN ACCESORIOSCRED Ac
				ON 	Det.AccesorioID = Ac.AccesorioID
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID)


			UNION

			# OBTIENE LOS ACCESORIOS COBRADOR POR CREDITO CUANDO LA FORMA DE COBRO ES FINANCIADO
			 (SELECT	Esq.AccesorioID, 	Esq.TipoFormaCobro AS TipoFormaCobro,	Decimal_Cero AS MontoAccesorio,	Decimal_Cero AS MontoIVAAccesorio,
						Esq.CobraIVA,		Ac.NombreCorto
				FROM ESQUEMAACCESORIOSPROD Esq
					INNER JOIN ESQCOBROACCESORIOS EsqAc
					ON 	Esq.AccesorioID = EsqAc.AccesorioID
					AND Esq.ProductoCreditoID = EsqAc.ProductoCreditoID
					INNER JOIN ACCESORIOSCRED Ac
					ON 	Esq.AccesorioID = Ac.AccesorioID
					AND EsqAc.AccesorioID = Ac.AccesorioID
					INNER JOIN PRODUCTOSCREDITO Pro
					ON Pro.ProducCreditoID = Esq.ProductoCreditoID
					LEFT JOIN CONVENIOSNOMINA Con
					ON EsqAc.ConvenioID = Con.ConvenioNominaID
					AND Esq.InstitNominaID = Con.InstitNominaID
				WHERE Esq.ProductoCreditoID = Var_ProductoCreditoID
				  AND EsqAc.PlazoID 		= Var_Plazo
				  AND Esq.TipoFormaCobro 	= CobroFinanciado
				  AND Var_CicloCliente 		>= EsqAc.CicloIni
				  AND Var_CicloCliente 		<= EsqAc.CicloFin
				  AND EsqAc.ConvenioID 		= Var_ConvenioNominaID
				  AND Var_MontoCreSol 		BETWEEN EsqAc.MontoMin AND EsqAc.MontoMax
				  AND ((Pro.ProductoNomina = Var_CadenaSI
                  AND EsqAc.ConvenioID = Con.ConvenioNominaID
                  AND Esq.InstitNominaID = Con.InstitNominaID)
                  OR (Pro.ProductoNomina = Var_CadenaNO))
				)
				  ORDER  BY TipoFormaCobro;


		END IF;
	END IF;

	# LISTA DE ACCESORIOS QUE SU FORMA DE COBRO ES ANTICIPADO
	IF(Par_NumLis = Lis_AccesoriosCred) THEN
		SELECT 	MAX(Det.AccesorioID) AS AccesorioID, MAX(Ac.NombreCorto) AS NombreCorto,	MAX(Ac.Descripcion) AS Descripcion,
				SUM(Det.SaldoVigente) AS MontoCuota, SUM(Det.SaldoIVAAccesorio) AS MontoIVACuota
		FROM DETALLEACCESORIOS Det
		INNER JOIN ACCESORIOSCRED Ac
		ON Det.AccesorioID = Ac.AccesorioID
		WHERE TipoFormaCobro = CobroAnticipado
		AND FechaLiquida = Fecha_Vacia
		AND Det.CreditoID = Par_CreditoID
		GROUP BY Det.AccesorioID;
	END IF;

	# LISTA DE ACCESORIOS POR SOLICITUD DE CREDITO
	IF(Par_NumLis = Lis_AccesSolicid) THEN
		SELECT 	MAX(Det.AccesorioID) AS AccesorioID, MAX(Ac.NombreCorto) AS NombreCorto,	MAX(Ac.Descripcion) AS Descripcion,
				SUM(Det.SaldoVigente) AS MontoCuota, SUM(Det.SaldoIVAAccesorio) AS MontoIVACuota
		FROM DETALLEACCESORIOS Det
		INNER JOIN ACCESORIOSCRED Ac
		ON Det.AccesorioID = Ac.AccesorioID
		WHERE TipoFormaCobro = 'D'
		AND FechaLiquida = Fecha_Vacia
		AND Det.SolicitudCreditoID = Par_SolicitudCreditoID
		GROUP BY Det.AccesorioID;
	END IF;

	-- Lista detalle para desglose de accesorios en tabla de simulacion
	IF (Par_NumLis = Var_LisAccSimulacion) THEN

		SET Par_CreditoID	:= IFNULL(Par_CreditoID, Entero_Cero);

		DELETE FROM TMPLISTAACCESORIOSSIMULADOS WHERE IF (CreditoID > Entero_Cero, CreditoID = Par_CreditoID, NumTransaccion = Aud_NumTransaccion);
		DELETE FROM TMPLISTAACCESORIOSSIMULADOS WHERE NumTransaccion = Aud_NumTransaccion;

		SELECT		COUNT(DISTINCT(AmortizacionID))
			INTO	Var_NumAmortizacion
			FROM	DETALLEACCESORIOS
			WHERE	IF (Par_CreditoID > Entero_Cero, CreditoID = Par_CreditoID, NumTransacSim = Aud_NumTransaccion)
			AND 	TipoFormaCobro = 'F';

		SELECT		COUNT(DISTINCT(AccesorioID))
			INTO	Var_NumAccesorios
			FROM	DETALLEACCESORIOS
			WHERE	IF (Par_CreditoID > Entero_Cero, CreditoID = Par_CreditoID, NumTransacSim = Aud_NumTransaccion)
			AND 	TipoFormaCobro = 'F';

		IF (Var_NumAccesorios = Entero_Cero) THEN

			INSERT INTO TMPLISTAACCESORIOSSIMULADOS (
								AccesorioID,		AmortizacionID,			MontoCuota,				MontoIVACuota,			MontoIntCuota,
								MontoIVAIntCuota,	MontoAccesorio,			MontoIVAAccesorio,		MontoInteres,			MontoIVAInteres,
								GeneraInteres,		ContadorAccesorios,		EncabezadoLista,		NumAmortizacion,		CreditoID,
								NumTransaccion	)
					VALUES	(	Entero_Cero,		Entero_Cero,			Entero_Cero,			Entero_Cero,			Entero_Cero,
								Entero_Cero,		Entero_Cero,			Entero_Cero,			Entero_Cero,			Entero_Cero,
								Cadena_Vacia,		Var_NumAccesorios,		Cadena_Vacia,			Var_NumAmortizacion,	Par_CreditoID,
								Aud_NumTransaccion	);

		ELSEIF (Var_NumAccesorios = Entero_Uno) THEN

			INSERT INTO TMPLISTAACCESORIOSSIMULADOS (
								AccesorioID,			AmortizacionID,			MontoCuota,				MontoIVACuota,		MontoIntCuota,
								MontoIVAIntCuota,		MontoAccesorio,			MontoIVAAccesorio,		MontoInteres,		MontoIVAInteres,
								GeneraInteres,
								EncabezadoLista,
								ContadorAccesorios,		NumAmortizacion,		CreditoID,				NumTransaccion	)
					SELECT		DET.AccesorioID,		DET.AmortizacionID,		DET.MontoCuota,			DET.MontoIVACuota,	DET.MontoIntCuota,
								DET.MontoIVAIntCuota,	DET.MontoAccesorio,		DET.MontoIVAAccesorio,	DET.MontoInteres,
								IF(DET.GeneraInteres = Var_CadenaSI,IFNULL(DET.MontoIVAInteres,Entero_Cero),Entero_Cero) AS MontoIVAInteres,
								DET.GeneraInteres,
								IF (DET.GeneraInteres = Var_CadenaSI,
									CONCAT(ACC.NombreCorto, ',IVA de ', ACC.NombreCorto, ',Inter&eacute;s de ' , ACC.NombreCorto, ',IVA Inter&eacute;s de ', ACC.NombreCorto),
									CONCAT(ACC.NombreCorto, ',IVA de ', ACC.NombreCorto)
								) EncabezadoLista,
								Var_NumAccesorios,			Var_NumAmortizacion,	Par_CreditoID,			Aud_NumTransaccion
						FROM	DETALLEACCESORIOS DET
						INNER JOIN ACCESORIOSCRED ACC ON DET.AccesorioID = ACC.AccesorioID
						WHERE	IF (Par_CreditoID > Entero_Cero, CreditoID = Par_CreditoID, NumTransacSim = Aud_NumTransaccion)
						AND 	TipoFormaCobro = 'F';

		ELSE

			INSERT INTO TMPLISTAACCESORIOSSIMULADOS (
								AccesorioID,			AmortizacionID,			MontoCuota,				MontoIVACuota,		MontoIntCuota,
								MontoIVAIntCuota,		MontoAccesorio,			MontoIVAAccesorio,		MontoInteres,		MontoIVAInteres,
								GeneraInteres,
								EncabezadoLista,
								ContadorAccesorios,		NumAmortizacion,		CreditoID,				NumTransaccion	)
					SELECT		DET.AccesorioID,		DET.AmortizacionID,		DET.MontoCuota,			DET.MontoIVACuota,	DET.MontoIntCuota,
								DET.MontoIVAIntCuota,	DET.MontoAccesorio,		DET.MontoIVAAccesorio,	DET.MontoInteres,
								IF(DET.GeneraInteres = Var_CadenaSI,IFNULL(DET.MontoIVAInteres,Entero_Cero),Entero_Cero) AS MontoIVAInteres,
								DET.GeneraInteres,
								IF (DET.GeneraInteres = Var_CadenaSI,
									CONCAT(ACC.NombreCorto, ',IVA de ', ACC.NombreCorto, ',Inter&eacute;s de ' , ACC.NombreCorto, ',IVA Inter&eacute;s de ', ACC.NombreCorto),
									CONCAT(ACC.NombreCorto, ',IVA de ', ACC.NombreCorto)
								) EncabezadoLista,
								Var_NumAccesorios,			Var_NumAmortizacion,	Par_CreditoID,			Aud_NumTransaccion
						FROM	DETALLEACCESORIOS DET
						INNER JOIN ACCESORIOSCRED ACC ON DET.AccesorioID = ACC.AccesorioID
						WHERE	IF (Par_CreditoID > Entero_Cero, CreditoID = Par_CreditoID, NumTransacSim = Aud_NumTransaccion)
						AND 	TipoFormaCobro = 'F';

		END IF;

		SELECT		AmortizacionID,			MontoCuota,				MontoIVACuota,			MontoIntCuota,			MontoIVAIntCuota,
					MontoAccesorio,			MontoIVAAccesorio,		MontoInteres,			MontoIVAInteres,		GeneraInteres,
					ContadorAccesorios,		EncabezadoLista,		NumAmortizacion
			FROM	TMPLISTAACCESORIOSSIMULADOS
			WHERE	NumTransaccion = Aud_NumTransaccion;

		DELETE FROM TMPLISTAACCESORIOSSIMULADOS WHERE IF (CreditoID > Entero_Cero, CreditoID = Par_CreditoID, NumTransaccion = Aud_NumTransaccion);
		DELETE FROM TMPLISTAACCESORIOSSIMULADOS WHERE NumTransaccion = Aud_NumTransaccion;

	END IF;

END TerminaStore$$
