-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASISREXTRAJEROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASISREXTRAJEROACT`;
DELIMITER $$

CREATE PROCEDURE `TASASISREXTRAJEROACT`(
/* ACTUALIZACIÓN PARA EL CAMBIO DE TASA DE ACUERDO A LA VIGENCIA. */
	Par_PaisID				INT(11),		-- Id del Pais.
	Par_Valor				DECIMAL(12,2),	-- Valor de la tasa.
	Par_Fecha				DATE,			-- Fecha de Vigencia.
	Par_Salida				CHAR(1),		-- Indica el tipo de SALIDA.
	INOUT Par_NumErr		INT(11),		-- Número de Validación.

	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Validación.
	/* Parámetros de Auditoría */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN
	-- DECLARACIÓN DE CONSTANTES.
	DECLARE Salida_SI 		CHAR(1);
	DECLARE Entero_Cero		INT;
	DECLARE Entero_Uno		INT;
	DECLARE Fecha_Vacia 	DATE;
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Decimal_Cero	DECIMAL(12,2);

	-- DECLARACIÓN DE VARIABLES.
	DECLARE Var_Control 	CHAR(15);
	DECLARE Var_FechaHis	DATE;
	DECLARE Var_FechaMax	DATE;
	DECLARE Var_ValorAnt	DECIMAL(12,2);
	DECLARE Var_NumCambios	INT;
	DECLARE Var_TipoAct		INT;

	-- ASIGNACIÓN DE CONSTANTES.
	SET Salida_SI			:= 'S';				-- Constante Si
	SET Entero_Cero 		:= 0;				-- Constante Cero
	SET Entero_Uno			:= 1;				-- Constante Uno
	SET Decimal_Cero		:= 0.0;				-- Valor DECIMAL
	SET Fecha_Vacia			:= '1900-01-01';	-- Constante Fecha Vacia
	SET Cadena_Vacia		:='';				-- Constante Cadena Vacia

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := '999';
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TASASISREXTRAJEROACT');
				SET Var_Control := 'SQLEXCEPTION' ;
			END;

		SET Var_FechaHis:= (SELECT Fecha FROM HISTASASISREXTRAJERO
								WHERE Fecha = Par_Fecha AND PaisID = Par_PaisID LIMIT 1);

		SET Var_FechaMax:= (SELECT MAX(Fecha) FROM HISTASASISREXTRAJERO AS hti
								INNER JOIN TASASISREXTRAJERO AS ti ON ti.TasaISR = hti.Valor
									WHERE ti.PaisID  = Par_PaisID);

		SET Var_FechaHis := IFNULL(Var_FechaHis,Fecha_Vacia);

		IF(IFNULL(Par_PaisID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 	:= '001';
			SET Par_ErrMen 	:= 'El Pais Residente en el Extranjero esta Vacio.';
			SET Var_Control := 'tasaImpuestoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Valor,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr 	:= '002';
			SET Par_ErrMen 	:= 'El Valor de Tasa ISR esta Vacio.';
			SET Var_Control := 'valor' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Fecha,Fecha_Vacia))= Fecha_Vacia THEN
			SET Par_NumErr 	:= '003';
			SET Par_ErrMen 	:= 'La Fecha de Nueva Vigencia esta Vacia.';
			SET Var_Control := 'fecha' ;
			LEAVE ManejoErrores;
		END IF;

		# SI AUN NO HAY REGISTRO PARA ESA FECHA DE CAMBIO DE TASA
		IF(IFNULL(Par_Fecha,Fecha_Vacia) != Var_FechaHis)THEN
			SET Var_TipoAct := 0;
		ELSE
			SET Var_TipoAct := 1;
		END IF;

		SET Aud_FechaActual := NOW();
		SET Var_NumCambios := (SELECT COUNT(Valor) FROM HISTASASISREXTRAJERO WHERE PaisID = Par_PaisID);

		/* Se obtiene el valor más reciente de la tasa de impuesto. */
		IF(Var_TipoAct = Entero_Cero)THEN
			IF(Var_NumCambios = Entero_Cero)THEN
				SET Var_ValorAnt := (SELECT TasaISR FROM TASASISREXTRAJERO WHERE PaisID = Par_PaisID LIMIT 1);
			ELSE
				SET Var_ValorAnt := (SELECT Valor FROM HISTASASISREXTRAJERO WHERE PaisID = Par_PaisID
										ORDER BY Fecha DESC LIMIT 1);
			END IF;
		ELSE
			SET Var_ValorAnt := (SELECT Valor FROM HISTASASISREXTRAJERO WHERE Fecha < Par_Fecha AND PaisID = Par_PaisID
									ORDER BY Fecha DESC LIMIT 1);
		END IF;
		SET Var_ValorAnt := IFNULL(Var_ValorAnt,Decimal_Cero);

		SET Aud_FechaActual := NOW();

		IF(IFNULL(Par_Fecha,Fecha_Vacia) != Var_FechaHis)THEN
			IF(IFNULL(Par_Fecha,Fecha_Vacia) < Var_FechaMax) THEN
				DELETE FROM HISTASASISREXTRAJERO
					 WHERE Fecha = Var_FechaMax AND PaisID = Par_PaisID;
			END IF;

			INSERT INTO HISTASASISREXTRAJERO(
				Fecha,			PaisID,			Valor,				ValorAnterior,	EmpresaID,
				Usuario,		FechaActual,	DireccionIP,		ProgramaID,		Sucursal,
				NumTransaccion)
			VALUES (
				Par_Fecha,		Par_PaisID,		Par_Valor,			Var_ValorAnt,	Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion
			);
		ELSE
			UPDATE HISTASASISREXTRAJERO
			SET
				Valor			= Par_Valor,
				ValorAnterior	= Var_ValorAnt,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,

				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE Fecha = Par_Fecha
				AND PaisID = Par_PaisID;

		END IF;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= CONCAT('Tasa ISR Actualizada Exitosamente');
		SET Var_Control	:= 'tasaImpuestoID';

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT
				Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Entero_Uno AS Consecutivo;
		END IF;

END TerminaStore$$