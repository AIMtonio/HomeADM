-- SP CONSTANCIARETIMBRADOCFDIPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CONSTANCIARETIMBRADOCFDIPRO;

DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETIMBRADOCFDIPRO`(
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
    DECLARE Var_Control 			VARCHAR(100); 			-- Control de Errores
	DECLARE Var_CliProEsp   		INT(11);				-- Almacena el Numero de Cliente para Procesos Especificos
    DECLARE Var_Llamada				VARCHAR(10000);			-- Almacena la llamada a realizar el proceso
	DECLARE Var_ProcPersonalizado	VARCHAR(200);			-- Almacena el nombre del SP para obtener el resumen de la cuenta
	DECLARE Var_CadenaCFDI		    VARCHAR(5000);			-- Almacena el nombre del SP para obtener el resumen de la cuenta
	DECLARE Var_NumErr				VARCHAR(200);
    DECLARE Var_ErrMen				VARCHAR(400);

	-- Declaracion de Constantes
	DECLARE Entero_Cero         INT(11);
	DECLARE Decimal_Cero        DECIMAL(12,2);
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Salida_SI 			CHAR(1);
	DECLARE Salida_NO 			CHAR(1);

    DECLARE ValorNO				CHAR(2);
    DECLARE ValorSI				CHAR(2);
    DECLARE ConstanteNO			CHAR(1);
    DECLARE ConstanteSI			CHAR(1);
	DECLARE Con_CliProcEspe     VARCHAR(20);

	DECLARE ConstanciaRet		INT(11);
	DECLARE NumClienteSofi		INT(11);
    DECLARE NumClienteCred		INT(11);
    DECLARE NumClienteMexi		INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero     := 0;		-- Entero Cero
	SET Decimal_Cero    := 0.00;	-- Decimal Cero
	SET Cadena_Vacia    := '';		-- Cadena Vacia
    SET Salida_SI		:= 'S'; 	-- Salida Store: SI
	SET Salida_NO 		:= 'N'; 	-- Salida Store: NO

    SET ValorNO			:= 'NO';	-- Valor: NO
    SET ValorSI			:= 'SI';	-- Valor: SI
    SET ConstanteNO		:= 'N';		-- Constante: NO
	SET ConstanteSI		:= 'S';		-- Constante: SI
    SET Con_CliProcEspe	:= 'CliProcEspecifico'; -- Llave Parametro para Procesos Especificos

    SET ConstanciaRet	:= 22;		-- Identificador Constancia de Retencion
	SET NumClienteSofi	:= 15;		-- Numero de Cliente para Sofi Procesos Especificos: 15
    SET NumClienteCred	:= 24;		-- Numero de Cliente para CrediClub Procesos Especificos: 24
    SET NumClienteMexi	:= 40;		-- Numero de Cliente para Mexi Procesos Especificos: 40

	SET Var_CadenaCFDI  := '@Par_CadenaCFDI';
	SET Var_NumErr 		:= '@Par_NumErr';
	SET Var_ErrMen 		:= '@Par_ErrMen';

	ManejoErrores:BEGIN #bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		 BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSTANCIARETIMBRADOCFDIPRO');
			SET Var_Control = 'SQLEXCEPTION';
		 END;

        -- Se obtiene el Numero de Cliente para Procesos Especificos
		SET Var_CliProEsp := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);
		SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);

		-- Se obtiene el nombre del SP a realizar el proceso
		IF(Var_CliProEsp = NumClienteSofi) THEN
			SET Var_ProcPersonalizado := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = ConstanciaRet AND CliProEspID = Var_CliProEsp);
		ELSEIF (Var_CliProEsp = NumClienteCred) THEN
			SET Var_ProcPersonalizado = (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = ConstanciaRet AND CliProEspID = Var_CliProEsp);
		ELSEIF (Var_CliProEsp = NumClienteMexi) THEN
			SET Var_ProcPersonalizado = (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = ConstanciaRet AND CliProEspID = Var_CliProEsp);
		ELSE
			SET Var_ProcPersonalizado = (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = ConstanciaRet AND CliProEspID = Entero_Cero);
		END IF;

		-- Se realiza la llamada al SP para realizar el proceso del timbrado CFDI
		SET Var_Llamada := CONCAT(' CALL ', Var_ProcPersonalizado," ('",Par_RFCEmisor,
			"','",Par_RazonSocial,		"','",	Par_GeneraCFDI,			"',",	Par_Anio,				",",	Par_ClienteID,
            ",'",Par_NombreComple,		"','",	Par_TipoPersona,		"','",	Par_RFC,				"','",	Par_RegHacienda,
            "',",Par_InteresGravado,	",",	Par_InteresExento,		",",	Par_InteresRetener,		",",	Par_InteresReal,
			",'",Par_Tipo,				"',",   Var_CadenaCFDI,			",",	Par_CteRelacionadoID,	",'",	Salida_NO,
			"',",Var_NumErr,			",",	Var_ErrMen,				",",	Par_EmpresaID,			",",	Aud_Usuario,
            ",'",Aud_FechaActual,		"','",	Aud_DireccionIP,		"','",	Aud_ProgramaID,			"',",	Aud_Sucursal,
            ",",Aud_NumTransaccion,");");

		-- Se ejecuta la sentencia del proceso
		SET @Sentencia    = (Var_Llamada);
		PREPARE EjecutaProc FROM @Sentencia;
		EXECUTE  EjecutaProc;
		DEALLOCATE PREPARE EjecutaProc;

        IF(@Par_NumErr <> Entero_Cero)THEN
			SET Par_NumErr := @Par_NumErr;
			SET Par_ErrMen := @Par_ErrMen;
            SET Par_CadenaCFDI := '';
		   LEAVE ManejoErrores;
        END IF;

        IF(Var_CliProEsp = NumClienteMexi)THEN
			SET Par_CadenaCFDI := @Par_CadenaCFDI;
		ELSE
			SET Par_CadenaCFDI := '';
        END IF;

		SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= 'Timbrado Constancia Retencion Realizado Exitosamente.';

	END ManejoErrores;


	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$
