-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVAINACTIVAPRODUCTOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTIVAINACTIVAPRODUCTOSACT`;
DELIMITER $$

CREATE PROCEDURE `ACTIVAINACTIVAPRODUCTOSACT`(
# ====================================================================================================
# ------- STORE PARA ACTUALIZAR ACTIVAR/ DESACTIVAR LOS PRODUCTOS DE LOS TIPOS DE INSTRUMENTOS---------
# ====================================================================================================
	Par_NumProducto			INT(11),			-- Numero del Producto
	Par_Estatus				CHAR(2),			-- Estatus A.-Activo I.-Inactivo

	Par_NumAct				TINYINT UNSIGNED,	-- Numero de actualizacion que realizara

	Par_Salida				CHAR(1),			-- Parametro de salida
	INOUT Par_NumErr        INT(11),  			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de error

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Par_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Par_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Par_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Par_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Par_SucursalID			INT(11),			-- Parametro de auditoria ID de la sucursal
	Par_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

    -- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);		-- Variable Control
	DECLARE Var_FechaSistema		DATE;				-- Fecha del Sistema

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);				-- Constante Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;					-- Constante Fecha Vacia
	DECLARE	Entero_Cero			INT;					-- Constante Entero Cero
    DECLARE	Estatus_Activo		CHAR(2);				-- Constante Estatus Activo
	DECLARE	Estatus_Inactivo	CHAR(2);				-- Constante Estatus Inactivo
    DECLARE	Con_SalidaSI		CHAR(1);				-- Constante Salida Si
    DECLARE	Act_TipoCuenta		INT(11);				-- Actualizacion Tipo Cuenta
	DECLARE	Act_TipoCred		INT(11);				-- Actualizacion Tipo Credito
	DECLARE	Act_TipoCede		INT(11);				-- Actualizacion Tipo Cede
	DECLARE	Act_TipoInversion	INT(11);				-- Actualizacion Tipo Inversion
    DECLARE	Act_TipoFondeador	INT(11);				-- Actualizacion Tipo Fondeador




	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET	Estatus_Activo			:= 'A';				-- Estatus Activo
	SET	Estatus_Inactivo		:= 'I';				-- Estatus Inactivo
	SET Con_SalidaSI			:= 'S';

    SET Act_TipoCuenta			:= 1;
	SET Act_TipoCred			:= 2;
    SET Act_TipoCede			:= 3;
	SET Act_TipoInversion		:= 4;
    SET Act_TipoFondeador		:= 5;


	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-ACTIVAINACTIVAPRODUCTOSACT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		SET Par_FechaActual := NOW();

        IF(IFNULL(Par_NumProducto,	Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := 'Especifique el Numero de Producto.';
				LEAVE ManejoErrores;
			END IF;

        IF(Par_NumAct = Act_TipoCuenta) THEN

				UPDATE TIPOSCUENTAS SET
					Estatus			= Par_Estatus,
					EmpresaID		= Par_EmpresaID,
					Usuario			= Par_Usuario,
					FechaActual 	= Par_FechaActual,
					DireccionIP 	= Par_DireccionIP,
					ProgramaID  	= Par_ProgramaID,
					Sucursal		= Par_SucursalID,
					NumTransaccion	= Par_NumTransaccion
				WHERE TipoCuentaID = Par_NumProducto;

			SET Par_NumErr		:=	0;
			SET Par_ErrMen		:=	'Tipo Cuenta Actualizado Exitosamente.';
			SET Var_Control		:=	'tipoProducto';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_NumAct = Act_TipoCred) THEN

				UPDATE PRODUCTOSCREDITO SET
					Estatus			= Par_Estatus,
					EmpresaID		= Par_EmpresaID,
					Usuario			= Par_Usuario,
					FechaActual 	= Par_FechaActual,
					DireccionIP 	= Par_DireccionIP,
					ProgramaID  	= Par_ProgramaID,
					Sucursal		= Par_SucursalID,
					NumTransaccion	= Par_NumTransaccion
				WHERE ProducCreditoID = Par_NumProducto;

			SET Par_NumErr		:=	0;
			SET Par_ErrMen		:=	'Producto Credito Actualizado Exitosamente.';
			SET Var_Control		:=	'tipoProducto';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumAct = Act_TipoCede) THEN

				UPDATE TIPOSCEDES SET
					Estatus			= Par_Estatus,
					EmpresaID		= Par_EmpresaID,
					Usuario			= Par_Usuario,
					FechaActual 	= Par_FechaActual,
					DireccionIP 	= Par_DireccionIP,
					ProgramaID  	= Par_ProgramaID,
					Sucursal		= Par_SucursalID,
					NumTransaccion	= Par_NumTransaccion
				WHERE TipoCedeID = Par_NumProducto;

			SET Par_NumErr		:=	0;
			SET Par_ErrMen		:=	'Tipo Cede Actualizado Exitosamente.';
			SET Var_Control		:=	'tipoProducto';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_NumAct = Act_TipoInversion) THEN

				UPDATE CATINVERSION SET
					Estatus			= Par_Estatus,
					EmpresaID		= Par_EmpresaID,
					Usuario			= Par_Usuario,
					FechaActual 	= Par_FechaActual,
					DireccionIP 	= Par_DireccionIP,
					ProgramaID  	= Par_ProgramaID,
					Sucursal		= Par_SucursalID,
					NumTransaccion	= Par_NumTransaccion
				WHERE TipoInversionID = Par_NumProducto;

			SET Par_NumErr		:=	0;
			SET Par_ErrMen		:=	'Tipo Inversion Actualizado Exitosamente.';
			SET Var_Control		:=	'tipoProducto';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumAct = Act_TipoFondeador) THEN

				UPDATE CATFONDEADORES SET
					Estatus			= Par_Estatus,
					EmpresaID		= Par_EmpresaID,
					Usuario			= Par_Usuario,
					FechaActual 	= Par_FechaActual,
					DireccionIP 	= Par_DireccionIP,
					ProgramaID  	= Par_ProgramaID,
					Sucursal		= Par_SucursalID,
					NumTransaccion	= Par_NumTransaccion
				WHERE CatFondeadorID = Par_NumProducto;

			SET Par_NumErr		:=	0;
			SET Par_ErrMen		:=	'Tipo Fondeador Actualizado Exitosamente.';
			SET Var_Control		:=	'tipoProducto';
			LEAVE ManejoErrores;
		END IF;



	END ManejoErrores;

	IF (Par_Salida = Con_SalidaSI) THEN
		SELECT 	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS Control,
                Par_NumProducto	AS Consecutivo;
    END IF;

END TerminaStore$$
