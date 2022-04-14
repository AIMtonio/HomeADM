-- SP DOMICILIACIONPAGOSENCALT

DELIMITER ;

DROP PROCEDURE IF EXISTS DOMICILIACIONPAGOSENCALT;

DELIMITER $$


CREATE PROCEDURE `DOMICILIACIONPAGOSENCALT`(
# ===================================================================================================
# -- STORE PARA EL REGISTRO DE INFORMACION PARA EL ENCABEZADO DEL LAYOUT DE DOMICILIACION DE PAGOS --
# ===================================================================================================
	Par_FolioID				BIGINT(20),			-- Numero de Folio
	Par_FechaRegistro		DATE,				-- Fecha en que se genera el Layout

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
	DECLARE	Var_Control     			VARCHAR(100);	-- Almacena el control de errores
    DECLARE	Var_ConsecutivoID			BIGINT(20);		-- ID Consecutivo
	DECLARE Var_ClabeInstitBancaria		VARCHAR(10);	-- Clave Institucion Bancaria
    DECLARE Var_NombreArchivo			VARCHAR(50);	-- Nombre del Archivo
	DECLARE Var_Consecutivo 			INT(11);		-- Almacena el valor consecutivo para el Layout por Fecha de Registro

    DECLARE Var_ImporteTotal			DECIMAL(14,2);	-- Importe Total

	-- Declaracion de Constantes
	DECLARE Entero_Cero    	INT(11);
    DECLARE Decimal_Cero	DECIMAL(14,2);
	DECLARE Cadena_Vacia   	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	SalidaSI        CHAR(1);

    DECLARE	SalidaNO        CHAR(1);
    DECLARE ConstanteSI		CHAR(1);
	DECLARE ValorCobroDom	CHAR(2);
	DECLARE Entero_Diez		INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 				-- Entero Cero
    SET Decimal_Cero		:= 0.00;			-- Decimal Cero
	SET Cadena_Vacia		:= '';    			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	SalidaSI        	:= 'S';				-- Salida Si

    SET	SalidaNO        	:= 'N'; 			-- Salida No
    SET ConstanteSI			:= 'S';				-- Constante: SI
	SET ValorCobroDom		:= 'CI';			-- Valor Cobro Domiciliacion
	SET Entero_Diez			:= 10;				-- Entero Diez


    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-DOMICILIACIONPAGOSENCALT');
			SET Var_Control = 'SQLEXCEPTION' ;
		END;

        -- Se obtiene la Clabe de la Institucion Bancaria
        SET Var_ClabeInstitBancaria :=(SELECT ClabeInstitBancaria FROM PARAMETROSSIS LIMIT 1);

        IF (IFNULL(Var_ClabeInstitBancaria,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr 	:= 01;
            SET Par_ErrMen 	:= 'No se a Definido la Clabe asignada por el Banco en Parametros Generales.';
            SET Var_Control := Cadena_Vacia;
            LEAVE ManejoErrores;
        END IF;

		-- Se obtiene la Fecha Actual
        SET Aud_FechaActual 	:= NOW();
		SET Par_FechaRegistro 	:= CURDATE();

        -- Se obtiene el Consecutivo por Fecha de Registro
		SET Var_Consecutivo := (SELECT IFNULL(COUNT(Consecutivo),Entero_Cero)FROM DOMICILIACIONPAGOSENC WHERE FechaRegistro = Par_FechaRegistro);

        -- Se aumenta + 1 al valor consecutivo obtenido
		SET Var_Consecutivo := Var_Consecutivo+1;

        -- Se valida el valor del Consecutivo
        IF (Var_Consecutivo < Entero_Diez) THEN
			SET Var_NombreArchivo := CONCAT(ValorCobroDom,Var_ClabeInstitBancaria,'0',Var_Consecutivo);
		ELSE
			SET Var_NombreArchivo := CONCAT(ValorCobroDom,Var_ClabeInstitBancaria,Var_Consecutivo);
        END IF;

        -- Se obtiene el valor consecutivo para el registro en la tabla DOMICILIACIONPAGOSENC
		SET Var_ConsecutivoID := (SELECT IFNULL(MAX(ConsecutivoID),Entero_Cero)+1 FROM DOMICILIACIONPAGOSENC);

        -- Se registra la informacion en la tabla DOMICILIACIONPAGOSENC
		INSERT INTO DOMICILIACIONPAGOSENC(
			ConsecutivoID, 			FolioID,				FechaRegistro,			NombreArchivo,			Consecutivo,
            ImporteTotal,			EmpresaID, 				Usuario, 				FechaActual,			DireccionIP,
            ProgramaID,				Sucursal, 				NumTransaccion)
		VALUES(
			Var_ConsecutivoID, 		Par_FolioID,			Par_FechaRegistro,		Var_NombreArchivo,		Var_Consecutivo,
            Decimal_Cero,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,
            Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

        -- Se obtiene el Monto Total del Exigible
        SELECT SUM(Dom.MontoExigible)
        INTO Var_ImporteTotal
        FROM DOMICILIACIONPAGOS Dom,
			 DOMICILIACIONPAGOSENC Enc
        WHERE Dom.FolioID = Enc.FolioID
        AND Dom.FolioID = Par_FolioID;

        -- Se actualiza el Monto Total del Exigible para el Encabezado del Layout
        UPDATE DOMICILIACIONPAGOSENC
        SET ImporteTotal = Var_ImporteTotal
        WHERE FolioID = Par_FolioID;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Domiciliacion de Pagos Agregada Exitosamente.';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Var_ConsecutivoID AS Consecutivo;
	END IF;

END TerminaStore$$