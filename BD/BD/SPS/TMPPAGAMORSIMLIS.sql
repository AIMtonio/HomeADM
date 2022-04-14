-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPAGAMORSIMLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPPAGAMORSIMLIS`;

DELIMITER $$
CREATE PROCEDURE `TMPPAGAMORSIMLIS`(
	-- Devuelve las amortizaciones temporales
	Par_NumTransac		INT,				-- Numero de transaccion de la amortizacion
	Par_NumLis			TINYINT UNSIGNED,   -- Numero de lista
	Par_EmpresaID		INT,

	-- Parametros de auditoria
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema        	DATE;
	DECLARE Var_Capital					DECIMAL(14,2);
	DECLARE Var_TasaFija            	DECIMAL(18,4);
	DECLARE Var_ComisAp             	DECIMAL(18,2);
    DECLARE Var_CobraSeguroCuota 		CHAR(1);

    DECLARE Var_CobraIVASeguroCuota 	CHAR(1);
	DECLARE Var_MontoSeguroCuota 		DECIMAL(12,2);
	DECLARE Var_TotalSeguroCuota 		DECIMAL(12,2);
	DECLARE Var_TotalIVASeguroCuota 	DECIMAL(12,2);
	DECLARE Var_SaldoOtrasComisiones	DECIMAL(14,2);	-- Saldo de Otras Comisiones

    DECLARE Var_SaldoIVAOtrasComisiones	DECIMAL(14,2);	-- Saldo IVA Otras Comisiones
    DECLARE Var_NumErr					INT(11);		-- Numero de Error
    DECLARE Var_ErrMen					VARCHAR(400);	-- Descripcion del Error
	DECLARE Var_CAT						DECIMAL(12,4);	-- Se obtiene el valor del CAT
    DECLARE Var_SolicitudCreditoID		BIGINT(20);		-- Se obtiene el numero de la solicitud de credito

    DECLARE Var_ProductoCreID       	INT(11);		-- Se obtiene el producto de Credito
	DECLARE Var_ClienteID				INT(11);		-- Se obtiene el Numero del Cliente
	DECLARE Var_ValorReqPrimerAmor		CHAR(1);		-- Descripcion de LLave del Parametro
	DECLARE Var_EsConsolidacionAgro 	CHAR(1);		-- Es consolidacion Agro
	DECLARE Var_FechaDesembolsoConAgro	 DATE;		-- Fecha de Desembolso de un credito consolidacion Agro

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha vacia
	DECLARE	Entero_Cero			INT;			-- Entero Cero
	DECLARE Decimal_Cero        DECIMAL(12,2);	-- Decimal Cero
	DECLARE SalidaNO            CHAR(1);		-- Salida: NO

    DECLARE ConstanteNO			CHAR(1);		-- Constante: NO
    DECLARE ConstanteSI			CHAR(1);		-- Constante: SI
	DECLARE	Lis_Principal		INT;            -- Lista Principal
	DECLARE DescValidaReqPrimerAmor	VARCHAR(50);	-- Descripcion

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero        := 0.0;				-- Decimal Cero
	SET SalidaNO            := 'N';				-- Salida: NO

    SET ConstanteNO         := 'N';				-- Constante: NO
	SET ConstanteSI         := 'S';				-- Constante: SI
	SET Lis_Principal       := 6;				-- Lista Principal
	SET DescValidaReqPrimerAmor	:= 'ValidaReqPrimerAmor';	-- Descripcion de LLave del Parametro

    -- Asignacion de Variables
    SET Var_NumErr := 0;
    SET Var_ErrMen := '';

	-- Consulta principal de amortizaciones temporales
	IF(Par_NumLis = Lis_Principal ) THEN
		-- SE OBTIENE INFORMACION DE LA SOLICITUD DE CREDITO
		SELECT 	ProductoCreditoID,			TasaFija,				ClienteID,				MontoPorComAper,			CobraSeguroCuota,
				CobraIVASeguroCuota,		MontoSeguroCuota,		SolicitudCreditoID,		EsConsolidacionAgro,		FechaInicio
        INTO 	Var_ProductoCreID,			Var_TasaFija,			Var_ClienteID,  		Var_ComisAp,				Var_CobraSeguroCuota,
				Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota, 	Var_SolicitudCreditoID,	Var_EsConsolidacionAgro,	Var_FechaDesembolsoConAgro
        FROM SOLICITUDCREDITO
        WHERE NumTransacSim = Par_NumTransac;

		-- Se obtiene el valor si requiere validar los dias requeridos para la primera amortizacion en Tipo Pago Capital LIBRES
		SELECT ValorParametro
		INTO Var_ValorReqPrimerAmor
		FROM PARAMGENERALES
		WHERE LlaveParametro = DescValidaReqPrimerAmor;

		SET Var_ValorReqPrimerAmor   := IFNULL(Var_ValorReqPrimerAmor, ConstanteNO);

		/* SP que actualiza la fecha de inicio, vencimiento y exigibilidad de las amortizaciones
		  cuando ya hayan realizados cierres y se consulten las amortizaciones de pagos libres */

        IF(Var_ValorReqPrimerAmor = ConstanteNO)THEN
			CALL PAGAMORLIBPRO(
				Par_NumTransac,		Par_EmpresaID,		Aud_Usuario,     Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

        IF(Var_ValorReqPrimerAmor = ConstanteSI)THEN

			-- SE OBTIENE LA FECHA DEL SISTEMA
			SET Var_FechaSistema	:=  (SELECT FechaSistema FROM PARAMETROSSIS);

			-- SE ACTUALIZA LA FECHA DE INICIO DE LA PRIMERA AMORTIZACION A LA FECHA DEL SISTEMA
			UPDATE TMPPAGAMORSIM
			SET Tmp_FecIni = CASE WHEN IFNULL(Var_EsConsolidacionAgro, ConstanteNO) = ConstanteNO THEN Var_FechaSistema
								  ELSE Var_FechaDesembolsoConAgro END
			WHERE NumTransaccion = Par_NumTransac
			AND Tmp_Consecutivo = 1;

			-- SE ACTUALIZA LOS NUMEROS DE DIAS DE LA PRIMERA AMORTIZACION
			UPDATE TMPPAGAMORSIM
			SET Tmp_Dias = DATEDIFF(Tmp_FecFin,Tmp_FecIni)
			WHERE NumTransaccion = Par_NumTransac
			AND Tmp_Consecutivo = 1;

			-- SE OBTIENE LA SUMA DEL CAPITAL
			SELECT SUM(Tmp_Capital) INTO Var_Capital
			FROM TMPPAGAMORSIM
			WHERE NumTransaccion = Par_NumTransac;

			 -- SP PARA RECAULCULAR LAS AMORTIZACIONES EN PAGOS LIBRES
			CALL CRERECPAGLIBPRO(
				Var_Capital,			Var_TasaFija,				Var_ProductoCreID,		Var_ClienteID,		Var_ComisAp,
				Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Decimal_Cero,		SalidaNO,
				Var_NumErr,				Var_ErrMen,					Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Par_NumTransac);

			-- SE OBTIENE EL VALOR DEL CAT
			SELECT Tmp_Cat INTO Var_CAT
			FROM TMPPAGAMORSIM
			WHERE NumTransaccion = Par_NumTransac
			AND Tmp_Consecutivo = 1;

			UPDATE SOLICITUDCREDITO SET
				FechaInicio         = CASE WHEN IFNULL(Var_EsConsolidacionAgro, ConstanteNO) = ConstanteNO THEN Var_FechaSistema
							  			   ELSE Var_FechaDesembolsoConAgro END,
				FechaInicioAmor     = CASE WHEN IFNULL(Var_EsConsolidacionAgro, ConstanteNO) = ConstanteNO THEN Var_FechaSistema
							  			   ELSE Var_FechaDesembolsoConAgro END,
			    ValorCAT			= Var_CAT
			WHERE SolicitudCreditoID = Var_SolicitudCreditoID;
		END IF;

		-- Se consultan las amortizaciones temporales
		SELECT	SUM(Tmp_MontoSeguroCuota),SUM(Tmp_IVASeguroCuota),	SUM(Tmp_OtrasComisiones),	SUM(Tmp_IVAOtrasComisiones)
			INTO Var_TotalSeguroCuota, Var_TotalIVASeguroCuota,		Var_SaldoOtrasComisiones,	Var_SaldoIVAOtrasComisiones
		FROM TMPPAGAMORSIM
		WHERE NumTransaccion = Par_NumTransac
		GROUP BY NumTransaccion;


		SET Var_TotalSeguroCuota := IFNULL(Var_TotalSeguroCuota,Entero_Cero);
		SET Var_TotalIVASeguroCuota := IFNULL(Var_TotalIVASeguroCuota,Entero_Cero);

		SELECT	Tmp_Consecutivo,		Tmp_FecIni, 	Tmp_FecFin,			Tmp_FecVig,		FORMAT(Tmp_Capital,2) AS Tmp_Capital,
				FORMAT(Tmp_Interes,2) AS Tmp_Interes,	FORMAT(Tmp_Iva,2) AS Tmp_Iva,		FORMAT(Tmp_SubTotal,2) AS Tmp_SubTotal,
				FORMAT(Tmp_Insoluto,2)AS Tmp_Insoluto,	Tmp_CuotasCap,		Tmp_CapInt,		Tmp_Cat,		NumTransaccion,
				FORMAT(Tmp_MontoSeguroCuota,2) AS MontoSeguroCuota,
				FORMAT(Tmp_IVASeguroCuota,2) AS IVASeguroCuota,
				FORMAT(Var_TotalSeguroCuota,2) AS TotalSeguroCuota,
				FORMAT(Var_TotalIVASeguroCuota,2) AS TotalIVASeguroCuota,
				FORMAT(Tmp_OtrasComisiones,2)	AS OtrasComisiones,
				FORMAT(Tmp_IVAOtrasComisiones,2)	AS IVAOtrasComisiones,
				FORMAT(Var_SaldoOtrasComisiones,2) AS TotalOtrasComisiones,
				FORMAT(Var_SaldoIVAOtrasComisiones,2) AS TotalIVAOtrasComisiones

		FROM TMPPAGAMORSIM
		WHERE NumTransaccion = Par_NumTransac;

	END IF;

END TerminaStore$$