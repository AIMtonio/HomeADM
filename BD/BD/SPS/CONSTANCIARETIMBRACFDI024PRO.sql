-- SP CONSTANCIARETIMBRACFDI024PRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CONSTANCIARETIMBRACFDI024PRO;

DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETIMBRACFDI024PRO`(
	-- SP para generar el CFDI de la Constancia de Retencion
	Par_RFCEmisor 				VARCHAR(25),			-- RFC del Emisor
	Par_RazonSocial 			VARCHAR(100),			-- Razon Social Emisor
	Par_GeneraCFDI				CHAR(1),				-- Geracion de CFDI
	Par_Anio					INT(11),				-- Anio en generar la Constancia de Rtenecion
	Par_ClienteID 				INT(11),				-- Numero del Cliente

    Par_NombreComple 			VARCHAR(250),			-- Nombre completo del Cliente
	Par_TipoPersona 			CHAR(1),				-- Tipo Persona: F = FISICA M =  MORAL
    Par_RFC 					VARCHAR(20),    		-- RFC del cliente
	Par_RegHacienda 			CHAR(1),				-- Registro en Hacienda
    Par_InteresGravado			DECIMAL(18,2),			-- Monto de Interes Gravado

    Par_InteresExento			DECIMAL(18,2),			-- Monto de Interes Exento
    Par_InteresRetener			DECIMAL(18,2),			-- Monto de Interes Retener
	Par_InteresReal				DECIMAL(18,2),			-- Monto de Interes Real
    Par_Tipo					CHAR(2),				-- Tipo Relacionados Fiscales\nA = Aportante\nC = Cliente\nR = Relacionado\nAC = Aportante Cliente
	INOUT Par_CadenaCFDI		VARCHAR(5000),			-- Se obtiene la Cadena CFDI

	Par_CteRelacionadoID		INT(11),				-- Numero del Cliente Relacionado

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
    DECLARE Var_Control 		VARCHAR(100); 			-- Control de Errores
	DECLARE Var_TotalGravado    DECIMAL(18,2);			-- Monto del Interes Gravado
	DECLARE Var_CadenaCFDI      VARCHAR(5000);			-- Valor de la Cadena CFDI
	DECLARE Var_TotalOperacion  DECIMAL(18,2);			-- Almacena el Monto Total de la Operacion (Interes Gravado + Interes Exento - Interes Retenido)
	DECLARE Var_TotalISR        DECIMAL(12,2);			-- Monto del Interes Retenido

	DECLARE Var_Continuar       INT(11);				-- Valor para continuar con el armado de la cadena CFDI
	DECLARE Var_LongRFC			INT(11);				-- Almacena la longitud del RFC
    DECLARE Var_TotalExento     DECIMAL(18,2);			-- Monto del Interes Exento
    DECLARE Var_MontIntNominal	DECIMAL(18,2);			-- Monto del Interes Nominal

    DECLARE Var_MontoIntReal	DECIMAL(18,2);			-- Monto del Interes Real
    DECLARE Var_Perdida			DECIMAL(18,2);			-- Monto de la Perdida
    DECLARE Var_MontoCapital	DECIMAL(18,2);			-- Monto del Capital
	DECLARE Var_MontoCtas	    DECIMAL(18,2);			-- Monto de las Cuentas
    DECLARE Var_MontoInv	    DECIMAL(18,2);			-- Monto de las Inversiones

	DECLARE Var_TimbraConsRet 	CHAR(1);				-- Almacena el valor si timbra la constancia de retencion
	DECLARE Var_MontoInteresReal	DECIMAL(18,2);		-- Monto del Interes Real
	DECLARE Var_DivideSaldoPromCta	CHAR(1);			-- Si divide el saldo promedio de las cuentas entre 12
    DECLARE Var_TipoProveedorWS	INT(11);				-- Tipo de proveedor de WS para el timbrado
    DECLARE Var_FechaSistema	DATE;					-- Fecha del sistema

	-- Declaracion de Constantes
	DECLARE Entero_Cero         INT(11);
	DECLARE Decimal_Cero        DECIMAL(12,2);
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Entero_Uno          INT(11);
	DECLARE PersonaFisica		CHAR(1);

    DECLARE Long_PerFisica		INT(11);
	DECLARE PersonaMoral		CHAR(1);
	DECLARE Long_PerMoral		INT(11);
	DECLARE NoAltaHacienda      CHAR(1);
    DECLARE GeneraSI            CHAR(1);

    DECLARE RFCGenerico         VARCHAR(151);
	DECLARE Salida_SI 			CHAR(1);
	DECLARE Salida_NO 			CHAR(1);
    DECLARE ClaveRetInteres		CHAR(10);
    DECLARE ValorNO				CHAR(2);

    DECLARE ValorSI				CHAR(2);
    DECLARE InstrumentoCta		INT(11);
    DECLARE InstrumentoInv		INT(11);
    DECLARE InstrumentoCede		INT(11);
    DECLARE ConstanteNO			CHAR(1);

    DECLARE ConstanteSI			CHAR(1);
	DECLARE PersonaFisAct		CHAR(1);


	-- Asignacion de Constantes
	SET Entero_Cero     := 0;		-- Entero Cero
	SET Decimal_Cero    := 0.00;	-- Decimal Cero
	SET Cadena_Vacia    := '';		-- Cadena Vacia
	SET Entero_Uno      := 1;		-- Entero Uno
	SET PersonaFisica	:= 'F';		-- Tipo Persona: FISICA

    SET Long_PerFisica	:= 13;		-- Longitud RFC Persona Fisica: 13
	SET PersonaMoral	:= 'M';		-- Tipo Persona: MORAL
	SET Long_PerMoral	:= 12;		-- Longitut RFC Persona Moral: 12
	SET NoAltaHacienda  := 'N';		-- Registro en hacienda: NO
	SET GeneraSI        := 'S';		-- Genera CFDI: Si

    SET RFCGenerico     := 'XAXX010101000';		-- RFC Generico
    SET Salida_SI		:= 'S'; 	-- Salida Store: SI
	SET Salida_NO 		:= 'N'; 	-- Salida Store: NO
    SET ClaveRetInteres	:= '16';	-- Catalogos de Retenciones e Informacion de Pagos: 16 = Intereses
    SET ValorNO			:= 'NO';	-- Valor: NO

    SET ValorSI			:= 'SI';	-- Valor: SI
	SET InstrumentoCta	:= 2;		-- Tipo de Instrumento: Cuenta de Ahorro
	SET InstrumentoInv	:= 13;		-- Tipo de Instrumento: Inversiones
	SET InstrumentoCede	:= 28;		-- Tipo de Instrumento: CEDES
    SET ConstanteNO		:= 'N';		-- Constante: NO

	SET ConstanteSI		:= 'S';		-- Constante: SI
    SET PersonaFisAct	:= 'A';		-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL


	-- Asignacion de variables
	SET Var_Continuar	:= Entero_Cero;
    SET Var_LongRFC	  	:= (SELECT LENGTH(Par_RFC));


	ManejoErrores:BEGIN #bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		 BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSTANCIARETIMBRACFDI024PRO');
			SET Var_Control = 'SQLEXCEPTION';
		 END;

		SET Var_FechaSistema:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		-- Se obtiene los datos de la Institucion
		SELECT  Con.TimbraConsRet,	Con.DivideSaldoPromCta, Con.TipoProveedorWS
		INTO 	Var_TimbraConsRet,	Var_DivideSaldoPromCta, Var_TipoProveedorWS
		FROM CONSTANCIARETPARAMS Con
		INNER JOIN PARAMETROSSIS Par ON Con.InstitucionID = Par.InstitucionID
		INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID;

		SET Var_TimbraConsRet 	:= IFNULL(Var_TimbraConsRet,ConstanteNO);
		SET Var_DivideSaldoPromCta := IFNULL(Var_DivideSaldoPromCta,ConstanteSI);

		-- Longitud de Persona Fisica: 13
		IF (Par_TipoPersona = PersonaFisica OR Par_TipoPersona = PersonaFisAct)THEN
			IF (IFNULL(Var_LongRFC, Entero_Cero) != Long_PerFisica)THEN
				SET Var_Continuar	:= Entero_Uno;
				SET Par_NumErr  	:= 001;
				SET Par_ErrMen  	:= CONCAT('Longitud RFC Persona Fisica: ',Par_ClienteID,', No Valida.');
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Longitud de Persona Moral: 12
		IF (Par_TipoPersona = PersonaMoral)THEN
			IF (IFNULL(Var_LongRFC, Entero_Cero) != Long_PerMoral )THEN
				SET Var_Continuar	:= Entero_Uno;
				SET Par_NumErr  	:= 002;
				SET Par_ErrMen  	:= CONCAT('Longitud RFC Persona Moral: ',Par_ClienteID,', No Valida.');
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- El cliente no esta dado de alta en hacienda
		IF (Par_RegHacienda = NoAltaHacienda) THEN
			-- Se genera CFDI con RFC Generico
			IF (Par_GeneraCFDI = GeneraSI) THEN
				SET Par_RFC     	:= RFCGenerico;
				SET Var_Continuar   := Entero_Cero;
			ELSE
				SET Var_Continuar   := Entero_Uno;
				SET Par_NumErr  	:= 003;
				SET Par_ErrMen  	:= 'No Genera CFDI Cliente No Registrado en Hacienda.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Se obtiene el Monto de los Intereses e ISR
		SELECT SUM(InteresGravado), SUM(InteresExento),  SUM(InteresRetener),	CASE WHEN SUM(InteresReal) > Decimal_Cero THEN SUM(InteresReal) ELSE Decimal_Cero END,
			   CASE WHEN SUM(InteresReal) < Decimal_Cero THEN SUM(InteresReal)* -1 ELSE Decimal_Cero END
		INTO   Var_TotalGravado,    Var_TotalExento,	 Var_TotalISR,			Var_MontoIntReal,
			   Var_Perdida
		FROM CONSTANCIARETENCION
		WHERE Anio = Par_Anio
		AND ClienteID = Par_ClienteID;


		SET Var_TotalGravado	:= IFNULL(Var_TotalGravado, Decimal_Cero);
		SET Var_TotalExento		:= IFNULL(Var_TotalExento, Decimal_Cero);
		SET Var_TotalISR		:= IFNULL(Var_TotalISR, Decimal_Cero);

		SET Var_TotalOperacion	:= Var_TotalGravado + Var_TotalExento - Var_TotalISR;
		SET Var_TotalOperacion	:= IFNULL(Var_TotalOperacion, Decimal_Cero);

		SET Var_MontIntNominal	:= Var_TotalGravado + Var_TotalExento;

		SET Var_MontIntNominal	:= IFNULL(Var_MontIntNominal, Decimal_Cero);
		SET Var_MontoIntReal	:= IFNULL(Var_MontoIntReal, Decimal_Cero);
		SET Var_Perdida			:= IFNULL(Var_Perdida, Decimal_Cero);

		-- Se obtiene el monto de las Cuentas
        -- Valida parametro para dividir el saldo promedio de las cuentas entre 12
        IF(Var_DivideSaldoPromCta = ConstanteNO)THEN
			SELECT 	SUM(Monto)
				INTO 	Var_MontoCtas
			FROM CONSTANCIARETENCION
			WHERE Anio = Par_Anio
			AND ClienteID = Par_ClienteID
			AND TipoInstrumentoID = InstrumentoCta;
        ELSE
			SELECT 	SUM(Monto) / 12
				INTO 	Var_MontoCtas
			FROM CONSTANCIARETENCION
			WHERE Anio = Par_Anio
			AND ClienteID = Par_ClienteID
			AND TipoInstrumentoID = InstrumentoCta;
        END IF;

		SET Var_MontoCtas	:= IFNULL(Var_MontoCtas, Decimal_Cero);

		-- Tabla temporal para obtener el saldo promedio de las Inversiones y CEDES vencidas en el Anio
		DROP TEMPORARY TABLE IF EXISTS TMPSALDOPROMINSTRUMENTO;
		CREATE TEMPORARY TABLE TMPSALDOPROMINSTRUMENTO(
			ClienteID 			INT(11),
			TipoInstrumentoID   INT(11),
			InstrumentoID		BIGINT(12),
			Monto				DECIMAL(18,2),
			FechaInicio 		DATE,
			FechaVencimiento 	DATE,
			Dias				INT(11),
			SaldoPromedio		DECIMAL(18,2));

		CREATE INDEX TMPSALDOPROMINSTRUMENTO_IDX ON TMPSALDOPROMINSTRUMENTO (ClienteID,TipoInstrumentoID,InstrumentoID);

		-- Se obtienen las Inversiones vencidas en el Anio
		INSERT INTO TMPSALDOPROMINSTRUMENTO(
			ClienteID,			TipoInstrumentoID,		InstrumentoID,		Monto,
			FechaInicio,		FechaVencimiento,		Dias,				SaldoPromedio)
		SELECT
			Con.ClienteID, 		Con.TipoInstrumentoID, 	Con.InstrumentoID, 	Con.Monto,
			Inv.FechaInicio,	Inv.FechaVencimiento,	Entero_Cero,		Decimal_Cero
		FROM CONSTANCIARETENCION Con,
			 INVERSIONES Inv
		WHERE Con.InstrumentoID = Inv.InversionID
		AND Con.Anio = Par_Anio
		AND Con.ClienteID = Par_ClienteID
		AND Con.TipoInstrumentoID = InstrumentoInv;

		-- Se obtienen los CEDES vencidas en el anio
		INSERT INTO TMPSALDOPROMINSTRUMENTO(
			ClienteID,			TipoInstrumentoID,		InstrumentoID,		Monto,
			FechaInicio,		FechaVencimiento,		Dias,				SaldoPromedio)
		 SELECT
			Con.ClienteID, 		Con.TipoInstrumentoID, 	Con.InstrumentoID, 	Con.Monto,
			Ced.FechaInicio,	Ced.FechaVencimiento,	Entero_Cero,		Decimal_Cero
		FROM CONSTANCIARETENCION Con,
			 CEDES Ced
		WHERE Con.InstrumentoID = Ced.CedeID
		AND Con.Anio = Par_Anio
		AND Con.ClienteID = Par_ClienteID
		AND Con.TipoInstrumentoID = InstrumentoCede;

		-- Se obtiene el valor de los dias
		UPDATE TMPSALDOPROMINSTRUMENTO
		SET Dias = DATEDIFF(FechaVencimiento,FechaInicio)+1;

		-- Se obtiene el saldo promedio por Instrumento
		 UPDATE TMPSALDOPROMINSTRUMENTO
		 SET SaldoPromedio = Dias * Monto;

		-- Se obtiene el monto de las Inversiones y CEDES
		SELECT 	ROUND(SUM(SaldoPromedio) / SUM(Dias),2)
		INTO 	Var_MontoInv
		FROM TMPSALDOPROMINSTRUMENTO
		WHERE ClienteID = Par_ClienteID;

		SET Var_MontoInv	:= IFNULL(Var_MontoInv, Decimal_Cero);

		-- Se obtiene el Monto Total de Capital
		SET Var_MontoCapital := Var_MontoCtas + Var_MontoInv;

        IF(Var_MontoIntReal > Decimal_Cero)THEN
			SET Var_MontoInteresReal := Var_MontoIntReal;
		ELSE
			SET Var_MontoInteresReal := Var_Perdida;
        END IF;

		IF (Var_Continuar = Entero_Cero AND Var_TimbraConsRet = ConstanteSI) THEN

			IF (Var_TotalISR > Decimal_Cero) THEN

				IF(Var_TipoProveedorWS = 2)THEN -- 2 - EL PROVEEDOR ES Smarter Web.
					SET Var_CadenaCFDI :="<retenciones:Retenciones   	montoTotExent=\"999.0\" montoTotGrav=\"999.0\" montoTotOperacion=\"999.0\" montoTotRet=\"999.0\"> 		<retenciones:ImpRetenidos BaseRet=\"10\" Impuesto=\"01\" TipoPagoRet=\"Pago definitivo\" montoRet=\"9999.0\"/> 	</retenciones:Totales> </retenciones:Retenciones>";

                    SET Var_CadenaCFDI := CONCAT('<retenciones:Retenciones', ' ', '\n');
                    SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI,'Cert=\"\"', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'CveRetenc=\"', CAST(ClaveRetInteres AS CHAR), '\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'FechaExp=\"',Var_FechaSistema,'T',TIME(NOW()),'-06:00','\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'FolioInt=\"0\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'NumCert=\"\"', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'Sello=\"\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'Version=\"1.0\" xmlns:c_retenciones=\"http://www.sat.gob.mx/esquemas/retencionpago/1/catalogos\" xmlns:retenciones=\"http://www.sat.gob.mx/esquemas/retencionpago/1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.sat.gob.mx/esquemas/retencionpago/1 http://www.sat.gob.mx/esquemas/retencionpago/1/retencionpagov1.xsd http://www.sat.gob.mx/esquemas/retencionpago/1/catalogos http://www.sat.gob.mx/esquemas/retencionpago/1/catalogos/catRetenciones.xsd\">', '\n');

					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '<retenciones:Emisor ', '\n');
 					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'NomDenRazSocE=\"',CAST(Par_RazonSocial AS CHAR),'\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'RFCEmisor=\"',CAST(Par_RFCEmisor AS CHAR),'\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '/> ', '\n');

					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '<retenciones:Receptor ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'Nacionalidad=\"Nacional\">', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '<retenciones:Nacional ', '\n');
 					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, ' NomDenRazSocR=\"',CAST(Par_NombreComple AS CHAR),'\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, ' RFCRecep=\"',CAST(Par_RFC AS CHAR),'\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '/> ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '</retenciones:Receptor> ', '\n');

					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '<retenciones:Periodo ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'Ejerc=\"', CAST(Par_Anio AS CHAR), '\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'MesFin=\"12\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'MesIni=\"1\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '/> ', '\n');

					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '<retenciones:Totales ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'montoTotExent=\"', CAST(Var_TotalExento AS CHAR), '\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'montoTotGrav=\"', CAST(Var_TotalGravado AS CHAR), '\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'montoTotOperacion=\"', CAST(Var_TotalOperacion AS CHAR), '\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'montoTotRet=\"', CAST(Var_TotalISR AS CHAR), '\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '>', '\n');
					/*SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '<retenciones:ImpRetenidos ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'BaseRet=\"0\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'Impuesto=\"01\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'TipoPagoRet=\"Pago definitivo\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, ' montoRet=\"',CAST(Var_TotalISR AS CHAR),'\" ', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '/>', '\n');*/
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '</retenciones:Totales>', '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '</retenciones:Retenciones>');

                ELSE -- SI NO UTILIZARA EL PRIMER PROVEEDOR FACTURA MODERNA
					SET Var_CadenaCFDI := CONCAT('[DocumentoRetenciones]', '\n');

					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'NumCert=\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'FechaExp=asignarFecha\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'CveRetenc=', CAST(ClaveRetInteres AS CHAR), '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'DescRetenc=Retencion de Intereses\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '\n');

					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '[Emisor]\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'RFCEmisor=',CAST(Par_RFCEmisor AS CHAR),'\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'NomDenRazSocE=',CAST(Par_RazonSocial AS CHAR),'\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '\n');

					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '[Receptor]\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'Nacionalidad=Nacional\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'Nacional[RFCRecep]=',CAST(Par_RFC AS CHAR),'\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'Nacional[NomDenRazSocR]=',CAST(Par_NombreComple AS CHAR),'\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '\n');

					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '[Periodo]\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'MesIni=1\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'MesFin=12\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'Ejerc=', CAST(Par_Anio AS CHAR), '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '\n');

					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '[Totales]\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'montoTotOperacion=', CAST(Var_TotalOperacion AS CHAR), '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'montoTotGrav=', CAST(Var_TotalGravado AS CHAR), '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'montoTotExent=', CAST(Var_TotalExento AS CHAR), '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'montoTotRet=', CAST(Var_TotalISR AS CHAR), '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '\n');

					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, '[ComplementoIntereses]\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'SistFinanciero=', CAST(ValorSI AS CHAR), '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'RetiroAORESRetInt=', CAST(ValorNO AS CHAR), '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'OperFinancDerivad=', CAST(ValorNO AS CHAR), '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'MontIntNominal=', CAST(Var_MontIntNominal AS CHAR), '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'MontIntReal=', CAST(Var_MontoIntReal AS CHAR), '\n');
					SET Var_CadenaCFDI := CONCAT(Var_CadenaCFDI, 'Perdida=', CAST(Var_Perdida AS CHAR), '\n');
				END IF;

				-- Se actualiza el valor de la CadenaCFDI
				UPDATE CONSTANCIARETCTE SET
					CadenaCFDI  = Var_CadenaCFDI
				WHERE ClienteID = Par_ClienteID
				 AND Anio = Par_Anio;

			END IF;

		END IF;

		-- Se actualizan los valores de los montos
		UPDATE CONSTANCIARETCTE SET
			MontoTotOperacion 	= Var_TotalOperacion,
			MontoTotGrav 		= Var_TotalGravado,
			MontoTotExent 		= Var_TotalExento,
			MontoTotRet 		= Var_TotalISR,
			MontoIntReal		= Var_MontoInteresReal,
			MontoCapital		= Var_MontoCapital
		WHERE ClienteID = Par_ClienteID
		 AND Anio = Par_Anio;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= 'Timbrado Constancia Retencion Realizado Exitosamente.';

		END ManejoErrores;


		IF (Par_Salida = Salida_SI) THEN
			SELECT 	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen;
		END IF;

END TerminaStore$$
