-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAERRORNOTICAPLDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAERRORNOTICAPLDALT`;

DELIMITER $$
CREATE PROCEDURE `BITACORAERRORNOTICAPLDALT`(
	-- Store Procedure de Alta en la Bitacora de Exclusiones o rompimiento de Grupos
	-- Modulo Web Service
	Par_OpeInusualID		BIGINT(20),	-- ID de la tabla PLDOPEINUSUALES
	Par_NumeroError			INT(11),	-- Codigo error
	Par_MensajeError		TEXT,		-- Mensaje del error

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Parametro Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro Mensaje de Error

	Aud_EmpresaID			INT(11),		-- Parámetro de auditoria ID de la Empresa
	Aud_Usuario				INT(11),		-- Parámetro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parámetro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parámetro de auditoria Direcciion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parámetro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parámetro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parámetro de auditoria Número de la transaccion
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(100); 	-- Control de Retorno en Pantalla
	DECLARE Var_MensajeError	VARCHAR(2000); 	-- Texto cortado a 2000 caracteres

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Constante Decimal Cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Salida_SI			CHAR(1);		-- Constante Salida SI

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Salida_SI			:= 'S';

	-- Bloque de Manejo de Errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := '999';
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-BITACORAERRORNOTICAPLDALT');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		-- Se validan parametros nulos
		SET Par_OpeInusualID	:= IFNULL(Par_OpeInusualID , Entero_Cero);
		SET Par_NumeroError		:= IFNULL(Par_NumeroError , Entero_Cero);
		SET Par_MensajeError	:= IFNULL(Par_MensajeError , Cadena_Vacia);
		SET Aud_EmpresaID		:= IFNULL(Aud_EmpresaID, Entero_Cero);
		SET Aud_Usuario			:= IFNULL(Aud_Usuario, Entero_Cero);
		SET Aud_FechaActual		:= NOW();
		SET Aud_DireccionIP		:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
		SET Aud_ProgramaID		:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
		SET Aud_Sucursal		:= IFNULL(Aud_Sucursal, Entero_Cero);
		SET Aud_NumTransaccion	:= IFNULL(Aud_NumTransaccion, Entero_Cero);

		SET Var_MensajeError	:= LEFT(Par_MensajeError, 2000);

		INSERT INTO BITACORAERRORNOTICAPLD (
			OpeInusualID,		NumeroError,			MensajeError,
			EmpresaID,			Usuario,				FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion)
		VALUES(
			Par_OpeInusualID,	Par_NumeroError,		Var_MensajeError,
			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Bitacora de Fallo Registrada Correctamente';

	END ManejoErrores;
	-- Fin Bloque de Manejo de Errores

	IF( Par_Salida = Salida_SI ) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen	AS ErrMen;
	END IF;

END TerminaStore$$