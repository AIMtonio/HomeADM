-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRECADREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIRCULOCRECADREALT`;DELIMITER $$

CREATE PROCEDURE `CIRCULOCRECADREALT`(
/* SP DE ALTA DE LA CADENA DE RESPUESTA DE LA CONSULTA DE CIRCULO DE CREDITO */
    Par_SolicitudID         INT(11),
	Par_CadenaEnviada	    LONGBLOB,
	/* Parametros de Salida */
    Par_Salida				CHAR(1),
    INOUT	Par_NumErr		INT(11),
    INOUT	Par_ErrMen		VARCHAR(400)
)
TerminaStore: BEGIN
/*DECLARACION DE VARIABLES*/
DECLARE varControl		VARCHAR(50);

/*DECLARACION DE CONSTANTES*/
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Fecha_Alta		DATE;
DECLARE	Salida_SI       CHAR(1);
DECLARE	Var_NO			CHAR(1);

/*ASIGNACION DE CONSTANTES*/
SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';
SET Entero_Cero			:= 0;
SET Salida_SI			:='S';
SET Var_NO				:='N';

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CIRCULOCRECADREALT');
			SET varControl:= 'sqlException';
		END;

INSERT INTO CIRCULOCRECADRE(
	fk_SolicitudID,		CadenaEnviada)
VALUES(
	Par_SolicitudID,	Par_CadenaEnviada);

SET Par_NumErr  := 000;
SET Par_ErrMen  := CONCAT('La Cadena de Respuesta se ha Guardado Correctamente: ',Par_SolicitudID);
SET varControl	:= 'fk_SolicitudID';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Entero_Cero	 AS consecutivo;
END IF;

END TerminaStore$$