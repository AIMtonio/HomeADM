-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCOBROSLCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCOBROSLCON`;DELIMITER $$

CREATE PROCEDURE `PSLCOBROSLCON`(
	-- Stored procedure para consultar la informacion de un pago de servicios en linea
	Par_CobroID						BIGINT(20),				-- ID del cobro
	Par_ProductoID 					INT(11), 				-- ID del producto
	Par_ServicioID 					INT(11), 				-- ID del servicio
	Par_ClasificacionServ 			CHAR(2), 				-- Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)
	Par_FechaIni 					DATE,					-- Fecha inicial
	Par_FechaFin 					DATE,					-- Fecha final

	Par_NumCon						TINYINT UNSIGNED,		-- Opcion de reporte

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
	DECLARE Var_ConPrincipal 		TINYINT;				-- Lista de productos con filtrosa
	DECLARE Est_Efectuado			CHAR(1); 				-- Estatus Cobro de Servicio Efectuado
	DECLARE Var_PagoEfec			CHAR(1); 				-- Forma de pago en efectivo
	DECLARE Var_PagoCta				CHAR(1); 				-- Forma de pago cargo a cuenta
	DECLARE Var_DescPagoEfec		VARCHAR(30); 			-- Descripcion para forma de pago en efectivo
	DECLARE Var_DescPagoCta			VARCHAR(30); 			-- Descripcion para forma de pago cargo a cuenta
	DECLARE Var_CanalV 				CHAR(1); 				-- Canal Ventanilla
	DECLARE Var_CanalL 				CHAR(1); 				-- Canal Banca en Linea
	DECLARE Var_CanalM 				CHAR(1); 				-- Canal Banca Movil
	DECLARE Var_CanalVL 			CHAR(2); 				-- Canal Ventanilla y Banca en linea
	DECLARE Var_CanalVM 			CHAR(2); 				-- Canal Ventanilla y Banca en movil
	DECLARE Var_CanalLM 			CHAR(2); 				-- Canal Banca en linea y Banca en movil
	DECLARE Var_DescCanalV 			VARCHAR(30); 			-- Descripcion de canal de Ventanilla
	DECLARE Var_DescCanalL 			VARCHAR(30); 			-- Descripcion de canal Banca en Linea
	DECLARE Var_DescCanalM 			VARCHAR(30); 			-- Descripcion de canal Banca Movil

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Var_SI 						:= 'S';					-- Variable con valor SI (S)
	SET Var_ConPrincipal 			:= 1;					-- Lista de productos con filtros
	SET Est_Efectuado 				:= 'E';					-- Estatus Cobro de Servicio Efectuado
	SET Var_PagoEfec				:= 'E'; 				-- Forma de pago en efectivo
	SET Var_PagoCta					:= 'C'; 				-- Forma de pago cargo a cuenta
	SET Var_DescPagoEfec			:= 'EFECTIVO'; 			-- Descripcion para forma de pago en efectivo
	SET Var_DescPagoCta				:= 'CARGO CTA'; 		-- Descripcion para forma de pago cargo a cuenta
	SET Var_CanalV 					:= 'V'; 				-- Canal Ventanilla
	SET Var_CanalL 					:= 'L'; 				-- Canal Banca en Linea
	SET Var_CanalM 					:= 'M'; 				-- Canal Banca Movil
    SET Var_CanalVL 				:= 'VL'; 				-- Canal Ventanilla y Banca en linea
    SET Var_CanalVM 				:= 'VM'; 				-- Canal Ventanilla y Banca en movil
    SET Var_CanalLM 				:= 'LM'; 				-- Canal Banca en linea y Banca en movil
	SET Var_DescCanalV 				:= 'VENTANILLA'; 		-- Descripcion de canal de Ventanilla
	SET Var_DescCanalL 				:= 'BANCA EN LINEA'; 	-- Descripcion de canal Banca en Linea
	SET Var_DescCanalM 				:= 'BANCA MOVIL'; 		-- Descripcion de canal Banca Movil

	-- Consulta por ID
	IF(Par_NumCon = Var_ConPrincipal) THEN
		SELECT 	psl.CobroID, 			psl.FechaHora, 			psl.CajaID, 				psl.Producto,				psl.Telefono,
				psl.Referencia,			psl.Precio,				psl.ComisiProveedor, 		psl.ComisiInstitucion,		psl.IVAComision,
				psl.TotalPagar,			psl.ClasificacionServ,	psl.ServicioID,				psl.ProductoID,				psl.SucursalID,
				suc.NombreSucurs,		prod.Servicio,
				CASE FormaPago
					WHEN Var_PagoEfec THEN Var_DescPagoEfec
					WHEN Var_PagoCta THEN Var_DescPagoCta
					ELSE Cadena_Vacia
				END AS FormaPago,
				CASE psl.Canal
					WHEN Var_CanalV THEN Var_DescCanalV
					WHEN Var_CanalL THEN Var_DescCanalL
					WHEN Var_CanalM  THEN Var_DescCanalM
					ELSE Cadena_Vacia
				END AS Canal,
				FNDECIMALALETRA(psl.TotalPagar, '2') AS CantidadLetra
			FROM PSLCOBROSL AS psl
			INNER JOIN SUCURSALES AS suc ON psl.SucursalID = suc.SucursalID
			INNER JOIN PSLPRODBROKER AS prod ON psl.ProductoID = prod.ProductoID
			WHERE psl.CobroID = Par_CobroID;
	END IF;

-- Fin del SP
END TerminaStore$$