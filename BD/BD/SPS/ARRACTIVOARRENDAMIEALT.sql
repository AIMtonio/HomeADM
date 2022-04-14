-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRACTIVOARRENDAMIEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRACTIVOARRENDAMIEALT`;DELIMITER $$

CREATE PROCEDURE `ARRACTIVOARRENDAMIEALT`(
# =====================================================================================
# -- STORED PROCEDURE PARA LIGAR UN ACTIVO CON UN ARRENDAMIENTO
# =====================================================================================
	Par_ArrendamientoID		BIGINT(12),				-- Id del arrendamiento
	Par_ActivoID			BIGINT(12),				-- Id del activo

	Par_Salida 				CHAR(1),				-- Indica si el sp tendra salida
	INOUT Par_NumErr		INT(11),				-- Numero de salida que retorna el sp
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje de salida

	Aud_EmpresaID			INT,					-- Id de la empresa
	Aud_Usuario         	INT,					-- Usuario
	Aud_FechaActual     	DATETIME,				-- Fecha actual
	Aud_DireccionIP     	VARCHAR(15),			-- Descripcion IP
	Aud_ProgramaID      	VARCHAR(50),			-- Id del programa
	Aud_Sucursal        	INT(11),				-- Numero de sucursal
	Aud_NumTransaccion  	BIGINT(20)				-- Numero de transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_ActivoStatus		CHAR(1);		-- Estatus del activo
	DECLARE Var_Control				VARCHAR(100);	-- Variable de control

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena Vacia
	DECLARE Entero_Cero			INT;				-- Entero cero
	DECLARE Salida_Si			CHAR(1);			-- Indica que si se devuelve un mensaje de salida
	DECLARE	Salida_NO       	CHAR(1);			-- Indica que no se devuelve un mensaje de salida
	DECLARE Estatus_Activo		CHAR(1);			-- Indica que el activo tenga estatus de activo

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET Entero_Cero			:= 0;					-- Entero Cero
	SET Salida_Si			:= 'S';					-- Salida SI
	SET Salida_NO			:= 'N';   				-- No se devuelve una salida
	SET Estatus_Activo		:= 'A';					-- valor para el estatus de activo
	SET Var_Control			:= '';					-- Valor inicial de la variable de control



	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. REF: SP-ARRACTIVOARRENDAMIEALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;



		SET	Par_ArrendamientoID		:= IFNULL(Par_ArrendamientoID, Entero_Cero);
		SET	Par_ActivoID			:= IFNULL(Par_ActivoID, Entero_Cero);


		IF(Par_ArrendamientoID	= Entero_Cero )THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El Numero de Arrendamiento esta vacio';
			SET Var_Control		:= 'ArrendamientoID';
			LEAVE ManejoErrores;
		END IF;


		IF(Par_ActivoID	= Entero_Cero )THEN
			SET Par_NumErr		:= 002;
			SET Par_ErrMen		:= 'El Numero de Activo esta vacio';
			SET Var_Control		:= 'ActivoID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_ActivoStatus := (SELECT Estatus
								  FROM ARRACTIVOS
								  WHERE ActivoID = Par_ActivoID);

		IF(Var_ActivoStatus	<> Estatus_Activo )THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'El estatus del Activo es distinto de activo';
			SET Var_Control		:= 'ActivoID';
			LEAVE ManejoErrores;
		END IF;


		IF(EXISTS(	SELECT ActivoID
					  FROM ARRACTIVOARRENDAMIE
					  WHERE activoID = Par_ActivoID)) THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'El arrendamiento no puede tener activos duplicados';
			SET Var_Control		:= 'ActivoID';
			LEAVE ManejoErrores;
		END IF;

		INSERT	ARRACTIVOARRENDAMIE(ArrendaID,		ActivoID,			EmpresaID,		Usuario,			FechaActual,
									DireccionIP,	ProgramaID,			Sucursal,		NumTransaccion
								   )
							VALUES(	Par_ArrendamientoID,	Par_ActivoID,		Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
									Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
		SET	Par_NumErr 	:= 0;
		SET	Par_ErrMen	:= "Activo ligado exitosamente";

	END ManejoErrores;
	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;


END TerminaStore$$