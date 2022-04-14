-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCONFIGSERVICIOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCONFIGSERVICIOCON`;DELIMITER $$

CREATE PROCEDURE `PSLCONFIGSERVICIOCON`(
	-- Stored procedure para consultar la configuracion de los servicios en linea
	Par_ServicioID 					INT(11), 				-- ID del servicio
	Par_ClasificacionServ 			CHAR(2), 				-- Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)

	Par_NumCon						TINYINT UNSIGNED,		-- Opcion de consulta

	Aud_EmpresaID 					INT(11), 				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal 					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore : BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;					-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(2, 1); 			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE Var_ConPrincipal 		TINYINT;				-- Alta de la configuracion del servicio
	DECLARE Var_IDCServRE 			CHAR(2); 				-- ID de la Clasificacion Servicio RE
	DECLARE Var_CServRE 			VARCHAR(30);			-- Descripcion de la  Clasificacion Servicio RE
	DECLARE Var_IDCServCO 			CHAR(2); 				-- ID de la Clasificacion Servicio CO
	DECLARE Var_CServCO 			VARCHAR(30);			-- Descripcion de la  Clasificacion Servicio CO
	DECLARE Var_IDCServPS 			CHAR(2); 				-- ID de la Clasificacion Servicio PS
	DECLARE Var_CServPS 			VARCHAR(30);			-- Descripcion de la  Clasificacion Servicio PS

	-- Declaracion de variables
	DECLARE Var_Servicio 			VARCHAR(200);
	DECLARE Var_ClasificacionServ 	VARCHAR(50);

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Var_ConPrincipal 			:= 1; 					-- Consulta por ID del Servicio
	SET Var_IDCServRE 				:= 'RE';				-- ID de la Clasificacion Servicio RE
	SET Var_CServRE 				:= 'RECARGA';			-- Descripcion de la  Clasificacion Servicio RE
	SET Var_IDCServCO 				:= 'CO';				-- ID de la Clasificacion Servicio CO
	SET Var_CServCO 				:= 'CONSULTA DE SALDO';	-- Descripcion de la  Clasificacion Servicio CO
	SET Var_IDCServPS 				:= 'PS';				-- ID de la Clasificacion Servicio PS
	SET Var_CServPS 				:= 'PAGO DE SERVICIO';	-- Descripcion de la  Clasificacion Servicio PS

	-- Consulta por ID del Servicio
	IF(Par_NumCon = Var_ConPrincipal) THEN
		-- Obtenemos el nombre del servicio
		SELECT DISTINCT(Servicio) INTO Var_Servicio
			FROM PSLPRODBROKER
			WHERE ServicioID = Par_ServicioID
			LIMIT 1;

		-- Obtenemos la descripcion de la clasificacion del servicio
		SELECT 	CASE Par_ClasificacionServ
					WHEN Var_IDCServRE THEN Var_CServRE
					WHEN Var_IDCServCO THEN Var_CServCO
					ELSE Var_CServPS
				END AS ClasificacionServ
				INTO Var_ClasificacionServ;

		SELECT 	PSLCONFIGSERVICIO.ServicioID, 		Var_Servicio AS Servicio, 			PSLCONFIGSERVICIO.ClasificacionServ, 	Var_ClasificacionServ AS NomClasificacion,	PSLCONFIGSERVICIO.CContaServicio,
				PSLCONFIGSERVICIO.CContaComision, 	PSLCONFIGSERVICIO.CContaIVAComisi, 	PSLCONFIGSERVICIO.NomenclaturaCC,  		PSLCONFIGSERVICIO.VentanillaAct,			PSLCONFIGSERVICIO.CobComVentanilla,
				PSLCONFIGSERVICIO.MtoCteVentanilla,	PSLCONFIGSERVICIO.MtoUsuVentanilla,	PSLCONFIGSERVICIO.BancaLineaAct, 		PSLCONFIGSERVICIO.CobComBancaLinea, 		PSLCONFIGSERVICIO.MtoCteBancaLinea,
				PSLCONFIGSERVICIO.BancaMovilAct, 	PSLCONFIGSERVICIO.CobComBancaMovil, PSLCONFIGSERVICIO.MtoCteBancaMovil,		PSLCONFIGSERVICIO.Estatus,
				IFNULL(CCSERV.Descripcion, Cadena_Vacia) DescCContaServicio,
				IFNULL(CCCOMISI.Descripcion, Cadena_Vacia) DescCContaComision,
				IFNULL(CCIVA.Descripcion, Cadena_Vacia) DescCContaIVAComisi
			FROM PSLCONFIGSERVICIO
			LEFT JOIN CUENTASCONTABLES CCSERV ON CCSERV.CuentaCompleta = PSLCONFIGSERVICIO.CContaServicio
			LEFT JOIN CUENTASCONTABLES CCCOMISI ON CCCOMISI.CuentaCompleta = PSLCONFIGSERVICIO.CContaComision
			LEFT JOIN CUENTASCONTABLES CCIVA ON CCIVA.CuentaCompleta = PSLCONFIGSERVICIO.CContaIVAComisi
			WHERE PSLCONFIGSERVICIO.ServicioID = Par_ServicioID AND PSLCONFIGSERVICIO.ClasificacionServ = Par_ClasificacionServ;
	END IF;

END TerminaStore$$