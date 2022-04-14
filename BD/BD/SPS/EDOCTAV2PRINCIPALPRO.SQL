-- EDOCTAV2PRINCIPALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2PRINCIPALPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2PRINCIPALPRO`(

	-- SP PRINCIPAL QUE LLAMA A LOS PROCESOS DE EXTRACCION PARA EL ESTADO DE CUENTA PRINCIPAL
	Par_Salida							CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr					INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen					VARCHAR(400),		-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador
	Par_EmpresaID 						INT(11),			-- Parametros de auditoria
	Aud_Usuario							INT(11),			-- Parametros de auditoria
	Aud_FechaActual						DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP						VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID						VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal						INT(11), 			-- Parametros de auditoria
	Aud_NumTransaccion					BIGINT(20)			-- Parametros de auditoria
)

TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_Control					VARCHAR(50);		-- Variable para control de excepciones

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia				VARCHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);			-- Entero Cero
	DECLARE Entero_Uno					INT(1);				-- Entero Uno
	DECLARE Var_SI						CHAR(1);			-- Etiqueta Si
	DECLARE Var_NO						CHAR(1);			-- Etiqueta No
	DECLARE Var_CliProEsp				INT(5);
	DECLARE CliProcEspecifico 			VARCHAR(20);
	DECLARE Var_ClienteNG				INT(5);

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero Cero
	SET Entero_Uno						:= 1;				-- Entero Uno
	SET Var_SI							:= 'S';				-- Etiqueta Si
	SET Var_NO							:= 'N';				-- Etiqueta No
	SET Var_ClienteNG					:= 48;


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2PRINCIPALPRO');
			SET Var_Control = 'sqlException';
		END;

		TRUNCATE TABLE EDOCTAV2GRAFICA           ;
		TRUNCATE TABLE TMPEDOCTAV2RESUMCREDITOS  ;
		TRUNCATE TABLE TMPEDOCTAV2PAGODIACRED    ;
		TRUNCATE TABLE TMPEDOCTAV2HEADERCRED     ;
		TRUNCATE TABLE EDOCTAV2XMLGENERADOS      ;
		TRUNCATE TABLE EDOCTAV2RESUMCREDITOS     ;
		TRUNCATE TABLE EDOCTAV2RESUMCAPTA        ;
		TRUNCATE TABLE EDOCTAV2PDFGENERADOS      ;
		TRUNCATE TABLE EDOCTAV2HEADERCTA         ;
		TRUNCATE TABLE EDOCTAV2HEADERCRED        ;
		TRUNCATE TABLE EDOCTAV2HEADERCEDES       ;
		TRUNCATE TABLE EDOCTAV2DETCRE            ;
		TRUNCATE TABLE EDOCTAV2DETACTA           ;
		TRUNCATE TABLE EDOCTAV2DETACEDES         ;
		TRUNCATE TABLE EDOCTAV2DATOSCTE          ;
		TRUNCATE TABLE EDOCTAV2CAROBJETADOS      ;
		TRUNCATE TABLE EDOCTAV2CFDIDATOS;
		TRUNCATE TABLE EDOCTAV2TMP_DATOSCTE;
		TRUNCATE TABLE EDOCTAV2TIMBRADOINGRE;
		TRUNCATE TABLE EDOCTAV2RESPTIMBRE;

		SELECT ValorParametro INTO Var_CliProEsp FROM PARAMGENERALES WHERE LlaveParametro= CliProcEspecifico;

		-- Llamado a SP de actualizacion de Parametros
		CALL EDOCTAV2PARAMSPRO	(	Var_NO,				Par_NumErr,				Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
		                    		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion	);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Datos Clientes
		CALL EDOCTAV2DATOSCTEPRO	(	Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Resumen de Creditos
		CALL EDOCTAV2RESUMCREDITOSPRO	(	Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Cabecera de creditos
		CALL EDOCTAV2HEADERCREDPRO	(	Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Detalle de creditos
		CALL EDOCTAV2DETCREPRO		(	Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Resumen Captacion
		CALL EDOCTAV2RESUMCAPTAPRO	(	Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- AHORRO Header
		CALL EDOCTAV2HEADERCTAPRO	(	Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Detalle de ahorro
		CALL EDOCTAV2DETACTAPRO		(	Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Cabecera de cedes
		CALL EDOCTAV2HEADERCEDESPRO	(	Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Detalle de cedes
		CALL EDOCTAV2DETACEDESPRO	(	Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		DROP TEMPORARY TABLE IF EXISTS TMP_EDOCTA_CLIENTESFINALES;
		CREATE TEMPORARY TABLE TMP_EDOCTA_CLIENTESFINALES
		SELECT DISTINCT ClienteID
		FROM EDOCTAV2RESUMCAPTA
		UNION
		SELECT DISTINCT ClienteID
		FROM EDOCTAV2RESUMCREDITOS;


		CREATE INDEX IDX_TMP_EDOCTA_CLIENTESFINALES_01 ON TMP_EDOCTA_CLIENTESFINALES(ClienteID);

		DELETE Cli FROM EDOCTAV2DATOSCTE Cli
		LEFT JOIN TMP_EDOCTA_CLIENTESFINALES Tmp ON Cli.ClienteID = Tmp.ClienteID
		WHERE Tmp.ClienteID IS NULL;

		-- Cargos Objetados
		CALL EDOCTAV2CARGOSOBJETADOSPRO	(	Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Graficas
		CALL EDOCTAV2GRAFICAPRO			(		);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		CALL EDOCTAV2CFDIDATOSPRO (	Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		IF(Var_ClienteNG = Var_CliProEsp)THEN
			CALL EDOCTAV2LITROSPRO (Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Proceso Principal de extraccion del Estado de Cuenta Ejecutado con Exito';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control;
	END IF;

END TerminaStore$$
