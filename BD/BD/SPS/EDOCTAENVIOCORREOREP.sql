-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAENVIOCORREOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAENVIOCORREOREP`;DELIMITER $$

CREATE PROCEDURE `EDOCTAENVIOCORREOREP`(
	-- Stored procedure para listar los cobros de servicios en linea
	Par_AnioMes						INT(11),				-- Periodo del estado de cuenta
	Par_ClienteID					INT(11),				-- ID de Cliente
	Par_Estatus						INT(11),				-- Estatus del Estado de Cuenta

	Par_NumRep						TINYINT UNSIGNED,		-- Opcion de reporte

	Aud_EmpresaID 					INT(11), 				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal 					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);				-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(14, 2); 		-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;					-- Fecha vacia
	DECLARE Var_SI 					CHAR(1); 				-- Variable con valor SI (S)
	DECLARE Var_LisReporte 			TINYINT;				-- Lista de productos con filtrosa

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Var_SI 						:= 'S';					-- Variable con valor SI (S)
	SET Var_LisReporte 				:= 1;					-- Lista de estados de cuenta

	-- Lista de productos con filtros
	IF(Par_NumRep = Var_LisReporte) THEN

		SELECT	edocta.AnioMes,			edocta.ClienteID,			cli.NombreCompleto,			edocta.SucursalID,			suc.NombreSucurs,
				edocta.PDFGenerado,		edocta.EstatusEdoCta,		edocta.EstatusEnvio
			FROM EDOCTAENVIOCORREO AS edocta
			INNER JOIN CLIENTES AS cli ON edocta.ClienteID = cli.ClienteID
			INNER JOIN SUCURSALES AS suc ON edocta.SucursalID = suc.SucursalID
			WHERE edocta.AnioMes = Par_AnioMes
			  AND edocta.ClienteID = IF(Par_ClienteID > Entero_Cero, Par_ClienteID, edocta.ClienteID)
			  AND CASE
					WHEN Par_Estatus = 1 THEN PDFGenerado = 'S'
					WHEN Par_Estatus = 2 THEN EstatusEdoCta = 2
					WHEN Par_Estatus = 3 THEN EstatusEdoCta <> 2
					WHEN Par_Estatus = 4 THEN EstatusEnvio = 'S'
					WHEN Par_Estatus = 5 THEN EstatusEnvio = 'N'
					ELSE TRUE END
			ORDER BY edocta.AnioMes;
	END IF;

-- Fin del SP
END TerminaStore$$