-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCONFIGPRODUCTOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCONFIGPRODUCTOLIS`;DELIMITER $$

CREATE PROCEDURE `PSLCONFIGPRODUCTOLIS`(
	-- Stored procedure para listar las configuraciones de los productos de servicios en linea
	Par_ProductoID 					INT(11), 				-- ID del producto
	Par_ServicioID 					INT(11), 				-- ID del servicio
	Par_ClasificacionServ 			CHAR(2), 				-- Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)
	Par_Producto 					VARCHAR(200), 			-- Nombre del producto
	Par_Habilitado 					CHAR(1), 				-- Bandera para habilitar el producto en los canales (S = SI, N = NO)

	Par_NumLis						TINYINT UNSIGNED,		-- Numero de lista

	Aud_EmpresaID					INT(11),				-- Parametro de auditoria
	Aud_Usuario						INT(11),				-- Parametro de auditoria
	Aud_FechaActual					DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP					VARCHAR(15),    		-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal					INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT					-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;					-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(2, 1); 			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE Var_LisActVentanilla 	TINYINT;				-- Opcion de lista de productos activos en ventanilla
	DECLARE Var_LisServicio 		TINYINT; 				-- Opcion de lista por servicio
	DECLARE Var_IDTRRelefono 		VARCHAR(2); 			-- ID Tipo refencia Telefono
	DECLARE Var_TRTelefono 			VARCHAR(30); 			-- Tipo referencia telefono
	DECLARE Var_TRReferencia 		VARCHAR(30); 			-- Tipo referencia referencia
	DECLARE Var_SI 					CHAR(1); 				-- Variable con valor SI (S)
	DECLARE Est_Activo 				CHAR(1); 				-- Estatus activo

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Var_LisActVentanilla 		:= 1;					-- Opcion de lista de productos activos en ventanilla
	SET Var_LisServicio 			:= 2; 					-- Opcion de lista por servicio
	SET Var_IDTRRelefono 			:= 'a'; 				-- ID Tipo refencia Telefono
	SET Var_TRTelefono 				:= 'TELEFONO'; 			-- Tipo referencia telefono
	SET Var_TRReferencia 			:= 'REFERENCIA'; 		-- Tipo referencia referencia
	SET Var_SI 						:= 'S';					-- Variable con valor SI (S)
	SET Est_Activo 					:= 'A';					-- Estatus activo

	-- DESCRIPCION COMPLETA DE TODOS LOS PRODUCTOS CON ESTATUS ACTIVO QUE TAMBIEN ESTEN ACTIVOS EN VENTANILLA,.
	IF(Par_NumLis = Var_LisActVentanilla) THEN
		SELECT 	PSLCONFIGPRODUCTO.ProductoID, PSLCONFIGPRODUCTO.Producto, CONCAT(PSLPRODBROKER.Servicio, ' - ', PSLCONFIGPRODUCTO.Producto) DescProducto
			FROM PSLCONFIGPRODUCTO
			INNER JOIN PSLCONFIGSERVICIO ON PSLCONFIGSERVICIO.ServicioID = PSLCONFIGPRODUCTO.ServicioID
				AND PSLCONFIGSERVICIO.ClasificacionServ = PSLCONFIGPRODUCTO.ClasificacionServ AND PSLCONFIGSERVICIO.VentanillaAct = Var_SI
			INNER JOIN PSLPRODBROKER ON PSLPRODBROKER.ProductoID = PSLCONFIGPRODUCTO.ProductoID
			WHERE PSLCONFIGPRODUCTO.Habilitado = Var_SI
			AND PSLCONFIGPRODUCTO.Estatus = Est_Activo
			ORDER BY CONCAT(PSLPRODBROKER.Servicio, ' - ', PSLCONFIGPRODUCTO.Producto);
	END IF;

	-- LISTA DE LOS PRODUCTOS POR SERVICIO Y CLASIFICACION DE SERVICIO
	IF(Par_NumLis = Var_LisServicio) THEN
		SELECT 	PSLCONFIGPRODUCTO.ProductoID, PSLCONFIGPRODUCTO.Producto, PSLPRODBROKER.DigVerificador, PSLPRODBROKER.Precio, PSLCONFIGPRODUCTO.Habilitado,
				CONCAT(PSLPRODBROKER.Servicio, ' - ', PSLCONFIGPRODUCTO.Producto) DescProducto,
				CASE PSLPRODBROKER.TipoReferencia
					WHEN Var_IDTRRelefono THEN Var_TRTelefono
					ELSE Var_TRReferencia
				END AS TipoReferencia
			FROM PSLCONFIGPRODUCTO
			INNER JOIN PSLPRODBROKER ON PSLPRODBROKER.ProductoID = PSLCONFIGPRODUCTO.ProductoID
			WHERE PSLCONFIGPRODUCTO.ServicioID = Par_ServicioID
			AND PSLCONFIGPRODUCTO.ClasificacionServ = Par_ClasificacionServ;
	END IF;

-- Fin del SP
END TerminaStore$$