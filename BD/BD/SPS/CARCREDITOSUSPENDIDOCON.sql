-- SP CARCREDITOSUSPENDIDOCON

DELIMITER ;

DROP PROCEDURE IF EXISTS CARCREDITOSUSPENDIDOCON;

DELIMITER $$

CREATE  PROCEDURE CARCREDITOSUSPENDIDOCON(
	-- Stored Procedure para consultar la Informacion del Creditos que se han realizado el pase a suspendido
	Par_CarCreditoSuspendidoID	BIGINT(12),			-- ID o numero de la tabla de suspencion del credito
	Par_CreditoID				BIGINT(12),			-- ID Del Numero de Credito del cliente.
	Par_NumCon					TINYINT UNSIGNED,	-- Numero de consulta de Consulta

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- ID de la Empresa
	Aud_Usuario					INT(11),			-- ID del Usuario que creo el Registro
	Aud_FechaActual				DATETIME,			-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP				VARCHAR(15),		-- Direccion IP de la computadora
	Aud_ProgramaID				VARCHAR(50),		-- Identificador del Programa
	Aud_Sucursal				INT(11),			-- Identificador de la Sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Numero de Transaccion
)TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE EstatusRegistrado	CHAR(1);			-- Estatus Registrado
	DECLARE Con_InfCredSup		INT(11);			-- Variable para la Consulta de Informacion de credito Suspendido

	-- Asignacion de constantes
	SET	Con_InfCredSup			:= 1;				-- Variable para la Consulta de Informacion de credito Suspendido
	SET EstatusRegistrado		:= "R";				-- Estatus Registrado

	-- 1.- Variable para la Consulta de Informacion de credito Suspendido
	IF(Par_NumCon = Con_InfCredSup) THEN
		SELECT	CarCreditoSuspendidoID,		CreditoID,				EstatusCredito,			FechaDefuncion,			FechaSuspencion,
				FolioActa,					ObservDefuncion,		Estatus,				TotalAdeudo,			TotalSalCapital,
				TotalSalInteres,			TotalSalMoratorio,		TotalSalComisiones
			FROM CARCREDITOSUSPENDIDO
			WHERE CreditoID = Par_CreditoID
				AND Estatus = EstatusRegistrado;
	END IF;

END TerminaStore$$
