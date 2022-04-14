-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALENDARIOINGRESOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALENDARIOINGRESOSBAJ`;
DELIMITER $$

CREATE PROCEDURE `CALENDARIOINGRESOSBAJ`(

	Par_InstitNominaID		INT(11),			-- Numero de Institucion Nomina
	Par_ConvenioNominaID    BIGINT UNSIGNED,	-- Numero de Convenio Nomina
	Par_Anio				INT(4),				-- Numero de Anio
	Par_Estatus				CHAR(1),			-- Estatus del Calendario de Ingresos

	Par_Salida          CHAR(1),				-- SALIDA
	INOUT Par_NumErr    INT(11),				-- NUMERO DE ERROR
	INOUT Par_ErrMen    VARCHAR(400),			-- MENSAJE DE ERROR

	-- PARAMETROS DE AUDITORIA
	Par_EmpresaID       int(11),
	Aud_Usuario         int(11),
	Aud_FechaActual     DateTime,
	Aud_DireccionIP     varchar(15),
	Aud_ProgramaID      varchar(50),
	Aud_Sucursal        int(11),
	Aud_NumTransaccion  bigint(20)
		)
TerminaStore: BEGIN
	DECLARE Var_Control			VARCHAR(100);

	DECLARE SalidaNO    CHAR(1);
	DECLARE SalidaSI    CHAR(1);
	DECLARE Entero_Cero	INT(1);

	SET SalidaNO        :='N';
	SET SalidaSI        := 'S';
	SET Entero_Cero		:= 0;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CALENDARIOINGRESOSBAJ');
			SET Var_Control	= 'SQLEXCEPTION';
		END;
		DELETE FROM CALENDARIOINGRESOS
			WHERE InstitNominaID = Par_InstitNominaID
				AND ConvenioNominaID = Par_ConvenioNominaID
				AND Anio = Par_Anio
				AND Estatus = Par_Estatus;

		SET Par_NumErr	:= 	Entero_Cero;
			SET Par_ErrMen	:= 'Calendario de Ingresos Eliminados Correctamente.';
			SET Var_Control	:= 'calendarioIngID';
	END ManejoErrores;
	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS Control;

	END IF;

END TerminaStore$$