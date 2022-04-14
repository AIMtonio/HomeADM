-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIDESCARGASREMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIDESCARGASREMPRO`;
DELIMITER $$


CREATE PROCEDURE `SPEIDESCARGASREMPRO`(
-- =====================================================================================
-- STORE PARA PROCESAR TODAS LAS REMESAS DESCARGADAS Y DAR LAS DE ALTA EN REMESAS SPEI
-- =====================================================================================
    Par_SpeiSolDesID			BIGINT(20),			-- Número de solicitud de descarga.

    Par_Salida				    CHAR(1),		    -- Parametro de confirmación para salida de datos S=si, N=no.
	INOUT Par_NumErr		    INT(11),            -- Parametro de entrada/salida de numero de error.
	INOUT Par_ErrMen		    VARCHAR(400),	    -- Parametro de entrada/salida de mensaje de control de respuesta.

	-- Parámetros de Auditoria
	Par_EmpresaID               INT(11),            -- Parámetro de auditoría ID de la empresa.
    Aud_Usuario                 INT(11),            -- Parámetro de auditoría ID del usuario.
    Aud_FechaActual             DATETIME,           -- Parámetro de auditoría fecha actual.
    Aud_DireccionIP             VARCHAR(15),        -- Parámetro de auditoría direccion IP.
    Aud_ProgramaID              VARCHAR(50),        -- Parámetro de auditoría programa.
    Aud_Sucursal                INT(11),            -- Parámetro de auditoría ID de la sucursal.
    Aud_NumTransaccion          BIGINT(20)          -- Parámetro de auditoría numero de transaccion.
)

TerminaStore: BEGIN

	-- Declaración de variables.
	DECLARE Var_Control			   	VARCHAR(200);  		-- Variable de control.
	DECLARE Var_SpeiSolDesID		BIGINT(20);			-- Variable para el número de solicitud de descarga.
	DECLARE Var_NumRegistros		BIGINT(20);			-- Variable para la cantidad de descargas de remesas sin procesar.
	DECLARE Var_Indice            	INT(11);			-- Variable indice para recorrer las descargas de remesas.
	DECLARE Var_CuentaAhoID			BIGINT(20);			-- Variable para el número de cuenta.

	-- Declaración variables para consulta a tabla SPEIDESCARGASREM
	DECLARE Var_ClaveRastreo		VARCHAR(30);
	DECLARE Var_TipoPago		   	INT(2);
	DECLARE Var_TipoCuentaOrd	   	INT(2);
	DECLARE Var_CuentaOrd		   	VARCHAR(20);
	DECLARE Var_NombreOrd		   	VARCHAR(40);

	DECLARE Var_RFCOrd	           	VARCHAR(18);
	DECLARE Var_TipoOperacion	   	INT(2);
	DECLARE Var_MontoTransferir	   	DECIMAL(16,2);
	DECLARE Var_IVA				   	DECIMAL(16,2);
	DECLARE Var_ComisionTrans	   	DECIMAL(16,2);

	DECLARE Var_IVAComision		   	DECIMAL(16,2);
	DECLARE Var_InstiRemitente	   	INT(5);
	DECLARE Var_InstiReceptora	   	INT(5);
	DECLARE Var_CuentaBeneficiario 	VARCHAR(20);
	DECLARE Var_NombreBeneficiario 	VARCHAR(40);

	DECLARE Var_RFCBeneficiario	   	VARCHAR(18);
	DECLARE Var_TipoCuentaBen	   	INT(2);
	DECLARE Var_ConceptoPago	   	VARCHAR(40);
	DECLARE Var_CuentaBenefiDos    	VARCHAR(20);
	DECLARE Var_NombreBenefiDos    	VARCHAR(40);

	DECLARE Var_RFCBenefiDos	   	VARCHAR(18);
	DECLARE Var_TipoCuentaBenDos   	INT(2);
	DECLARE Var_ConceptoPagoDos    	VARCHAR(40);
	DECLARE Var_ReferenciaCobranza 	VARCHAR(40);
	DECLARE Var_ReferenciaNum      	INT(7);

	DECLARE Var_Prioridad    	   	INT(1);
	DECLARE Var_EstatusRem         	INT(3);
	DECLARE Var_UsuarioEnvio       	VARCHAR(30);
	DECLARE Var_AreaEmiteID	       	INT(2);
	DECLARE Var_FechaRecepcion     	DATETIME;

	DECLARE Var_CausaDevol         	INT(2);
	DECLARE Var_Topologia          	CHAR(1);
	DECLARE Var_Folio              	BIGINT(20);
	DECLARE Var_FolioPaquete       	BIGINT(20);
	DECLARE Var_FolioServidor      	BIGINT(20);

	DECLARE Var_Firma              	VARCHAR(250);
	DECLARE Var_SpeiDetSolDesID	   	BIGINT(20);
	DECLARE Var_RemesaWSID		   	BIGINT(20);
	DECLARE Error_Key				INT(11);			-- Codigo de error en transaccion
	DECLARE Var_Exitosos			INT(11);			-- Variable para la cantidad de descargas de remesas EXITOSOS
	DECLARE Var_Fallidos			INT(11);			-- Variable para la cantidad de descargas de remesas FALLIDOS

	-- Declaración de constantes.
	DECLARE Entero_Cero     		INT;				-- Constante número cero (0).
	DECLARE Cadena_Vacia    		CHAR(1);			-- Constante cadena vacía ''.
	DECLARE Fecha_Vacia     		DATE;				-- Constante fecha vacia '1900-01-01',
	DECLARE Decimal_Cero			DECIMAL(12,0);		-- Constante número cero en decimal (0.00).
	DECLARE Salida_SI        		CHAR(1);			-- Constante para confirmación de salida 'S'.

	DECLARE Salida_NO        		CHAR(1);			-- Constante para negación de salida 'N'.
	DECLARE Est_Pendiente       	CHAR(1);			-- Constante estatus pendiente 'P'.
	DECLARE Err_nueve       		BIGINT;				-- Constante error nueve (999).
	DECLARE Act_EstProce    		INT;				-- Actualización estatus procesado 'P' SPEIDESCARGASREM.
	DECLARE Act_EstError    		INT;				-- Actualización estatus erroneo 'E' SPEIDESCARGASREM.

	DECLARE Act_SpeiSolRemesa		INT;				-- Actualización del número de solicitud de descarga REMESASWS.

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero     	:= 0;
	SET Cadena_Vacia    	:= '';
	SET Fecha_Vacia     	:= '1900-01-01';
	SET Decimal_Cero		:= 0.00;
	SET Salida_SI        	:= 'S';

	SET Salida_NO        	:= 'N';
	SET Est_Pendiente       := 'P';
	SET Err_nueve       	:= 999;
	SET Act_EstProce    	:= 1;
	SET Act_EstError    	:= 2;

	SET Act_SpeiSolRemesa	:= 2;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen =  LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-SPEIDESCARGASREMPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'sqlException';
		END;

		IF (IFNULL(Par_SpeiSolDesID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El numero de solicitud de descarga esta vacio.';
			SET Var_Control := 'SpeiSolDesID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_SpeiSolDesID := (SELECT SpeiSolDesID FROM SPEISOLDESREM WHERE SpeiSolDesID = Par_SpeiSolDesID);

		IF (IFNULL(Var_SpeiSolDesID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El numero de solicitud de descarga no existe.';
			SET Var_Control := 'SpeiSolDesID';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual	:= NOW();
		SET Var_Indice := Entero_Cero;
		SET Var_NumRegistros := (SELECT COUNT(*) FROM SPEIDESCARGASREM WHERE Estatus = Est_Pendiente AND (IFNULL(SpeiSolDesID, Entero_Cero) = Entero_Cero));
		SET Var_NumRegistros := IFNULL(Var_NumRegistros, Entero_Cero);
        SET Var_Exitosos := Entero_Cero;
        SET Var_Fallidos := Entero_Cero;

		IteraRegistros: WHILE (Var_Indice < Var_NumRegistros) DO

			Iteraciones: BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
				DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
				DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
				DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

					SET Error_Key	:= Entero_Cero;
					SET	Par_NumErr := Entero_Cero;
					SET	Par_ErrMen := Cadena_Vacia;

					SELECT
						ClaveRastreo,			TipoPagoID,				TipoCuentaOrd,				LEFT(FNDECRYPTSAFI(CuentaOrd),20),			LEFT(FNDECRYPTSAFI(NombreOrd),40),
						LEFT(FNDECRYPTSAFI(RFCOrd),18),					TipoOperacion,				CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),				IVAPorPagar,	ComisionTrans,
						IVAComision,			InstiRemitenteID,		InstiReceptoraID,			LEFT(FNDECRYPTSAFI(CuentaBeneficiario),20),	LEFT(FNDECRYPTSAFI(NombreBeneficiario),40),
						LEFT(FNDECRYPTSAFI(RFCBeneficiario),18),		TipoCuentaBen,				LEFT(FNDECRYPTSAFI(ConceptoPago),40),		CuentaBenefiDos,		NombreBenefiDos,
						RFCBenefiDos,			TipoCuentaBenDos,		ConceptoPagoDos,			ReferenciaCobranza,							ReferenciaNum,
						PrioridadEnvio,			EstatusRem,				UsuarioEnvio,				AreaEmiteID,								FechaRecepcion,
						CausaDevol,				Topologia,				Folio,						FolioPaquete,								FolioServidor,
						Firma,					SpeiDetSolDesID,		RemesaWSID
					INTO
						Var_ClaveRastreo,		Var_TipoPago,			Var_TipoCuentaOrd,			Var_CuentaOrd,								Var_NombreOrd,
						Var_RFCOrd,				Var_TipoOperacion,		Var_MontoTransferir,		Var_IVA,									Var_ComisionTrans,
						Var_IVAComision,		Var_InstiRemitente,		Var_InstiReceptora,			Var_CuentaBeneficiario,						Var_NombreBeneficiario,
						Var_RFCBeneficiario,	Var_TipoCuentaBen,		Var_ConceptoPago,			Var_CuentaBenefiDos,						Var_NombreBenefiDos,
						Var_RFCBenefiDos,		Var_TipoCuentaBenDos,	Var_ConceptoPagoDos,		Var_ReferenciaCobranza,						Var_ReferenciaNum,
						Var_Prioridad,			Var_EstatusRem,			Var_UsuarioEnvio,			Var_AreaEmiteID,							Var_FechaRecepcion,
						Var_CausaDevol,			Var_Topologia,			Var_Folio,					Var_FolioPaquete,							Var_FolioServidor,
						Var_Firma,				Var_SpeiDetSolDesID,	Var_RemesaWSID
					FROM SPEIDESCARGASREM WHERE Estatus = 'P' AND IFNULL(SpeiSolDesID, Entero_Cero) = Entero_Cero LIMIT 1;

					SET Var_CuentaAhoID := (SELECT CA.CuentaAhoID FROM CUENTASAHO CA INNER JOIN REMESASWS WS ON WS.CuentaClabeRemesa = CA.Clabe WHERE WS.RemesaWSID = Var_RemesaWSID);
					IF(IFNULL(Var_CuentaAhoID, Entero_Cero) = Entero_Cero)THEN
						SET Error_Key			:= 3;
						SET Par_ErrMen			:= CONCAT('No se encontro la Cuenta de Ahorro de la Remesadora');
						LEAVE Iteraciones;
					END IF;

					SET Var_UsuarioEnvio := (SELECT LEFT(NombreCompleto,30) FROM USUARIOS WHERE UsuarioID = Aud_Usuario);

					CALL SPEIREMESASALT (
						Var_ClaveRastreo,  		Var_TipoPago,         	Var_TipoCuentaOrd,		Var_CuentaOrd,			Var_NombreOrd,
						Var_RFCOrd,         	Var_TipoOperacion,     	Var_MontoTransferir,	Var_IVA,				Var_ComisionTrans,
						Var_IVAComision,    	Var_InstiRemitente,    	Var_InstiReceptora,		Var_CuentaBeneficiario,	Var_NombreBeneficiario,
						Var_RFCBeneficiario,	Var_TipoCuentaBen,		Var_ConceptoPago,		Var_CuentaBenefiDos,	Var_NombreBenefiDos,
						Var_RFCBenefiDos,   	Var_TipoCuentaBenDos, 	Var_ConceptoPagoDos,	Var_ReferenciaCobranza,	Var_ReferenciaNum,
						Var_Prioridad,      	Var_EstatusRem,        	Var_UsuarioEnvio,		Var_AreaEmiteID,		Var_FechaRecepcion,
						Var_CausaDevol,			Var_Topologia,         	Var_Folio,				Var_FolioPaquete,		Var_FolioServidor,
						Var_Firma,          	Var_SpeiDetSolDesID,	Par_SpeiSolDesID,		Var_CuentaAhoID,		Salida_NO,
						Par_NumErr,				Par_ErrMen, 			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,	       	Aud_NumTransaccion
					);

					IF(Par_NumErr <> Entero_Cero)THEN
						SET Error_Key := 5;
						LEAVE Iteraciones;
					END IF;

					CALL REMESASWSACT (
						Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,	Decimal_Cero,	Cadena_Vacia,
						Cadena_Vacia, 		Entero_Cero,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,
						Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Entero_Cero,
						Entero_Cero, 		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,

						Entero_Cero,		Entero_Cero,		Entero_Cero,	Cadena_Vacia,	Cadena_Vacia,
						Cadena_Vacia, 		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Entero_Cero,
						Entero_Cero, 		Entero_Cero,		Entero_Cero,	Entero_Cero,	Entero_Cero,
						Cadena_Vacia, 		Cadena_Vacia,		Fecha_Vacia,	Cadena_Vacia,	Cadena_Vacia,
						Cadena_Vacia, 		Cadena_Vacia,		Cadena_Vacia,	Entero_Cero,	Entero_Cero,

						Entero_Cero, 		Entero_Cero,		Entero_Cero,	Cadena_Vacia,	Entero_Cero,
						Cadena_Vacia, 		Entero_Cero,		Entero_Cero,	Entero_Cero,	Entero_Cero,
						Entero_Cero,		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia,	Cadena_Vacia,
						Cadena_Vacia, 		Entero_Cero,		Fecha_Vacia,	Cadena_Vacia,	Entero_Cero,
						Fecha_Vacia, 		Cadena_Vacia,		Cadena_Vacia,	Entero_Cero,	Entero_Cero,

						Entero_Cero, 		Entero_Cero,		Entero_Cero,	Cadena_Vacia,	Entero_Cero,
						Cadena_Vacia, 		Cadena_Vacia,		Entero_Cero,	Entero_Cero,	Cadena_Vacia,
						Cadena_Vacia, 		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Entero_Cero,
						Cadena_Vacia, 		Entero_Cero,		Cadena_Vacia,	Entero_Cero,	Cadena_Vacia,
						Entero_Cero, 		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia,	Entero_Cero,

						Cadena_Vacia, 		Entero_Cero,		Cadena_Vacia, 	Entero_Cero, 	Cadena_Vacia,
						Entero_Cero, 		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia, 	Entero_Cero,
						Cadena_Vacia, 		Entero_Cero,		Cadena_Vacia,	Entero_Cero, 	Cadena_Vacia,
						Entero_Cero, 		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia, 	Var_RemesaWSID,
						Par_SpeiSolDesID,	Cadena_Vacia,		Act_SpeiSolRemesa,

						Salida_NO,			Par_NumErr, 		Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
					);

					IF(Par_NumErr <> Entero_Cero)THEN
						SET Error_Key := 6;
						LEAVE Iteraciones;
					END IF;

            END Iteraciones;

			SET Var_Indice = Var_Indice + 1;

			IF (Error_Key = Entero_Cero) THEN
				SET Var_Exitosos := Var_Exitosos + 1;
                SET Par_ErrMen := SUBSTR(Par_ErrMen,1,240);
				CALL SPEIDESCARGASREMACT (
					Var_SpeiDetSolDesID,	Par_SpeiSolDesID,		Var_ClaveRastreo,	Act_EstProce,		Salida_NO,
					Par_NumErr,       		Par_ErrMen,
                    Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,  	Aud_ProgramaID,
                    Aud_Sucursal,			Aud_NumTransaccion
				);

				IF(Par_NumErr <> Entero_Cero)THEN
					ITERATE IteraRegistros;
				END IF;
			ELSE
				SET Var_Fallidos := Var_Fallidos + 1;
                SET Par_ErrMen := SUBSTR(CONCAT(Error_Key,'-',Par_ErrMen),1,250);
				CALL SPEIDESCARGASREMACT (
					Var_SpeiDetSolDesID,	Par_SpeiSolDesID,		Var_ClaveRastreo,   	Act_EstError,			Salida_NO,
					Par_NumErr,     	  	Par_ErrMen,
                    Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,  		Aud_ProgramaID,
                    Aud_Sucursal,			Aud_NumTransaccion
				);

				IF(Par_NumErr <> Entero_Cero)THEN
					ITERATE IteraRegistros;
				END IF;

			END IF;

		END WHILE IteraRegistros;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Descarga Remesas Procesadas Exitosamente: ','Remesas Procesadas: ',Var_NumRegistros,', Exitosas: ',Var_Exitosos, ', Fallidos: ',Var_Fallidos);

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Par_SpeiSolDesID AS consecutivo;
	END IF;

END TerminaStore$$