-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGRODETACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAAGRODETACT`;

DELIMITER $$
CREATE PROCEDURE `CRECONSOLIDAAGRODETACT`(
	-- Store Procedure para la actualizacion de los creditos consolidados agro
	-- Solicitud de Credito Agro --> Registro --> Autorizacion de Solicitud de Credito
	Par_FolioConsolida		BIGINT(12),			-- Folio de Consolidacion
	Par_NumAct				TINYINT UNSIGNED,	-- Numero de Actualizacion

	Par_Salida				CHAR(1),			-- Indica si se muestra mensaje de exito o no
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de error

	Par_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				 VARCHAR(100);	-- Control de Retorno en pantalla
	DECLARE Var_FolioConsolidacionID BIGINT(12);	-- Varariable Folio de Consolidacion


	-- Declaracion de constantes
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(11);		-- Constante Entero en Cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante String Vacio
	DECLARE Salida_SI			CHAR(1);		-- Constante Salida SI
	DECLARE Salida_NO			CHAR(1);		-- Constante Salida NO

	DECLARE Cons_SI				CHAR(1);		-- Constante SI
	DECLARE Cons_NO				CHAR(1);		-- Constante NO
	DECLARE Est_Autorizada		CHAR(1);		-- Constante Estatus Autorizado
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Constante Decimal Cero

	-- Declaracion de Actualizaciones
	DECLARE Act_EstAutorizado	TINYINT UNSIGNED;	-- Actualizacion a Estatus Autorizado

	-- Asignacion de constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';
	SET Salida_NO				:= 'N';

	SET Cons_SI					:= 'S';
	SET Cons_NO					:= 'N';
	SET Est_Autorizada			:= 'A';
	SET Decimal_Cero			:= 0.00;

	-- Asignacion de Actualizaciones
	SET Act_EstAutorizado		:= 1;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECONSOLIDAAGRODETACT');
			SET Var_Control := 'sqlexception';
		END;

		SET Par_FolioConsolida := IFNULL(Par_FolioConsolida,Entero_Cero);
		IF( Par_FolioConsolida = Entero_Cero)THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Folio de Consolidacion esta Vacio.';
			SET Var_Control := 'folioConsolidacionID';
			LEAVE ManejoErrores;
		END IF;

		SELECT FolioConsolida
		INTO Var_FolioConsolidacionID
		FROM CRECONSOLIDAAGROENC
		WHERE FolioConsolida = Par_FolioConsolida;

		SET Var_FolioConsolidacionID := IFNULL(Var_FolioConsolidacionID, Entero_Cero);
		IF(Var_FolioConsolidacionID = Entero_Cero)THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El Folio de Consolidacion No Existe.';
			SET Var_Control := 'folioConsolidacionID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumAct = Act_EstAutorizado )THEN

			SET Aud_FechaActual := NOW();
			UPDATE CRECONSOLIDAAGRODET SET
				Estatus			= Est_Autorizada,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE FolioConsolida = Par_FolioConsolida;

		END IF;

		SET Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= 'Credito Consolidado Actualizado Exitosamente';
		SET Var_Control	:= 'solicitudCreditoID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$