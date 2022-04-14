-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGNATIPOTARJETAWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGNATIPOTARJETAWSCON`;

DELIMITER $$
CREATE PROCEDURE `ASIGNATIPOTARJETAWSCON`(
	-- Store Procedure de Validacion el cual determina si la tarjeta es de credito o de debito y con ella
	-- Se realiza el consumo de los recursos correspondientes por de Web Service
	-- Tarjetas de Credito y Debito --> Web Service
	Par_CardNumber					CHAR(16),		-- Numero de Tarjeta de Credito y Debito
	Par_NumConsulta					TINYINT UNSIGNED,-- Numero de Consulta

	Par_EmpresaID					INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario						INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual					DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP					VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID					VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal					INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion				BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_TipoTarjeta			CHAR(1);			-- Indica el Tipo de Tarjeta
	DECLARE Var_TarjetaCreditoID	CHAR(16);			-- Numero de Tarjeta de Credito
	DECLARE Var_TarjetaDebitoID		CHAR(16);			-- Numero de Tarjeta de Debito

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE TarjetaCredito			CHAR(1);			-- Constante Tarjeta Credito
	DECLARE TarjetaDebito			CHAR(1);			-- Constante Tarjeta Debito
	DECLARE Con_NO					CHAR(1);			-- Constante SI
	DECLARE Con_SI					CHAR(1);			-- Constante NO

	DECLARE Con_TarjetaActiva		INT(11);			-- Constante Estatus Activo de Tarjetas
	DECLARE Entero_Cero				INT(11);			-- Constante Entero Cero
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Constante Decimal Cero

	-- Declaracion de Consultasa
	DECLARE Con_Principal			TINYINT UNSIGNED;	-- Consulta Principal

	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';
	SET TarjetaCredito			:= 'C';
	SET TarjetaDebito			:= 'D';
	SET Con_NO					:= 'N';
	SET Con_SI					:= 'S';

	SET Con_TarjetaActiva		:= 7;
	SET Entero_Cero				:= 0;
	SET Decimal_Cero			:= 0.00;

	-- Declaracion de Consultasa
	SET Con_Principal			:= 1;

	-- Consulta Principal
	IF( Par_NumConsulta = Con_Principal ) THEN

		-- Valores Default para los Parametros de Entrada
		SET Par_CardNumber	:= IFNULL(Par_CardNumber, Cadena_Vacia);
		SET Var_TipoTarjeta	:= Cadena_Vacia;

		SELECT	TarjetaCredID
		INTO 	Var_TarjetaCreditoID
		FROM TARJETACREDITO
		WHERE TarjetaCredID = Par_CardNumber
		  AND Estatus = Con_TarjetaActiva;

		SET Var_TarjetaCreditoID := IFNULL(Var_TarjetaCreditoID, Cadena_Vacia);

		IF( Var_TarjetaCreditoID <> Cadena_Vacia ) THEN
			SET Var_TipoTarjeta := TarjetaCredito;
		END IF;

		SELECT	TarjetaDebID
		INTO 	Var_TarjetaDebitoID
		FROM TARJETADEBITO
		WHERE TarjetaDebID = Par_CardNumber
		  AND Estatus = Con_TarjetaActiva;

		SET Var_TarjetaDebitoID := IFNULL(Var_TarjetaDebitoID, Cadena_Vacia);

		IF( Var_TarjetaDebitoID <> Cadena_Vacia ) THEN
			SET Var_TipoTarjeta := TarjetaDebito;
		END IF;

		SELECT Var_TipoTarjeta AS TipoTarjeta;

	END IF;

END TerminaStore$$
