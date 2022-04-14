-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPERFILESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMPERFILESMOD`;DELIMITER $$

CREATE PROCEDURE `BAMPERFILESMOD`(
-- 	Procedimiento para modIFicar un perfil de la banca movil
	Par_PerfilID			BIGINT(20),				-- ID del perfil de BM que deseamos modificar
    Par_NombrePerfil 		VARCHAR(50),			-- Nombre del perfil
	Par_Descripcion			VARCHAR(200),			-- Descripcion del perfil
    Par_AccesoConToken		CHAR(1),				-- Acceso a la app con token S.- si N.- no
    Par_TransaccionConToken	CHAR(1),				-- Trasacciones en la App con Token S.- si N-- no
    Par_CostoPrimeraVez		DECIMAL(12,2),			-- Indica si el pertenecer a un perfil tiene un costo inicial
    Par_CostoMensual		DECIMAL(12,2),			-- Indica el pago mesual del perfil de banca movil

	Par_Salida          	CHAR(1),				-- Indica si el SP genera una salida
    INOUT Par_NumErr   		INT(11),				-- Parametro de salida con el numero de error
    INOUT Par_ErrMen   		VARCHAR(400),			-- Parametro de salida que indica el mensaje de error

	Par_EmpresaID			INT(11),				-- Parametro de auditoria
	Aud_Usuario				INT(11),				-- Parametro de auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal			INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de auditoria
	)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control    	VARCHAR(50);			-- Variable de Control

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);				-- Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;					-- Fecha Vacia
	DECLARE	Entero_Cero		INT;					-- Entero 0
	DECLARE SalidaSI        CHAR(1);				-- Salida SI

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';				-- Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero		:= 0;				-- Entero cero
	SET SalidaSI        := 'S';             -- El Store SI genera una Salida

	ManejoErrores: BEGIN
     DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMPERFILESMOD');
				SET Var_Control = 'SQLEXCEPTION';
			END;

	IF NOT EXISTS(SELECT PerfilID
				FROM BAMPERFILES
					WHERE PerfilID = Par_PerfilID) THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'El Perfil no Existe';
			SET Var_Control := 'perfilID';
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_NombrePerfil, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 002;
			SET	Par_ErrMen	:= 'El Nombre del Perfil esta Vacio';
			SET Var_Control := 'nombrePerfil';
			LEAVE ManejoErrores;
		END IF;


    	IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 003;
			SET	Par_ErrMen	:= 'La Descripcion esta Vacia';
			SET Var_Control := 'descripcion';
			LEAVE ManejoErrores;
		END IF;

    	IF(IFNULL(Par_AccesoConToken, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 004;
			SET	Par_ErrMen	:= 'Campo Acceso con Token Vacio';
			SET Var_Control := 'accesoConToken';
			LEAVE ManejoErrores;
		END IF;

        	IF(IFNULL(Par_TransaccionConToken, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 005;
			SET	Par_ErrMen	:= 'Campo Transaccion con Token esta Vacio';
			SET Var_Control := 'transaccionConToken';
			LEAVE ManejoErrores;
		END IF;

        	IF(IFNULL(Par_CostoPrimeraVez, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 006;
			SET	Par_ErrMen	:= 'El Costo por Primera Vez esta Vacio';
			SET Var_Control := 'costoPrimeraVez';
			LEAVE ManejoErrores;
		END IF;

        	IF(IFNULL(Par_CostoMensual, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 007;
			SET	Par_ErrMen	:= 'El Costo Mensual esta Vacio';
			SET Var_Control := 'costoMensual';
			LEAVE ManejoErrores;
		END IF;

	SET Aud_FechaActual	:= NOW();

	UPDATE BAMPERFILES SET

		NombrePerfil	= Par_NombrePerfil,
        Descripcion     = Par_Descripcion,
        AccesoConToken	= Par_AccesoConToken,
		TransacConToken = Par_TransaccionConToken,
        CostoPrimeraVez	= Par_CostoPrimeraVez,
        CostoMensual	= Par_CostoMensual,

		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
		WHERE PerfilID = Par_PerfilID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Perfil Modificado Exitosamente';
			SET Var_Control := 'perfilID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				IFNULL (Par_PerfilID,Entero_Cero) AS consecutivo;
	END IF;

END TerminaStore$$