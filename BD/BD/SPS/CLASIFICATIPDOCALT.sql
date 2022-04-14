-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICATIPDOCALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLASIFICATIPDOCALT`;
DELIMITER $$

CREATE PROCEDURE `CLASIFICATIPDOCALT`(
/* ALTA DE TIPOS DE DOCUMENTOS EN SOLICITUD DE CRÉDITO.*/
	Par_ClasTipDocID		INT(11),
	Par_ClasificaDesc		VARCHAR(50),
	Par_ClasificaTipo		CHAR(1),
	Par_TipoGrupInd			CHAR(1),
	Par_GrupoAplica			INT(11),

	Par_EsGarantia			CHAR(1),
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen  		VARCHAR(400),
	/* Paraámetros de Auditoría.*/
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11) ,

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

# DECLARACIÓN DE VARIABLES.
DECLARE Var_ClasTipDocID		INT(11);
DECLARE Var_Control				CHAR(20);
DECLARE Var_ClasifIDLim			INT(11);
DECLARE var_DocMesaControl		INT(11);

# DECLARACIÓN DE CONSTANTES.
DECLARE Entero_Cero				INT;
DECLARE Cadena_Vacia			CHAR(1);
DECLARE SalidaSI				CHAR(1);
DECLARE SalidaNO				CHAR(1);

# ASIGNACIÓN DE CONSTANTES.
SET Entero_Cero			:= 0;
SET Cadena_Vacia		:= '';
SET SalidaSI			:= 'S';
SET SalidaNO			:= 'N';
SET Var_ClasifIDLim		:= 9990;	-- LÍMITE DE DOCUMENTOS.
SET var_DocMesaControl	:= 9998;
SET Var_Control			:='clasificaTipDocID' ;
SET Var_ClasTipDocID	:=Entero_Cero;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CLASIFICATIPDOCALT');
			SET Var_Control:= 'excepcionSql' ;
		END;

	IF(IFNULL(Par_ClasificaDesc,Cadena_Vacia)=Cadena_Vacia)THEN
		SET Par_NumErr		:= '001';
		SET Par_ErrMen		:= CONCAT('El Tipo de Documento esta Vacio');
		SET Var_Control		:= 'clasificaTipDocID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(EXISTS(SELECT ClasificaTipDocID FROM CLASIFICATIPDOC WHERE clasificaTipDocID = Par_ClasTipDocID)) THEN
		SET Par_NumErr		:= '002';
		SET Par_ErrMen  	:= CONCAT('El Tipo de Documento ya Existe');
		SET Var_Control		:= 'clasificaTipDocID' ;
		LEAVE ManejoErrores;

	END IF;

	IF(EXISTS(SELECT ClasificaDesc FROM CLASIFICATIPDOC WHERE ClasificaDesc = Par_ClasificaDesc)) THEN
		SET Par_NumErr		:='003';
		SET Par_ErrMen		:= CONCAT('La Descripcion del Tipo de Documento ya Existe');
		SET Var_Control		:='clasificaTipDocID' ;
		LEAVE ManejoErrores;
	END IF;

	# SE OBTIENE EL MÁXIMO EXCEPTO LOS QUE FUERON AGREGANDOS POR 999_
	SET Var_ClasTipDocID	:= (SELECT IFNULL(MAX(ClasificaTipDocID),Entero_Cero) FROM CLASIFICATIPDOC WHERE ClasificaTipDocID < Var_ClasifIDLim);
	SET Var_ClasTipDocID	:= IFNULL(Var_ClasTipDocID, Entero_Cero)+ 1;
	SET Aud_FechaActual		:= NOW();

	INSERT INTO CLASIFICATIPDOC(
		ClasificaTipDocID,	ClasificaDesc,		ClasificaTipo,		TipoGrupInd,		GrupoAplica,
		EsGarantia,			EmpresaID,			Usuario,			FechaActual,		DireccionIP,
		ProgramaID,			Sucursal,			NumTransaccion)
	VALUES(
		Var_ClasTipDocID,	Par_ClasificaDesc,	Par_ClasificaTipo,	Par_TipoGrupInd,	Par_GrupoAplica,
		Par_EsGarantia,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT("Tipo de Documento ",CONVERT(Var_ClasTipDocID, CHAR)," Agregado Correctamente");
	SET Var_Control:='clasificaTipDocID' ;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_ClasTipDocID AS consecutivo;
	END IF;

END TerminaStore$$