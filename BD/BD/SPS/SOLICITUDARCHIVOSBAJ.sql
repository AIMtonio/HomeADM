-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDARCHIVOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDARCHIVOSBAJ`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDARCHIVOSBAJ`(
/* SP QUE DA DE BAJA UN ARCHIVO DE SOLICITUD */
	Par_SolicitudCreditoID           BIGINT(20),
	Par_TipoDocumentoID     INT(11),
	Par_DigSolCreditoID        INT(11),
	Par_TipoBaja            INT(11),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
		)
TerminaStore: BEGIN

	/*  Declaracion de Variables  */
	DECLARE Var_EstatusSol 		CHAR(1);
    DECLARE VarControl     		CHAR(20);

	/*  Declaracion de Constantes   */
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero         INT;
	DECLARE Str_SI              CHAR(1);
	DECLARE Str_NO              CHAR(1);
	DECLARE TipoSolCredFolio    INT(11);

	-- Asignacion de Valores a Constantes

	SET	Cadena_Vacia            := '';
	SET Fecha_Vacia             := '1900-01-01';
	SET Entero_Cero             := 0;
	SET Str_SI                  := 'S';
	SET Str_NO                  := 'N';
	SET TipoSolCredFolio        := 1;   -- baja por Folio(llave ID)

	/* Inicializar parametros de salida */
	SET	Par_NumErr              := 1;
	SET Par_ErrMen              := Cadena_Vacia;

    ManejoErrores: BEGIN
		 DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						 'esto le ocasiona. Ref: SP-SOLICITUDARCHIVOSBAJ');
				SET VarControl = 'sqlException' ;
			END;



	/* Baja Por Folio de Un determinado credito */
	IF Par_TipoBaja = TipoSolCredFolio THEN
		SET Var_EstatusSol := Cadena_Vacia;

		SET Var_EstatusSol := (SELECT Estatus FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID);

        IF IFNULL(Var_EstatusSol, Cadena_Vacia) =  Cadena_Vacia THEN
				SET Par_NumErr	:=01;
				SET Par_ErrMen	:='La Solicitud de Credito No Existe';
				SET Varcontrol	:='solicitudCreditoID';
				LEAVE ManejoErrores;
		END IF;


		DELETE FROM SOLICITUDARCHIVOS
			WHERE SolicitudCreditoID   = Par_SolicitudCreditoID
			  AND DigSolID   = Par_DigSolCreditoID;

		SET	Par_NumErr := 000;
		SET Par_ErrMen := 'El documento fue Eliminado Exitosamente';
		SET	VarControl := 'solicitudCreditoID';

	END IF;

    END ManejoErrores;

	IF(Par_Salida =Str_SI) THEN
		SELECT  Par_NumErr AS NumErr,
		Par_ErrMen  AS ErrMen,
		VarControl AS control,
		Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$