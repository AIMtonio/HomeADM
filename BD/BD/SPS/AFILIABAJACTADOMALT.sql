DELIMITER ;
DROP PROCEDURE IF EXISTS `AFILIABAJACTADOMALT`;

DELIMITER $$
CREATE PROCEDURE `AFILIABAJACTADOMALT`(
-- SP que guarda la informacion constante de la cabecera de archivo de afiliacion
	Par_FechaRegistro	DATE,				-- Fecha en que se realiza el registro
	Par_Estatus			CHAR(1),			-- estatus con el que se queda el archivo

	Par_TipoOperacion	CHAR(1),			-- Tipo de operacion ya sea alta o baja
    Par_Salida			CHAR(1),			-- Parametro que espera si se tendra un salida
    INOUT Par_NumErr	INT(11),			-- Numero de error
    INOUT Par_ErrMen	VARCHAR(250),		-- Mensaje de error

	Par_EmpresaID		INT(11),			-- Parametro de auditoria
	Aud_Usuario			INT(11),			-- Parametro de auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal		INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria
)
TerminaStore:BEGIN

        -- Declaracion de variables
        DECLARE Var_Control           VARCHAR(50);	-- Variable de control
        DECLARE Var_Consecutivo       INT(11);		-- Variable del valor consecutivo para el archivo
        DECLARE Var_Folio             BIGINT(20);	-- Folio con el que se identifica al registro
        DECLARE Var_ClabeBanco        VARCHAR(10);	-- clabe que identifica el banco a la financiera
		DECLARE Var_NombreArchivo     VARCHAR(20);  -- Almacena el nombre del archivo

        -- Declaracion de constantes
		DECLARE Entero_Cero		INT(11);		-- Entero cero
        DECLARE Cadena_Vacia	CHAR(1);		-- constante para la cadena vacia
        DECLARE Con_SalidaSI	CHAR(1);		-- Constante de salida SI
        DECLARE Con_SI			CHAR(1);		-- Constante SI
        DECLARE Est_Procesado	CHAR(1);		-- Estatus Procesado

        -- Seteo de valores
        SET Entero_Cero		:= 0;
        SET Cadena_Vacia	:= '';
        SET Con_SalidaSI	:= 'S';
        SET Var_NombreArchivo	:= 'CI';
		SET Con_SI			:= 'S';
        SET Est_Procesado	:= 'P';

    ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion.',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-AFILIABAJACTADOMALT');
			SET Var_Control := 'sqlexception';
		END;


        SELECT ClabeInstitBancaria INTO Var_ClabeBanco
        FROM PARAMETROSSIS;

        IF (IFNULL(Var_ClabeBanco,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr := 1;
            SET Par_ErrMen := 'No se a definido la clabe asignada por el banco en Parametros Generales';
            SET Var_Control := '';
            LEAVE ManejoErrores;
        END IF;

        SELECT IFNULL(COUNT(Consecutivo),Entero_Cero) INTO Var_Consecutivo
        FROM AFILIABAJACTADOM
        WHERE FechaRegistro = Par_FechaRegistro;

        SET Var_Consecutivo := Var_Consecutivo+1;

        SELECT IFNULL(MAX(FolioAfiliacion),Entero_Cero) INTO Var_Folio
        FROM AFILIABAJACTADOM;

        SET Var_Folio := ROUND(Var_Folio+1);
		IF Var_Consecutivo<10 THEN
			SET Var_NombreArchivo := CONCAT(Var_NombreArchivo,Var_ClabeBanco,'0',Var_Consecutivo);
		ELSE
			SET Var_NombreArchivo := CONCAT(Var_NombreArchivo,Var_ClabeBanco,Var_Consecutivo);
        END IF;

        IF Par_Estatus = Con_SI THEN
			SET Par_Estatus := Est_Procesado;
        END IF;


        INSERT INTO AFILIABAJACTADOM(
			FolioAfiliacion, 	FechaRegistro, 	NombreArchivo, 	Consecutivo, 	Estatus,
            TipoOperacion, 		EmpresaID, 		Usuario, 		FechaActual, 	DireccionIP,
            ProgramaID, 		Sucursal, 		NumTransaccion)
        VALUES(
			Var_Folio,	            Par_FechaRegistro,	Var_NombreArchivo,	Var_Consecutivo,	Par_Estatus,
            Par_TipoOperacion,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

            SET Par_NumErr := 0;
            SET Par_ErrMen := Var_NombreArchivo;
            SET Var_Control:= 'afiliacionID';

    END ManejoErrores;

    IF Par_Salida = Con_SalidaSI THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
            Var_Folio AS Consecutivo;
    END IF;

END TerminaStore$$