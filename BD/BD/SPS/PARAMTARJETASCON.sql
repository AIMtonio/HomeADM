-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMTARJETASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS PARAMTARJETASCON;

DELIMITER $$
CREATE PROCEDURE `PARAMTARJETASCON`(
	-- Store Procedure de Consulta de los Parametros de Tarjetas
	Par_NumConsulta			TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore : BEGIN

	-- Declaracion de Constantes
	DECLARE Var_AutorizaTerceroTranTD		VARCHAR(200);	-- Variable para almacenar el valor del campo AutorizaTerceroTranTD
	DECLARE Var_RutaConWSAutoriza			VARCHAR(200);	-- Variable para almacenar el valor del campo RutaConWSAutoriza
	DECLARE Var_TimeOutConWSAutoriza		VARCHAR(200);	-- Variable para almacenar el valor del campo TimeOutConWSAutoriza
	DECLARE Var_UsuarioConWSAutoriza		VARCHAR(200);	-- Variable para almacenar el valor del campo UsuarioConWSAutoriza
	DECLARE Var_IDEmisor					VARCHAR(200);	-- Variable para almacenar el valor del campo IDEmisor
	DECLARE Var_PrefijoEmisor				VARCHAR(200);	-- Variable para almacenar el valor del campo PrefijoEmisor

	-- Declaracion de Constantes
	DECLARE Llave_AutorizaTerceroTranTD		VARCHAR(50);	-- Llave AutorizaTerceroTranTD
	DECLARE Llave_RutaConWSAutoriza			VARCHAR(50);	-- Llave RutaConWSAutoriza
	DECLARE Llave_TimeOutConWSAutoriza		VARCHAR(50);	-- Llave TimeOutConWSAutoriza
	DECLARE Llave_UsuarioConWSAutoriza		VARCHAR(50);	-- Llave UsuarioConWSAutoriza
	DECLARE Llave_IDEmisor					VARCHAR(50);	-- Llave IDEmisor
	DECLARE Llave_PrefijoEmisor				VARCHAR(50);	-- Llave PrefijoEmisor

	-- Declaracion de Consultas
	DECLARE Con_Principal					TINYINT UNSIGNED;

	-- Asignacion de Constantes
	SET Llave_AutorizaTerceroTranTD		:= 'AutorizaTerceroTranTD';
	SET Llave_RutaConWSAutoriza			:= 'RutaConWSAutoriza';
	SET Llave_TimeOutConWSAutoriza		:= 'TimeOutConWSAutoriza';
	SET Llave_UsuarioConWSAutoriza		:= 'UsuarioConWSAutoriza';
	SET Llave_IDEmisor					:= 'IDEmisor';
	SET Llave_PrefijoEmisor				:= 'PrefijoEmisor';

	-- Asignacion de Consultas
	SET Con_Principal					:= 1;

	-- Consulta Principal
	IF( Par_NumConsulta = Con_Principal ) THEN

		SET Var_AutorizaTerceroTranTD 	:= FNPARAMTARJETAS(Llave_AutorizaTerceroTranTD);
		SET Var_RutaConWSAutoriza 		:= FNPARAMTARJETAS(Llave_RutaConWSAutoriza);
		SET Var_TimeOutConWSAutoriza 	:= FNPARAMTARJETAS(Llave_TimeOutConWSAutoriza);
		SET Var_UsuarioConWSAutoriza 	:= FNPARAMTARJETAS(Llave_UsuarioConWSAutoriza);
		SET Var_IDEmisor			 	:= FNPARAMTARJETAS(Llave_IDEmisor);
		SET Var_PrefijoEmisor		 	:= FNPARAMTARJETAS(Llave_PrefijoEmisor);


		SELECT	Var_AutorizaTerceroTranTD AS AutorizaTerceroTranTD, Var_RutaConWSAutoriza AS RutaConWSAutoriza,
				Var_TimeOutConWSAutoriza AS TimeOutConWSAutoriza,	Var_UsuarioConWSAutoriza AS UsuarioConWSAutoriza,
				Var_IDEmisor AS IDEmisor,							Var_PrefijoEmisor AS PrefijoEmisor;

	END IF;
END TerminaStore$$
