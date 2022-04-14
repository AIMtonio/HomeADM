-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANAUTCRECONAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS CANAUTCRECONAGROPRO;

DELIMITER $$
CREATE PROCEDURE CANAUTCRECONAGROPRO(
	-- Store Procedure para Cancelacion Automatica de Creditos Consolidados Agro
	-- Cierre de Dia -->  Proceso de Cierre de Cartera --> Cancelacion Automatica
	Par_Fecha				DATE,			-- Fecha de Cancelacion

	Par_Salida				CHAR(1),		-- Indica si se muestra mensaje de exito o no
	INOUT Par_NumErr		INT(11),		-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de error

	Aud_EmpresaID			INT(11),		-- Parametro de auditoria
	Aud_Usuario				INT(11),		-- Parametro de auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal			INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_CanAutConsolidacionAgro	CHAR(1);	-- Cancelacion Automatica de Créditos Consolidados Agro posterior a la fecha de Desembolso.

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;		-- Constante Fecha Vacia
	DECLARE Entero_Cero				INT(11);	-- Constante Entero en Cero
	DECLARE Cadena_Vacia			CHAR(1);	-- Constante Cadena Vacia
	DECLARE SalidaSI				CHAR(1);	-- Constante Salida SI
	DECLARE SalidaNO				CHAR(1);	-- Constante Salida NO

	DECLARE Con_SI					CHAR(1);	-- Constante SI
	DECLARE Con_NO					CHAR(1);	-- Constante NO
	DECLARE Est_Cancelado			CHAR(1);	-- Estatus Credito Cancelado
	DECLARE Est_Autorizado			CHAR(1);	-- Constante Estatus Autorizado
	DECLARE Est_Inactivo			CHAR(1);	-- Constante Estatus Inactivo

	DECLARE Con_ProgramaID					VARCHAR(50);	-- Descripcion de movimiento
	DECLARE Llave_CanAutConsolidacionAgro	VARCHAR(50);		-- Llave EjecucionCierreDia

	-- Asignacion de constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';
	SET SalidaSI				:= 'S';
	SET SalidaNO				:= 'N';

	SET Con_SI					:= 'S';
	SET Con_NO					:= 'N';
	SET Est_Cancelado			:= 'C';
	SET Est_Autorizado			:= 'A';
	SET Est_Inactivo			:= 'I';

	SET Con_ProgramaID					:= 'CARTERACIEDIAPRO.CANAUTCRECONAGROPRO';
	SET Llave_CanAutConsolidacionAgro	:= 'CanAutConsolidacionAgro';

	-- Bloque de Manejo de Errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr 	:= 999;
			SET Par_ErrMen 	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-CANAUTCRECONAGROPRO');
		END;


		SET Var_CanAutConsolidacionAgro	:= IFNULL(FNPARAMGENERALES(Llave_CanAutConsolidacionAgro), Con_NO);

		IF( Var_CanAutConsolidacionAgro = Con_SI ) THEN

			SET Aud_ProgramaID := Con_ProgramaID;

			/* SE RECICLA EL NUMERO DE LA CUENTA CLABE*/
			INSERT INTO FOLIOSCTACANCEL(
					FolioClabeID,		CreditoID,		EmpresaID,		Usuario,			FechaActual,
					DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)
			SELECT	Cre.CuentaCLABE,	Cre.CreditoID,	Aud_EmpresaID,	Aud_Usuario,		NOW(),
					Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
			FROM CRECONSOLIDAAGROENC Enc
			INNER JOIN CREDITOS Cre ON Enc.CreditoID = Cre.CreditoID
			WHERE Enc.FechaDesembolso <= Par_Fecha
			  AND Enc.Estatus = Est_Autorizado
			  AND Cre.CuentaCLABE != Cadena_Vacia
			  AND Cre.Estatus IN (Est_Autorizado, Est_Inactivo);

			UPDATE CRECONSOLIDAAGROENC Enc
			INNER JOIN CRECONSOLIDAAGRODET Det ON Enc.FolioConsolida = Det.FolioConsolida
			INNER JOIN CREDITOS Cre ON Enc.CreditoID = Cre.CreditoID SET
				Det.Estatus			= Est_Cancelado,
				Det.EmpresaID		= Aud_EmpresaID,
				Det.Usuario			= Aud_Usuario,
				Det.FechaActual		= NOW(),
				Det.DireccionIP		= Aud_DireccionIP,
				Det.ProgramaID		= Aud_ProgramaID,
				Det.Sucursal		= Aud_Sucursal,
				Det.NumTransaccion	= Aud_NumTransaccion,

				Enc.Estatus			= Est_Cancelado,
				Enc.EmpresaID		= Aud_EmpresaID,
				Enc.Usuario			= Aud_Usuario,
				Enc.FechaActual		= NOW(),
				Enc.DireccionIP		= Aud_DireccionIP,
				Enc.ProgramaID		= Aud_ProgramaID,
				Enc.Sucursal		= Aud_Sucursal,
				Enc.NumTransaccion	= Aud_NumTransaccion,

				Cre.Estatus			= Est_Cancelado,
				Cre.CuentaCLABE		= Cadena_Vacia,
				Cre.EmpresaID		= Aud_EmpresaID,
				Cre.Usuario			= Aud_Usuario,
				Cre.FechaActual		= NOW(),
				Cre.DireccionIP		= Aud_DireccionIP,
				Cre.ProgramaID		= Aud_ProgramaID,
				Cre.Sucursal		= Aud_Sucursal,
				Cre.NumTransaccion	= Aud_NumTransaccion
			WHERE Enc.FechaDesembolso <= Par_Fecha
			  AND Enc.Estatus = Est_Autorizado
			  AND Cre.Estatus IN (Est_Autorizado, Est_Inactivo);
		END IF;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= 'Cancelacion Automatica de Creditos Consolidados Realizada Correctamente';

	END ManejoErrores;
	-- Fin Bloque de Manejo de Errores

	IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$