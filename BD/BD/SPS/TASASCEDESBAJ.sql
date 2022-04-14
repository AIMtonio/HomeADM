-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASCEDESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASCEDESBAJ`;
DELIMITER $$


CREATE PROCEDURE `TASASCEDESBAJ`(
# ============================================================
# ----------- SP PARA DAR DE BAJA LAS TASAS CEDES-------------
# ============================================================
	Par_TasaCedeID		INT(11),
	Par_TipoCedeID		INT(11),
	Par_NumBaj			INT(11),

	Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(400);
	DECLARE Var_Consecutivo			INT(11);
    DECLARE Var_EstatusTipoCede		CHAR(2);					-- Estatus del Tipo Cede
	DECLARE Var_Descripcion			VARCHAR(200);				-- Descripcion Tipo Cede


	-- Declaracion de constantes
	DECLARE TipoBajaTasa			INT(11);
	DECLARE TipoBajaMontoPlazo		INT(11);
	DECLARE Salida_SI				CHAR(1);
    DECLARE Estatus_Inactivo		CHAR(1);					-- Estatus Inactivo


	-- Asignacion de constantes
	SET TipoBajaTasa				:=1;
	SET TipoBajaMontoPlazo			:=2;
    SET Salida_SI					:= 'S';
    SET Estatus_Inactivo			:= 'I';


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-TASASCEDESBAJ');
				SET Var_Control = 'SQLEXCEPTION' ;
			END;
		SELECT 	Estatus,				Descripcion
		INTO 	Var_EstatusTipoCede,	Var_Descripcion
		FROM TIPOSCEDES
        WHERE TipoCedeID = Par_TipoCedeID;


		IF(Var_EstatusTipoCede = Estatus_Inactivo) THEN
			SET Par_NumErr	:=	001;
			SET Par_ErrMen	:=	CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control	:=	'tipoCedeID';
            LEAVE ManejoErrores;
		END IF;

		IF (Par_NumBaj = TipoBajaTasa)THEN

			DELETE FROM TASASCEDES	WHERE TasaCedeID = Par_TasaCedeID;
			DELETE FROM TASACEDESUCURSALES	WHERE TasaCedeID = Par_TasaCedeID ;

		END IF;

		IF (TipoBajaMontoPlazo =Par_NumBaj) THEN

			DELETE FROM TASASCEDES	WHERE TipoCedeID = Par_TipoCedeID ;
			DELETE FROM TASACEDESUCURSALES	WHERE TipoCedeID = Par_TipoCedeID ;

		END IF;

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('La Tasa se ha Eliminado Exitosamente: ',CONVERT(Par_TasaCedeID,CHAR));
        SET Var_Control 	:= 'tasaCedeID';
		SET Var_Consecutivo	:= 0;


	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$