DELIMITER ;
DROP PROCEDURE IF EXISTS `DETAFILIABAJACTADOMALT`;
DELIMITER $$
CREATE PROCEDURE `DETAFILIABAJACTADOMALT`(
-- SP para dar de alta a los clientes que se vana a afiliar para la domiciliacion
	Par_FolioAfiliacion		BIGINT (20),		-- Folio de afiliacion
	Par_Referencia			VARCHAR(50),		-- Referencia para el cliente
	Par_ClienteID			INT(11),			-- identificador del cliente
	Par_NombreCompleto		VARCHAR(150),		-- Nombre completo del cliente
	Par_EsNomina			CHAR(1),			-- Indica si el cliente es de nomina

    Par_InstitNominaID		INT(11),			-- Identificador de la institucion de nomina
	Par_NombreEmpNomina		VARCHAR(150),		-- Nombre de la empresa de nomina
	Par_InstitBancaria		INT(11),			-- Identificador de la instiucion bancaria
	Par_NombreBanco			VARCHAR(150),		-- Nombre de la institucion bancaria
	Par_Clabe				VARCHAR(20),		-- clabe de referencia del  banco del cliente

    Par_Convenio			VARCHAR(50),		-- Convenio de la empresa de nomina con la financiera
	Par_Comentario			VARCHAR(150),		-- Comentarios
	Par_EstatusDomicilia	CHAR(1),			-- Estatus de domiciliacion del cliente

	Par_Salida				CHAR(1),			-- Parametro de salida
    INOUT Par_NumErr		INT(11),			-- Numero de error
    INOUT Par_ErrMen		VARCHAR(250),		-- Mensaje  de error

    Par_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
    Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de variables
    DECLARE Var_Control 		VARCHAR(50);	-- Varialbe de control

    -- Declaracion de constantes
    DECLARE Con_SalidaSI	CHAR(1);	-- Constante de salida SI
    DECLARE Cadena_Vacia	CHAR(1);	-- Constante de Cadena vacia
    DECLARE Entero_Cero		INT(11);	-- Constante entero cero
    DECLARE EsNominaSI		CHAR(1);	-- Indica afirmacion para empresa de nomina
    DECLARE Est_Procesado	CHAR(1);	-- Estatus Procesado
    DECLARE Est_Activo		CHAR(1);	-- Estatus Activo

    -- seteo de valores
    SET Con_SalidaSI	:= 'S';
    SET Cadena_Vacia	:= '';
    SET Entero_Cero		:= 0;
    SET EsNominaSI		:= 'S';
    SET Est_Procesado	:= 'P';
    SET Est_Activo		:= 'A';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-DETAFILIABAJACTADOMALT');
			SET Var_Control := 'sqlexception';
		END;


 		IF IFNULL(Par_FolioAfiliacion,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 1;
            SET Par_ErrMen := 'El folio de Afiliacion no debe estar vacio.';
            SET Var_Control := 'FolioAfiliacion';
            LEAVE ManejoErrores;
        END IF;

        IF IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Cliente no debe estar vacio';
            SET Var_Control := 'clienteID';
            LEAVE ManejoErrores;
        END IF;

        IF IFNULL(Par_InstitNominaID,Entero_cero) = Entero_Cero AND Par_EsNomina = EsNominaSI THEN
			SET Par_NumErr := 3;
            SET Par_ErrMen := 'La Empresa de nomina no debe estar vacio';
            SET Var_Control := 'institNominaID';
            LEAVE ManejoErrores;
        END IF;

        IF IFNULL(Par_InstitBancaria,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 4;
            SET Par_ErrMen := 'La institucion Bancaria no debe estar vacio';
            SET Var_Control := 'clienteID';
            LEAVE MAnejoErrores;
        END IF;

        IF Par_InstitNominaID = Entero_Cero THEN
			SET Par_NombreEmpNomina :=Cadena_Vacia;
		END IF;

        INSERT INTO `DETAFILIABAJACTADOM`(
				FolioAfiliacion,	Referencia,			ClienteID,			NombreCompleto,		EsNomina,
                InstitNominaID,		NombreEmpNomina,	InstitBancaria,		NombreBanco,		Clabe,
                Convenio,			Comentario,			EstatusDomicilia,	EmpresaID,			Usuario,
                FechaActual,		DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion
        )
        VALUES(
				Par_FolioAfiliacion,	Par_Referencia,			Par_ClienteID,			Par_NombreCompleto,		Par_EsNomina,
                Par_InstitNominaID,		Par_NombreEmpNomina,	Par_InstitBancaria,		Par_NombreBanco,		Par_Clabe,
                Par_Convenio,			Par_Comentario,			Par_EstatusDomicilia,	Par_EmpresaID,			Aud_Usuario,
                Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
        );

        UPDATE CUENTASTRANSFER SET
			EstatusDomici = Est_Procesado,
			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE	ClienteID	= Par_ClienteID
        AND 	Estatus		= Est_Activo
		AND 	Clabe		= Par_Clabe
        AND 	EstatusDomici= Par_EstatusDomicilia;

        SET Par_NumErr := 0;
        SET Par_ErrMen := 'Registro Grabado Exitosamente';
        SET Var_Control := 'afiliacionID';
    END ManejoErrores;


    IF(Par_Salida = Con_SalidaSI)THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Par_FolioAfiliacion AS Consecutivo;
    END IF;
END TerminaStore$$