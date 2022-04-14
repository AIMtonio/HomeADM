-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASIMPUESTOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASIMPUESTOSACT`;
DELIMITER $$

CREATE PROCEDURE `TASASIMPUESTOSACT`(
/* ACTUALIZACIÓN PARA EL CAMBIO DE TASA DE ACUERDO A LA VIGENCIA. */
	Par_TasaImpuestoID		INT(11),		-- Id de la Tasa.
	Par_Nombre				VARCHAR(45),	-- Nombre corto.
	Par_Descripcion			VARCHAR(100),	-- Descrićión de la tasa.
	Par_Valor				DECIMAL(12,2),	-- Valor de la tasa.
	Par_Fecha				DATE,			-- Fecha de Vigencia.

	Par_Salida          	CHAR(1),		-- Indica el tipo de SALIDA.
	INOUT Par_NumErr       	INT(11),		-- Número de Validación.
	INOUT Par_ErrMen       	VARCHAR(400),	-- Mensaje de Validación.
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
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TASASIMPUESTOSACT');
				SET Var_Control := 'SQLEXCEPTION' ;
			END;

		SET Var_FechaHis:= (SELECT Fecha
			FROM `HIS-TASASIMPUESTOS`
			WHERE Fecha = Par_Fecha
			LIMIT 1);

		SET Var_FechaMax:= (SELECT MAX(Fecha)
			FROM `HIS-TASASIMPUESTOS` AS hti
			INNER JOIN TASASIMPUESTOS AS ti ON ti.Valor = hti.Valor
			 WHERE ti.TasaImpuestoID  = Par_TasaImpuestoID);

		SET Var_FechaHis := IFNULL(Var_FechaHis,Fecha_Vacia);

		IF(IFNULL(Par_TasaImpuestoID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 	:= '001';
			SET Par_ErrMen 	:= 'El Numero de Tasa ISR esta Vacio.';
			SET Var_Control := 'tasaImpuestoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Nombre,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr 	:= '002';
			SET Par_ErrMen 	:= 'El Nombre de Tasa ISR esta Vacio.';
			SET Var_Control := 'nombreImpuesto' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Descripcion,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr 	:= '003';
			SET Par_ErrMen 	:= 'La Descripcion de Tasa ISR esta Vacia.';
			SET Var_Control := 'descripcion' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Valor,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr 	:= '004';
			SET Par_ErrMen 	:= 'El Valor de Tasa ISR esta Vacio.';
			SET Var_Control := 'valor' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Fecha,Fecha_Vacia))= Fecha_Vacia THEN
			SET Par_NumErr 	:= '005';
			SET Par_ErrMen 	:= 'La Fecha esta Vacia.';
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
		SET Var_NumCambios := (SELECT COUNT(Valor) FROM `HIS-TASASIMPUESTOS`);

		/* Se obtiene el valor más reciente de la tasa de impuesto. */
		IF(Var_TipoAct = 0)THEN
			IF(Var_NumCambios = Entero_Cero)THEN
				SET Var_ValorAnt := (SELECT Valor FROM TASASIMPUESTOS LIMIT 1);
			ELSE
				SET Var_ValorAnt := (SELECT Valor FROM `HIS-TASASIMPUESTOS` ORDER BY Fecha DESC LIMIT 1);
			END IF;
		ELSE
			SET Var_ValorAnt := (SELECT Valor FROM `HIS-TASASIMPUESTOS` WHERE Fecha < Par_Fecha ORDER BY Fecha DESC LIMIT 1);
		END IF;
		SET Var_ValorAnt := IFNULL(Var_ValorAnt,Decimal_Cero);

		UPDATE TASASIMPUESTOS SET
			Nombre			= Par_Nombre,
			Descripcion		= Par_Descripcion,
			Valor			= Par_Valor,
			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,

			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE TasaImpuestoID = Entero_Uno;


		IF(IFNULL(Par_Fecha,Fecha_Vacia) != Var_FechaHis)THEN

			IF(IFNULL(Par_Fecha,Fecha_Vacia) < Var_FechaMax) THEN
				DELETE FROM `HIS-TASASIMPUESTOS`
					 WHERE Fecha = Var_FechaMax;
			END IF;

			INSERT INTO `HIS-TASASIMPUESTOS`(
				Fecha,			TasaImpuestoID,			Valor,				ValorAnterior,	EmpresaID,
				Usuario,		FechaActual,			DireccionIP,		ProgramaID,		Sucursal,
				NumTransaccion)
			VALUES (
				Par_Fecha,		Par_TasaImpuestoID,		Par_Valor,			Var_ValorAnt,	Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion
			);
		ELSE
			UPDATE `HIS-TASASIMPUESTOS` SET
				Valor			= Par_Valor,
				ValorAnterior	= Var_ValorAnt,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,

				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE Fecha = Par_Fecha;

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
				Par_TasaImpuestoID AS Consecutivo;
		END IF;

END TerminaStore$$