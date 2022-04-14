-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWTIPOSFONDEADORALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWTIPOSFONDEADORALT`;
DELIMITER $$

CREATE PROCEDURE `CRWTIPOSFONDEADORALT`(
	Par_Descripcion 		VARCHAR(100),	-- Descripción del Fondeador.
	Par_EsObligSol			CHAR(1),		-- Especifica si el Tipo de Inversionista, es obligado solidario.
	Par_PagoEnIncum			CHAR(1),		-- Especifica si se paga al Inversionista en el incumplimiento.
	Par_PorcentMora			DECIMAL(8,4),	-- Porcentaje de Participacion en la Mora.
	Par_PorcentComi			DECIMAL(8,4),	-- Porcentaje de Participacion en Comisiones.

	Par_Salida				CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error
	/* Parámetros de Auditoría. */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaración de Variables.
DECLARE	Var_TipoFondeadorID		INT;
DECLARE	Var_Control				VARCHAR(50);

-- Declaración de Constantes.
DECLARE Entero_Cero				INT;
DECLARE Decimal_Cero			DECIMAL(12,2);
DECLARE Cadena_Vacia			CHAR(1);
DECLARE Str_SI					CHAR(1);
DECLARE Str_NO					CHAR(1);

-- Asignación de constantes.
SET Entero_Cero					:=0;		-- Constante Entero Cero
SET Decimal_Cero				:=0.00;		-- Constante Decimal Cero
SET Cadena_Vacia				:= '';		-- Constante Cadena Vacia
SET Str_SI						:= 'S';		-- Constante SI
SET Str_NO						:= 'N';		-- Constante NO

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWTIPOSFONDEADORALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'La Descripcion esta Vacia.';
		SET Var_Control:= 'descripcion';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PorcentMora,Decimal_Cero)) = Decimal_Cero THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El % de Participacion en Mora esta vacio.';
		SET Var_Control:= 'porcentMora';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PorcentComi,Decimal_Cero)) = Decimal_Cero THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'El % de Participacion en Comisiones esta vacio.';
		SET Var_Control:= 'porcentComi';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EsObligSol,Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'Es Obligado Solidario esta vacio.';
		SET Var_Control:= 'porcentComi';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EsObligSol,Cadena_Vacia) NOT IN (Str_SI, Str_NO)) THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'Obligado Solidario No Valido.';
		SET Var_Control:= 'porcentComi';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PagoEnIncum,Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'El Pago en Incumplimiento esta vacio.';
		SET Var_Control:= 'porcentComi';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PagoEnIncum,Cadena_Vacia) NOT IN (Str_SI, Str_NO)) THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'El Pago en Incumplimiento No Valido.';
		SET Var_Control:= 'porcentComi';
		LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual := NOW();
	SET Var_TipoFondeadorID := (SELECT IFNULL(MAX(TipoFondeadorID),Entero_Cero) + 1 FROM CRWTIPOSFONDEADOR);

	INSERT INTO CRWTIPOSFONDEADOR (
		TipoFondeadorID,	Descripcion,		EsObligadoSol,		PagoEnIncumple,		PorcentajeMora,
		PorcentajeComisi, 	EmpresaID,			Usuario,			FechaActual,		DireccionIP,
		ProgramaID,			Sucursal,			NumTransaccion)
	VALUES(
		Var_TipoFondeadorID,Par_Descripcion,	Par_EsObligSol,		Par_PagoEnIncum,	Par_PorcentMora,
		Par_PorcentComi,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT('Tipo de Fondeador Agregado Exitosamente: ',Var_TipoFondeadorID,'.');
	SET Var_Control:= 'tipoFondeadorID';

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Var_TipoFondeadorID AS Consecutivo;
END IF;

END TerminaStore$$