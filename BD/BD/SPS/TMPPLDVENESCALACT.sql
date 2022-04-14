-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDVENESCALACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPPLDVENESCALACT`;DELIMITER $$

CREATE PROCEDURE `TMPPLDVENESCALACT`(

	Par_FolioEscala		BIGINT(11),
	Par_TipoResultEscID	CHAR(1),
	Par_Salida			CHAR(1),
	INOUT Par_NumErr   	INT,
    INOUT Par_ErrMen   	VARCHAR(400),

	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
		)
TerminaStore: BEGIN

    DECLARE Var_FolioEscala		BIGINT(11);
    DECLARE Var_Control			VARCHAR(20);
    DECLARE Var_Consecutivo		VARCHAR(100);


    DECLARE	Cadena_Vacia		CHAR(1);
    DECLARE Decimal_Cero		DECIMAL(12,2);
    DECLARE Entero_Uno			INT;
    DECLARE Entero_Cero			INT;
    DECLARE Fecha_Vacia			DATE;
    DECLARE Salida_SI			CHAR(1);
    DECLARE Est_Rechazado		CHAR(1);
    DECLARE Est_Autorizado		CHAR(1);
    DECLARE Est_Finalizado		CHAR(1);


    SET Cadena_Vacia		:= '';
    SET Decimal_Cero		:= 0.0;
    SET Entero_Cero			:= 0;
    SET Entero_Uno			:= 1;
    SET Salida_SI			:= 'S';
    SET Fecha_Vacia			:= '1900-01-01';
    SET Est_Rechazado		:= 'R';
    SET Est_Autorizado		:= 'A';
    SET Est_Finalizado		:= 'F';


    SET Var_FolioEscala		:= Entero_Cero;

    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-TMPPLDVENESCALACT');
		END;

        SET Par_FolioEscala		:=	IFNULL(Par_FolioEscala,	Entero_Cero);
		SET Par_TipoResultEscID	:=	IFNULL(Par_TipoResultEscID, Cadena_Vacia);
        SET Aud_FechaActual		:= NOW();

        IF(Par_FolioEscala 	= Entero_Cero) THEN
			SET Par_NumErr	:= 001;
            SET Par_ErrMen	:= 'El Folio esta Vacio';
			SET Var_Control := 'folioID';
            SET Var_Consecutivo	:= Par_FolioEscala;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoResultEscID = Cadena_Vacia) THEN
			SET Par_NumErr	:= 002;
            SET Par_ErrMen	:= 'El Estatus de la Operacion Esta Vacio.';
			SET Var_Control := 'fecha';
			LEAVE ManejoErrores;
        END IF;

        SET Aud_FechaActual := NOW();

		UPDATE TMPPLDVENESCALA SET
			TipoResultEscID = Par_TipoResultEscID,
            EmpresaID		= Aud_EmpresaID,
            Usuario			= Aud_Usuario,
            FechaActual		= Aud_FechaActual,
            DireccionIP		= Aud_DireccionIP,
            ProgramaID		= Aud_ProgramaID,
            Sucursal		= Aud_Sucursal,
            NumTransaccion	= Aud_NumTransaccion
			WHERE
				FolioEscala = Par_FolioEscala;
		SET Par_NumErr		:= 000;
        IF(Par_TipoResultEscID = Est_Rechazado) THEN
			SET	Par_NumErr	:= 503;
			SET	Par_ErrMen	:= CONCAT("La Solicitud de Escalamiento ha Sido Rechazada, Favor de Verificar con el Personal Autorizado de Escalamiento Interno. Folio de la Solicitud: ", Par_FolioEscala,".");
		 ELSEIF(Par_TipoResultEscID = Est_Autorizado) THEN
			SET	Par_NumErr	:= 502;
			SET	Par_ErrMen	:=CONCAT("La Solicitud de Escalamiento ha Sido Autorizada Exitosamente. Folio de la Solicitud: ", Par_FolioEscala,".");
            ELSEIF(Par_TipoResultEscID = Est_Finalizado) THEN
				SET	Par_NumErr	:= 0;
				SET	Par_ErrMen	:=CONCAT("La Solicitud de Escalamiento Ha Finalizado Exitosamente. Folio de la Solicitud: ", Par_FolioEscala,".");

		END IF;
		SET Var_Control		:= 'FolioEscalaID' ;
		SET Var_Consecutivo	:= Par_FolioEscala;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;
END TerminaStore$$