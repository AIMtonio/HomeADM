-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCOBROSLREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCOBROSLREP`;DELIMITER $$

CREATE PROCEDURE `PSLCOBROSLREP`(
	-- Stored procedure para listar los cobros de servicios en linea
	Par_ProductoID 					INT(11), 				-- ID del producto
	Par_ServicioID 					INT(11), 				-- ID del servicio
	Par_ClasificacionServ 			CHAR(2), 				-- Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)
	Par_TipoUsuario 				CHAR(1),				-- Campo para el tipo de Usuario (S = Socio/Cliente, U = Usuario )
	Par_ClienteID 					INT(11),				-- Identificador del socio o cliente
	Par_CuentaAhoID 				BIGINT(12),				-- Identificador del la cuenta de ahorro
	Par_FormaPago 					CHAR(1),				-- Forma de pago por el producto (E = Efectivo, C = Cargo a cuenta de ahorro)
	Par_FechaHora 					DATETIME,				-- Fecha y hora del cobro de servicio
	Par_SucursalID 					INT(11),				-- Identificador de la sucursal donde ser realizo el cobro de servicio
	Par_CajaID 						INT(11),				-- Identificador de la caja donde ser realizo el cobro de servicio
	Par_CajeroID 					INT(11),				-- Identificador de la cajero que realizo el cobro de servicio
	Par_Canal 						VARCHAR(2),				-- Identificador del canal por donde ser realizo el servicio (V = Ventanilla, L = Banca en linea, M = Banca mobil)
	Par_FechaIni 					DATE,					-- Fecha inicial
	Par_FechaFin 					DATE,					-- Fecha final

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
	SET Var_LisReporte 				:= 1;					-- Lista de productos con filtros
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

	-- Lista de productos con filtros
	IF(Par_NumRep = Var_LisReporte) THEN
		-- Temporal con los canales a consultar
		DROP TABLE IF EXISTS TMPCANALES;
		CREATE TEMPORARY TABLE TMPCANALES (
			Canal 		CHAR(1),
			PRIMARY KEY (Canal)
		);

		IF(Par_Canal IN (Var_CanalV, Var_CanalL, Var_CanalM)) THEN
			INSERT INTO TMPCANALES(Canal) VALUES (Par_Canal);
		END IF;

        IF(Par_Canal = Var_CanalVL) THEN
			INSERT INTO TMPCANALES(Canal) VALUES (Var_CanalV);
			INSERT INTO TMPCANALES(Canal) VALUES (Var_CanalL);
		END IF;

		IF(Par_Canal = Var_CanalVM) THEN
			INSERT INTO TMPCANALES(Canal) VALUES (Var_CanalV);
			INSERT INTO TMPCANALES(Canal) VALUES (Var_CanalM);
		END IF;

		IF(Par_Canal = Var_CanalLM) THEN
			INSERT INTO TMPCANALES(Canal) VALUES (Var_CanalL);
			INSERT INTO TMPCANALES(Canal) VALUES (Var_CanalM);
		END IF;

		IF(Par_Canal = Cadena_Vacia) THEN
			INSERT INTO TMPCANALES(Canal) VALUES (Var_CanalV);
			INSERT INTO TMPCANALES(Canal) VALUES (Var_CanalL);
			INSERT INTO TMPCANALES(Canal) VALUES (Var_CanalM);
		END IF;

		-- Temporal con los nombres de los servicios
		DROP TABLE IF EXISTS TMPSERVICIO;
		CREATE TEMPORARY TABLE TMPSERVICIO (
			ServicioID 					INT(1),
			Servicio 					VARCHAR(100),

			PRIMARY KEY(ServicioID),
			INDEX `INDEX_TMPSERVICIO_1` (`ServicioID` ASC)
		);

		-- Insertamos los servicios vigentes
		INSERT INTO TMPSERVICIO (ServicioID, Servicio)
			SELECT ServicioID, Servicio
			FROM PSLPRODBROKER
		    GROUP BY ServicioID;

		 -- Insertamos los servicios en el historial que no se encuentren en los servicios actuales
		INSERT INTO TMPSERVICIO (ServicioID, Servicio)
			SELECT PSLHISPRODBROKER.ServicioID, PSLHISPRODBROKER.Servicio
				FROM PSLHISPRODBROKER
				LEFT JOIN PSLPRODBROKER ON PSLPRODBROKER.ServicioID = PSLHISPRODBROKER.ServicioID
				WHERE PSLPRODBROKER.ServicioID IS NULL
			    GROUP BY PSLHISPRODBROKER.ServicioID;

		SELECT 	psl.CobroID, 			psl.FechaHora, 			psl.CajaID, 				psl.Producto,				psl.Telefono,
				psl.Referencia,			psl.Precio,				psl.ComisiProveedor, 		psl.ComisiInstitucion,		psl.IVAComision,
				psl.TotalPagar,			psl.ClasificacionServ,	psl.ServicioID,				psl.ProductoID,				psl.SucursalID,
				suc.NombreSucurs,		ser.Servicio,
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
				END AS Canal
			FROM PSLCOBROSL AS psl
			INNER JOIN SUCURSALES AS suc ON psl.SucursalID = suc.SucursalID
			INNER JOIN TMPSERVICIO AS ser ON psl.ServicioID = ser.ServicioID
			INNER JOIN TMPCANALES AS can ON can.Canal = psl.Canal
			WHERE psl.SucursalID = IF(Par_SucursalID > Entero_Cero, Par_SucursalID, psl.SucursalID)
			  AND psl.ClasificacionServ = IF(Par_ClasificacionServ <> Cadena_Vacia, Par_ClasificacionServ, psl.ClasificacionServ)
			  AND psl.ServicioID = IF(Par_ServicioID > Entero_Cero, Par_ServicioID, psl.ServicioID)
			  AND psl.ProductoID = IF(Par_ProductoID > Entero_Cero, Par_ProductoID, psl.ProductoID)
			  AND CAST(psl.FechaHora AS DATE) >= Par_FechaIni
			  AND CAST(psl.FechaHora AS DATE) <= Par_FechaFin
			  AND psl.Estatus = Est_Efectuado
			ORDER BY psl.SucursalID, psl.ServicioID, psl.ClasificacionServ, psl.Producto, psl.FechaHora;

		DROP TABLE IF EXISTS TMPCANALES;
		DROP TABLE IF EXISTS TMPSERVICIO;
	END IF;

-- Fin del SP
END TerminaStore$$