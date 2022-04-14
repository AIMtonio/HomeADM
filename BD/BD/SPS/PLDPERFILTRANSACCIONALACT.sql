
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPERFILTRANSACCIONALACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPERFILTRANSACCIONALACT`;

DELIMITER $$
CREATE PROCEDURE `PLDPERFILTRANSACCIONALACT`(
	/*SP que realiza el proceso de Autorizacion/Rechazo de los perfiles transaccionales reales.*/
	Par_ClienteID					INT(11),					# Numero de Cliente
	Par_Fecha						DATE,						# Fecha del Perfil

	Par_AutoRec						CHAR(1),					# A:Autoriza R:Rechaza
	Par_Salida						CHAR(1),					# Indica el tipo de salida S.- SI N.- No

	INOUT Par_NumErr				INT,						# Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				# Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,

	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(12)
	)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);				-- ID del Control en pantalla
	DECLARE Var_Consecutivo 		VARCHAR(200);				-- Numero consecutivo para la imagen a digitalizar
	DECLARE Var_FechaRegistro 		DATE;						-- Fecha en la que se digitalizo el Archivo
	DECLARE Var_TipoProceso			CHAR(1);
	DECLARE Var_AntDepositosMax		DECIMAL(16,2);
	DECLARE Var_AntRetirosMax		DECIMAL(16,2);
	DECLARE Var_AntNumDepositos		INT(11);
	DECLARE Var_AntNumRetiros		INT(11);
	-- Declaracion de constantes
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Cons_NO					CHAR(1);
	DECLARE SalidaSi				CHAR(1);
	DECLARE Autorizado				CHAR(1);
	DECLARE Rechazado				CHAR(1);


	-- Asignacion de constantes
	SET Estatus_Activo			:= 'A';							-- Estatus Activo
	SET Entero_Cero				:=0;							-- Entero Cero
	SET Cadena_Vacia			:= '';							-- Cadena Vacia
	SET Cons_NO					:= 'N';							-- Constante No
	SET Autorizado				:= 'A';							-- Proceso de Autorizacion
	SET Rechazado				:= 'R';							-- Proceso de Rechazo
	SET SalidaSi				:= 'S';							-- Salida Si
	SET Var_TipoProceso			:= 'M';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDPERFILTRANSACCIONALACT');
			SET Var_Control		:= 'sqlException' ;
		END;

		SET Aud_FechaActual		:= NOW();

		INSERT INTO PLDHISPERFILTRANSREAL(
			TransaccionID,	Fecha,				ClienteID,			DepositosMax,	RetirosMax,
			NumDepositos,	NumRetiros,			Estatus,			Hora,			AntDepositosMax,
			AntRetirosMax,	AntNumDepositos,	AntNumRetiros,		NivelRiesgo,	TipoEval,
			FechaInicio,	FechaFin,			EmpresaID,			Usuario,		FechaActual,
			DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion)
		SELECT
			TransaccionID,	Fecha,				ClienteID,			DepositosMax,	RetirosMax,
			NumDepositos,	NumRetiros,			Par_AutoRec,		Hora,			AntDepositosMax,
			AntRetirosMax,	AntNumDepositos,	AntNumRetiros,		NivelRiesgo,	TipoEval,
			FechaInicio,	FechaFin,			EmpresaID,			Usuario,		FechaActual,
			DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion
		FROM PLDPERFILTRANSREAL AS REA
		WHERE REA.ClienteID = Par_ClienteID
			AND REA.Fecha = Par_Fecha;

		IF(Par_AutoRec = Autorizado) THEN
			SELECT
				DepositosMax,			RetirosMax,				NumDepositos,				NumRetiros
			INTO
				Var_AntDepositosMax,	Var_AntRetirosMax,		Var_AntNumDepositos,		Var_AntNumRetiros
			FROM PLDPERFILTRANS
			WHERE ClienteID = Par_ClienteID;

			UPDATE PLDPERFILTRANS AS PLD
				INNER JOIN PLDPERFILTRANSREAL AS REA ON PLD.ClienteID = REA.ClienteID
			SET
				PLD.DepositosMax 		= IF(REA.DepositosMax>0,REA.DepositosMax,PLD.DepositosMax),
				PLD.RetirosMax 			= IF(REA.RetirosMax>0,REA.RetirosMax,PLD.RetirosMax),
				PLD.NumDepositos 		= IF(REA.NumDepositos>0,REA.NumDepositos,PLD.NumDepositos),
				PLD.NumRetiros 			= IF(REA.NumRetiros>0,REA.NumRetiros,PLD.NumRetiros),
				PLD.TipoProceso			= 'A',
				PLD.AntDepositosMax		= Var_AntDepositosMax,
				PLD.AntRetirosMax		= Var_AntRetirosMax,
				PLD.AntNumDepositos		= Var_AntNumDepositos,
				PLD.AntNumRetiros		= Var_AntNumRetiros,
				PLD.Hora				= CURRENT_TIME(),
				PLD.EmpresaID 			= Aud_EmpresaID,
				PLD.Usuario 			= Aud_Usuario,
				PLD.FechaActual 		= Aud_FechaActual,
				PLD.DireccionIP 		= Aud_DireccionIP,
				PLD.ProgramaID 			= Aud_ProgramaID,
				PLD.Sucursal 			= Aud_Sucursal,
				PLD.NumTransaccion 		= Aud_NumTransaccion
			WHERE PLD.ClienteID = Par_ClienteID
				AND REA.Fecha = Par_Fecha;

			CALL PLDPERFILTRANSHISALT(
				Par_ClienteID,		Entero_Cero,			Cons_NO,				Par_NumErr,				Par_ErrMen,
				Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion
			);

			IF(Par_NumErr!=Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			/*Se calcula el Nivel de Riesgo del Nuevo Cliente ################################################################################# */
			CALL RIESGOPLDCTEPRO(
				Par_ClienteID,		Cons_NO,        	Par_NumErr,       	Par_ErrMen,   Aud_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal, Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
			  LEAVE ManejoErrores;
			END IF;
			/*FIN de Calculo de Nivel de Riesgo del Nuevo Cliente ############################################################################# */
		END IF;

		DELETE FROM PLDPERFILTRANSREAL
			WHERE ClienteID = Par_ClienteID AND Fecha = Par_Fecha;

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('Perfil Transaccional Actualizado Exitosamente');
		SET Var_Control 	:= 'sucursalID' ;
		SET Var_Consecutivo	:= 0;
	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$

