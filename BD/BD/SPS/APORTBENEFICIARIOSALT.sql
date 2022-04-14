

-- APORTBENEFICIARIOSALT --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTBENEFICIARIOSALT`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `APORTBENEFICIARIOSALT`(
/* SP DE ALTA DE BENEFICIARIOS PARA APORTACIONES */
	Par_AportacionID			INT(11),		-- ID de Aportación.
	Par_AmortizacionID			INT(11),		-- Id de la Amortizacion.
	Par_CuentaTranID			INT(11),		-- No consecutivo de cuentas transfer por cliente.
	Par_InstitucionID			INT(11),		-- Institucion Participante SPEI.
	Par_TipoCuentaSpei			INT(2),			-- Tipo de Cuenta de Envio para SPEI (TIPOSCUENTASPEI).

	Par_Clabe					VARCHAR(20),	-- Numero de Cuenta para Envío SPEI.
	Par_Beneficiario			VARCHAR(100),	-- Nombre del Beneficiario.
	Par_EsPrincipal				CHAR(1),		-- Indica si la Cuenta Destino es Principal. S.- Si N.- No
	Par_MontoDispersion			DECIMAL(18,2),	-- Monto de la Dispersión por Beneficiario.
	Par_MontoTotal				DECIMAL(18,2),	-- Monto Total de la Dispersión.

	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),

	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control			CHAR(15);		-- Nombre del control en pantalla.
DECLARE Var_MontoTotal		DECIMAL(18,2);	-- Monto Total de la Dispersión.

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	Cons_SI				CHAR(1);
DECLARE	Cons_NO				CHAR(1);
DECLARE	EstatusPend			CHAR(1);
DECLARE	ActBeneficiarios	INT(11);
DECLARE Var_MontoPendiente 	DECIMAL(18,2);
DECLARE Var_CuentaAhoID		BIGINT(20);
DECLARE Var_Cliente			INT(11);
DECLARE Var_TotalMontoPen	DECIMAL(18,2);
DECLARE Var_AportBeneficiarioID	BIGINT(20);


-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia.
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero			:= 0;				-- Entero Cero.
SET	Cons_SI				:= 'S';				-- Constante Si.
SET	Cons_NO				:= 'N'; 			-- Constante No.
SET	EstatusPend			:= 'P'; 			-- Estatus Pendiente de Dispersión.
SET ActBeneficiarios	:= 01;				-- Actualizacion de beneficiarios.
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTBENEFICIARIOSALT');
			SET Var_Control:= 'sqlException' ;
		END;

	SET Par_MontoTotal := IFNULL(Par_MontoTotal, Entero_Cero);
	SET Par_MontoDispersion := IFNULL(Par_MontoDispersion, Entero_Cero);

	SET Var_MontoTotal := (SELECT SUM(MontoDispersion) FROM APORTBENEFICIARIOS WHERE AportacionID = Par_AportacionID AND AmortizacionID = Par_AmortizacionID);
	SET Var_MontoTotal := IFNULL(Var_MontoTotal, Entero_Cero) + Par_MontoDispersion;

	/** Si el monto que se está dispersando es mayor al monto total a dispersar (monto de la cuota)
	 ** entonces no se registra el beneficiario.
	 ** */
	IF(Var_MontoTotal > Par_MontoTotal)THEN
		SET	Par_NumErr := 1;
		SET	Par_ErrMen := CONCAT('El Monto a Dispersar es Mayor al Monto por Dispersar:<BR><BR>Monto Por Dispersar: $',FORMAT(Par_MontoTotal,2),'<br>Monto a Dispersar: $',FORMAT(Var_MontoTotal,2));
		SET Var_Control:= 'aportacionID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MontoDispersion, Entero_Cero)=Entero_Cero)THEN
		SET	Par_NumErr := 2;
		SET	Par_ErrMen := CONCAT('El Monto a Dispersar esta Vacio.');
		SET Var_Control:= 'aportacionID' ;
		LEAVE ManejoErrores;
	END IF;

	SET Var_AportBeneficiarioID := (SELECT FolioClabeID FROM FOLIOSAPORTACIONES);
	SET Var_AportBeneficiarioID := IFNULL(Var_AportBeneficiarioID,0) + 1;

	INSERT INTO APORTBENEFICIARIOS(
		AportBeneficiarioID,	AportacionID,		AmortizacionID,		CuentaTranID,			InstitucionID,
		TipoCuentaSpei,			Clabe,				Beneficiario,		EsPrincipal,			MontoDispersion,
		EmpresaID,				UsuarioID,			FechaActual,		DireccionIP,			ProgramaID,
		Sucursal,				NumTransaccion)
	VALUES(
		Var_AportBeneficiarioID,	Par_AportacionID,	Par_AmortizacionID,	Par_CuentaTranID,		Par_InstitucionID,
		Par_TipoCuentaSpei,			Par_Clabe,			Par_Beneficiario,	Par_EsPrincipal,		Par_MontoDispersion,
		Par_EmpresaID,				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,				Aud_NumTransaccion);

	CALL APORTDISPERSIONESACT(
		Par_AportacionID,	Par_AmortizacionID,	Par_CuentaTranID,	Cons_SI,		ActBeneficiarios,	
        Cons_NO,
		Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	UPDATE FOLIOSAPORTACIONES SET FolioClabeID = Var_AportBeneficiarioID;
	
	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT('Beneficiarios Grabados Exitosamente.');
	SET Var_Control:= 'aportacionID' ;

END ManejoErrores;

IF (Par_Salida = Cons_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_AportacionID AS Consecutivo;
END IF;

END TerminaStore$$