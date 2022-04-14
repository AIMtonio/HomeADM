-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTECONSOLIDADOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTECONSOLIDADOCON`;

DELIMITER $$
CREATE PROCEDURE `CLIENTECONSOLIDADOCON`(
	-- Store Procedure para validar si un cliente cumple los requisitos para ser un titular de un credito consolidado
	Par_ClienteID				INT(11),			-- Numero de Cliente
	Par_NumConsulta				TINYINT UNSIGNED,	-- Numero de Validacion

	Par_EmpresaID				INT(11),			-- Parametro de Auditoria Empresa ID
	Aud_Usuario					INT(11),			-- Parametro de Auditoria Usuario ID
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria Programa ID
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria Sucursal ID
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria Numero Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_EsClienteConsolidado CHAR(1);		-- Es Cliente Consolidado
	DECLARE Var_Identificacion		INT(11);		-- Identificacion Oficial
	DECLARE Var_Direccion			INT(11);		-- Direccion Oficial
	DECLARE Var_CuentaAhorro		INT(11);		-- Cuenta de Ahorro
	DECLARE Var_ClienteID			INT(11);		-- Numero de Cliente

	-- Declaracion de Validacion
	DECLARE Con_ClienteConsolidado	TINYINT UNSIGNED;-- Consulta para validar si el cliente es Consolidado

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia				DATE;			-- Constante Fecha Vacia
	DECLARE Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE Con_SI					CHAR(1);		-- Constante SI
	DECLARE Con_NO					CHAR(1);		-- Constante NO
	DECLARE Est_Activa				CHAR(1);		-- Constante Estatus activo

	DECLARE Entero_Cero				INT(11);		-- Constante Entero Cero
	DECLARE Decimal_Cero			DECIMAL(12,0);	-- Constante Decimal Cero

	-- Declaracion de Validacion
	SET Con_ClienteConsolidado		:= 1;

	-- Asignacion de Constantes
	SET Fecha_Vacia					:= '1900-01-01';
	SET Cadena_Vacia				:= '';
	SET Con_SI						:= 'S';
	SET Con_NO						:= 'N';
	SET Est_Activa					:= 'A';

	SET Entero_Cero					:= 0;
	SET Decimal_Cero				:= 0.00;

	IF(Par_NumConsulta = Con_ClienteConsolidado) THEN

		SET Var_EsClienteConsolidado := Con_NO;

		SELECT IFNULL( COUNT(ClienteID), Entero_Cero)
		INTO Var_ClienteID
		FROM CLIENTES
		WHERE ClienteID = Par_ClienteID;

		SELECT IFNULL( COUNT(ClienteID), Entero_Cero)
		INTO Var_Identificacion
		FROM IDENTIFICLIENTE
		WHERE ClienteID = Par_ClienteID
		  AND Oficial = Con_SI;

		SELECT IFNULL( COUNT(DireccionID), Entero_Cero)
		INTO Var_Direccion
		FROM DIRECCLIENTE
		WHERE ClienteID = Par_ClienteID
		  AND Oficial = Con_SI;

		SELECT IFNULL( COUNT(CuentaAhoID), Entero_Cero)
		INTO Var_CuentaAhorro
		FROM CUENTASAHO
		WHERE ClienteID = Par_ClienteID
		  AND Estatus = Est_Activa
		  AND EsPrincipal = Con_SI;

		IF( Var_Identificacion > Entero_Cero AND Var_Direccion > Entero_Cero AND
			Var_CuentaAhorro > Entero_Cero   AND Var_ClienteID > Entero_Cero) THEN
			SET Var_EsClienteConsolidado := Con_SI;
		END IF;

		SELECT 	Par_ClienteID AS ClienteID,
				Var_Identificacion AS Identificacion,
				Var_Direccion AS Direccion,
				Var_CuentaAhorro AS CuentaAhorro,
				Var_EsClienteConsolidado AS EsClienteConsolidado;
	END IF;

END TerminaStore$$