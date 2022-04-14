-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLBUROCREDITOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLBUROCREDITOACT`;
DELIMITER $$

CREATE PROCEDURE `SOLBUROCREDITOACT`(
	/*SP de Actualizacion del folio de consulta*/
	Par_RFC				VARCHAR(13),			# RFC del cliente al que se le hizo la consulta
	Par_FolioConsul		VARCHAR(30),			# Numero de folio retornado por la consulta de buro de credito
	Par_NumTransacc		BIGINT,					# Numero de transaccion con el que se dio de alta la solicitud
	Par_SolicitudCre	BIGINT(20),				# NUmero de solicitud de credito
	Par_Tipo			TINYINT UNSIGNED,		# Numero de consulta 1: Buro 2: Circulo

    Par_Salida			CHAR(1),				# Salida S:Si N:No
	INOUT Par_NumErr	INT(11),				# Numero de error
	INOUT Par_ErrMen	VARCHAR(400),			# Mensaje de error

	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),				# Auditoria
	Aud_Usuario			INT(11),				# Auditoria
	Aud_FechaActual		DATETIME,				# Auditoria
	Aud_DireccionIP		VARCHAR(15),			# Auditoria
	Aud_ProgramaID		VARCHAR(50),			# Auditoria
	Aud_Sucursal		INT(11),				# Auditoria
	Aud_NumTransaccion	BIGINT(20)				# Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
    DECLARE Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE Entero_Cero			INT(11);			-- Entero Cero
	DECLARE SalidaSI			CHAR(1);			-- Salida SI
	DECLARE SalidaNO			CHAR(1);			-- Salida No
	DECLARE TipoBC				INT(11);			-- Actualizacion para buro de credito
	DECLARE TipoCC				INT(11);			-- Actualizacion para circulo de credito
	DECLARE TipoBCErr			INT(11);			-- Actualizacion para buro con error
    DECLARE TipoCCErr			INT(11);			-- Actualizacion para circulo con error
	DECLARE Act_FolioBC			INT(11);			-- Actualizacion para BC en solicitud de credito
	DECLARE Act_FolioCC			INT(11);			-- Actualizacion para BC en solicitud de credito
	DECLARE Decimal_Cero		DECIMAL(14,2);
	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(100);		-- Variable de control
	DECLARE Var_Consecutivo		VARCHAR(20);		-- Variable consecutivo
    DECLARE Var_FolioBC			VARCHAR(30);
	DECLARE Var_FolioBCC		VARCHAR(30);

	-- Asignacion de constantes
	SET	Entero_Cero		:= 0;
	SET SalidaSI		:='S';
	SET SalidaNO		:='N';
	SET TipoBC			:= 1;
	SET TipoCC			:= 2;
    SET TipoBCErr		:= 3;
    SET TipoCCErr		:= 4;
    SET	Act_FolioBC 	:= 11;
    SET Act_FolioCC		:= 12;
    SET Decimal_Cero	:= 0.0;
	SET Aud_FechaActual := NOW();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SOLBUROCREDITOACT');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		/* Actualizacion 1: Actualizacion de folio Buro de credito*/
		IF (Par_Tipo =TipoBC ) THEN

			UPDATE SOLBUROCREDITO SET
				FolioConsulta 		= Par_FolioConsul,
				EmpresaID 			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal
			WHERE
				RFC 				= Par_RFC
				AND NumTransaccion	= Par_NumTransacc;

            -- se obtiene folio de consulta de Buro de credito
            SELECT FOL_BUR INTO Var_FolioBC
				FROM bur_fol Bur
			WHERE Bur.BUR_SOLNUM = Par_FolioConsul;

            -- Llamada para actualizacion de folio en solicitud de credito
             CALL SOLICITUDCREDITOACT(
				Par_SolicitudCre,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,
                Decimal_Cero,			Act_FolioBC,		Entero_Cero,		Entero_Cero,		Cadena_Vacia,
                Decimal_Cero,			Var_FolioBC,		Decimal_Cero,		SalidaNO,			Par_NumErr,
                Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr<>Entero_Cero)THEN
				LEAVE ManejoErrores;
            END IF;

			SET Par_NumErr		:= 000;
			SET Par_ErrMen		:= CONCAT('Solicitud Actualizada Con Folio: ',Par_FolioConsul,'.');
			SET Var_Consecutivo	:= Par_FolioConsul;
			SET Var_Control		:= 'folioConsulta';

		END IF;

        -- Error en consulta Buro
        IF (Par_Tipo =TipoBCErr ) THEN

			UPDATE SOLBUROCREDITO SET
				FolioConsulta 		= Par_FolioConsul,
				EmpresaID 			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal
			WHERE
				RFC 				= Par_RFC
				AND NumTransaccion	= Par_NumTransacc;

			SET Par_NumErr		:= 000;
			SET Par_ErrMen		:= CONCAT('Solicitud Actualizada Con Folio: ',Par_FolioConsul,'.');
			SET Var_Consecutivo	:= Par_FolioConsul;
			SET Var_Control		:= 'folioConsulta';

		END IF;

		/*Actualizacion 2: Actualizacion del folio de la consulta de circulo de credito.*/
		IF (Par_Tipo= TipoCC) THEN
			UPDATE SOLBUROCREDITO SET
				FolioConsultaC 		= Par_FolioConsul,
				EmpresaID 			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal
			WHERE
				RFC 				= Par_RFC
				AND NumTransaccion	= Par_NumTransacc;

			-- se obtiene folio de consulta de circulo  de credito
            SELECT FolioConsulta INTO Var_FolioBCC
				FROM CIRCULOCRESOL Cir
			WHERE Cir.SolicitudID = Par_FolioConsul;

            -- Llamada para actualizacion de folio en solicitud de credito
             CALL SOLICITUDCREDITOACT(
				Par_SolicitudCre,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,
                Decimal_Cero,			Act_FolioCC,		Entero_Cero,		Entero_Cero,		Cadena_Vacia,
                Decimal_Cero,			Var_FolioBCC,		Decimal_Cero,		SalidaNO,			Par_NumErr,
                Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr<>Entero_Cero)THEN
				LEAVE ManejoErrores;
            END IF;

			SET Par_NumErr		:= 000;
			SET Par_ErrMen		:= CONCAT('Solicitud Actualizada Con Folio: ',Par_FolioConsul,'.');
			SET Var_Consecutivo	:= Par_FolioConsul;
			SET Var_Control		:= 'folioConsulta';
		END IF;


        /*Actualizacion 3: Actualizacion del folio de la consulta de circulo de credito, COn mensaje de error*/
		IF (Par_Tipo = TipoCCErr) THEN
			UPDATE SOLBUROCREDITO SET
				FolioConsultaC 		= Par_FolioConsul,
				EmpresaID 			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal
			WHERE
				RFC 				= Par_RFC
				AND NumTransaccion	= Par_NumTransacc;

			SET Par_NumErr		:= 000;
			SET Par_ErrMen		:= CONCAT('Solicitud Actualizada Con Folio: ',Par_FolioConsul,'.');
			SET Var_Consecutivo	:= Par_FolioConsul;
			SET Var_Control		:= 'folioConsulta';
		END IF;


	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$