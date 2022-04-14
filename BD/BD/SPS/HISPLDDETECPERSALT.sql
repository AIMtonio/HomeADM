
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPLDDETECPERSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPLDDETECPERSALT`;

DELIMITER $$
CREATE PROCEDURE `HISPLDDETECPERSALT`(
/* SP DE ALTA EN EL HISTÓRICO DE LAS PERSONAS ENCONTRADAS EN LISTAS PLD*/
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	/* Parametros de Auditoria */
	Par_EmpresaID 			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE Salida_SI 				CHAR(1);
	DECLARE Cons_No					CHAR(1);

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(20);

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET Salida_SI 	 			:= 'S';				-- Salida Si
	SET Cons_No					:= 'N';				-- Constante No

	SET Aud_FechaActual 		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-HISPLDDETECPERSALT');
			SET Var_Control:= 'sqlException';
		END;

	SET @Var_IDPLDHistorico 	:= (SELECT MAX(IDPLDhist) FROM HISPLDDETECPERS);
	SET @Var_IDPLDHistorico 	:= IFNULL(@Var_IDPLDHistorico, Entero_Cero);

	INSERT INTO HISPLDDETECPERS (
		IDPLDhist,
		IDPLDDetectPers,	TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,	TipoLista,
		FechaDeteccion,		ListaPLDID,			IDQEQ,				NumeroOficio,	OrigenDeteccion,
		FechaAlta,			TipoListaID,		CuentaAhoID,		EmpresaID,		Usuario,
		FechaActual,		DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion)
	SELECT
		(@Var_IDPLDHistorico:=@Var_IDPLDHistorico+1),
		IDPLDDetectPers,	TipoPersonaSAFI,	ClavePersonaInv,	NombreCompleto,	TipoLista,
		FechaDeteccion,		ListaPLDID,			IDQEQ,				NumeroOficio,	OrigenDeteccion,
		FechaAlta,			TipoListaID,		CuentaAhoID,		EmpresaID,		Usuario,
		FechaActual,		DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion
	FROM PLDDETECPERS;

	TRUNCATE PLDDETECPERS;

	SET	Par_NumErr := 0;
	SET	Par_ErrMen := CONCAT('Guardado en el Historico Exitosamente.');

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$

