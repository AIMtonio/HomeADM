
-- TARLAYDEBSAFIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARLAYDEBSAFIALT`;
DELIMITER $$

CREATE PROCEDURE `TARLAYDEBSAFIALT`(
-- ===================================================================================
-- SP PARA REGISTRAR LA CADENA DE LOS DATOS PARA EL LAYOUT
-- ===================================================================================
	Par_TarLayDebSAFIID	BIGINT(12),		# Identificador de la tabla TarLayDebSAFIID
	Par_LoteDebSAFIID	INT(11),		# Identificador de la tabla LoteDebSAFIID
	Par_LayoutTarDeb	VARCHAR(500),	# Cadena de layout
	Par_FechaRegistro   DATETIME,		# Fecha de registro del lote
	Par_EsGenerado      CHAR(1),		# Indica si ya se genero

	Par_NumTarjeta        CHAR(16),		# Numero de la tarjeta
	Par_CVV               CHAR(4),		# CVV proporcionado por copayment
	Par_ICVV              CHAR(4),		# ICVV proporcionado por copayment
	Par_CVV2              CHAR(8),		# CVV2 proporcionado por copayment
	Par_FechaVencimiento  CHAR(5),		# Fecha de vencimiento de la tarjeta

	Par_NIP               VARCHAR(256), # NIP proporcionado por copayment

	Par_Salida			CHAR(1),		# Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr	INT(11),		# Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	# Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID 		INT(11),
	Aud_Usuario 		INT(11),
  	Aud_FechaActual 	DATETIME,
  	Aud_DireccionIP 	VARCHAR(15),
  	Aud_ProgramaID 		VARCHAR(50),
  	Aud_Sucursal 		INT(11),
  	Aud_NumTransaccion 	BIGINT(20)
)
TerminaStore:BEGIN

	/*Declaracion de Variables*/
	DECLARE Var_Control 		VARCHAR(50); 	# Control en Pantalla
	DECLARE	Var_Consecutivo 	INT(11); 		# Consecutivo en Pantalla
	DECLARE Var_LoteDebSAFIID	INT(11);
	DECLARE Var_TarLayDebSAFIID	BIGINT(12);

	/*Declración de Constantes*/
	DECLARE	Entero_Cero 			INT(11); 		# Constante Entero Cero
    DECLARE Entero_Uno 				INT(11); 		# Constante Entero Uno
	DECLARE Decimal_Cero			DECIMAL(12,2); 	# Constante Decimal Cero
	DECLARE Fecha_Vacia				DATE; 			# Constante Fecha Vacía
	DECLARE FechaCorta_Vacia		CHAR(5); 		# Constante Fecha corta vacia en formato yy/mm
	DECLARE SalidaSI				CHAR(1); 		# Constante Cadena Si
	DECLARE Cadena_Vacia			VARCHAR(100); 	# Constante Cadena Vacía
    DECLARE SalidaNo				CHAR(1); 		# Constante Salida No
    DECLARE NoGenerado				CHAR(1);

	/*Asignacion de Constantes*/
	SET Entero_Cero 	:= 0; 				# Constante Entero Cero
    SET Entero_Uno 		:= 1; 				# Constante Entero Uno
	SET Decimal_Cero 	:= 0.0; 			# Constante Decimal Cero
	SET Fecha_Vacia		:= '1900-01-01'; 	# Constante Fecha Vacía
	SET FechaCorta_Vacia := '00/01';		# Constante Fecha corta vacia en formato yy/mm
	SET SalidaSI		:= 'S'; 			# Constante Cadena Si
	SET Cadena_Vacia 	:= ''; 				# Constante Cadena Vacía
    SET SalidaNo 		:= 'N'; 			# Constante Salida No
    SET NoGenerado		:= 'N';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocaciones. Ref: SP-TARLAYDEBSAFIALT');
			SET Var_Control	:='SQLEXCEPTION';
		END;

		SELECT loteDebSAFIID
			INTO Var_LoteDebSAFIID
		FROM LOTETARJETADEBSAFI
			WHERE LoteDebSAFIID = Par_LoteDebSAFIID;

		IF(IFNULL(Var_LoteDebSAFIID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 01;
			SET Par_ErrMen := 'El lote de tarjeta no existe.';
			SET Var_Control := 'loteDebSAFIID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_LayoutTarDeb,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr := 02;
			SET Par_ErrMen := 'La cadena del layout esta vacio.';
			SET Var_Control := 'layoutTarDeb';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaRegistro,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr := 05;
			SET Par_ErrMen := 'La fecha de registro esta vacio.';
			SET Var_Control := 'fechaRegistro';
			LEAVE ManejoErrores;
		END IF;

		SET Var_TarLayDebSAFIID	:= (SELECT IFNULL(MAX(TarLayDebSAFIID),Entero_Cero) + Entero_Uno  FROM TARLAYDEBSAFI);

		INSERT INTO TARLAYDEBSAFI (	TarLayDebSAFIID, 		LoteDebSAFIID, 		LayoutTarDeb, 			NumTarjeta,			CVV,
									ICVV,					CVV2,				FechaVencimiento,		NIP,				FechaRegistro,
									EsGenerado, 			EmpresaID,			Usuario, 				FechaActual, 		DireccionIP,
									ProgramaID,				Sucursal, 			NumTransaccion)
							VALUES(	Var_TarLayDebSAFIID, 	Par_LoteDebSAFIID, 	Par_LayoutTarDeb, 		Par_NumTarjeta,		Cadena_Vacia,
									Cadena_Vacia,			Cadena_Vacia,		Par_FechaVencimiento,	Cadena_Vacia,		Par_FechaRegistro,
									NoGenerado,				Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
		SET Par_NumErr := 00;
		SET Par_ErrMen := 'Registro Agregado Correctamente';
		SET Var_Control := 'accesorioID';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
                Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
