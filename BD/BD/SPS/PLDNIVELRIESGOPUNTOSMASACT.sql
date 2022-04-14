-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDNIVELRIESGOPUNTOSMASACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDNIVELRIESGOPUNTOSMASACT`;DELIMITER $$

CREATE PROCEDURE `PLDNIVELRIESGOPUNTOSMASACT`(
	Par_TipoCliente     	INT,				# 3 Evalua todos los clientes, 4- Evalua por fecha CTE
	Par_Salida 				CHAR(1), 			# Salida S:Si N:No
	INOUT	Par_NumErr		INT(11),			# Numero de error
	INOUT	Par_ErrMen		VARCHAR(400),		# Mensaje de error

	/* Parametros de Auditoria */
	Aud_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(20);	# Campo para el id del control de pantalla
	DECLARE Var_Consecutivo			VARCHAR(50);	# Consecutivo que se mostrara en pantalla
	DECLARE Var_FechaActual			DATE;			# Fecha Actual
	DECLARE Var_ClienteID			INT(11);		# Numero de Cliente
	DECLARE Var_Error_Key				INT(11);		# Clave de Error en el ciclo del cursor

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);		# Cadena Vacia
	DECLARE ConstanteNO				CHAR(1);
	DECLARE ConstanteSI				CHAR(1);
	DECLARE Decimal_Cero			DECIMAL(12, 2);
	DECLARE Entero_Cero				INT(11);		# Entero Cero
	DECLARE Entero_Uno				INT;
	DECLARE Error_DUPLICATEKEY		INT(11);
	DECLARE Error_INVALIDNULL		INT(11);
	DECLARE Error_SQLEXCEPTION		INT(11);
	DECLARE Error_VARUNQUOTED		INT(11);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Salida_SI				CHAR(1);		# Salida Si

	DECLARE CURSORCLIENTES  CURSOR FOR
		SELECT ClienteID
			FROM CLIENTES AS CTE LEFT JOIN CONOCIMIENTOCTE AS CON ON CTE.ClienteID = CON.ClienteID
			WHERE
			CTE.Estatus = 'A' AND
			CTE.FechaSigEvalPLD <=Var_FechaActual OR CTE.FechaSigEvalPLD IS NULL OR
			CTE.NivelRiesgo IS NULL OR
			CTE.NivelRiesgo = '' AND
			CON.EvaluaXMatriz = 'S';

		DECLARE CURSORCLIENTES2  CURSOR FOR
		SELECT CTE.ClienteID
			FROM CLIENTES  AS CTE LEFT JOIN CONOCIMIENTOCTE AS CON ON CTE.ClienteID = CON.ClienteID
			WHERE
			CTE.Estatus = 'A' AND
			CON.EvaluaXMatriz = 'S';
	-- Asginacion de constantes
	SET Cadena_Vacia			:= '';				-- String Vacio
	SET ConstanteNO				:= 'N';				-- Constante NO
	SET ConstanteSI				:= 'S';				-- Constante SI
	SET Decimal_Cero			:= 0.00;			-- Decimal Cero
	SET Entero_Cero				:= 0;				-- Entero en Cero
	SET Entero_Uno				:= 1;				-- Entero en Uno
	SET Error_DUPLICATEKEY		:= 2; 				-- Codigo de Error para el SQLSTATE: LLAVE DUPLICADA, COLUMNA NO DEBE SER NULA, COLUMNA AMBIGUA, ETC.
	SET Error_INVALIDNULL		:= 4; 				-- Codigo de Error para el SQLSTATE: USO INVALIDO DEL VALOR NULL, ERROR OBTENIDO DESDE EXPRESON REGULAR.
	SET Error_SQLEXCEPTION		:= 1;				-- Codigo de Error para el SQLSTATE: SQLEXCEPTION.
	SET Error_VARUNQUOTED		:= 3; 				-- Codigo de Error para el SQLSTATE: VARIABLE SIN COMILLAS, FUNCIONES DE AGREGACION (GROUP BY, SUM, ETC), ETC.
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Salida_SI				:= 'S';				-- Salida Si


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDNIVELRIESGOPUNTOSMASACT');
			SET Var_Control := 'sqlException';
		END;

		SELECT
			PAR.FechaSistema
		  INTO
			Var_FechaActual
			FROM PARAMETROSSIS AS PAR;
		IF(Par_TipoCliente = 4) THEN
			OPEN CURSORCLIENTES;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLOGLA:LOOP
						FETCH CURSORCLIENTES INTO Var_ClienteID;
						BEGIN
							DECLARE EXIT HANDLER FOR SQLEXCEPTION 		SET Var_Error_Key := Error_SQLEXCEPTION;
							DECLARE EXIT HANDLER FOR SQLSTATE '23000'	SET Var_Error_Key := Error_DUPLICATEKEY;
							DECLARE EXIT HANDLER FOR SQLSTATE '42000'	SET Var_Error_Key := Error_VARUNQUOTED;
							DECLARE EXIT HANDLER FOR SQLSTATE '22004'	SET Var_Error_Key := Error_INVALIDNULL;

							SET Var_Error_Key   	:= Entero_Cero;
							CALL PLDNIVELRIESGOPUNTOSINDACT(
								Var_ClienteID,		ConstanteNO,			Par_NumErr,			Par_ErrMen,			Aud_Empresa,
								Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
								Aud_NumTransaccion);

							IF(Par_NumErr!=Entero_Cero) THEN
								LEAVE CICLOGLA;
							END IF;
						END;
					END LOOP CICLOGLA;
				END;
			CLOSE CURSORCLIENTES;
		ELSEIF(Par_TipoCliente = 3) THEN
			OPEN CURSORCLIENTES2;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLOGLA2:LOOP
						FETCH CURSORCLIENTES2 INTO Var_ClienteID;
						BEGIN
							DECLARE EXIT HANDLER FOR SQLEXCEPTION 		SET Var_Error_Key := Error_SQLEXCEPTION;
							DECLARE EXIT HANDLER FOR SQLSTATE '23000'	SET Var_Error_Key := Error_DUPLICATEKEY;
							DECLARE EXIT HANDLER FOR SQLSTATE '42000'	SET Var_Error_Key := Error_VARUNQUOTED;
							DECLARE EXIT HANDLER FOR SQLSTATE '22004'	SET Var_Error_Key := Error_INVALIDNULL;

							SET Var_Error_Key   	:= Entero_Cero;
							CALL PLDNIVELRIESGOPUNTOSINDACT(
								Var_ClienteID,		ConstanteNO,			Par_NumErr,			Par_ErrMen,			Aud_Empresa,
								Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
								Aud_NumTransaccion);

							IF(Par_NumErr!=Entero_Cero) THEN
								LEAVE CICLOGLA2;
							END IF;
						END;
					END LOOP CICLOGLA2;
				END;
			CLOSE CURSORCLIENTES2;
		END IF;

		IF(Par_NumErr!=Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_ErrMen,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 0;
			SET Par_ErrMen := 'Proceso Ejecutado Exitosamente';
		END IF;
	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$