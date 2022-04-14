-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESROLALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESROLALT`;
DELIMITER $$

CREATE PROCEDURE `OPCIONESROLALT`(
/* ALTA DE LAS NUEVAS OPCIONES POR ROL*/
	Par_RolID			INT(11),		-- ID DEL ROL
	Par_OpcionMenuID	VARCHAR(50),	-- ID DE LA OPCION DE MENU
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
DECLARE Var_NoExiste	INT;
DECLARE	Cons_SI			CHAR(1);
DECLARE	Cons_NO			CHAR(1);

SET	Estatus_Activo	:= 'A';
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET Var_NoExiste	:= 0;
SET	Cons_SI			:= 'S';
SET	Cons_NO			:= 'N';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-OPCIONESROLALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(EXISTS (SELECT OpcionMenuID FROM OPCIONESROL
			WHERE RolID=Par_RolID AND OpcionMenuID= Par_OpcionMenuID)=Var_NoExiste) THEN

		INSERT INTO OPCIONESROL (
			RolID,				OpcionMenuID,		EmpresaID,		Usuario,			FechaActual,
			DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion)
		VALUES  (
			Par_RolID,			Par_OpcionMenuID,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

	END IF;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT("Opciones Agregadas al Rol: ",Par_RolID,".");
	SET Var_Control:= 'rolID';

END ManejoErrores;

IF (Par_Salida = Cons_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_RolID AS Consecutivo;
END IF;

END TerminaStore$$