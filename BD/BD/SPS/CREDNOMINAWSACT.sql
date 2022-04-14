-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDNOMINAWSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDNOMINAWSACT`;
DELIMITER $$

CREATE PROCEDURE `CREDNOMINAWSACT`(
	-- Store Procedure Exclusivo de WS para actualizar el Estatus de Instalacion de los Creditos de Nomina
	Par_CreditoID			BIGINT(11),		-- Indica el CréditoID
    Par_EstatusAfiliacion   CHAR(1),        -- Indica el Estatus de Instalacion I=Instalado
    Par_FolioInstalacion    VARCHAR(25),    -- Indica el Folio de la Instalacion

	Par_Salida				CHAR(1),		-- Paramentro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Control				VARCHAR(15);	    -- Control a retornar en pantalla
    DECLARE Var_CreditoID	        BIGINT(12);         -- ID de Credito de Nomina
    DECLARE Var_Nomina	         	INT(11);            -- Insitutcion de Nomina ligada al Credito


	-- Declaracion de Constantes,
	DECLARE	Entero_Cero				INT(11);			-- Constante de entero cero
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante cadena vacia
	DECLARE	SalidaSI				CHAR(1);			-- Salida Si
	DECLARE Con_Vigente             CHAR(1);            -- Estatus Vigente 'V'
    DECLARE Con_Vencido             CHAR(1);            -- Estatus Vencido 'B'
    DECLARE Con_Instalado           CHAR(1);            -- Estatus Instalado 'I'
    DECLARE Con_NoInstalado         CHAR(1);            -- Estatus No Instalado 'N'

	-- Asignacion de Constantes
	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:='';
	SET SalidaSI					:= 'S';
    SET Con_Vigente					:= 'V';
	SET Con_Vencido					:= 'B';
	SET Con_Instalado				:= 'I';
	SET Con_NoInstalado				:= 'N';


	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									 'esto le ocasiona. Ref: SP-CREDNOMINAWSACT');
			SET Var_Control = 'sqlException';
		END;

		IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El CreditoID esta Vacio.';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        SET Var_CreditoID := (SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
        SET Var_CreditoID := IFNULL(Var_CreditoID, Entero_Cero);

		IF(Var_CreditoID = Entero_Cero) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Credito No Existe';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_EstatusAfiliacion, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 003;
            SET Par_ErrMen  := 'El Estatus de Instalacion esta Vacio';
            SET Var_Control := Cadena_Vacia;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_EstatusAfiliacion, Cadena_Vacia)) <> Con_Instalado THEN
            SET Par_NumErr  := 004;
            SET Par_ErrMen  := 'El Estatus de Instalacion no Existe';
            SET Var_Control := Cadena_Vacia;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_FolioInstalacion, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 005;
            SET Par_ErrMen  := 'El Folio de Instalacion esta Vacio';
            SET Var_Control := Cadena_Vacia;
            LEAVE ManejoErrores;
        END IF;

        SET Var_Nomina := (SELECT InstitucionNominaID FROM SOLICITUDCREDITO WHERE CreditoID = Par_CreditoID);
        SET Var_Nomina := IFNULL(Var_Nomina, Entero_Cero);

        IF(Var_Nomina = Entero_Cero) THEN
			SET Par_NumErr  := 006;
			SET Par_ErrMen  := 'El Credito No Es de Nomina';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        UPDATE CREDITOS SET
        	EstatusInstalacion 	= Par_EstatusAfiliacion,
        	FolioInstalacion 	= Par_FolioInstalacion,
    		EmpresaID 			= Par_EmpresaID,
			Usuario 			= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID 			= Aud_ProgramaID,
			Sucursal 			= Aud_Sucursal,
			NumTransaccion 		= Aud_NumTransaccion
		WHERE CreditoID = Par_CreditoID;

        SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := CONCAT('Actualizacion al Credito ',Par_CreditoID,' realizada con Exito');
		SET Var_Control := Cadena_Vacia;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$