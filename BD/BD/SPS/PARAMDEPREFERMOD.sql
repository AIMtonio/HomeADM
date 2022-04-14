-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMDEPREFERMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMDEPREFERMOD`;
DELIMITER $$


CREATE PROCEDURE `PARAMDEPREFERMOD`(
-- -----------------------------------------------------------------
-- -- SP PARA MODIFICAR LOS PARAMETROS DE DEPOSITOS REFERENCIADOS --
-- -----------------------------------------------------------------
	Par_ConsecutivoID		CHAR(1),		-- ID Consecutivo
	Par_TipoArchivo			INT(11),		-- Tipo de Archivo
	Par_DescripcionArch		VARCHAR(100),	-- Descripcion o nombre corto del archivo
	Par_PagoCredAutom		CHAR(1),		-- Indica SI o NO aplica pago de credito automatico
	Par_Exigible			CHAR(1),		-- Indica la Accion a Realizar en caso de NO tener exigible

	Par_Sobrante			CHAR(1),		-- Indica la accion a realizar en caso de tener Sobrante
	Par_LecturaAutom		CHAR(1),		-- Indica si o no requiere lectura automatica de pagos referenciados
	Par_RutaArchivos		VARCHAR(150),	-- Ruta donde se guardan los archivos que se leerar
	Par_TiempoLectura		INT(11),		-- Tiempo en minutos de la comprobacion de archivos nuevos en la ruta

	Par_AplicaCobranzaRef	CHAR(1),		-- Indica SI aplica Cobranza Referenciado: S=SI ,N=NO,
	Par_ProducCreditoID		INT(11),		-- ID o Numero del producto de credito,

	Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
)

TerminaStore: BEGIN


-- DECLARACION DE VARIABLES
DECLARE Var_Control				VARCHAR(100);	-- Variable de control
DECLARE Var_Consecutivo			INT(11);		-- Variable Consecutivo
DECLARE Var_ParamCobranzaReferID	INT(11);		-- Variable para almacenar el numero de parametro cobranza referenciado


-- DECLARACION DE CONSTANTES
DECLARE Entero_Cero				TINYINT;		-- Constante Entero Cero
DECLARE Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
DECLARE Salida_SI				CHAR(1);		-- Constante Salida SI
DECLARE Con_SI					CHAR(1);		-- Constante para valor S
DECLARE Con_NO					CHAR(1);		-- Constante para valor N

-- ASIGNACION DE CONSTANTES
SET Entero_Cero					:= 0;
SET Cadena_Vacia				:= '';
SET Salida_SI					:= 'S';
SET Con_SI						:= 'S';
SET Con_NO						:= 'N';


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-PARAMDEPREFERMOD');
			SET Var_Control = 'SQLEXCEPTION';
			SET Var_Consecutivo	:= Entero_Cero;
		END;


		IF NOT EXISTS(SELECT ConsecutivoID FROM PARAMDEPREFER WHERE ConsecutivoID = Par_ConsecutivoID) THEN
			SET Par_NumErr 		:= 001;
			SET Par_ErrMen 		:= 'No existe el Registro';
			SET Var_Control		:= 'tipoArchivo';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;



		IF NOT EXISTS(SELECT TipoArchivo FROM PARAMDEPREFER WHERE TipoArchivo = Par_TipoArchivo) THEN
			SET Par_NumErr 		:= 002;
			SET Par_ErrMen 		:= 'No existe el Tipo de Archivo';
			SET Var_Control		:= 'tipoArchivo';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_DescripcionArch, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 003;
			SET Par_ErrMen 		:= 'La Descripcion del archivo está vacia';
			SET Var_Control		:= 'tipoArchivo';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_PagoCredAutom, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 004;
			SET Par_ErrMen 		:= 'Seleccione una opcion en la seccion Aplica en automatico el pago de credito';
			SET Var_Control		:= 'tipoArchivo';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Exigible, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 005;
			SET Par_ErrMen 		:= 'Seleccione una opcion en la seccion En caso de no tener exigible';
			SET Var_Control		:= 'tipoArchivo';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;



		IF(IFNULL(Par_Sobrante, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 006;
			SET Par_ErrMen 		:= 'Seleccione una opcion en la seccion En caso de sobrante';
			SET Var_Control		:= 'tipoArchivo';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_LecturaAutom,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 007;
			SET Par_ErrMen 		:= 'Seleccione una opcion en la seccion Habilitar lectura automatica';
			SET Var_Control		:= 'tipoArchivo';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_LecturaAutom = Con_SI AND IFNULL(Par_RutaArchivos,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 008;
			SET Par_ErrMen 		:= 'Ingrese la ruta de archivos';
			SET Var_Control		:= 'tipoArchivo';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_LecturaAutom = Con_SI AND IFNULL(Par_TiempoLectura,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 009;
			SET Par_ErrMen 		:= 'Ingrese la periodicidad de lectura';
			SET Var_Control		:= 'tipoArchivo';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_AplicaCobranzaRef,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 10;
			SET Par_ErrMen 		:= 'Aplica Cobranza Referenciado esta Vacia.';
			SET Var_Control		:= 'aplicaCobranzaRef';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ProducCreditoID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 11;
			SET Par_ErrMen 		:= 'El Numero de Producto de Credito se Encuentra Vacio.';
			SET Var_Control		:= 'productoCreditoID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ProducCreditoID FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProducCreditoID) THEN
			SET Par_NumErr 		:= 12;
			SET Par_ErrMen 		:= 'El Numero de Producto de Credito No existe.';
			SET Var_Control		:= 'productoCreditoID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF Par_LecturaAutom = Con_NO THEN
			SET Par_RutaArchivos := Cadena_Vacia;
			SET Par_TiempoLectura := Entero_Cero;
		END IF;

		UPDATE PARAMDEPREFER SET
			TipoArchivo 			= Par_TipoArchivo,
			DescripcionArch 		= Par_DescripcionArch,
			PagoCredAutom 			= Par_PagoCredAutom,
			Exigible 				= Par_Exigible,
			Sobrante 				= Par_Sobrante,
			LecturaAutom 			= Par_LecturaAutom,
			RutaArchivos 			= Par_RutaArchivos,
			TiempoLectura 			= Par_TiempoLectura,

			EmpresaID 				= Par_EmpresaID,
			Usuario 				= Aud_Usuario,
			FechaActual 			= Aud_FechaActual,
			DireccionIP 			= Aud_DireccionIP,
			ProgramaID 				= Aud_ProgramaID,
			Sucursal 				= Aud_Sucursal,
			NumTransaccion 			= Aud_NumTransaccion
		WHERE ConsecutivoID = Par_ConsecutivoID;

		-- Consultamos si ya existe el registro de configuracion por producto de credito
		SELECT ParamCobranzaReferID
			INTO Var_ParamCobranzaReferID
			FROM PARAMCOBRANZAREFER
			WHERE ConsecutivoID = Par_ConsecutivoID
			AND ProducCreditoID = Par_ProducCreditoID;

		SET Var_ParamCobranzaReferID	:= IFNULL(Var_ParamCobranzaReferID, Entero_Cero);

		-- Damos de alta la configuracion por poducto de credito si no se encuentra registrado
		IF(Var_ParamCobranzaReferID = Entero_Cero) THEN
			CALL PARAMCOBRANZAREFERALT(	Par_ConsecutivoID,		Par_AplicaCobranzaRef,		Par_ProducCreditoID,		Con_NO,				Par_NumErr,
										Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);
		END IF;

		-- Modificamos el registro si ya se tiene configurado por producto
		IF(Var_ParamCobranzaReferID > Entero_Cero) THEN
			CALL PARAMCOBRANZAREFERMOD(	Var_ParamCobranzaReferID,		Par_ConsecutivoID,		Par_AplicaCobranzaRef,		Par_ProducCreditoID,		Con_NO,
										Par_NumErr,						Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
										Aud_DireccionIP,				Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);
		END IF;

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr      := 000;
		SET Par_ErrMen      := CONCAT('Modificacion realizada exitosamente.');
		SET Var_Control     := 'tipoArchivo';
		SET Var_Consecutivo	:= Par_ConsecutivoID;

	 END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
	END IF;



END TerminaStore$$
