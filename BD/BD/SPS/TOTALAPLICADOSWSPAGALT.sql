DELIMITER ;
DROP PROCEDURE IF EXISTS `TOTALAPLICADOSWSPAGALT`;

DELIMITER $$
CREATE PROCEDURE `TOTALAPLICADOSWSPAGALT`(
	Par_ClienteID           INT(11),
    Par_CreditoID           BIGINT(12),
    Par_NumCtaInstit        BIGINT(12),
    Par_InstitucionID       INT(11),

	Par_MontoPagar          DECIMAL(12,2),
    Par_Origen              CHAR(1),
    Par_ModoPago            CHAR(1),
    INOUT Par_Poliza        BIGINT(12),

    Par_Salida              CHAR(1),    
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),  
    
    -- Parametros de Auditoria
    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),

    Aud_NumTransaccion      BIGINT(20)


)
TerminaStore :BEGIN
	
	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE Con_Servicio		VARCHAR(20);
	DECLARE Salida_SI			CHAR(1);


	-- DECLARACION DE VARIABLES
	DECLARE Var_Consecutivo			BIGINT(12);
	DECLARE Var_Control				VARCHAR(50);
	DECLARE Var_FechaActual			DATE;

	DECLARE Var_ProductoCreditoID 	INT(11);
	DECLARE Var_NombreComercial 	VARCHAR(100);
	DECLARE Var_CreditoID 			BIGINT(12);
	DECLARE Var_InstitNominaID 		INT(11);
	DECLARE Var_NombreInstit 		VARCHAR(200);
	DECLARE Var_ConvenioNominaID 	BIGINT;
	DECLARE Var_Descripcion 		VARCHAR(150);
	DECLARE Var_ClienteID 			INT(11);
	DECLARE Var_NombreCompleto		VARCHAR(200);
	DECLARE Var_RFCOficial			VARCHAR(13);
	DECLARE Var_CuentaID			BIGINT(12);
	DECLARE Var_SaldoDispon			DECIMAL(12,2);
	DECLARE Var_SaldoBloq 			DECIMAL(12,2);
	DECLARE Var_Saldo 				DECIMAL(12,2);
	DECLARE Var_InstitucionID 		INT(11);
	DECLARE Var_NombreCorto 		VARCHAR(45);
	DECLARE Var_ClabeCtaDomici 		VARCHAR(20);

	DECLARE Var_MontoCap 			DECIMAL(12,2);
	DECLARE Var_MontoInt 			DECIMAL(14,4);
	DECLARE Var_MontoIVA 			DECIMAL(12,2);
	DECLARE Var_MontoAccesorios 	DECIMAL(12,2);
	DECLARE Var_MontoIVAAccesorios	DECIMAL(12,2);
	DECLARE Var_MontoNotasCargo 	DECIMAL(14,2);
	DECLARE Var_MontoIVANotasCargo 	DECIMAL(14,2);
	DECLARE Var_MontoTotPago 		DECIMAL(12,2);
	DECLARE Var_FechaPago			DATE;

	DECLARE Var_InstitucionIDTeso	INT(11);
	DECLARE Var_NombreCortoTeso		VARCHAR(45);
	DECLARE Var_CuentaTeso			VARCHAR(20);

	DECLARE Var_ImportePend			DECIMAL(12,2);
	DECLARE Var_Concepto			VARCHAR(150);


	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET Aud_FechaActual 	:= NOW();
	SET Con_Servicio		:= 'SERVICIO WEB';
	SET Salida_SI			:= 'S';



	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr   := 999;
				SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					'esto le ocasiona. Ref: SP-TOTALAPLICADOSWSPAGALT');
				SET Var_Control  := 'SQLEXCEPTION';
			END;

		SELECT P.FechaSistema INTO Var_FechaActual FROM PARAMETROSSIS P;


		SELECT IFNULL(MAX(TotalAplicWSPagID),Entero_Cero)+1 INTO Var_Consecutivo FROM TOTALAPLICADOSWSPAG;

		INSERT INTO TOTALAPLICADOSWSPAG(
				TotalAplicWSPagID,		FechaPago,				CreditoID,				ClienteID,				TotalOperacion,
				InstitPagoID,			OrigenPago,
				EmpresaID, 				Usuario,				FechaActual, 			DireccionIP,			ProgramaID,
				Sucursal, 				NumTransaccion)
		VALUES(	Var_Consecutivo,		Var_FechaActual,		Par_CreditoID,			Par_ClienteID,			Par_MontoPagar,
				Par_NumCtaInstit,		Con_Servicio,
				Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Datos grabados';
		SET Var_Control := Cadena_Vacia;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control 	AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$