-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRACTIVOARRENDAMIEBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRACTIVOARRENDAMIEBAJ`;DELIMITER $$

CREATE PROCEDURE `ARRACTIVOARRENDAMIEBAJ`(
# =====================================================================================
# -- STORED PROCEDURE PARA ELIMINAR LOS ACTIVOS QUE SE ENCUENTRAN LIGADOS A UN ARRENDAMIENTO
# =====================================================================================
	Par_ArrendaID			BIGINT(12),				-- Id del arrendamiento
    Par_NumBaja				INT UNSIGNED,			-- Tipo de baja que se realizara

	Par_Salida				CHAR(1),				-- Define si el store devuelve algo
	INOUT Par_NumErr		INT(11),				-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje de error

    Aud_EmpresaID			INT(11),				-- Id de la empresa
	Aud_Usuario				INT(11),				-- Usuario
	Aud_FechaActual			DATETIME,				-- Fecha actual
	Aud_DireccionIP 		VARCHAR(15),			-- Direccion IP
	Aud_ProgramaID 			VARCHAR(50),			-- Id del programa
	Aud_Sucursal 			INT(11),				-- Numero de sucursal
	Aud_NumTransaccion 		BIGINT(20)				-- Numero de transaccion
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE VarControl  VARCHAR(300); 		-- Variable de control
    DECLARE Baj_Activo 	INT(11);			-- Lista de Activos e Inactivos

	-- Declaracion de constantes
	DECLARE SalidaSI    CHAR(1);

	-- Asignacion de constantes
	SET SalidaSI    	:= 'S';
	SET VarControl  	:= '';
    SET Baj_Activo 		:= 1;

    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	=	999;
			SET Par_ErrMen	=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-ARRACTIVOARRENDAMIEBAJ');
			SET VarControl = 'sqlException';
		END;

        -- Tipo de baja 1
        IF (Par_NumBaja = Baj_Activo) THEN
			DELETE FROM ARRACTIVOARRENDAMIE WHERE ArrendaID = Par_ArrendaID;
		END IF;

        SET Par_NumErr := 0;
		SET Par_ErrMen := 'Activos Eliminados.' ;

	END ManejoErrores;

    IF(Par_Salida =SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				VarControl AS control;
	END IF;

END TerminaStore$$