-- SP CONSTANCIARETRELTIMBRADOPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CONSTANCIARETRELTIMBRADOPRO;

DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETRELTIMBRADOPRO`(
	-- SP para la Distribucion de Intereses y Retenciones para el timbrado de la Constancia de Retencion del Relacionado Fiscal
	Par_RFCEmisor 				VARCHAR(25),			-- RFC del Emisor
	Par_RazonSocial 			VARCHAR(100),			-- Razon Social Emisor
	Par_GeneraCFDI				CHAR(1),				-- Geracion de CFDI
	Par_Anio					INT(11),				-- Anio en generar la Constancia de Retencion
	Par_ClienteID 				INT(11),				-- Numero del Cliente

    Par_Salida					CHAR(1), 				-- Indica si espera un SELECT de salida
	INOUT Par_NumErr 			INT(11),				-- Numero de Error
	INOUT Par_ErrMen 			VARCHAR(400), 			-- Descripcion de Error

	Par_EmpresaID				INT(11),				-- Parametro de Auditoria
	Aud_Usuario					INT(11),				-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal				INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)				-- Parametro de Auditoria
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
    DECLARE Var_Control 		VARCHAR(100);			-- Control de Errores
	DECLARE Var_CadenaCFDI      VARCHAR(5000);			-- Valor de la Cadena CFDI
	DECLARE Var_InteresGravado  DECIMAL(18,2);			-- Valor del Interes Gravado
    DECLARE Var_InteresExento   DECIMAL(18,2);			-- Valor del Interes Exento
	DECLARE Var_InteresRetener	DECIMAL(12,2);			-- Valor del Interes Retenido

    DECLARE Var_InteresReal		DECIMAL(18,2);			-- Valor del Interes Real
    DECLARE Var_MontoCapital	DECIMAL(18,2);			-- Valor del Monto de Capital
	DECLARE Var_MontoCtas	    DECIMAL(18,2);			-- Monto de las Cuentas
    DECLARE Var_MontoInstrum	DECIMAL(18,2);			-- Monto de los Instrumentos (INVERSIONES/CEDES/APORTACIONES)
	DECLARE Var_MontoTotGrav  	DECIMAL(18,2);			-- Monto del Interes Gravado

    DECLARE Var_MontoTotExento  DECIMAL(18,2);			-- Monto del Interes Exento
	DECLARE Var_MontoTotRet		DECIMAL(12,2);			-- Monto del Interes Retenido
    DECLARE Var_MontoIntReal	DECIMAL(18,2);			-- Monto del Interes Real
	DECLARE Var_NombreComple    VARCHAR(250);			-- Nombre Completo del Cliente
    DECLARE Var_TipoPersona     CHAR(1);				-- Tipo de Persona: FISICA, MORAL

    DECLARE Var_RFC             VARCHAR(20);			-- RFC del cliente
    DECLARE Var_RegHacienda     CHAR(1);				-- Valor del Registro en Hacienda
    DECLARE Var_ConsecutivoID	INT(11);   				-- Variable consecutivo
	DECLARE Var_NumRegistros	INT(11);				-- Almacena el Numero de Registros
	DECLARE Var_Contador		INT(11);				-- Contador

    DECLARE Var_Anio            INT(11);				-- Anio del proceso
    DECLARE Var_ClienteID       INT(11);				-- Numero de Cliente
    DECLARE Var_ConstanciaRetID BIGINT(12);				-- Almacena el numero de consecutivo de la Constancia de Retencion
    DECLARE Var_Tipo			CHAR(2);				-- Tipo de Relacionado
	DECLARE Var_TotalOperacion  DECIMAL(18,2);			-- Almacena el Monto Total de la Operacion (Interes Gravado + Interes Exento - Interes Retenido)

	DECLARE Var_TimbraConsRet 	CHAR(1);				-- Almacena el valor si timbra la constancia de retencion
	DECLARE Var_CteRelacionadoID INT(11);				-- Almacena el valor del Cliente Relacionado
	DECLARE Var_Cadena			 VARCHAR(5000);			-- Valor de la Cadena CFDI Existente
	DECLARE Var_DivideSaldoPromCta	CHAR(1);			-- Si divide el saldo promedio de las cuentas entre 12
    DECLARE Var_MontoCapital2	DECIMAL(18,2);			-- Valor del Monto de Capital
	DECLARE Var_MontoCapital3	DECIMAL(18,2);			-- Valor del Monto de Capital

    -- Declaracion de Constantes
	DECLARE Entero_Cero         INT(11);
	DECLARE Decimal_Cero        DECIMAL(12,2);
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Entero_Uno          INT(11);
	DECLARE PersonaFisica		CHAR(1);

	DECLARE PersonaFisAct		CHAR(1);
	DECLARE Salida_SI 			CHAR(1);
	DECLARE Salida_NO 			CHAR(1);
    DECLARE ValorNO				CHAR(2);
    DECLARE ValorSI				CHAR(2);

    DECLARE InstrumentoCta		INT(11);
    DECLARE InstrumentoInv		INT(11);
    DECLARE InstrumentoCede		INT(11);
	DECLARE InstrumentoAporta	INT(11);
    DECLARE ConstanteNO			CHAR(1);

    DECLARE ConstanteSI			CHAR(1);
	DECLARE TipoAportante		CHAR(1);
    DECLARE TipoCliente			CHAR(1);
    DECLARE TipoRelacion		CHAR(1);
	DECLARE TipoAportaCte		CHAR(2);

	DECLARE Est_Generado		CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero     	:= 0;		-- Entero Cero
	SET Decimal_Cero    	:= 0.00;	-- Decimal Cero
	SET Cadena_Vacia    	:= '';		-- Cadena Vacia
	SET Entero_Uno      	:= 1;		-- Entero Uno
	SET PersonaFisica		:= 'F';		-- Tipo Persona: FISICA

    SET PersonaFisAct		:= 'A';		-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL
    SET Salida_SI			:= 'S'; 	-- Salida Store: SI
	SET Salida_NO 			:= 'N'; 	-- Salida Store: NO
    SET ValorNO				:= 'NO';	-- Valor: NO
    SET ValorSI				:= 'SI';	-- Valor: SI

    SET InstrumentoCta		:= 2;		-- Tipo de Instrumento: Cuenta de Ahorro
    SET InstrumentoInv		:= 13;		-- Tipo de Instrumento: Inversiones
	SET InstrumentoCede		:= 28;		-- Tipo de Instrumento: CEDES
	SET InstrumentoAporta	:= 31;		-- Tipo de Instrumento: APORTACIONES
    SET ConstanteNO			:= 'N';		-- Constante: NO

    SET ConstanteSI			:= 'S';		-- Constante: SI
    SET TipoAportante		:= 'A';		-- Tipo Relacionado Fiscal: APORTANTE
    SET TipoCliente			:= 'C';		-- Tipo Relacionado Fiscal: CLIENTE
	SET TipoRelacion		:= 'R';		-- Tipo Relacionado Fiscal: RELACIONADO
	SET TipoAportaCte		:= 'AC';	-- Tipo Relacionado Fiscal: APORTANTE CLIENTE

	SET Est_Generado		:= 'G';		-- Estatus: Generado

	ManejoErrores:BEGIN #bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		 BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSTANCIARETRELTIMBRADOPRO');
			SET Var_Control = 'SQLEXCEPTION';
		 END;

        -- Se obtiene los datos de la Institucion
		SELECT  Con.TimbraConsRet, Con.DivideSaldoPromCta
		INTO 	Var_TimbraConsRet, Var_DivideSaldoPromCta
		FROM CONSTANCIARETPARAMS Con
		INNER JOIN PARAMETROSSIS Par ON Con.InstitucionID = Par.InstitucionID
		INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID;

		SET Var_TimbraConsRet 	:= IFNULL(Var_TimbraConsRet,ConstanteNO);
		SET Var_DivideSaldoPromCta := IFNULL(Var_DivideSaldoPromCta,ConstanteSI);

        -- SE ELIMINA LA TABLA TEMPORAL
		DELETE FROM TMPPARTFISCCONSRETCTE;
		SET @Var_ConsecutivoID := 0;

		-- SE OBTIENE INFORMACION DEL APORTANTE Y SUS PERSONAS RELACIONADAS
		INSERT INTO TMPPARTFISCCONSRETCTE(
			ConsecutivoID,		ConstanciaRetID,	Anio,				ClienteID,			Tipo,
            CteRelacionadoID,	ParticipaFiscal,	MontoCapital,		MontoTotOperacion,	MontoTotGrav,
            MontoTotExent,		MontoTotRet,		MontoIntReal,		TipoPersona,		RFC,
            RegHacienda,		NombreCompleto,		EmpresaID,			Usuario,			FechaActual,
            DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)

		SELECT
			@Var_ConsecutivoID:=@Var_ConsecutivoID+1,ConstanciaRetID,	Anio,	ClienteID,	Tipo,
            CteRelacionadoID,	ParticipaFiscal,	MontoCapital,		MontoTotOperacion,	MontoTotGrav,
            MontoTotExent,		MontoTotRet,		MontoIntReal,		TipoPersona,		RFC,
            RegHacienda,  		CASE WHEN TipoPersona IN(PersonaFisica,PersonaFisAct) THEN NombreCompleto ELSE RazonSocial END,
            Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,       Aud_NumTransaccion
		FROM CONSTANCIARETCTEREL
		WHERE Anio = Par_Anio
        AND ClienteID = Par_ClienteID
		AND EstatusGenera != Est_Generado
        AND (Tipo != TipoAportaCte AND CteRelacionadoID != Par_ClienteID);

        -- SE OBTIENE LA SUMATORIA DE LOS INTERESES Y RETENCIONES DEL EJERCICIO DEL APORTANTE
		SELECT SUM(InteresGravado),		SUM(InteresExento),		SUM(InteresRetener),	SUM(InteresReal)
		INTO   Var_InteresGravado,		Var_InteresExento,	 	Var_InteresRetener,		Var_InteresReal
		FROM CONSTANCIARETENCION
		WHERE Anio = Par_Anio
		AND ClienteID = Par_ClienteID;

        SET Var_InteresGravado	:= IFNULL(Var_InteresGravado, Decimal_Cero);
		SET Var_InteresExento	:= IFNULL(Var_InteresExento, Decimal_Cero);
		SET Var_InteresRetener	:= IFNULL(Var_InteresRetener, Decimal_Cero);
		SET Var_InteresReal		:= IFNULL(Var_InteresReal, Decimal_Cero);

        -- SE OBTIENE EL MONTO DE LAS CUENTAS
        -- Valida parametro para dividir el saldo promedio de las cuentas entre 12
        IF(Var_DivideSaldoPromCta = ConstanteNO)THEN
			SELECT SUM(Monto)
				INTO Var_MontoCtas
			FROM CONSTANCIARETENCION
			WHERE Anio = Par_Anio
			AND ClienteID = Par_ClienteID
			AND TipoInstrumentoID = InstrumentoCta;
		ELSE
			SELECT SUM(Monto) / 12
				INTO Var_MontoCtas
			FROM CONSTANCIARETENCION
			WHERE Anio = Par_Anio
			AND ClienteID = Par_ClienteID
			AND TipoInstrumentoID = InstrumentoCta;
        END IF;

		SET Var_MontoCtas	:= IFNULL(Var_MontoCtas, Decimal_Cero);

        -- SE ELIMINA LA TABLA TEMPORAL
		DELETE FROM TMPSALDOPROMINSTRUM;

        -- SE OBTIENE LAS INVERSIONES VENCIDAS EN EL ANIO
		INSERT INTO TMPSALDOPROMINSTRUM(
			ClienteID,				TipoInstrumentoID,		InstrumentoID,		Monto,			FechaInicio,
            FechaVencimiento,		Dias,					SaldoPromedio,		EmpresaID,		Usuario,
            FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
		SELECT
			Con.ClienteID, 			Con.TipoInstrumentoID, 	Con.InstrumentoID, 	Con.Monto,		Inv.FechaInicio,
            Inv.FechaVencimiento,	Entero_Cero,			Decimal_Cero,		Par_EmpresaID, 	Aud_Usuario,
            Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,   Aud_NumTransaccion
		FROM CONSTANCIARETENCION Con,
			 INVERSIONES Inv
		WHERE Con.InstrumentoID = Inv.InversionID
		AND Con.Anio = Par_Anio
		AND Con.ClienteID = Par_ClienteID
		AND Con.TipoInstrumentoID = InstrumentoInv;

        -- SE OBTIENEN LOS CEDES VENCIDAS EN EL ANIO
		INSERT INTO TMPSALDOPROMINSTRUM(
			ClienteID,				TipoInstrumentoID,		InstrumentoID,		Monto,			FechaInicio,
            FechaVencimiento,		Dias,					SaldoPromedio,		EmpresaID,		Usuario,
            FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
		 SELECT
			Con.ClienteID, 			Con.TipoInstrumentoID, 	Con.InstrumentoID, 	Con.Monto,		Ced.FechaInicio,
            Ced.FechaVencimiento,	Entero_Cero,			Decimal_Cero,		Par_EmpresaID, 	Aud_Usuario,
            Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,   Aud_NumTransaccion
		FROM CONSTANCIARETENCION Con,
			 CEDES Ced
		WHERE Con.InstrumentoID = Ced.CedeID
		AND Con.Anio = Par_Anio
		AND Con.ClienteID = Par_ClienteID
		AND Con.TipoInstrumentoID = InstrumentoCede;

		-- SE OBTIENEN LAS APORTACIONES VENCIDAS EN EL ANIO
		INSERT INTO TMPSALDOPROMINSTRUM(
			ClienteID,				TipoInstrumentoID,		InstrumentoID,		Monto,			FechaInicio,
            FechaVencimiento,		Dias,					SaldoPromedio,		EmpresaID,		Usuario,
            FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
		 SELECT
			Con.ClienteID, 			Con.TipoInstrumentoID, 	Con.InstrumentoID, 	Con.Monto,		Apo.FechaInicio,
            Apo.FechaVencimiento,	Entero_Cero,			Decimal_Cero,		Par_EmpresaID, 	Aud_Usuario,
            Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,   Aud_NumTransaccion
		FROM CONSTANCIARETENCION Con,
			 APORTACIONES Apo
		WHERE Con.InstrumentoID = Apo.AportacionID
		AND Con.Anio = Par_Anio
		AND Con.ClienteID = Par_ClienteID
		AND Con.TipoInstrumentoID = InstrumentoAporta;

        -- SE OBTIENE EL VALOR DE LOS DIAS DE ACUERDO A LA FECHA DE INICIO Y VENCIMIENTO DE LOS INSTRUMENTOS
		UPDATE TMPSALDOPROMINSTRUM
		SET Dias = DATEDIFF(FechaVencimiento,FechaInicio)+1;

        -- SE OBTIENE EL SALDO PROMEDIO POR INSTRUMENTO
		UPDATE TMPSALDOPROMINSTRUM
		SET SaldoPromedio = Dias * Monto;

        /*-- SE OBTIENE EL MONTO DE LAS INVERSIONES, CEDES Y APORTACIONES
		SELECT 	ROUND(SUM(SaldoPromedio) / SUM(Dias),2)
		INTO 	Var_MontoInstrum
		FROM TMPSALDOPROMINSTRUM
        WHERE ClienteID = Par_ClienteID;*/
        
        -- Implementaciones - Solicitud de Fuentes
        DROP TABLE if exists tmp_CapitalMexi;
		  CREATE TABLE tmp_CapitalMexi(
			 ClienteID      		INT(11),
			 AportacionID 			INT(11),
			 MesDivide				INT(11),
			 Monto					DECIMAL(18,2),
			 MontoPromedio			DECIMAL(18,2),
			PRIMARY KEY (ClienteID,AportacionID)
		  );
  
		  INSERT INTO tmp_CapitalMexi
		  SELECT	MAX(ClienteID) AS ClienteID, MAX(InstrumentoID) AS AportacionID, ((Max(Mes)-Min(Mes))+Entero_Uno) AS MesDivide,
					SUM(Monto) AS Monto, ROUND(SUM(Monto)/((Max(Mes)-Min(Mes))+Entero_Uno),2) AS MontoPromedio
				FROM CONSTANCIARETENCION
				WHERE Anio = Par_Anio
				GROUP BY ClienteID, InstrumentoID;
		        
        -- SE OBTIENE EL MONTO DE LAS INVERSIONES, CEDES Y APORTACIONES
        SELECT 	SUM(MontoPromedio)
		INTO 	Var_MontoInstrum
		FROM tmp_CapitalMexi
        WHERE ClienteID = Par_ClienteID;
		-- Implementaciones Fin
	
        SET Var_MontoInstrum	:= IFNULL(Var_MontoInstrum, Decimal_Cero);

        -- SE OBTIENE EL MONTO TOTAL DE CAPITAL
		SET Var_MontoCapital 	:= Var_MontoCtas + Var_MontoInstrum;
		SET Var_MontoCapital	:= IFNULL(Var_MontoCapital, Decimal_Cero);
		SET Var_MontoCapital2	:= IFNULL(Var_MontoCapital2, Decimal_Cero);
		SET Var_MontoCapital3	:= IFNULL(Var_MontoCapital3, Decimal_Cero);

        -- SE ACTUALIZA EL MONTO DEL CAPITAL Y LA DISTRIBUCION DE LOS INTERESES Y RETENCIONES DE ACUERDO A LOS PORCENTAJES DE PARTICIPACION FISCAL
        UPDATE TMPPARTFISCCONSRETCTE
        SET MontoCapital 	= ROUND(Var_MontoCapital * ParticipaFiscal / 100,2),
            MontoTotGrav 	= ROUND(Var_InteresGravado * ParticipaFiscal / 100,2),
            MontoTotExent 	= ROUND(Var_InteresExento * ParticipaFiscal / 100,2),
            MontoTotRet 	= ROUND(Var_InteresRetener * ParticipaFiscal / 100,2),
            MontoIntReal 	= ROUND(Var_InteresReal * ParticipaFiscal / 100,2)
		WHERE Anio = Par_Anio
		AND ClienteID = Par_ClienteID;

        -- SE ACTUALIZA EL VALOR DEL MONTO TOTAL DE LA OPERACION
        UPDATE TMPPARTFISCCONSRETCTE
        SET MontoTotOperacion = MontoTotGrav + MontoTotExent - MontoTotRet
		WHERE Anio = Par_Anio
		AND ClienteID = Par_ClienteID;

		-- SE ELIMINA LA TABLA TEMPORAL
		DELETE FROM TMPPARTFISCCONSRETREL;
		SET @Var_ConsecutivoID := 0;

        -- SE OBTIENE INFORMACION DEL APORTANTE QUE SE ENCUENTRA COMO PERSONA RELACIONADA DE OTROS APORTANTES
		INSERT INTO TMPPARTFISCCONSRETREL(
			ConsecutivoID,		ConstanciaRetID,	Anio,				ClienteID,			Tipo,
            CteRelacionadoID,	ParticipaFiscal,	MontoCapital,		MontoTotOperacion,	MontoTotGrav,
            MontoTotExent,		MontoTotRet,		MontoIntReal,		TipoPersona,		RFC,
            RegHacienda,		NombreCompleto,		EmpresaID,			Usuario,			FechaActual,
            DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)

		SELECT
			@Var_ConsecutivoID:=@Var_ConsecutivoID+1,ConstanciaRetID,	Anio,	ClienteID,	Tipo,
            CteRelacionadoID,	ParticipaFiscal,	MontoCapital,		MontoTotOperacion,	MontoTotGrav,
            MontoTotExent,		MontoTotRet,		MontoIntReal,		TipoPersona,		RFC,
            RegHacienda,  		CASE WHEN TipoPersona IN(PersonaFisica,PersonaFisAct) THEN NombreCompleto ELSE RazonSocial END,
            Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,       Aud_NumTransaccion
		FROM CONSTANCIARETCTEREL
		WHERE Anio = Par_Anio
		AND CteRelacionadoID = Par_ClienteID
        AND EstatusGenera != Est_Generado;

        -- SE OBTIENE EL NUMERO DE REGISTROS
		SET Var_NumRegistros := (SELECT COUNT(ConsecutivoID) FROM TMPPARTFISCCONSRETREL);
		SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

		-- SE VALIDA QUE EL NUMERO DE REGISTROS SEA MAYOR A CERO
		IF(Var_NumRegistros > Entero_Cero)THEN
			-- SE INICIALIZA EL CONTADOR
			SET Var_Contador := 1;

            -- SE OBTIENE LA SUMATORIA DE LOS INTERESES Y RETENCIONES DEL APORTANTE
			WHILE(Var_Contador <= Var_NumRegistros) DO
				SELECT	ClienteID,		ConstanciaRetID
				INTO    Var_ClienteID,	Var_ConstanciaRetID
				FROM TMPPARTFISCCONSRETREL
				WHERE ConsecutivoID = Var_Contador;

				SELECT SUM(InteresGravado),		SUM(InteresExento),		SUM(InteresRetener),	SUM(InteresReal)
				INTO   Var_InteresGravado,		Var_InteresExento,	 	Var_InteresRetener,		Var_InteresReal
				FROM CONSTANCIARETENCION
				WHERE ClienteID = Var_ClienteID
                AND Anio = Par_Anio;

				SET Var_InteresGravado	:= IFNULL(Var_InteresGravado, Decimal_Cero);
				SET Var_InteresExento	:= IFNULL(Var_InteresExento, Decimal_Cero);
				SET Var_InteresRetener	:= IFNULL(Var_InteresRetener, Decimal_Cero);
				SET Var_InteresReal		:= IFNULL(Var_InteresReal, Decimal_Cero);

				-- SE OBTIENE EL MONTO DE LAS CUENTAS
				-- Valida parametro para dividir el saldo promedio de las cuentas entre 12
				IF(Var_DivideSaldoPromCta = ConstanteNO)THEN
					SELECT SUM(Monto)
						INTO Var_MontoCtas
					FROM CONSTANCIARETENCION
					WHERE Anio = Par_Anio
					AND ClienteID = Var_ClienteID
					AND TipoInstrumentoID = InstrumentoCta;
				ELSE
					SELECT SUM(Monto) / 12
						INTO Var_MontoCtas
					FROM CONSTANCIARETENCION
					WHERE Anio = Par_Anio
					AND ClienteID = Var_ClienteID
					AND TipoInstrumentoID = InstrumentoCta;
				END IF;

				SET Var_MontoCtas	:= IFNULL(Var_MontoCtas, Decimal_Cero);

				-- SE ELIMINA LA TABLA TEMPORAL
				DELETE FROM TMPSALDOPROMINSTRUM;

				-- SE OBTIENE LAS INVERSIONES VENCIDAS EN EL ANIO
				INSERT INTO TMPSALDOPROMINSTRUM(
					ClienteID,				TipoInstrumentoID,		InstrumentoID,		Monto,			FechaInicio,
					FechaVencimiento,		Dias,					SaldoPromedio,		EmpresaID,		Usuario,
					FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
				SELECT
					Con.ClienteID, 			Con.TipoInstrumentoID, 	Con.InstrumentoID, 	Con.Monto,		Inv.FechaInicio,
					Inv.FechaVencimiento,	Entero_Cero,			Decimal_Cero,		Par_EmpresaID, 	Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,   Aud_NumTransaccion
				FROM CONSTANCIARETENCION Con,
					 INVERSIONES Inv
				WHERE Con.InstrumentoID = Inv.InversionID
				AND Con.Anio = Par_Anio
				AND Con.ClienteID = Var_ClienteID
				AND Con.TipoInstrumentoID = InstrumentoInv;

				-- SE OBTIENEN LOS CEDES VENCIDAS EN EL ANIO
				INSERT INTO TMPSALDOPROMINSTRUM(
					ClienteID,				TipoInstrumentoID,		InstrumentoID,		Monto,			FechaInicio,
					FechaVencimiento,		Dias,					SaldoPromedio,		EmpresaID,		Usuario,
					FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
				 SELECT
					Con.ClienteID, 			Con.TipoInstrumentoID, 	Con.InstrumentoID, 	Con.Monto,		Ced.FechaInicio,
					Ced.FechaVencimiento,	Entero_Cero,			Decimal_Cero,		Par_EmpresaID, 	Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,   Aud_NumTransaccion
				FROM CONSTANCIARETENCION Con,
					 CEDES Ced
				WHERE Con.InstrumentoID = Ced.CedeID
				AND Con.Anio = Par_Anio
				AND Con.ClienteID = Var_ClienteID
				AND Con.TipoInstrumentoID = InstrumentoCede;

				-- SE OBTIENEN LAS APORTACIONES VENCIDAS EN EL ANIO
				INSERT INTO TMPSALDOPROMINSTRUM(
					ClienteID,				TipoInstrumentoID,		InstrumentoID,		Monto,			FechaInicio,
					FechaVencimiento,		Dias,					SaldoPromedio,		EmpresaID,		Usuario,
					FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
				 SELECT
					Con.ClienteID, 			Con.TipoInstrumentoID, 	Con.InstrumentoID, 	Con.Monto,		Apo.FechaInicio,
					Apo.FechaVencimiento,	Entero_Cero,			Decimal_Cero,		Par_EmpresaID, 	Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,   Aud_NumTransaccion
				FROM CONSTANCIARETENCION Con,
					 APORTACIONES Apo
				WHERE Con.InstrumentoID = Apo.AportacionID
				AND Con.Anio = Par_Anio
				AND Con.ClienteID = Var_ClienteID
				AND Con.TipoInstrumentoID = InstrumentoAporta;

				-- SE OBTIENE EL VALOR DE LOS DIAS DE ACUERDO A LA FECHA DE INICIO Y VENCIMIENTO DE LOS INSTRUMENTOS
				UPDATE TMPSALDOPROMINSTRUM
				SET Dias = DATEDIFF(FechaVencimiento,FechaInicio)+1;

				-- SE OBTIENE EL SALDO PROMEDIO POR INSTRUMENTO
				UPDATE TMPSALDOPROMINSTRUM
				SET SaldoPromedio = Dias * Monto;

				/*-- SE OBTIENE EL MONTO DE LAS INVERSIONES, CEDES Y APORTACIONES
				SELECT 	ROUND(SUM(SaldoPromedio) / SUM(Dias),2)
				INTO 	Var_MontoInstrum
				FROM TMPSALDOPROMINSTRUM
				WHERE ClienteID = Var_ClienteID;*/
                
                -- Implementaciones
                SELECT 	SUM(MontoPromedio)
				INTO 	Var_MontoInstrum
				FROM tmp_CapitalMexi
				WHERE ClienteID = Var_ClienteID;
				-- Implementaciones Fin
				SET Var_MontoInstrum	:= IFNULL(Var_MontoInstrum, Decimal_Cero);

				-- SE OBTIENE EL MONTO TOTAL DE CAPITAL
				SET Var_MontoCapital2 := Var_MontoCtas + Var_MontoInstrum;
                SET Var_MontoCapital2	:= IFNULL(Var_MontoCapital2, Decimal_Cero);

				IF(Var_MontoCapital2 = Decimal_Cero)THEN
					SET Var_MontoCapital2 := Var_MontoCapital;
                END IF;

                -- SE ACTUALIZA LA DISTRIBUCION DE LOS INTERESES Y RETENCIONES DE ACUERDO A LOS PORCENTAJES DE PARTICIPACION FISCAL
				UPDATE TMPPARTFISCCONSRETREL
				SET MontoCapital	= ROUND(Var_MontoCapital2 * ParticipaFiscal / 100,2),
					MontoTotGrav 	= ROUND(Var_InteresGravado * ParticipaFiscal / 100,2),
					MontoTotExent 	= ROUND(Var_InteresExento * ParticipaFiscal / 100,2),
					MontoTotRet 	= ROUND(Var_InteresRetener * ParticipaFiscal / 100,2),
					MontoIntReal 	= ROUND(Var_InteresReal * ParticipaFiscal / 100,2)
				WHERE Anio = Par_Anio
				AND ClienteID = Var_ClienteID
                AND ConstanciaRetID = Var_ConstanciaRetID;

				-- SE ACTUALIZA EL VALOR DEL MONTO TOTAL DE LA OPERACION
				UPDATE TMPPARTFISCCONSRETREL
				SET MontoTotOperacion = MontoTotGrav + MontoTotExent - MontoTotRet
				WHERE Anio = Par_Anio
				AND ClienteID = Var_ClienteID
				AND ConstanciaRetID = Var_ConstanciaRetID;

				SET Var_Contador := Var_Contador + 1;

            END WHILE; -- FIN del WHILE

        END IF; -- FIN SE VALIDA QUE EL NUMERO DE REGISTROS SEA MAYOR A CERO

        -- SE ELIMINA LA TABLA TEMPORAL
		DELETE FROM TMPPARTFISCRETCTEREL;
		SET @Var_ConsecutivoID := 0;

        -- SE OBTIENE INFORMACION DE CLIENTES QUE NO GENERARON INTERESES EN EL PERIODO
		INSERT INTO TMPPARTFISCRETCTEREL(
			ConsecutivoID,		ConstanciaRetID,	Anio,				ClienteID,			Tipo,
            CteRelacionadoID,	ParticipaFiscal,	MontoCapital,		MontoTotOperacion,	MontoTotGrav,
            MontoTotExent,		MontoTotRet,		MontoIntReal,		TipoPersona,		RFC,
            RegHacienda,		NombreCompleto,		EmpresaID,			Usuario,			FechaActual,
            DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)

		SELECT
			@Var_ConsecutivoID:=@Var_ConsecutivoID+1,ConstanciaRetID,	Anio,	ClienteID,	Tipo,
            CteRelacionadoID,	ParticipaFiscal,	MontoCapital,		MontoTotOperacion,	MontoTotGrav,
            MontoTotExent,		MontoTotRet,		MontoIntReal,		TipoPersona,		RFC,
            RegHacienda,  		CASE WHEN TipoPersona IN(PersonaFisica,PersonaFisAct) THEN NombreCompleto ELSE RazonSocial END,
            Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,       Aud_NumTransaccion
		FROM CONSTANCIARETCTEREL
		WHERE Anio = Par_Anio
		AND CteRelacionadoID != Par_ClienteID
		AND ClienteID != Par_ClienteID
		AND Tipo = TipoCliente
        AND EstatusGenera != Est_Generado;

        -- SE OBTIENE EL NUMERO DE REGISTROS
		SET Var_NumRegistros := (SELECT COUNT(ConsecutivoID) FROM TMPPARTFISCRETCTEREL);
		SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

        -- SE VALIDA QUE EL NUMERO DE REGISTROS SEA MAYOR A CERO
		IF(Var_NumRegistros > Entero_Cero)THEN
			-- SE INICIALIZA EL CONTADOR
			SET Var_Contador := 1;

            -- SE OBTIENE LA SUMATORIA DE LOS INTERESES Y RETENCIONES DEL APORTANTE
			WHILE(Var_Contador <= Var_NumRegistros) DO
				SELECT	ClienteID,		ConstanciaRetID
				INTO    Var_ClienteID,	Var_ConstanciaRetID
				FROM TMPPARTFISCRETCTEREL
				WHERE ConsecutivoID = Var_Contador;

				SELECT SUM(InteresGravado),		SUM(InteresExento),		SUM(InteresRetener),	SUM(InteresReal)
				INTO   Var_InteresGravado,		Var_InteresExento,	 	Var_InteresRetener,		Var_InteresReal
				FROM CONSTANCIARETENCION
				WHERE ClienteID = Var_ClienteID
				AND Anio = Par_Anio;

                SET Var_InteresGravado	:= IFNULL(Var_InteresGravado, Decimal_Cero);
				SET Var_InteresExento	:= IFNULL(Var_InteresExento, Decimal_Cero);
				SET Var_InteresRetener	:= IFNULL(Var_InteresRetener, Decimal_Cero);
				SET Var_InteresReal		:= IFNULL(Var_InteresReal, Decimal_Cero);

                -- SE OBTIENE EL MONTO DE LAS CUENTAS
				-- Valida parametro para dividir el saldo promedio de las cuentas entre 12
				IF(Var_DivideSaldoPromCta = ConstanteNO)THEN
					SELECT SUM(Monto)
						INTO Var_MontoCtas
					FROM CONSTANCIARETENCION
					WHERE Anio = Par_Anio
					AND ClienteID = Var_ClienteID
					AND TipoInstrumentoID = InstrumentoCta;
				ELSE
					SELECT SUM(Monto) / 12
						INTO Var_MontoCtas
					FROM CONSTANCIARETENCION
					WHERE Anio = Par_Anio
					AND ClienteID = Var_ClienteID
					AND TipoInstrumentoID = InstrumentoCta;
				END IF;

				SET Var_MontoCtas	:= IFNULL(Var_MontoCtas, Decimal_Cero);

				-- SE ELIMINA LA TABLA TEMPORAL
				DELETE FROM TMPSALDOPROMINSTRUM;

				-- SE OBTIENE LAS INVERSIONES VENCIDAS EN EL ANIO
				INSERT INTO TMPSALDOPROMINSTRUM(
					ClienteID,				TipoInstrumentoID,		InstrumentoID,		Monto,			FechaInicio,
					FechaVencimiento,		Dias,					SaldoPromedio,		EmpresaID,		Usuario,
					FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
				SELECT
					Con.ClienteID, 			Con.TipoInstrumentoID, 	Con.InstrumentoID, 	Con.Monto,		Inv.FechaInicio,
					Inv.FechaVencimiento,	Entero_Cero,			Decimal_Cero,		Par_EmpresaID, 	Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,   Aud_NumTransaccion
				FROM CONSTANCIARETENCION Con,
					 INVERSIONES Inv
				WHERE Con.InstrumentoID = Inv.InversionID
				AND Con.Anio = Par_Anio
				AND Con.ClienteID = Var_ClienteID
				AND Con.TipoInstrumentoID = InstrumentoInv;

				-- SE OBTIENEN LOS CEDES VENCIDAS EN EL ANIO
				INSERT INTO TMPSALDOPROMINSTRUM(
					ClienteID,				TipoInstrumentoID,		InstrumentoID,		Monto,			FechaInicio,
					FechaVencimiento,		Dias,					SaldoPromedio,		EmpresaID,		Usuario,
					FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
				 SELECT
					Con.ClienteID, 			Con.TipoInstrumentoID, 	Con.InstrumentoID, 	Con.Monto,		Ced.FechaInicio,
					Ced.FechaVencimiento,	Entero_Cero,			Decimal_Cero,		Par_EmpresaID, 	Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,   Aud_NumTransaccion
				FROM CONSTANCIARETENCION Con,
					 CEDES Ced
				WHERE Con.InstrumentoID = Ced.CedeID
				AND Con.Anio = Par_Anio
				AND Con.ClienteID = Var_ClienteID
				AND Con.TipoInstrumentoID = InstrumentoCede;

				-- SE OBTIENEN LAS APORTACIONES VENCIDAS EN EL ANIO
				INSERT INTO TMPSALDOPROMINSTRUM(
					ClienteID,				TipoInstrumentoID,		InstrumentoID,		Monto,			FechaInicio,
					FechaVencimiento,		Dias,					SaldoPromedio,		EmpresaID,		Usuario,
					FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
				 SELECT
					Con.ClienteID, 			Con.TipoInstrumentoID, 	Con.InstrumentoID, 	Con.Monto,		Apo.FechaInicio,
					Apo.FechaVencimiento,	Entero_Cero,			Decimal_Cero,		Par_EmpresaID, 	Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,   Aud_NumTransaccion
				FROM CONSTANCIARETENCION Con,
					 APORTACIONES Apo
				WHERE Con.InstrumentoID = Apo.AportacionID
				AND Con.Anio = Par_Anio
				AND Con.ClienteID = Var_ClienteID
				AND Con.TipoInstrumentoID = InstrumentoAporta;

				-- SE OBTIENE EL VALOR DE LOS DIAS DE ACUERDO A LA FECHA DE INICIO Y VENCIMIENTO DE LOS INSTRUMENTOS
				UPDATE TMPSALDOPROMINSTRUM
				SET Dias = DATEDIFF(FechaVencimiento,FechaInicio)+1;

				-- SE OBTIENE EL SALDO PROMEDIO POR INSTRUMENTO
				UPDATE TMPSALDOPROMINSTRUM
				SET SaldoPromedio = Dias * Monto;

				-- SE OBTIENE EL MONTO DE LAS INVERSIONES, CEDES Y APORTACIONES
				/*SELECT 	ROUND(SUM(SaldoPromedio) / SUM(Dias),2)
				INTO 	Var_MontoInstrum
				FROM TMPSALDOPROMINSTRUM
				WHERE ClienteID = Var_ClienteID;*/
                
                -- Implementaciones
                SELECT 	SUM(MontoPromedio)
				INTO 	Var_MontoInstrum
				FROM tmp_CapitalMexi
				WHERE ClienteID = Var_ClienteID;
				-- Implementaciones Fin
            
				SET Var_MontoInstrum	:= IFNULL(Var_MontoInstrum, Decimal_Cero);

				-- SE OBTIENE EL MONTO TOTAL DE CAPITAL
				SET Var_MontoCapital3 	:= Var_MontoCtas + Var_MontoInstrum;
                SET Var_MontoCapital3	:= IFNULL(Var_MontoCapital3, Decimal_Cero);

                IF(Var_MontoCapital3 = Decimal_Cero)THEN
					SET Var_MontoCapital3 := Var_MontoCapital;
                END IF;

                 -- SE ACTUALIZA LA DISTRIBUCION DE LOS INTERESES Y RETENCIONES DE ACUERDO A LOS PORCENTAJES DE PARTICIPACION FISCAL
				UPDATE TMPPARTFISCRETCTEREL
				SET MontoCapital	= ROUND(Var_MontoCapital3 * ParticipaFiscal / 100,2),
					MontoTotGrav 	= ROUND(Var_InteresGravado * ParticipaFiscal / 100,2),
					MontoTotExent 	= ROUND(Var_InteresExento * ParticipaFiscal / 100,2),
					MontoTotRet 	= ROUND(Var_InteresRetener * ParticipaFiscal / 100,2),
					MontoIntReal 	= ROUND(Var_InteresReal * ParticipaFiscal / 100,2)
				WHERE Anio = Par_Anio
				AND ClienteID = Var_ClienteID
                AND ConstanciaRetID = Var_ConstanciaRetID;

                -- SE ACTUALIZA EL VALOR DEL MONTO TOTAL DE LA OPERACION
				UPDATE TMPPARTFISCRETCTEREL
				SET MontoTotOperacion = MontoTotGrav + MontoTotExent - MontoTotRet
				WHERE Anio = Par_Anio
				AND ClienteID = Var_ClienteID
				AND ConstanciaRetID = Var_ConstanciaRetID;

                SET Var_Contador := Var_Contador + 1;

			END WHILE; -- FIN del WHILE

		END IF; -- FIN SE VALIDA QUE EL NUMERO DE REGISTROS SEA MAYOR A CERO


		-- SE ELIMINA LA TABLA TEMPORAL
		DELETE FROM TMPCONSRETRELFISCAL;
		SET @Var_ConsecutivoID := 0;

		-- SE REGISTRA INFORMACION DEL APORTANTE Y SUS PERSONAS RELACIONADAS
		INSERT INTO TMPCONSRETRELFISCAL(
			ConsecutivoID,		ConstanciaRetID,	Anio,				ClienteID,			Tipo,
            CteRelacionadoID,	ParticipaFiscal,	MontoCapital,		MontoTotOperacion,	MontoTotGrav,
            MontoTotExent,		MontoTotRet,		MontoIntReal,		TipoPersona,		RFC,
            RegHacienda,		NombreCompleto,		EmpresaID,			Usuario,			FechaActual,
            DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)

		SELECT
			@Var_ConsecutivoID:=@Var_ConsecutivoID+1,ConstanciaRetID,	Anio,	ClienteID,	Tipo,
            CteRelacionadoID,	ParticipaFiscal,	MontoCapital,		MontoTotOperacion,	MontoTotGrav,
            MontoTotExent,		MontoTotRet,		MontoIntReal,		TipoPersona,		RFC,
            RegHacienda,  		NombreCompleto,		Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,
            Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion
		FROM TMPPARTFISCCONSRETCTE;

		-- SE REGISTRA INFORMACION DEL APORTANTE QUE SE ENCUENTRA COMO PERSONA RELACIONADA DE OTROS APORTANTES
        INSERT INTO TMPCONSRETRELFISCAL(
			ConsecutivoID,		ConstanciaRetID,	Anio,				ClienteID,			Tipo,
            CteRelacionadoID,	ParticipaFiscal,	MontoCapital,		MontoTotOperacion,	MontoTotGrav,
            MontoTotExent,		MontoTotRet,		MontoIntReal,		TipoPersona,		RFC,
            RegHacienda,		NombreCompleto,		EmpresaID,			Usuario,			FechaActual,
            DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)

		SELECT
			@Var_ConsecutivoID:=@Var_ConsecutivoID+1,ConstanciaRetID,	Anio,	ClienteID,	Tipo,
            CteRelacionadoID,	ParticipaFiscal,	MontoCapital,		MontoTotOperacion,	MontoTotGrav,
            MontoTotExent,		MontoTotRet,		MontoIntReal,		TipoPersona,		RFC,
            RegHacienda,  		NombreCompleto,		Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,
            Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion
		FROM TMPPARTFISCCONSRETREL;

		-- SE REGISTRA INFORMACION DE CLIENTES QUE NO GENERARON INTERESES EN EL PERIODO
		INSERT INTO TMPCONSRETRELFISCAL(
			ConsecutivoID,		ConstanciaRetID,	Anio,				ClienteID,			Tipo,
            CteRelacionadoID,	ParticipaFiscal,	MontoCapital,		MontoTotOperacion,	MontoTotGrav,
            MontoTotExent,		MontoTotRet,		MontoIntReal,		TipoPersona,		RFC,
            RegHacienda,		NombreCompleto,		EmpresaID,			Usuario,			FechaActual,
            DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)

		SELECT
			@Var_ConsecutivoID:=@Var_ConsecutivoID+1,ConstanciaRetID,	Anio,	ClienteID,	Tipo,
            CteRelacionadoID,	ParticipaFiscal,	MontoCapital,		MontoTotOperacion,	MontoTotGrav,
            MontoTotExent,		MontoTotRet,		MontoIntReal,		TipoPersona,		RFC,
            RegHacienda,  		NombreCompleto,		Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,
            Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion
		FROM TMPPARTFISCRETCTEREL;

        -- SE OBTIENE EL NUMERO DE REGISTROS PARA REALIZAR EL TIMBRADO DE LA CONSTANCIA DE RETENCION
		SET Var_NumRegistros := (SELECT COUNT(ConsecutivoID) FROM TMPCONSRETRELFISCAL);
		SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

        -- SE VALIDA QUE EL NUMERO DE REGISTROS PARA REALIZAR EL TIMBRADO DE LA CONSTANCIA DE RETENCION SEA MAYOR A CERO
		IF(Var_NumRegistros > Entero_Cero)THEN

            -- SE INICIALIZA EL CONTADOR
			SET Var_Contador := 1;

            -- SE GENERA EL TIMBRADO DE LA CONSTANCIA DE RETENCION
			WHILE(Var_Contador <= Var_NumRegistros) DO
				SELECT	Anio,				ClienteID,				NombreCompleto,			TipoPersona,		RFC,
						RegHacienda, 		MontoTotGrav,			MontoTotExent,			MontoTotRet,		MontoIntReal,
                        MontoCapital,		ConstanciaRetID,		Tipo,					MontoTotOperacion,	CteRelacionadoID
				INTO    Var_Anio,			Var_ClienteID,			Var_NombreComple,		Var_TipoPersona,	Var_RFC,
						Var_RegHacienda, 	Var_MontoTotGrav,		Var_MontoTotExento, 	Var_MontoTotRet,	Var_MontoIntReal,
                        Var_MontoCapital,	Var_ConstanciaRetID,	Var_Tipo,				Var_TotalOperacion,	Var_CteRelacionadoID
				FROM TMPCONSRETRELFISCAL
				WHERE ConsecutivoID = Var_Contador;

                -- LLAMADA PARA EL ARMADO DE LA CADENA CFID PARA EL TIMBRADO DE LA CONSTANCIA DE RETENCION
                IF(Var_TimbraConsRet = ConstanteSI)THEN
					CALL CONSTANCIARETIMBRADOCFDIPRO(
						Par_RFCEmisor,			Par_RazonSocial,		Par_GeneraCFDI,			Var_Anio,				Var_ClienteID,
						Var_NombreComple,		Var_TipoPersona,		Var_RFC,				Var_RegHacienda,		Var_MontoTotGrav,
						Var_MontoTotExento,		Var_MontoTotRet,		Var_MontoIntReal,		Var_Tipo,				Var_CadenaCFDI,
                        Var_CteRelacionadoID,	Salida_NO,				Par_NumErr, 			Par_ErrMen, 			Par_EmpresaID,
                        Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,  		Aud_Sucursal,
                        Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

                    IF(Var_Tipo = TipoAportaCte)THEN
						SET Var_CadenaCFDI := Cadena_Vacia;
					END IF;

					-- SE ACTUALIZA EL VALOR DE LA CADENA CFDI, EL MONTO DEL CAPITAL Y LOS INTERESES
					UPDATE CONSTANCIARETCTEREL
					SET CadenaCFDI 		= Var_CadenaCFDI,
						MontoCapital 	= Var_MontoCapital,
						MontoTotGrav 	= Var_MontoTotGrav,
						MontoTotExent 	= Var_MontoTotExento,
						MontoTotRet 	= Var_MontoTotRet,
						MontoIntReal 	= Var_MontoIntReal,
						MontoTotOperacion = Var_TotalOperacion,
                        EstatusGenera	= Est_Generado
					WHERE ConstanciaRetID = Var_ConstanciaRetID
					AND Anio = Par_Anio
					AND ClienteID = Var_ClienteID;

				END IF;

                IF(Var_TimbraConsRet = ConstanteNO)THEN
					UPDATE CONSTANCIARETCTEREL
					SET CadenaCFDI 		= CadenaCFDI,
						MontoCapital 	= Var_MontoCapital,
						MontoTotGrav 	= Var_MontoTotGrav,
						MontoTotExent 	= Var_MontoTotExento,
						MontoTotRet 	= Var_MontoTotRet,
						MontoIntReal 	= Var_MontoIntReal,
						MontoTotOperacion = Var_TotalOperacion,
                        EstatusGenera   = EstatusGenera
					WHERE ConstanciaRetID = Var_ConstanciaRetID
					AND Anio = Par_Anio
					AND ClienteID = Var_ClienteID;
				END IF;
                SET Var_Contador := Var_Contador + 1;

			END WHILE; -- FIN del WHILE

		END IF;  -- FIN SE VALIDA QUE EL NUMERO DE REGISTROS PARA REALIZAR EL TIMBRADO DE LA CONSTANCIA DE RETENCION SEA MAYOR A CERO


		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= 'Distribucion de Intereses y Retenciones Realizado Exitosamente.';
		SET Var_Control := Cadena_Vacia;

	END ManejoErrores;


	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
                Var_Control AS control;
	END IF;

END TerminaStore$$