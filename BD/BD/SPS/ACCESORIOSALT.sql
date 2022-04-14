-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACCESORIOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACCESORIOSALT`;
DELIMITER $$

CREATE PROCEDURE `ACCESORIOSALT`(
-- ===================================================================================
-- SP PARA REGISTRAR LOS ACCESORIOS A COBRAR DE UN CREDITO
-- ===================================================================================
	Par_AccesorioID 	INT(11),		# Identificador del Accesorio
	Par_Descripcion		VARCHAR(100),	# Descripcion del Accesorio
	Par_Abreviatura		VARCHAR(10),	# Abreviatura del Accesorio
	Par_Prelacion		INT(11),		# Indica la Prelacion de Cobro del Accesorio
	Par_CAT				char(1),		# Indica si se aplica cálculo CAT

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
	DECLARE	Var_MontoBase 		DECIMAL(12,2); 	# Monto Base del Accesorio
	DECLARE Var_AccesorioID 	INT(11);		# Accesorio ID
	DECLARE Var_Contador 		INT(11);		# Contador para un Cliclo
	DECLARE Var_SaldoDipon 		DECIMAL(12,2); 	# Guarda el Saldo Disponible
    DECLARE Var_NumRegistros 	INT(11); 		# Número de Registros
    DECLARE Var_NombreCorto 	CHAR(10);		# Nombre Corto del Accesorio
    DECLARE Var_ConceptoCarID 	INT(11); 		# Id del concepto del Cartera

	/*Declración de Constantes*/
	DECLARE	Entero_Cero 			INT(11); 			# Constante Entero Cero
    DECLARE Entero_Uno 				INT(11); 			# Constante Entero Uno
	DECLARE Decimal_Cero			DECIMAL(12,2); 		# Constante Decimal Cero
	DECLARE Fecha_Vacia				DATE; 				# Constante Fecha Vacía
	DECLARE SalidaSI				CHAR(1); 			# Constante Cadena Si
	DECLARE Cadena_Vacia			VARCHAR(100); 		# Constante Cadena Vacía
    DECLARE SalidaNo				CHAR(1); 			# Constante Salida No
    DECLARE String_IVA				VARCHAR(4); 		# Constante IVA
    DECLARE String_Interes 			VARCHAR(30);		# Constante Interes
    DECLARE String_IvaInteres 		VARCHAR(30);		# Constante IvaInteres
    DECLARE String_Devengamiento 	VARCHAR(30);		# Constante Devengamiento

	/*Asignacion de Constantes*/
	SET Entero_Cero 			:= 0; 					# Constante Entero Cero
    SET Entero_Uno 				:= 1; 					# Constante Entero Uno
	SET Decimal_Cero 			:= 0.0; 				# Constante Decimal Cero
	SET Fecha_Vacia				:= '1900-01-01'; 		# Constante Fecha Vacía
	SET SalidaSI				:= 'S'; 				# Constante Cadena Si
	SET Cadena_Vacia 			:= ''; 					# Constante Cadena Vacía
    SET SalidaNo 				:= 'N'; 				# Constante Salida No
    SET String_IVA				:= 'IVA '; 				# Constante Cadena IVA
    SET String_Interes			:= 'INTERES '; 			# Constante Cadena Interes
    SET String_IvaInteres 		:= 'IVA INTERES ';		# Constante IvaInteres
    SET String_Devengamiento	:= 'DEVENGAMIENTO INTERES '; 	# Constante Cadena Devengamiento


	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocaciones. Ref: SP-ACCESORIOSALT');
			SET Var_Control	:='SQLEXCEPTION';
		END;

	IF(IFNULL(Par_Descripcion,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 02;
		SET Par_ErrMen := 'La Descripcion esta vacia.';
		SET Var_Control := 'descripcion';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Abreviatura,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 03;
		SET Par_ErrMen := 'La Abreviatura esta vacia.';
		SET Var_Control := 'abreviatura';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Prelacion,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr := 04;
		SET Par_ErrMen := 'La Prelacion esta vacio.';
		SET Var_Control := 'prelacion';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CAT,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr := 05;
		SET Par_ErrMen := 'El CAT esta vacio.';
		SET Var_Control := 'cat';
		LEAVE ManejoErrores;
	END IF;

		-- Verifica que no exista el producto a agregar
		SET Var_AccesorioID := (SELECT AccesorioID FROM ACCESORIOSCRED WHERE AccesorioID=Par_AccesorioID);
		SET Var_AccesorioID := IFNULL(Var_AccesorioID,Entero_Cero);

		-- Valida para saber si agregar un nuevo accesorio o actualizar uno ya existente
		IF(Var_AccesorioID=Entero_Cero)THEN
			-- Entra si agrega un nuevo accesorio
			SET Var_AccesorioID	:= (SELECT IFNULL(MAX(AccesorioID),Entero_Cero) + Entero_Uno  FROM ACCESORIOSCRED);

			INSERT INTO ACCESORIOSCRED VALUES(
				Var_AccesorioID,	Par_Descripcion,	Par_Abreviatura,	Par_Prelacion,		Par_CAT,
				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

		   CALL CONCEPTOSCARTERAALT(
			Entero_Cero,	Par_Abreviatura,	SalidaNO,			Par_NumErr,			Par_ErrMen,
			Aud_EmpresaID, 	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,   Aud_NumTransaccion);

            IF(Par_NumErr<>Entero_Cero)THEN
				SET Var_Control := 'conceptoCarteraID';
				LEAVE ManejoErrores;
			END IF;

            CALL CONCEPTOSCARTERAALT(
			Entero_Cero,	CONCAT(String_IVA,Par_Abreviatura),	SalidaNO,			Par_NumErr,			Par_ErrMen,
			Aud_EmpresaID, 	Aud_Usuario,						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,   Aud_NumTransaccion);

			IF(Par_NumErr<>Entero_Cero)THEN
				SET Var_Control := 'conceptoCarteraID';
				LEAVE ManejoErrores;
			END IF;

			CALL CONCEPTOSCARTERAALT(
			Entero_Cero,	CONCAT(String_Interes,Par_Abreviatura),	SalidaNO,			Par_NumErr,			Par_ErrMen,
			Aud_EmpresaID, 	Aud_Usuario,							Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,   Aud_NumTransaccion);

			IF(Par_NumErr<>Entero_Cero)THEN
				SET Var_Control := 'conceptoCarteraID';
				LEAVE ManejoErrores;
			END IF;

			CALL CONCEPTOSCARTERAALT(
			Entero_Cero,	CONCAT(String_IvaInteres,Par_Abreviatura),	SalidaNO,			Par_NumErr,			Par_ErrMen,
			Aud_EmpresaID, 	Aud_Usuario,								Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,   Aud_NumTransaccion);

			IF(Par_NumErr<>Entero_Cero)THEN
				SET Var_Control := 'conceptoCarteraID';
				LEAVE ManejoErrores;
			END IF;

			CALL CONCEPTOSCARTERAALT(
			Entero_Cero,	CONCAT(String_Devengamiento,Par_Abreviatura),	SalidaNO,			Par_NumErr,			Par_ErrMen,
			Aud_EmpresaID, 	Aud_Usuario,									Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,   Aud_NumTransaccion);

			IF(Par_NumErr<>Entero_Cero)THEN
				SET Var_Control := 'conceptoCarteraID';
				LEAVE ManejoErrores;
			END IF;

		ELSE
			-- Entra para actualizar en accesorio ya existente
			-- Actualiza Concepto Cartera
			SET Var_NombreCorto := (SELECT NombreCorto FROM ACCESORIOSCRED
									WHERE AccesorioID = Var_AccesorioID);
			SET Var_ConceptoCarID := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA
									WHERE Descripcion = Var_NombreCorto);
			SET Var_ConceptoCarID := IFNULL(Var_ConceptoCarID,Entero_Cero);
            IF(Var_ConceptoCarID<>Entero_Cero)THEN
				UPDATE CONCEPTOSCARTERA SET
					Descripcion = Par_Abreviatura
				WHERE ConceptoCarID = Var_ConceptoCarID;
            END IF;

            -- Actualiza Concepto de IVA
            SET Var_ConceptoCarID := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA
									WHERE Descripcion = CONCAT(String_IVA,Var_NombreCorto));
			SET Var_ConceptoCarID := IFNULL(Var_ConceptoCarID,Entero_Cero);
            IF(Var_ConceptoCarID<>Entero_Cero)THEN
				UPDATE CONCEPTOSCARTERA SET
					Descripcion = CONCAT(String_IVA,Par_Abreviatura)
				WHERE ConceptoCarID = Var_ConceptoCarID;
			END IF;

			 -- Actualiza Concepto de Interes
            SET Var_ConceptoCarID := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA
									WHERE Descripcion = CONCAT(String_Interes,Var_NombreCorto));
			SET Var_ConceptoCarID := IFNULL(Var_ConceptoCarID,Entero_Cero);
            IF(Var_ConceptoCarID<>Entero_Cero)THEN
				UPDATE CONCEPTOSCARTERA SET
					Descripcion = CONCAT(String_Interes,Par_Abreviatura)
				WHERE ConceptoCarID = Var_ConceptoCarID;
			END IF;

			 -- Actualiza Concepto de IvaInteres
            SET Var_ConceptoCarID := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA
									WHERE Descripcion = CONCAT(String_IvaInteres,Var_NombreCorto));
			SET Var_ConceptoCarID := IFNULL(Var_ConceptoCarID,Entero_Cero);
            IF(Var_ConceptoCarID<>Entero_Cero)THEN
				UPDATE CONCEPTOSCARTERA SET
					Descripcion = CONCAT(String_IvaInteres,Par_Abreviatura)
				WHERE ConceptoCarID = Var_ConceptoCarID;
			END IF;

			 -- Actualiza Concepto de Devengamiento
            SET Var_ConceptoCarID := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA
									WHERE Descripcion = CONCAT(String_Devengamiento,Var_NombreCorto));
			SET Var_ConceptoCarID := IFNULL(Var_ConceptoCarID,Entero_Cero);
            IF(Var_ConceptoCarID<>Entero_Cero)THEN
				UPDATE CONCEPTOSCARTERA SET
					Descripcion = CONCAT(String_Devengamiento,Par_Abreviatura)
				WHERE ConceptoCarID = Var_ConceptoCarID;
			END IF;

			-- Actualiza Accesorios
			UPDATE ACCESORIOSCRED SET
				Descripcion 	= 	Par_Descripcion,
				NombreCorto 	= 	Par_Abreviatura,
				Prelacion 		= 	Par_Prelacion,
				CAT				= 	Par_CAT,
				EmpresaID 		= 	Aud_EmpresaID,
				Usuario 		= 	Aud_Usuario,
				FechaActual 	= 	Aud_FechaActual,
				DireccionIP 	= 	Aud_DireccionIP,
				ProgramaID 		= 	Aud_ProgramaID,
				Sucursal 		= 	Aud_Sucursal,
				NumTransaccion 	=  	Aud_NumTransaccion
			WHERE AccesorioID = Var_AccesorioID;
		END IF;

		-- Verifica que no exista un accesorio con la misma abreviatura
		SET Var_NumRegistros := (SELECT COUNT(*) FROM ACCESORIOSCRED WHERE NombreCorto=Par_Abreviatura);


		IF(IFNULL(Var_NumRegistros, Entero_Cero) > Entero_Uno)THEN
			SET Par_NumErr := 05;
			SET Par_ErrMen := 'Existe mas de un Accesorio con la misma abreviatura.';
			SET Var_Control := 'abreviatura';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := 00;
		SET Par_ErrMen := 'Accesorio Agregado Correctamente';
		SET Var_Control := 'accesorioID';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
                Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
