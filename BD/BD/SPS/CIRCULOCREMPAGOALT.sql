-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCREMPAGOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIRCULOCREMPAGOALT`;

DELIMITER $$
CREATE PROCEDURE `CIRCULOCREMPAGOALT`(
    Par_SolicitudID         VARCHAR(10),
	Par_Consecutivo	    	INT(11),
	Par_NumPagVencidos		INT(11),
	Par_HistoricoPagos		VARCHAR(800),
	Par_FechaRecHisPag		DATE,

	Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400)
)
TerminaStore: BEGIN

	/*DECLARACION DE VARIABLES*/
	DECLARE varControl		VARCHAR(50);
	DECLARE varConsecutivo	INT(11);

	/*DECLARACION DE CONSTANTES*/
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	Fecha_Alta		DATE;
	DECLARE	Salida_SI       CHAR(1);
	DECLARE	Var_NO			CHAR(1);

	/*ASIGNACION DE CONSTANTES*/
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Salida_SI			:='S';
	SET Var_NO				:='N';
	SET varConsecutivo		:= 0;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CIRCULOCREMPAGOALT');
			SET varControl	:= 'sqlException';
		END;

		/* asignacion de variables */
		SET varConsecutivo := (SELECT IFNULL(MAX(Consecutivo),Entero_Cero) + 1 FROM CIRCULOCREMPAGO WHERE fk_SolicitudID = Par_SolicitudID);
		SET Par_HistoricoPagos := LEFT(Par_HistoricoPagos,168);

		INSERT INTO CIRCULOCREMPAGO(
				fk_SolicitudID,		Consecutivo,		NumPagVencidos, 		HistoricoPagos,		FechaRecHisPag)
		VALUES (
				Par_SolicitudID,	varConsecutivo,		Par_NumPagVencidos,		Par_HistoricoPagos,	Par_FechaRecHisPag);

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('La Cadena de modo de pago se ha insertado correctamente: ',Par_SolicitudID);
		SET varControl	:= 'fk_SolicitudID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen	 AS ErrMen,
				varControl	 AS control,
				Entero_Cero	 AS consecutivo;
	END IF;

END TerminaStore$$