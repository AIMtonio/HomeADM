-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMIMGANTIPHISHINGALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMIMGANTIPHISHINGALT`;DELIMITER $$

CREATE PROCEDURE `BAMIMGANTIPHISHINGALT`(

# SP PARA EL ALTA DE IMAGENES ANTIPHISHING

	Par_ImagenBinaria				MEDIUMBLOB,				-- Imagen en binario que deseamos  guardar en la base
    Par_Descripcion 				VARCHAR(100),			-- Descripcion de la imagen
    Par_Estatus 					CHAR(1),				-- Estatus de la imagen -- A.- Activo I.- Inactivo
    Par_Salida         				CHAR(1),				-- Especificamos si se espera una salida
    INOUT Par_NumErr    			INT(11),					-- Parametro de salida con  numero de error

    INOUT Par_ErrMen    			VARCHAR(400),			-- Parametro de salida con el numero de error
    Par_EmpresaID      				INT(11),				-- Parametro de auditoria
    Aud_Usuario         			INT(11),				-- Parametro de auditoria
    Aud_FechaActual    		    	DATETIME,				-- Parametro de auditoria
    Aud_DireccionIP     			VARCHAR(15),			-- Parametro de auditoria

    Aud_ProgramaID      			VARCHAR(50),			-- Parametro de auditoria
    Aud_Sucursal        			INT(11),				-- Parametro de auditoria
    Aud_NumTransaccion  			BIGINT(20)				-- Parametro de auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Par_ImagenPhishingID    BIGINT;
    DECLARE Var_Control     		VARCHAR(50);

	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Entero_Cero     		INT;
	DECLARE SalidaSI        		CHAR(1);

	-- Asignacion  de constantes
	SET Cadena_Vacia    := '';              	-- Cadena o string vacio
	SET Entero_Cero     := 0;               	-- Entero en cero
	SET SalidaSI        := 'S';             	-- El Store SI genera una Salida


	ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMIMGANTIPHISHINGALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		IF(IFNULL(Par_ImagenBinaria, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'La Imagen esta Vacia';
				SET Var_Control := 'imagen';
				LEAVE ManejoErrores;

        ELSEIF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 002;
				SET	Par_ErrMen	:= 'La Descripcion esta Vacia';
				SET Var_Control := 'descripcion';
				LEAVE ManejoErrores;


		ELSEIF(IFNULL(Par_Estatus, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 003;
				SET	Par_ErrMen	:= 'El Estatus esta Vacio';
				SET Var_Control := 'estatus';
				LEAVE ManejoErrores;

		ELSE
			-- Consecutivo
			CALL FOLIOSAPLICAACT('BAMIMGANTIPHISHING', Par_ImagenPhishingID);

			SET Aud_FechaActual := 	NOW();

			INSERT INTO BAMIMGANTIPHISHING (
				ImagenPhishingID,		ImagenBinaria,		Descripcion,		Estatus,			EmpresaID,
                Usuario,				FechaActual,   		DireccionIP,		ProgramaID,			Sucursal,
                NumTransaccion)
			VALUES (
				Par_ImagenPhishingID,  	Par_ImagenBinaria,  Par_Descripcion,	Par_Estatus,		Par_EmpresaID,
                Aud_Usuario,	 		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,
                Aud_NumTransaccion);

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Imagen Antiphishing Agregada Exitosamente';
			SET Var_Control := 'imagenPhishing';
			SET Entero_Cero := Par_ImagenPhishingID;

		END IF;
	END ManejoErrores;  -- END del Handler de Errores

		IF(Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Entero_Cero AS consecutivo;
		END IF;

END TerminaStore$$