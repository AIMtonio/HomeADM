-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDTASAPASIVAAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDTASAPASIVAAGROALT`;DELIMITER $$

CREATE PROCEDURE `CREDTASAPASIVAAGROALT`(
/* SP DE ALTA PARA TASAS PASIVAS */
	Par_CreditoID				BIGINT(12),		-- Número del Crédito.
	Par_SolicitudCreditoID		BIGINT(12),		-- Número de la Solicitud de Crédito.
	Par_TasaPasiva				DECIMAL(14,4),	-- Valor de la Tasa Pasiva.
	Par_TipoAlta				TINYINT,		-- Tipo de Alta. 1.-Solicitud 2.- Credito.
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
DECLARE	Var_Control		CHAR(15);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI		CHAR(1);
DECLARE	SalidaNO		CHAR(1);
DECLARE	TipoSolCred		INT(11);
DECLARE	TipoCredito		INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI			:= 'S';				-- Salida Si
SET	SalidaNO			:= 'N'; 			-- Salida No
SET TipoSolCred			:= 01;				-- Tipo de alta Solicitud de Crédito
SET TipoCredito			:= 02;				-- Tipo de alta Crédito
SET Aud_FechaActual		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDTASAPASIVAAGROALT');
			SET Var_Control:= 'sqlException' ;
		END;

	SET Par_TasaPasiva := IFNULL(Par_TasaPasiva, Entero_Cero);

	IF(IFNULL(Par_TipoAlta,Entero_Cero) = TipoSolCred)THEN
		IF(IFNULL(Par_SolicitudCreditoID, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El Número de Credito y de Solicitud esta Vacia.';
			SET Var_Control:= 'solicitudCredID' ;
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM CREDTASAPASIVAAGRO
			WHERE SolicitudCreditoID = IFNULL(Par_SolicitudCreditoID, Entero_Cero);
	END IF;

	IF(IFNULL(Par_TipoAlta,Entero_Cero) = TipoCredito)THEN
		IF(IFNULL(Par_CreditoID, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Número de Credito y de Solicitud esta Vacia.';
			SET Var_Control:= 'solicitudCredID' ;
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM CREDTASAPASIVAAGRO
			WHERE CreditoID = IFNULL(Par_CreditoID, Entero_Cero);
	END IF;

	INSERT INTO CREDTASAPASIVAAGRO(
		CreditoID,			SolicitudCreditoID,		TasaPasiva,			EmpresaID,			Usuario,
		FechaActual,		DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
	VALUES(
		Par_CreditoID,		Par_SolicitudCreditoID, Par_TasaPasiva,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Tasa Pasiva Grabada Exitosamente.';
	SET Var_Control:= 'creditoID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_CreditoID AS Consecutivo;
END IF;

END TerminaStore$$