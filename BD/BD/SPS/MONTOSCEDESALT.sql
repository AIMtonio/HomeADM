-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOSCEDESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONTOSCEDESALT`;
DELIMITER $$


CREATE PROCEDURE `MONTOSCEDESALT`(
# ===========================================================
# ----------- SP PARA REGISTRAR LOS MONTOS DE CEDES----------
# ===========================================================
	Par_TipoCedeID			INT(11),
	Par_MontoInferior		DECIMAL(18,2),
	Par_MontoSuperior		DECIMAL(18,2),

	Par_Salida				CHAR(1),
    INOUT Par_NumErr		INT(11),
    INOUT Par_ErrMen		VARCHAR(400),

	Par_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

    -- Declaracion de variables
	DECLARE	Var_MontoID				INT(11);
	DECLARE Var_Control				VARCHAR(50);
	DECLARE Var_Consecutivo 		INT(11);
	DECLARE Var_EstatusTipoCede		CHAR(2);				-- Estatus del Tipo Cede
	DECLARE Var_Descripcion			VARCHAR(200);			-- Descripcion Tipo Cede


	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
    DECLARE SalidaSI		CHAR(1);
	DECLARE Estatus_Inactivo		CHAR(1);					-- Estatus Inactivo


    -- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
    SET SalidaSI			:= 'S';
	SET Var_MontoID			:= 0;
	SET Aud_FechaActual		:= NOW();
    SET Estatus_Inactivo    := 'I';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-MONTOSCEDESALT');
			END;

          SELECT	Estatus,				Descripcion
			INTO 	Var_EstatusTipoCede,	Var_Descripcion
			FROM 	TIPOSCEDES
			WHERE	TipoCedeID	= Par_TipoCedeID;

		IF (IFNULL(Par_TipoCedeID,Entero_Cero)) < Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Tipo de CEDES esta vacio.';
			SET Var_Control	:= 'plazoInferior';
			LEAVE ManejoErrores;
		END IF;


		IF (IFNULL(Par_MontoInferior,Entero_Cero)) < Entero_Cero THEN
			SET	Par_NumErr 	:= 2;
			SET	Par_ErrMen	:= 'El Monto Inferior esta vacio.';
			SET Var_Control	:= 'plazoInferior';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_MontoSuperior,Entero_Cero)) = Entero_Cero THEN
			SET	Par_NumErr 	:= 3;
			SET	Par_ErrMen	:= 'El Monto Superior esta vacio.';
			SET Var_Control	:= 'plazoSuperior';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusTipoCede = Estatus_Inactivo) THEN
			SET Par_NumErr	:=	004;
			SET Par_ErrMen	:=	CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control	:=	'tipoCedeID';
			LEAVE ManejoErrores;
		END IF;

		INSERT MONTOSCEDES VALUES (
			Par_TipoCedeID, Par_MontoInferior,		Par_MontoSuperior,	Par_Empresa	,	Aud_Usuario,
			Aud_FechaActual,Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET Par_NumErr		:= 000;
        SET Par_ErrMen		:= "Rangos de Montos Agregados Exitosamente";
		SET Var_Control		:= 'tipoCedeID';
		SET Var_Consecutivo	:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$