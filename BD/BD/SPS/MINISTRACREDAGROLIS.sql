-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRACREDAGROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINISTRACREDAGROLIS`;

DELIMITER $$
CREATE PROCEDURE `MINISTRACREDAGROLIS`(
	/*SP para Listar las Ministraciones de Credito*/
	Par_NumLis					TINYINT UNSIGNED,		# Numero de Lista
	Par_TransaccionID			BIGINT(20),				# Numero de Transaccion
	Par_SolicitudCreditoID		BIGINT(12),				# Numero de Solicitud de Credito
	Par_CreditoID				BIGINT(20),				# Numero de Credito
	Par_ClienteID				INT(11),				# Numero de Cliente

	Par_ProspectoID				INT(11),				# Numero de Prospecto
	/*Parametros de Auditoria*/
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),

	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_Total				DECIMAL(18,2);
	DECLARE Var_Diferencia			DECIMAL(18,2);
	DECLARE Var_MontoTotalSol		DECIMAL(18,2);
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_ManejaComGarantia	CHAR(1);			-- Maneja Comisión por Garantía \nS.- SI \nN.- NO
	DECLARE Var_ComGarLinPrevLiq	CHAR(1);			-- comision Previamente Liquidada

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Entero_Uno				INT(11);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Lis_Principal			INT(11);
	DECLARE Lis_Desembolso			INT(11);
    DECLARE Lis_NoActivos			INT(11);
	DECLARE Lis_Grupales			INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
    DECLARE Str_SI					CHAR(1);
    DECLARE Str_NO					CHAR(1);
    DECLARE EstatusInact			CHAR(1);
    DECLARE EstatusPend				CHAR(1);
    DECLARE EstatusCanc				CHAR(1);
    DECLARE EstatusDesemb			CHAR(1);
    DECLARE EstDescInact			VARCHAR(15);
    DECLARE EstDescPend				VARCHAR(15);
    DECLARE EstDescCanc				VARCHAR(15);
    DECLARE EstDescDesemb			VARCHAR(15);

	-- Asignacion de Constantes
	SET	Entero_Cero					:= 0;				-- Entero Cero
	SET	Entero_Uno					:= 1;				-- Entero Uno
	SET	Fecha_Vacia					:= '1900-01-01';	-- Fecha vacia
	SET	Lis_Principal				:= 1;				-- Lista principal
	SET	Lis_Desembolso				:= 2;				-- Lista que se muestra en desembolso
	SET	Lis_NoActivos				:= 3;				-- Lista de creditos no activo
    SET Lis_Grupales				:= 4;				-- Lista para grupales
	SET Cadena_Vacia				:= '';				-- Cadena Vacia
    SET Str_SI						:= 'S';				-- Constante SI
    SET Str_NO						:= 'N';				-- Constante NO
    SET EstatusInact				:= 'I';				-- Estatus de la misnitración inactivo
    SET EstatusPend					:= 'P';				-- Estatus de la misnitración pendiente
    SET EstatusCanc					:= 'C';				-- Estatus de la misnitración cancelado
    SET EstatusDesemb				:= 'D';				-- Estatus de la misnitración desembolsado
    SET EstDescInact				:= 'INACTIVO';		-- Descripción del estatus de la misnitración inactivo
    SET EstDescPend					:= 'PENDIENTE';		-- Descripción del estatus de la misnitración pendiente
    SET EstDescCanc					:= 'CANCELADO';		-- Descripción del estatus de la misnitración cancelado
    SET EstDescDesemb				:= 'DESEMBOLSADO';	-- Descripción del estatus de la misnitración desembolsado
    SET Var_FechaSistema			:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

	/* Numero de Lista: 1
	Lista Principal */
	IF(Par_NumLis = Lis_Principal OR Par_NumLis = Lis_NoActivos OR Par_NumLis =Lis_Grupales) THEN
		SET Par_SolicitudCreditoID	:= IFNULL(Par_SolicitudCreditoID, Entero_Cero);
		SET Par_CreditoID 			:= (SELECT CreditoID FROM MINISTRACREDAGRO WHERE SolicitudCreditoID = Par_SolicitudCreditoID ORDER BY CreditoID LIMIT 1);
		SET Par_CreditoID			:= IFNULL(Par_CreditoID, Entero_Cero);
		SET Par_ClienteID			:= IFNULL(Par_ClienteID, Entero_Cero);
		SET Par_ProspectoID			:= IFNULL(Par_ProspectoID, Entero_Cero);
		SET Var_Total				:= (SELECT SUM(Capital) FROM MINISTRACREDAGRO WHERE SolicitudCreditoID = Par_SolicitudCreditoID);
		SET Var_MontoTotalSol		:= (SELECT MontoSolici FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID);
		SET Var_Total				:= IFNULL(Var_Total, Entero_Cero);
		SET Var_MontoTotalSol		:= IFNULL(Var_MontoTotalSol, Entero_Cero);
		SET Var_Diferencia			:= Var_MontoTotalSol - Var_MontoTotalSol;

        IF(Par_CreditoID > Entero_Cero) THEN
			SELECT
				Mins.Numero,			Mins.TransaccionID,			Mins.SolicitudCreditoID,		Mins.CreditoID,				Mins.ClienteID,
				Mins.ProspectoID,
				IF( Mins.Numero = Entero_Uno  AND Var_FechaSistema != Mins.FechaPagoMinis AND
					Cred.Estatus  IN('I','A') AND Cred.EsConsolidacionAgro = 'N', Var_FechaSistema, Mins.FechaPagoMinis) AS FechaPagoMinis,
				Mins.Capital,		Var_Total AS Total,		Var_Diferencia AS Diferencia
			FROM MINISTRACREDAGRO AS Mins
			INNER JOIN CREDITOS AS Cred ON Mins.CreditoID = Cred.CreditoID
			WHERE Mins.CreditoID = Par_CreditoID;
		ELSE
			SELECT
				Numero,			TransaccionID,			SolicitudCreditoID,		CreditoID,				ClienteID,
				ProspectoID,
				IF(Numero = Entero_Uno AND Var_FechaSistema != FechaPagoMinis, Var_FechaSistema, FechaPagoMinis) AS FechaPagoMinis,
				Capital,		Var_Total AS Total,		Var_Diferencia AS Diferencia
			FROM MINISTRACREDAGRO
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID;
		END IF;
	END IF;

	/* Numero de Lista: 2
	Lista para mostrar el calendario de ministraciones en Desembolso. */
	IF(Par_NumLis = Lis_Desembolso) THEN

		SET Par_CreditoID := IFNULL(Par_CreditoID, Entero_Cero);

		SELECT ManejaComGarantia,	ComGarLinPrevLiq
		INTO Var_ManejaComGarantia,	Var_ComGarLinPrevLiq
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		SET Var_ManejaComGarantia	:= IFNULL(Var_ManejaComGarantia, Str_NO);

		SELECT
			Numero,		FechaPagoMinis,		FORMAT(Capital, 2) AS Capital,
			CASE Estatus
				WHEN EstatusInact THEN EstDescInact
				WHEN EstatusPend THEN EstDescPend
				WHEN EstatusCanc THEN EstDescCanc
				WHEN EstatusDesemb THEN EstDescDesemb
			END AS Estatus,
			IF(Estatus IN (EstatusInact,EstatusPend),Str_NO, Str_SI) AS Seleccionado,
			IF(FechaMinistracion=Fecha_Vacia OR Estatus IN(EstatusInact,EstatusPend),'',FechaMinistracion) AS FechaMinistracion,
			UsuarioAutoriza,	FechaAutoriza,		ComentariosAutoriza,
			IF( Var_ManejaComGarantia = Str_NO ,
				Cadena_Vacia,
				CASE WHEN (Numero = Entero_Uno)
						  THEN Str_NO
						  ELSE IF( Var_ComGarLinPrevLiq = Str_SI, Cadena_Vacia, Str_SI)
				END
				) AS ManejaComGarantia, ForPagComGarantia
		FROM MINISTRACREDAGRO
		WHERE CreditoID = Par_CreditoID;
	END IF;

END TerminaStore$$