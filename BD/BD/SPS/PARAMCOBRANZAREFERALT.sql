-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMCOBRANZAREFERALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMCOBRANZAREFERALT`;
DELIMITER $$

CREATE PROCEDURE `PARAMCOBRANZAREFERALT`(
	-- SP PARA DAR DE ALTA LOS PARAMETROS DE COBRANZA REFERENCIADOS
	Par_ConsecutivoID			INT(11),		-- ID o Numero de Parametros de Deposito referenciados,
	Par_AplicaCobranzaRef		CHAR(1),		-- Indica SI aplica Cobranza Referenciado: S=SI ,N=NO,
	Par_ProducCreditoID			INT(11),		-- ID o Numero del producto de credito,

	Par_Salida					CHAR(1),		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr			INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen			VARCHAR(400),	-- Parametro de salida mensaje de error

	Aud_EmpresaID				INT(11),		-- Parametro de Auditoria
	Aud_Usuario					INT(11),		-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de Auditoria
)TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control					VARCHAR(100);	-- Variable de control
	DECLARE Var_Consecutivo				INT(11);		-- Variable Consecutivo
	DECLARE Var_ParamCobranzaReferID	INT(11);		-- Variable para almacenar el numero de parametro cobranza referenciado

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero				TINYINT;		-- Constante Entero Cero
	DECLARE Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE Salida_SI				CHAR(1);		-- Constante Salida SI
	DECLARE Con_SI					CHAR(1);		-- Constante para valor S
	DECLARE Con_NO					CHAR(1);		-- Constante para valor N

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero					:= 0;			-- Constante Entero Cero
	SET Cadena_Vacia				:= '';			-- Constante Cadena Vacia
	SET Salida_SI					:= 'S';			-- Constante Salida SI
	SET Con_SI						:= 'S';			-- Constante para valor S
	SET Con_NO						:= 'N';			-- Constante para valor N

	-- Seteo de variables por defaul
	SET Par_ConsecutivoID			:= IFNULL(Par_ConsecutivoID,Entero_Cero);
	SET Par_AplicaCobranzaRef		:= IFNULL(Par_AplicaCobranzaRef,Cadena_Vacia);
	SET Par_ProducCreditoID			:= IFNULL(Par_ProducCreditoID,Entero_Cero);
	
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-PARAMCOBRANZAREFERALT');
			SET Var_Control = 'SQLEXCEPTION';
			SET Var_Consecutivo	:= Entero_Cero;
		END;

		IF(Par_ConsecutivoID = Entero_Cero) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El Numero de Deposito Referenciado se Encuentra Vacio.';
			SET Var_Control		:= 'consecutivoID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ConsecutivoID FROM PARAMDEPREFER WHERE ConsecutivoID = Par_ConsecutivoID) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'El Numero de Deposito Referenciado no existe.';
			SET Var_Control		:= 'consecutivoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_AplicaCobranzaRef = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'Aplica Cobranza Referenciado esta Vacia.';
			SET Var_Control		:= 'aplicaCobranzaRef';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ProducCreditoID = Entero_Cero) THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'El Numero de Producto de Credito se Encuentra Vacio.';
			SET Var_Control		:= 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ProducCreditoID FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProducCreditoID) THEN
			SET Par_NumErr 		:= 5;
			SET Par_ErrMen 		:= 'El Numero de Producto de Credito No existe.';
			SET Var_Control		:= 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL(MAX(ParamCobranzaReferID),Entero_Cero) + 1
			INTO Var_ParamCobranzaReferID
			FROM PARAMCOBRANZAREFER;

		INSERT INTO PARAMCOBRANZAREFER(	ParamCobranzaReferID,		ConsecutivoID,		AplicaCobranzaRef,		ProducCreditoID,		EmpresaID,
										Usuario,					FechaActual,		DireccionIP,			ProgramaID,				Sucursal,
										NumTransaccion)

					VALUES			(	Var_ParamCobranzaReferID,	Par_ConsecutivoID,	Par_AplicaCobranzaRef,	Par_ProducCreditoID,	Aud_EmpresaID,
										Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
										Aud_NumTransaccion);

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= CONCAT('Registro de Parametros Cobranza Referenciado Realizada Exitosamente.');
		SET Var_Control		:= 'paramCobranzaRefer';
		SET Var_Consecutivo	:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
