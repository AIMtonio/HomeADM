-- SP TMPAFILIACUENTASCLABEALT

DELIMITER ;

DROP PROCEDURE IF EXISTS TMPAFILIACUENTASCLABEALT;

DELIMITER $$

CREATE PROCEDURE `TMPAFILIACUENTASCLABEALT`(
# ==========================================================================
# --- STORE PARA EL REGISTRO DE AFILIACIONES CUENTAS CLABE PARA PROCESAR ---
# ==========================================================================
	Par_CuentaClabe			VARCHAR(18),		-- Cuenta Clabe
    Par_ClaveAfiliacion		CHAR(2),			-- Clave de Afiliacion
    Par_Tipo				CHAR(1),			-- Tipo: A = Alta B =  Baja
    Par_NumAfiliacionID		INT(11),			-- Numero de Afiliacion

    Par_Salida           	CHAR(1),			-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     	INT(11),			-- Numero de Error
	INOUT Par_ErrMen     	VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Control     	VARCHAR(100);	-- Almacena el control de errores
    DECLARE	Var_FolioAfiliacion	INT(11);		-- Folio de Afiliacion
    DECLARE Var_CuentaClabe		VARCHAR(18);	-- Numero de Cuenta Clabe
    DECLARE Var_ClienteID       INT(11);		-- Numero del Cliente
	DECLARE Var_InstitucionID   INT(11);		-- Numero de la Institucion

	DECLARE Var_FolioInst		CHAR(3);		-- Folio de la Institucion Bancaria

	-- Declaracion de Constantes
	DECLARE Entero_Cero    	INT(11);
	DECLARE Cadena_Vacia   	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	SalidaSI        CHAR(1);
    DECLARE	SalidaNO        CHAR(1);

    DECLARE ConstanteSI		CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 				-- Entero Cero
	SET Cadena_Vacia		:= '';    			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	SalidaSI        	:= 'S';				-- Salida Si
    SET	SalidaNO        	:= 'N'; 			-- Salida No

    SET ConstanteSI			:= 'S';				-- Constante: SI

    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-TMPAFILIACUENTASCLABEALT');
			SET Var_Control = 'SQLEXCEPTION' ;
		END;

        -- Se obtienen los datos de la Cuenta Clabe
        SELECT 	Clabe,				ClienteID
        INTO 	Var_CuentaClabe,	Var_ClienteID
        FROM CUENTASTRANSFER
        WHERE Clabe = Par_CuentaClabe;

		SET Var_CuentaClabe 	:= IFNULL(Var_CuentaClabe,Cadena_Vacia);
		SET Var_ClienteID 		:= IFNULL(Var_ClienteID,Entero_Cero);

		-- Se obtiene el Numero del Folio de la Institucion Bancaria a partir de la Cuenta Clabe
        SET Var_FolioInst :=(SELECT SUBSTRING(Par_CuentaClabe,1,3));

        -- Se obtiene el Numero de la Institucion Bancaria a partir del Folio
        SET Var_InstitucionID   := (SELECT InstitucionID FROM INSTITUCIONES WHERE Folio = Var_FolioInst);
		SET Var_InstitucionID 	:= IFNULL(Var_InstitucionID,Entero_Cero);

		SET Var_FolioAfiliacion := (SELECT IFNULL(MAX(FolioAfiliacionID),Entero_Cero)+1 FROM TMPAFILIACUENTASCLABE);

        SET Aud_FechaActual := NOW();

        -- Se valida que la Cuenta Clabe Exista
        IF(Var_CuentaClabe != Cadena_Vacia) THEN
			-- Se valida si ya existe el registro de la Cuenta Clabe para procesar en TMPAFILIACUENTASCLABE
            IF NOT EXISTS(SELECT CuentaClabe FROM TMPAFILIACUENTASCLABE WHERE CuentaClabe = Var_CuentaClabe AND Tipo = Par_Tipo) THEN
				INSERT INTO TMPAFILIACUENTASCLABE(
					FolioAfiliacionID, 		NumAfiliacionID,		ClienteID,				InstitucionID,			CuentaClabe,
					ClaveAfiliacion,		Tipo,					EmpresaID, 				Usuario, 				FechaActual,
                    DireccionIP, 			ProgramaID, 			Sucursal, 				NumTransaccion)
				VALUES(
					Var_FolioAfiliacion, 	Par_NumAfiliacionID,	Var_ClienteID,			Var_InstitucionID,		Var_CuentaClabe,
					Par_ClaveAfiliacion,	Par_Tipo,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
                    Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

            IF EXISTS (SELECT CuentaClabe FROM TMPAFILIACUENTASCLABE WHERE CuentaClabe = Var_CuentaClabe AND Tipo = Par_Tipo)THEN
				UPDATE TMPAFILIACUENTASCLABE
                SET InstitucionID 	= Var_InstitucionID,
					ClaveAfiliacion = Par_ClaveAfiliacion,
                    EmpresaID 		= Par_EmpresaID,
                    Usuario 		= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID 		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion 	= Aud_NumTransaccion
				WHERE CuentaClabe = Var_CuentaClabe
                AND Tipo = Par_Tipo;
            END IF;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Afiliacion Cuenta Clabe Registrada Exitosamente: ', CONVERT(Var_FolioAfiliacion, CHAR));
		SET Var_Control	:= 'procesar';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Var_FolioAfiliacion AS Consecutivo;
	END IF;

END TerminaStore$$