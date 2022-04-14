-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCONOCIMIENTOCTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCONOCIMIENTOCTECON`;
DELIMITER $$

CREATE PROCEDURE `BANCONOCIMIENTOCTECON`(
	Par_ClienteID					INT(11),				-- Numero de cliente
	Par_NumCon						TINYINT UNSIGNED,		-- Numero de consulta

	Aud_EmpresaID					INT(11),				-- Parametro de auditoria
	Aud_Usuario						INT(11),				-- Parametro de auditoria
	Aud_FechaActual					DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal					INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametro de auditoria
)TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia				CHAR(1);			-- Constante cadena vacia
	DECLARE	Fecha_Vacia					DATE;				-- Constante Fecha vacia
	DECLARE	Entero_Cero					INT(11);			-- Constante Entero cero

	DECLARE	Con_ConocimientoCLiente		INT(11);			-- Numero de consulta de conocimiento del cliente

	-- Asignacion de constantes
	SET	Cadena_Vacia					:= '';				-- Cadena Vacia
	SET	Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero						:= 0;				-- Entero Cero

	SET	Con_ConocimientoCLiente			:= 1;				-- Numero de consulta de conocimiento del cliente


	-- 1.- Consulta de conocimiento del cliente
	IF(Par_NumCon = Con_ConocimientoCLiente) THEN
		SELECT	CONCTE.ClienteID,					CLI.NombreCompleto,				CONCTE.NomGrupo,				CONCTE.RFC,						CONCTE.Participacion,
				CONCTE.Nacionalidad,				CONCTE.RazonSocial,				CONCTE.Giro,					CONCTE.NoEmpleados,				CONCTE.Serv_Produc,
				CONCTE.Cober_Geograf,				CONCTE.Estados_Presen,			CONCTE.ImporteVta,				CONCTE.Activos,					CONCTE.Pasivos,
				CONCTE.Capital,						CONCTE.Importa,					CONCTE.DolaresImport,			CONCTE.Exporta,					CONCTE.DolaresExport,
				CONCTE.PaisesImport,				CONCTE.PaisesImport2,			CONCTE.PaisesImport3,			CONCTE.PaisesExport,			CONCTE.PaisesExport2,
				CONCTE.PaisesExport3,				CONCTE.NombRefCom,				CONCTE.NoCuentaRefCom,			CONCTE.DireccionRefCom,			CONCTE.TelRefCom,
				CONCTE.ExtTelRefCom,				CONCTE.NombRefCom2,				CONCTE.NoCuentaRefCom2,			CONCTE.DireccionRefCom2,		CONCTE.TelRefCom2,
				CONCTE.ExtTelRefCom2,				CONCTE.BancoRef,				CONCTE.BanTipoCuentaRef,		CONCTE.NoCuentaRef,				CONCTE.BanSucursalRef,
				CONCTE.BanNoTarjetaRef,				CONCTE.BanTarjetaInsRef,		CONCTE.BanCredOtraEnt,			CONCTE.BanInsOtraEnt,			CONCTE.BancoRef2,
				CONCTE.BanTipoCuentaRef2,			CONCTE.NoCuentaRef2,			CONCTE.BanSucursalRef2,			CONCTE.BanNoTarjetaRef2,		CONCTE.BanTarjetaInsRef2,
				CONCTE.BanCredOtraEnt2,				CONCTE.BanInsOtraEnt2,			CONCTE.NombreRef,				CONCTE.DomicilioRef,			CONCTE.TelefonoRef,
				CONCTE.TipoRelacion1,				CONCTE.extTelefonoRefUno,		CONCTE.NombreRef2,				CONCTE.DomicilioRef2,			CONCTE.TelefonoRef2,
				CONCTE.TipoRelacion2,				CONCTE.extTelefonoRefDos,		CONCTE.PEPs,					CONCTE.FuncionID,				CONCTE.FechaNombramiento,
				CONCTE.PeriodoCargo,				CONCTE.PorcentajeAcciones,		CONCTE.MontoAcciones,			CONCTE.ParentescoPEP,			CONCTE.NombFamiliar,
				CONCTE.APaternoFam,					CONCTE.AMaternoFam,				CONCTE.PFuenteIng,				CONCTE.IngAproxMes
		FROM CONOCIMIENTOCTE CONCTE
		INNER JOIN CLIENTES CLI ON CLI.ClienteID = CONCTE.ClienteID
		WHERE CONCTE.ClienteID = Par_ClienteID;
	END IF;

END TerminaStore$$



