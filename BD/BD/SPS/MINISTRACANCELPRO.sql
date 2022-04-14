-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRACANCELPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINISTRACANCELPRO`;DELIMITER $$

CREATE PROCEDURE `MINISTRACANCELPRO`(
/* SP QUE CANCELA LA MINISTRACION DE ACUERDO AL METODO DE PREPAGO */
	Par_CreditoID					BIGINT(12),			-- Número del Crédito Activo (CREDITOS).
	Par_Numero						INT(11),			-- Número de la Ministración a Cancelar.
	Par_Salida						CHAR(1),			-- Tipo de Salida.
	INOUT Par_NumErr				INT(11),			-- Número de Error.
	INOUT Par_ErrMen				VARCHAR(400),		-- Mensaje de Error.

	/* Parametros de Auditoria */
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),

	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_TipoCancelacion			CHAR(1);			-- Tipo de Cancelación
DECLARE Var_Consecutivo				BIGINT(12);			-- Número consecutivo
DECLARE Var_Control					VARCHAR(50);		-- Control id
DECLARE Var_CreditoFondeoID			BIGINT(20);			-- Id del credito pasivo
DECLARE Var_TipoFondeo				CHAR(1);			-- Tipo de Fondeo: P .- Recursos Propios F .- Institucion de Fondeo

-- Declaracion de Constantes
DECLARE Cadena_Vacia				CHAR(1);
DECLARE Fecha_Vacia					DATE;
DECLARE Entero_Cero					INT;
DECLARE Entero_Uno					INT;
DECLARE Decimal_Cero				DECIMAL(12, 2);
DECLARE SalidaSI					CHAR(1);
DECLARE SalidaNO					CHAR(1);
DECLARE Tipo_InstitucionFondeo		CHAR(1);
DECLARE EstatusVigente				CHAR(1);
-- Asignacion de Constantes
SET Cadena_Vacia    				:= '';              -- Cadena Vacia
SET Fecha_Vacia     				:= '1900-01-01';	-- Fecha Vacia
SET Entero_Cero     				:= 0;               -- Entero en Cero
SET Entero_Uno   					:= 1;    	        -- Entero en Uno
SET Decimal_Cero    				:= 0.00;            -- Decimal Cero
SET SalidaSI        				:= 'S';             -- El Store si Regresa una Salida
SET SalidaNO        				:= 'N';             -- El Store no Regresa una Salida
SET Tipo_InstitucionFondeo			:= 'F';				-- Fondeo por Financiamiento
SET EstatusVigente					:= 'V';				-- Estatus vigente

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-MINISTRACANCELPRO');
			SET Var_Control := 'sqlException';
		END;

-- Se obiente el tipo de cancelación y el tipo de fondeo
SELECT Cre.TipoCancelacion, Cre.TipoFondeo
INTO Var_TipoCancelacion, Var_TipoFondeo
	FROM CREDITOS Cre WHERE Cre.CreditoID = Par_CreditoID;

SET Var_TipoCancelacion	:= IFNULL(Var_TipoCancelacion, Cadena_Vacia);
SET Var_TipoFondeo		:= IFNULL(Var_TipoFondeo, Cadena_Vacia);


-- Se realiza la cancelación del Crédito Activo.
CALL MINCREDCANCELPRO(
	Par_CreditoID, 			Par_Numero, 			SalidaNO, 			Par_NumErr, 		Par_ErrMen,
	Aud_EmpresaID, 			Aud_Usuario, 			Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,
	Aud_Sucursal, 			Aud_NumTransaccion);

IF(Par_NumErr != Entero_Cero)THEN
	LEAVE ManejoErrores;
END IF;


-- Si el crédito es Fondeado por alguna Institución, se obtiene su crédito pasivo
IF(Var_TipoFondeo = Tipo_InstitucionFondeo) THEN
	SET Var_CreditoFondeoID := (SELECT CreditoFondeoID FROM RELCREDPASIVOAGRO WHERE CreditoID = Par_CreditoID LIMIT 1);
	-- Se realiza la cancelación del Crédito Pasivo (Fondeo).

	IF(IFNULL(Var_CreditoFondeoID, Entero_Cero) != Entero_Cero)THEN
		CALL MINFONDEOCANCELPRO(
			Par_CreditoID,			Var_CreditoFondeoID,	Par_Numero,			SalidaNO,			Par_NumErr,
			Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal, 			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;
END IF;

SET Par_NumErr	:= Entero_Cero;
SET Par_ErrMen	:= 'Ministracion de Credito Cancelada Exitosamente.';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Aud_NumTransaccion AS Consecutivo;
	END IF;

END TerminaStore$$