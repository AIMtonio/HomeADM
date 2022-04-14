-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSTANCIARETCTEACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSTANCIARETCTEACT`;
DELIMITER $$


CREATE PROCEDURE `CONSTANCIARETCTEACT`(
	-- SP creado para actualizar informacion del timbrado de la Constancia de Retencion
    Par_AnioProceso 	INT(11), 			-- Anio de Proceso Constancia de Retencion
	Par_ClienteID 		INT(11),			-- Numero del cliente
	Par_Version			VARCHAR(10),		-- Numero de inversion
	Par_NoCertifSAT		VARCHAR(500),		-- Numero de certificado SAT
	Par_UUID			VARCHAR(150),		-- UUID del CFDI

    Par_FechaTimbrado	VARCHAR(50),		-- Fecha de Timbrado
	Par_SelloCFD		VARCHAR(1000),		-- Sello CFD del CFDI
	Par_SelloSAT		VARCHAR(1000),		-- Sello del SAT
	Par_CadenaOriginal	VARCHAR(1000),		-- Cadena Original
	Par_FechaCertifica	VARCHAR(45),		-- Fecha de Certificacion

    Par_NoCertEmisor	VARCHAR(80),		-- Numero Certificacion Emisor
	Par_SucursalCte		INT(11),			-- Sucursal del cliente
	Par_NumAct			INT(11),			-- Tipo modificacion
	Par_Estatus			INT(11),			-- Estatus del timbrado: 2 = Exitoso 3 = Erroneo

	Par_Salida			CHAR(1),        	-- Indica si espera un SELECT de salida
	INOUT Par_NumErr    INT(11),			-- Numero de Error
	INOUT Par_ErrMen    VARCHAR(400),  		-- Descripcion de Error

	Par_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria

)

TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Control			CHAR(20);
	DECLARE Var_Consecutivo     BIGINT(12);

	-- Declaracion de constantes
	DECLARE Entero_Cero		INT;
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Salida_SI		CHAR(1);
	DECLARE Salida_NO		CHAR(1);

	DECLARE Act_DatosCFDI	INT(11);
	DECLARE Act_Estatus 	INT(11);
	DECLARE Fecha_Vacia	    DATE;

	-- Asignacion de constantes
	SET Entero_Cero		:= 0;			 -- Entero cero
	SET Cadena_Vacia	:= '';			 -- Cadena vacia
	SET Salida_SI		:= 'S';			 -- Salida Store: SI
	SET Salida_NO		:= 'N';			 -- Salida Store: NO

	SET Act_DatosCFDI	:= 1;			 -- Actualiza datos CFDI
	SET Act_Estatus		:= 2;			 -- Actualiza de Estatus
	SET Fecha_Vacia     := '1900-01-01'; -- Fecha vacia

    ManejoErrores:BEGIN     #bloque para manejar los posibles errores
      DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
              SET Par_NumErr  = 999;
              SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                        'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSTANCIARETCTEACT');
              SET Var_Control = 'SQLEXCEPTION';
            END;

    -- Actualiza datos CFDI
	IF (Par_NumAct = Act_DatosCFDI)THEN
		SET Aud_FechaActual := (SELECT DATE_FORMAT(CURRENT_TIMESTAMP(), '%Y-%m-%d'));

			UPDATE CONSTANCIARETCTE
			SET
				CFDIVersion			= Par_Version,
				CFDINoCertSAT 		= Par_NoCertifSAT,
				CFDIUUID 			= Par_UUID,
				CFDIFechaTimbrado 	= Par_FechaTimbrado,
				CFDISelloCFD 		= Par_SelloCFD,
				CFDISelloSAT 		= Par_SelloSAT,
				CFDICadenaOrig 		= Par_CadenaOriginal,
				CFDIFechaCertifica 	= Par_FechaCertifica,
				CFDINoCertEmisor 	= Par_NoCertEmisor,
				CFDIFechaEmision	= Aud_FechaActual,
				EmpresaID			= Par_EmpresaID,
				Usuario 			= Aud_Usuario,
				FechaActual 		= NOW(),
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID 			= Aud_ProgramaID,
				Sucursal 			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE ClienteID = Par_ClienteID
				AND Anio = Par_AnioProceso;

			SET Par_NumErr    	:= Entero_Cero;
			SET Par_ErrMen      := 'Datos CFDI Actualizado Exitosamente.';
	END IF;

	-- Actualiza estatus del Timbrado
	IF (Par_NumAct = Act_Estatus)THEN

		UPDATE CONSTANCIARETCTE
		SET
			Estatus			= Par_Estatus,
            EmpresaID		= Par_EmpresaID,
			Usuario 		= Aud_Usuario,
			FechaActual 	= NOW(),
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID 		= Aud_ProgramaID,
			Sucursal 		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE ClienteID 	= Par_ClienteID
        AND Anio = Par_AnioProceso;

		SET Par_NumErr    	:= Entero_Cero;
		SET Par_ErrMen      := 'Estatus Actualizado Exitosamente.';

	END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Cadena_Vacia AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$