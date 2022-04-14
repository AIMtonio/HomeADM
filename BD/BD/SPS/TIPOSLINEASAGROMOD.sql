-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSLINEASAGROMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSLINEASAGROMOD`;

DELIMITER $$
CREATE PROCEDURE `TIPOSLINEASAGROMOD`(
	-- Store procedure para la Modificacion de Tipos de lineas de credito
	-- Modulo Cartera --> Registro --> Tipos Lineas Credito
	Par_TipoLineaAgroID			INT(11),			-- ID del tipo de linea
	Par_NombreTipoLinea			VARCHAR(100),		-- Nombre del tipo de linea
	Par_ManejaComAdmon			CHAR(1),			-- Indica si maneja comision por administracion
	Par_ManejaComGaran			CHAR(1),			-- Indica si maneja comision por garantia
	Par_ProductosCredito		VARCHAR(100),		-- indica los Id's de los productos de credito separados por comas(,)

	Par_Estatus					CHAR(1),			-- Estatus del Tipo de Linea

	Par_Salida					CHAR(1),			-- indica una salida
	INOUT Par_NumErr			INT(11),			-- numero de error
	INOUT Par_ErrMen			VARCHAR(400),		-- mensaje de error

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declacion de Variables
	DECLARE Var_Control			VARCHAR(100);		-- Variable de control
	DECLARE Var_TipoLineaAgroID	INT(11);			-- Numero de Tipo de Linea Agro

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);			-- Constante entero cero
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante cadena vacia
	DECLARE Salida_SI			CHAR(1);			-- Constante salida si
	DECLARE Salida_NO			CHAR(1);			-- Constante salida no
	DECLARE Con_SI				CHAR(1);			-- Constante si

	DECLARE Con_NO				CHAR(1);			-- Constante no
	DECLARE Est_Inactiva		CHAR(1);			-- Constante Estatus Inactiva
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante Decimal cero
	DECLARE Fecha_Vacia			DATE;				-- Constante fecha vacia

	-- Declaracion de Actualizaciones
	DECLARE Act_InactivarLinea	TINYINT UNSIGNED;	-- Actualizacion a inactiva

	-- Asignacion de constantes
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';
	SET Salida_NO				:= 'N';
	SET Con_SI					:= 'S';

	SET Con_NO					:= 'N';
	SET Est_Inactiva			:= 'I';
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia				:= '1900-01-01';

	-- Asignacion de Actualizaciones
	SET Act_InactivarLinea		:= 1;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-TIPOSLINEASAGROMOD');
			SET Var_Control	:= 'sqlException';
		END;

		SET Par_TipoLineaAgroID		:= IFNULL(Par_TipoLineaAgroID, Entero_Cero);
		SET Par_NombreTipoLinea		:= IFNULL(Par_NombreTipoLinea, Cadena_Vacia);
		SET Par_ManejaComAdmon		:= IFNULL(Par_ManejaComAdmon, Cadena_Vacia);
		SET Par_ManejaComGaran		:= IFNULL(Par_ManejaComGaran, Cadena_Vacia);
		SET Par_ProductosCredito	:= IFNULL(Par_ProductosCredito, Cadena_Vacia);
		SET Par_Estatus				:= IFNULL(Par_Estatus, Cadena_Vacia);

		IF( Par_TipoLineaAgroID = Entero_Cero ) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Tipo de linea Agro esta vacio.';
			SET Var_Control := 'tipoLineaAgroID';
			LEAVE ManejoErrores;
		END IF;

		SELECT TipoLineaAgroID
		INTO Var_TipoLineaAgroID
		FROM TIPOSLINEASAGRO
		WHERE TipoLineaAgroID = Par_TipoLineaAgroID;

		IF( Var_TipoLineaAgroID = Entero_Cero ) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Tipo de linea Agro no Existe.';
			SET Var_Control := 'tipoLineaAgroID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NombreTipoLinea = Cadena_Vacia ) THEN
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'El nombre del tipo de linea esta vacio.';
			SET Var_Control := 'nombre' ;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ManejaComAdmon = Cadena_Vacia ) THEN
			SET Par_NumErr  := 004;
			SET Par_ErrMen  := 'La opcion de maneja comision administrativa esta vacia.';
			SET Var_Control := 'manejaComAdmon' ;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ManejaComAdmon NOT IN (Con_SI, Con_NO)) THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= 'La opcion de maneja comision administrativa no es valida.';
			SET Var_Control	:= 'manejaComAdmon';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ManejaComGaran = Cadena_Vacia ) THEN
			SET Par_NumErr  := 006;
			SET Par_ErrMen  := 'La opcion de manejo comision por garantia esta Vacia.';
			SET Var_Control := 'manejaComGaran' ;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ManejaComGaran NOT IN (Con_SI, Con_NO)) THEN
			SET Par_NumErr	:= 007;
			SET Par_ErrMen	:= 'La opcion de manejo de comision por garantia no es valida.';
			SET Var_Control	:= 'manejaComAdmon';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ProductosCredito = Cadena_Vacia ) THEN
			SET Par_NumErr  := 008;
			SET Par_ErrMen  := 'El producto de credito esta vacio';
			SET Var_Control := 'productosCredito' ;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();
		UPDATE TIPOSLINEASAGRO SET
			Nombre				= Par_NombreTipoLinea,
			ManejaComAdmon		= Par_ManejaComAdmon,
			ManejaComGaran		= Par_ManejaComGaran,
			ProductosCredito	= Par_ProductosCredito,

			EmpresaID			= Aud_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE TipoLineaAgroID = Par_TipoLineaAgroID;

		IF( Par_Estatus = Est_Inactiva ) THEN
			CALL TIPOSLINEASAGROACT(
				Par_TipoLineaAgroID,	Act_InactivarLinea,
				Salida_NO,				Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET	Par_NumErr		:= Entero_Cero;
		SET	Par_ErrMen		:= CONCAT('Tipo Linea Agro Modificada Exitosamente: ',CONVERT(Par_TipoLineaAgroID,CHAR));
		SET Var_Control		:= 'tipoLineaAgroID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_TipoLineaAgroID AS Consecutivo;
	END IF;

END TerminaStore$$