-- SP ESQCOMAPERNOMINAALT

DELIMITER ;

DROP PROCEDURE IF EXISTS ESQCOMAPERNOMINAALT;

DELIMITER $$

CREATE PROCEDURE  ESQCOMAPERNOMINAALT(
	Par_InstitNominaID		INT(11),			-- Numero de Institucion Nomina
	Par_ProducCreditoID		INT(11),			-- Numero de Producto de Credito;
	Par_ManejaEsqConvenio	CHAR(1),			-- Indica si el Esquema es por Convenio

	Par_Salida				CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr		INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro de entrada/salida de mensaje de control de respuesta

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria ID de la Empresa
	Aud_Usuario				INT(11),			-- Parametro de Auditoria ID del Usuario
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria ID de la Sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria Numero de la Transaccion
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control
	DECLARE Var_EsquemaComApertID	BIGINT(12);			-- Consecutivo siguiente al ultimo ID de la tabla ESQCOMAPERNOMINA

	-- Declaracion de Constantes
	DECLARE Var_Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE Var_Entero_Cero				INT(1);				-- Entero Cero
	DECLARE Var_Decimal_Cero			DECIMAL(12,2);		-- Decimal Cero
	DECLARE Var_Fecha_Vacia				DATE;				-- Constante para fecha vacia
	DECLARE Var_SalidaSI				CHAR(1);			-- Salida Si

	DECLARE Var_SalidaNO				CHAR(1);			-- Salida No

	-- Asignacion de Constantes
	SET Var_Cadena_Vacia				:= '';				-- Constante Cadena Vacia
	SET Var_Entero_Cero					:= 0;				-- Entero Cero
	SET Var_Decimal_Cero				:= 0.0;				-- Decimal Cero
	SET Var_Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
	SET Var_SalidaSI					:= 'S';				-- Salida Si

	SET Var_SalidaNO					:= 'N';				-- Salida No

ManejoErrores:BEGIN


	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQCOMAPERNOMINAALT');
		SET Var_Control	= 'SQLEXCEPTION';
	END;


	IF(IFNULL(Par_ProducCreditoID, Var_Entero_Cero) = Var_Entero_Cero) THEN
		SET Par_NumErr	:= 001;
		SET Par_ErrMen	:= 'El Producto de Nomina se encuentra Vacio.';
		SET Var_Control	:= 'producCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS (SELECT InstitNominaID FROM INSTITNOMINA WHERE InstitNominaID = Par_InstitNominaID) THEN
		SET Par_NumErr	:= 001;
		SET Par_ErrMen	:= 'La Institución de nómina no existe.';
		SET Var_Control	:= 'institNominaID';
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS (SELECT producCreditoID FROM PRODUCTOSCREDITO WHERE producCreditoID = Par_ProducCreditoID) THEN
		SET Par_NumErr	:= 001;
		SET Par_ErrMen	:= 'El producto no existe.';
		SET Var_Control	:= 'producCreditoID';
		LEAVE ManejoErrores;
	END IF;

	SET Var_EsquemaComApertID := (SELECT IFNULL(MAX(EsqComApertID),Var_Entero_Cero)+1 FROM ESQCOMAPERNOMINA);


	SET Aud_FechaActual := NOW();

	INSERT INTO ESQCOMAPERNOMINA
		(
		EsqComApertID,			InstitNominaID,		ProducCreditoID,		ManejaEsqConvenio,		EmpresaID,
		Usuario,				FechaActual,		DireccionIP,			ProgramaID,				Sucursal,
		NumTransaccion
		)
	VALUES
		(
		Var_EsquemaComApertID,	Par_InstitNominaID,	Par_ProducCreditoID,	Par_ManejaEsqConvenio,	Par_EmpresaID,
		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
		Aud_NumTransaccion
		);

	SET Par_NumErr	:= Var_Entero_Cero;
	SET Par_ErrMen	:= 'Esquema Cobro de Comision por Apertura Grabado Exitosamente.';
	SET Var_Control	:= 'institNominaID';

END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS Control,
				Var_EsquemaComApertID	AS Consecutivo;

	END IF;

END TerminaStore$$
