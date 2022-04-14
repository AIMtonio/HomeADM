-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESROLBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESROLBAJ`;
DELIMITER $$

CREATE PROCEDURE `OPCIONESROLBAJ`(
/* SP DE BAJA OPCIONES DE MENÚ POR ROL. */
	Par_RolID			INT(11),		-- ID DEL ROL
	Par_OpcionMenuID	VARCHAR(50),	-- ID DE LA OPCION DE MENU
	Par_TipoBaja		INT(11),		-- TIPO DE TRANSACCIÓN
	Par_Salida			CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr	INT(11),		-- Numero de Error

	INOUT Par_ErrMen	VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),

	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

DECLARE	Var_Control		VARCHAR(100);

DECLARE	Estatus_Activo	CHAR(1);
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE Baja_Principal	INT;
DECLARE	Cons_SI			CHAR(1);
DECLARE	Cons_NO			CHAR(1);

SET	Estatus_Activo	:= 'A';
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET Baja_Principal	:= 1;
SET	Cons_SI			:= 'S';
SET	Cons_NO			:= 'N';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-OPCIONESROLBAJ');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(Par_TipoBaja = Baja_Principal)THEN
		DELETE FROM OPCIONESROL
			WHERE RolID = Par_RolID;
	END IF;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT("Opciones Eliminadas del rol: ",Par_RolID);
	SET Var_Control:= 'OpcionMenuID';

END ManejoErrores;

IF (Par_Salida = Cons_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_RolID AS Consecutivo;
END IF;

END TerminaStore$$