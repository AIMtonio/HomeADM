-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEASCREDITOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEASCREDITOCON`;

DELIMITER $$
CREATE PROCEDURE `LINEASCREDITOCON`(
	-- Store procedure para la Consulta de lineas de credito
	-- Modulo Cartera y Solicitud de Credito Agro
	Par_LineaCreditoID 		BIGINT(12),			-- Numero de Linea de Credito
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de Consulta

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_RegistroID			INT(11);-- Numero de Registro
	DECLARE Var_FechaSistema		DATE;	-- Fecha del Sistema
	DECLARE Var_FechaProximoCobro	DATE;	-- Fecha de Proximo cobro de Comision
	DECLARE Var_FechaRegistro		DATE;	-- Fecha de Registro del cobro de Comision

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);	-- Constantes Cadena Vacia
	DECLARE Fecha_Vacia			DATE;		-- Constantes Fecha Vacia
	DECLARE Entero_Cero			INT(11);	-- Constantes Entero Cero
	DECLARE Con_SI				CHAR(1);	-- Constante SI
	DECLARE Con_NO				CHAR(1);	-- Constante NO
	DECLARE EstatusInactivo		CHAR(1);	-- Constantes Estatus Inactivo

	DECLARE Tip_Total			CHAR(1);	-- Constante Total en primera Disposicion
	DECLARE	Tip_ComAdmon		CHAR(1);	-- Constante Tipo Comision Admon

	-- Declaracion de Consultas
	DECLARE Con_Principal		INT(11);	-- Consulta Principal
	DECLARE Con_Actualiza		INT(11);	-- Consulta Actualizacion
	DECLARE Con_Foranea			INT(11);	-- Consulta Foranea
	DECLARE Con_Agropecuaria	INT(11);	-- Consulta Agropecuaria
	DECLARE Con_AgroInactiva	INT(11);	-- Consulta Agropecuaria

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET Con_SI				:='S';
	SET Con_NO				:='N';
	SET EstatusInactivo		:='I';

	SET Tip_Total			:= 'T';
	SET	Tip_ComAdmon		:= 'A';

	-- Asignacion de Consultas
	SET	Con_Principal		:= 1;
	SET	Con_Foranea 		:= 2;
	SET	Con_Actualiza		:= 3;
	SET	Con_Agropecuaria	:= 4;
	SET	Con_AgroInactiva	:= 5;

	SELECT	FechaSistema
	INTO	Var_FechaSistema
	FROM PARAMETROSSIS
	LIMIT 1;

	-- Segmento de validacion para verificar el cobro anual cuando la linea de credito tiene una Forma de Cobro
	-- Total en primera disposicion

	SELECT 	MAX(RegistroID)
	INTO 	Var_RegistroID
	FROM BITACORAFORCOBCOMLIN
	WHERE LineaCreditoID = Par_LineaCreditoID
	  AND TipoComision = Tip_ComAdmon
	  AND ForCobCom = Tip_Total;

	SET Var_RegistroID := IFNULL(Var_RegistroID, Entero_Cero);
	IF( Var_RegistroID = Entero_Cero ) THEN
		SET Var_FechaProximoCobro := Var_FechaSistema;
		SET Var_FechaRegistro := Fecha_Vacia;
	ELSE
		SELECT 	FechaProximoCobro,		FechaRegistro
		INTO 	Var_FechaProximoCobro,	Var_FechaRegistro
		FROM BITACORAFORCOBCOMLIN
		WHERE RegistroID = Var_RegistroID;
		SET Var_FechaProximoCobro := IFNULL(Var_FechaProximoCobro, Fecha_Vacia);
		SET Var_FechaRegistro := IFNULL(Var_FechaRegistro, Fecha_Vacia);
	END IF;


	IF( Par_NumCon = Con_Principal ) THEN
		SELECT	LineaCreditoID,		ClienteID,					CuentaID,				MonedaID,
				SucursalID,			FolioContrato,				FechaInicio,			FechaVencimiento,
				ProductoCreditoID,	FORMAT(Solicitado,2),		FORMAT(Autorizado,2), 	FORMAT(Dispuesto,2),
				FORMAT(Pagado,2),	FORMAT(SaldoDisponible,2), 	FORMAT(SaldoDeudor,2),	Estatus,
				NumeroCreditos,		IFNULL(IdenCreditoCNBV,Cadena_Vacia) as IdenCreditoCNBV,
				SaldoComAnual AS ComisionAnual, CobraComAnual, TipoComAnual, ComisionCobrada
		FROM LINEASCREDITO
		WHERE LineaCreditoID = Par_LineaCreditoID
		  AND EsAgropecuario = Con_NO;
	END IF;


	IF( Par_NumCon = Con_Actualiza ) THEN
		SELECT	LineaCreditoID,		ClienteID,			CuentaID,			Solicitado,			Autorizado,
				Estatus, 			FechaAutoriza,		UsuarioAutoriza,	FechaBloqueo,		UsuarioBloqueo,
				MotivoBloqueo,		FechaDesbloqueo,	UsuarioDesbloq,		MotivoDesbloqueo,	FechaCancelacion,
				UsuarioCancela,		MotivoCancela,		FechaInicio,		ProductoCreditoID
		FROM LINEASCREDITO
		WHERE LineaCreditoID = Par_LineaCreditoID
		  AND EsAgropecuario = Con_NO;
	END IF;

	IF( Par_NumCon = Con_Foranea ) THEN
		SELECT	LineaCreditoID, ClienteID,	CuentaID, ProductoCreditoID
		FROM LINEASCREDITO
		WHERE LineaCreditoID = Par_LineaCreditoID
		  AND EsAgropecuario = Con_NO;
	END IF;

	IF( Par_NumCon = Con_Agropecuaria ) THEN
		SELECT
			LineaCreditoID,		ClienteID,			CuentaID,				MonedaID,				SucursalID,
			FolioContrato,		FechaInicio,		FechaVencimiento,		ProductoCreditoID,		Solicitado,
			Autorizado,			Dispuesto,			Pagado,					SaldoDisponible,		SaldoDeudor,
			SaldoComAnual,		Estatus,			NumeroCreditos,			FechaCancelacion,		FechaBloqueo,
			FechaDesbloqueo,	FechaAutoriza,		UsuarioAutoriza,		UsuarioBloqueo,			UsuarioDesbloq,
			UsuarioCancela,		MotivoBloqueo,		MotivoDesbloqueo,		MotivoCancela,			IdenCreditoCNBV,
			CobraComAnual,		TipoComAnual,		ValorComAnual,			ComisionCobrada,		EsAgropecuario,
			TipoLineaAgroID,	EsRevolvente,		ManejaComAdmon,			ForCobComAdmon,			PorcentajeComAdmon,
			ManejaComGarantia,	ForCobComGarantia,	PorcentajeComGarantia,	UltFechaDisposicion,	UltMontoDisposicion,
			CASE WHEN ( ForCobComAdmon = Tip_Total AND Var_FechaSistema >= Var_FechaProximoCobro ) THEN Con_SI
				 ELSE Con_NO
			END AS CobraTolPriDisposicion,			Var_FechaRegistro AS FechaCobroComision,
			Var_FechaProximoCobro AS FechaProximoCobro
		FROM LINEASCREDITO
		WHERE LineaCreditoID = Par_LineaCreditoID
		  AND EsAgropecuario = Con_SI;
	END IF;


	IF( Par_NumCon = Con_AgroInactiva ) THEN
		SELECT
			LineaCreditoID,		ClienteID,			CuentaID,				MonedaID,				SucursalID,
			FolioContrato,		FechaInicio,		FechaVencimiento,		ProductoCreditoID,		Solicitado,
			Autorizado,			Dispuesto,			Pagado,					SaldoDisponible,		SaldoDeudor,
			SaldoComAnual,		Estatus,			NumeroCreditos,			FechaCancelacion,		FechaBloqueo,
			FechaDesbloqueo,	FechaAutoriza,		UsuarioAutoriza,		UsuarioBloqueo,			UsuarioDesbloq,
			UsuarioCancela,		MotivoBloqueo,		MotivoDesbloqueo,		MotivoCancela,			IdenCreditoCNBV,
			CobraComAnual,		TipoComAnual,		ValorComAnual,			ComisionCobrada,		EsAgropecuario,
			TipoLineaAgroID,	EsRevolvente,		ManejaComAdmon,			ForCobComAdmon,			PorcentajeComAdmon,
			ManejaComGarantia,	ForCobComGarantia,	PorcentajeComGarantia,	UltFechaDisposicion,	UltMontoDisposicion,
			CASE WHEN ( ForCobComAdmon = Tip_Total AND Var_FechaSistema >= Var_FechaProximoCobro ) THEN Con_SI
				 ELSE Con_NO
			END AS CobraTolPriDisposicion,			Var_FechaRegistro AS FechaCobroComision,
			Var_FechaProximoCobro AS FechaProximoCobro
		FROM LINEASCREDITO
		WHERE LineaCreditoID = Par_LineaCreditoID
		  AND EsAgropecuario = Con_SI
		  AND Estatus = EstatusInactivo;
	END IF;

END TerminaStore$$