-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPODOCUMENTOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPODOCUMENTOSALT`;DELIMITER $$

CREATE PROCEDURE `GRUPODOCUMENTOSALT`(
	Par_Descripcion			VARCHAR(100),
	Par_RequeridoEn			VARCHAR(50),
	Par_TipoPersona			VARCHAR(10),

	Par_EmpresaID			INT(11),
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore:BEGIN

-- Declaracion de Constantes
DECLARE Entero_Cero			INT(11);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE SalidaSI			CHAR(1);
DECLARE Consecutivo			INT(11);
DECLARE Var_Consecutivo		INT(11);
DECLARE Var_Control			VARCHAR(100);

-- Asignacion de Constantes
SET Entero_Cero				:= 0; 		-- Constante Entero Cero
SET Cadena_Vacia			:= '';		-- Constante Cadena Vacia
SET SalidaSI				:= 'S';		-- Contantes Salida SI

-- Asignacion de Variables
SET Consecutivo				:= (SELECT MAX(GrupoDocumentoID) FROM GRUPODOCUMENTOS);
SET Consecutivo 			:= Consecutivo + 1;

ManejoErrores:BEGIN

  -- *************** Agregar llaves foraneas a tabla  **************************

DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
        						'Disculpe las molestias que esto le ocasiona. Ref: SP-GRUPODOCUMENTOSALT');
	SET Var_Control := 'SQLEXCEPTION';
    END;


IF(Par_Descripcion = Cadena_Vacia)THEN
		SET	Par_NumErr 	:= 1;
		SET	Par_ErrMen	:= 'La Descripcion esta vacia';
		SET Var_Consecutivo:=Entero_cero;
		SET Var_Control:='descripcion';
		LEAVE ManejoErrores;
END IF;

IF Par_RequeridoEn	=Cadena_Vacia THEN
		SET	Par_NumErr 	:= 2;
		SET	Par_ErrMen	:= 'El Campo Requerido En esta Vacio';
		SET Var_Consecutivo:=Entero_cero;
		SET Var_Control:='requeridoEn';
		LEAVE ManejoErrores;

END IF;
IF Par_TipoPersona=Cadena_Vacia THEN
		SET	Par_NumErr 	:= 3;
		SET	Par_ErrMen	:= 'Seleccione Tipo de Persona';
		SET Var_Consecutivo:=Entero_cero;
		SET Var_Control:='tipoPersona';
		LEAVE ManejoErrores;
END IF;

SET Aud_FechaActual:=NOW();

	INSERT INTO GRUPODOCUMENTOS (
		GrupoDocumentoID,	Descripcion,		RequeridoEn,		TipoPersona,		EmpresaID,
		Usuario,		  	FechaActual,		DireccionIP,		ProgramaID, 		Sucursal,
		NumTransaccion)
	VALUES(
		Consecutivo,		Par_Descripcion,	Par_RequeridoEn,	Par_TipoPersona,	Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	SET	Par_NumErr 	:= 0;
	SET	Par_ErrMen	:= CONCAT('Grupo de Documento Guardado Exitosamente: ',Consecutivo);
	SET Var_Consecutivo:=Consecutivo;
	SET Var_Control:='grupoDocumentoID';

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
END IF;


END  TerminaStore$$