-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONDICIONESVENCIMAPORTACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONDICIONESVENCIMAPORTACT`;DELIMITER $$

CREATE PROCEDURE `CONDICIONESVENCIMAPORTACT`(
# ====================================================================================
# ------ SP PARA ACTUALIZAR LAS CONDICIONES DE VENCIMIENTO DE UNA APORTACION---------
# ====================================================================================
	Par_AportacionID				INT(11),			-- ID de la aportacion, hace referencia a la tabla (APORTACIONES)
	Par_Estatus 					CHAR(1),			-- Indica el Estatus de las condiciones de vencimiento de la Aportacion\nP) Pendiente\nA) Autorizada\nR) Por Autorizar \n
	Par_NumAct						TINYINT UNSIGNED,	-- Numero de actualizacion

	Par_Salida 						CHAR(1), 			-- Salida en Pantalla
	INOUT Par_NumErr 				INT(11),			-- Parametro de numero de error
	INOUT Par_ErrMen 				VARCHAR(400),		-- Parametro de mensaje de error

	Par_EmpresaID 					INT(11),			-- Parametro de Auditoria
	Aud_Usuario 					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual 				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP 				VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID 					VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal 					INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion 				BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control
	DECLARE Var_FechaInicio 		DATE;
	DECLARE Var_FechaVencimiento 	DATE;
	DECLARE Var_Monto				DECIMAL(16,2);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_TipoAportacionID	INT(11);
	DECLARE Var_TasaFija			DECIMAL(18,4);
	DECLARE Var_TipoPagoInt 		CHAR(1);
	DECLARE Var_DiasPeriodo			INT(11);
	DECLARE Var_PagoIntCal			CHAR(2);
	DECLARE Var_DiaPago				INT(11);
	DECLARE Var_PlazoOriginal		INT(11);
	DECLARE Var_Capitaliza			CHAR(1);



	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia 			CHAR(1);			-- Constante Cadena Vacia ('')
	DECLARE Entero_Cero				TINYINT;			-- Constante Entero Cero (0)
	DECLARE Constante_NO			CHAR(1);			-- Constante NO (N)
	DECLARE Constante_SI 			CHAR(1);			-- Constante SI (S)
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Constante Decimal Cero (00.00)
	DECLARE Fecha_Vacia				DATE;				-- Fecha Vacia
	DECLARE AportacionConMAS		INT(11);			-- Aportacion con MAS (2)
	DECLARE AportacionConMENOS		INT(11);			-- Aportacion con MENOS (3)
	DECLARE TipoPago_Programado		CHAR(1);			-- Tipo de pago Programado (E)
	DECLARE Actualiza_Estatus		TINYINT UNSIGNED;	-- Opcion de actualizar estatus (3)
	DECLARE Estatus_Autorizado		CHAR(1);			-- Estatus Autorizado



	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:= '';
	SET Entero_Cero				:= 0;
	SET Constante_NO			:= 'N';
	SET Constante_SI			:= 'S';
	SET Decimal_Cero			:= 00.00;
	SET Fecha_Vacia				:= '1900-01-01';
	SET AportacionConMAS		:= 2;
	SET AportacionConMENOS		:= 3;
	SET TipoPago_Programado		:= 'E';
	SET Actualiza_Estatus		:= 3;
	SET Estatus_Autorizado		:= 'A';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr :=	999;
				SET Par_ErrMen :=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-CONDICIONESVENCIMAPORTACT');
				SET Var_Control	:= 'sqlException';
			END;


	IF(IFNULL(Par_AportacionID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:=	1;
			SET Par_ErrMen	:=	'No existe el Numero de Aportacion';
			SET Var_Control	:=	'aportacionID';
			LEAVE ManejoErrores;
		END IF;


	-- 1) ACTUALIZACION DE ESTATUS
	IF(Par_NumAct = Actualiza_Estatus) THEN
		IF(IFNULL(Par_Estatus, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	2;
				SET Par_ErrMen	:=	'El Estatus esta vacio';
				SET Var_Control	:=	Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;


		UPDATE CONDICIONESVENCIMAPORT SET
			Estatus 				= Estatus_Autorizado,

			EmpresaID 				= Par_EmpresaID,
			UsuarioID 				= Aud_Usuario,
			FechaActual 			= Aud_FechaActual,
			DireccionIP 			= Aud_DireccionIP,
			ProgramaID 				= Aud_ProgramaID,
			Sucursal 				= Aud_Sucursal,
			NumTransaccion 			= Aud_NumTransaccion

		WHERE AportacionID = Par_AportacionID;

	END IF;

	SET Par_NumErr := 00;
		SET Par_ErrMen := CONCAT('Condiciones de Vencimiento Autorizadas Exitosamente.');
		SET Var_Control := 'aportacionID';
	END ManejoErrores;

	IF(Par_Salida = Constante_SI)THEN
		SELECT 	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Entero_Cero 	AS consecutivo;
	END IF;


END TerminaStore$$