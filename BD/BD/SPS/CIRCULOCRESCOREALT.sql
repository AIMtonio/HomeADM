-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRESCOREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIRCULOCRESCOREALT`;DELIMITER $$

CREATE PROCEDURE `CIRCULOCRESCOREALT`(

    Par_SolicitudID			VARCHAR(10),
    Par_NombreScore			VARCHAR(40),
	Par_Codigo				INT(11),
	Par_Valor				INT(11),
	Par_Razon1				VARCHAR(5),

	Par_Razon2				VARCHAR(5),
	Par_Razon3				VARCHAR(5),
	Par_Razon4				VARCHAR(5),
	Par_CodError			VARCHAR(5),
	Par_Salida				CHAR(1),

    INOUT	Par_NumErr		INT(11),
    INOUT	Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,

    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore: BEGIN


DECLARE Var_Control		VARCHAR(50);
DECLARE Var_Consecutivo	INT(11);


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Fecha_Alta		DATE;
DECLARE	Salida_SI       CHAR(1);


SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';
SET Entero_Cero			:= 0;
SET Salida_SI			:='S';
SET Var_Consecutivo		:= 0;

SET Aud_FechaActual 	:= NOW();

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CIRCULOCRESCOREALT');
		SET Var_Control	:= 'sqlException';
    END;

	SET Var_Consecutivo := (SELECT IFNULL(MAX(Consecutivo),Entero_Cero) + 1 FROM CIRCULOCRESCORE WHERE fk_SolicitudID = Par_SolicitudID);


	SELECT	EmpresaID,        	Usuario,			FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,        	NumTransaccion
     INTO	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion
		FROM SOLBUROCREDITO
			WHERE FolioConsultaC = Par_SolicitudID;

	INSERT INTO CIRCULOCRESCORE(
		fk_SolicitudID,		NombreScore,		Consecutivo,		Codigo, 			Valor,
        Razon1, 			Razon2, 			Razon3, 			Razon4, 			CodError,
        EmpresaID,        	Usuario,			FechaActual,		DireccionIP,		ProgramaID,
        Sucursal,        	NumTransaccion)
	VALUES (
		Par_SolicitudID,	Par_NombreScore,	Var_Consecutivo,	Par_Codigo, 		Par_Valor,
        Par_Razon1, 		Par_Razon2, 		Par_Razon3, 		Par_Razon4, 		Par_CodError,
        Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
        Aud_Sucursal,		Aud_NumTransaccion);

	SET Par_NumErr  := 000;
	SET Par_ErrMen  := CONCAT('Scores Guardados Correctamente para la Socilictud: ',CONVERT(Par_SolicitudID,CHAR(10)));
	SET Var_Control	:= 'fk_SolicitudID';

END ManejoErrores;

IF(Par_Salida = Salida_SI) THEN
	SELECT  Par_NumErr 	 AS NumErr,
			Par_ErrMen	 AS ErrMen,
			Var_Control	 AS Control,
			Entero_Cero	 AS Consecutivo;
END IF;

END TerminaStore$$