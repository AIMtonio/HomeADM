-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCONFIGPRODUCTOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCONFIGPRODUCTOCON`;DELIMITER $$

CREATE PROCEDURE `PSLCONFIGPRODUCTOCON`(
	-- Stored procedure para consultar la configuracion de los productos de servicios en linea
	Par_ProductoID 					INT(11), 				-- ID del producto
	Par_ServicioID 					INT(11), 				-- ID del servicio
	Par_ClasificacionServ 			CHAR(2), 				-- Clasificacion del servicio (RE = Recarga de tiempo aire, CO = Consulta saldo, PS = Pago de servicios)
	Par_Producto 					VARCHAR(200), 			-- Nombre del producto
	Par_Habilitado 					CHAR(1), 				-- Bandera para habilitar el producto en los canales (S = SI, N = NO)

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
	DECLARE Var_ConPrincipal 		TINYINT;				-- Consulta por ID del Producto
	DECLARE Var_TipoFront1 			TINYINT;				-- Tipo front 1
	DECLARE Var_SI 					CHAR(1); 				-- Valor SI (S)
	DECLARE Est_Activo 				CHAR(1); 				-- Estatus activo

	-- Declaracion de variables
	DECLARE Var_Servicio 			VARCHAR(200);			-- Nombre del Servicio
	DECLARE Var_ClasificacionServ 	VARCHAR(50); 			-- Clasificacion del Servicio
	DECLARE Var_IVA 				DECIMAL(5,2); 			-- Iva de la sucursal

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Var_ConPrincipal 			:= 1; 					-- Consulta por ID del Producto
	SET Var_TipoFront1 				:= 1; 					-- Tipo front 1
	SET Var_SI 						:= 'S'; 				-- Valor SI (S)
	SET Est_Activo 					:= 'A';					-- Estatus activo

	-- Consulta por ID del Producto
	IF(Par_NumCon = Var_ConPrincipal) THEN
		SELECT IVA INTO Var_IVA
			FROM SUCURSALES
			WHERE SucursalID = Aud_Sucursal;

		-- Temporal con los distintos tipos de servicios
		SELECT 	PSLCONFIGPRODUCTO.ProductoID, 		PSLCONFIGPRODUCTO.ServicioID, 		PSLCONFIGPRODUCTO.ClasificacionServ, 	PSLCONFIGPRODUCTO.Producto, 	PSLPRODBROKER.TipoReferencia,
				PSLPRODBROKER.TipoFront, 			PSLCONFIGSERVICIO.MtoCteVentanilla,	PSLCONFIGSERVICIO.MtoUsuVentanilla,
				IF(PSLPRODBROKER.TipoFront = Var_TipoFront1, Decimal_Cero, PSLPRODBROKER.Precio) MtoProveedor,
				IF(PSLPRODBROKER.TipoFront = Var_TipoFront1, PSLPRODBROKER.Precio, Decimal_Cero) Precio,
				CAST(PSLCONFIGSERVICIO.MtoCteVentanilla * Var_IVA AS DECIMAL(14,2)) IVAMtoCteVentanilla,
				CAST(PSLCONFIGSERVICIO.MtoUsuVentanilla * Var_IVA AS DECIMAL(14,2)) IVAMtoUsuVentanilla,
				PSLCONFIGSERVICIO.CobComVentanilla
			FROM PSLCONFIGPRODUCTO
			INNER JOIN PSLCONFIGSERVICIO ON PSLCONFIGSERVICIO.ServicioID = PSLCONFIGPRODUCTO.ServicioID
					AND PSLCONFIGSERVICIO.ClasificacionServ = PSLCONFIGPRODUCTO.ClasificacionServ AND PSLCONFIGSERVICIO.VentanillaAct = Var_SI
			INNER JOIN PSLPRODBROKER ON PSLPRODBROKER.ProductoID = PSLCONFIGPRODUCTO.ProductoID
			WHERE PSLCONFIGPRODUCTO.ProductoID = Par_ProductoID;
	END IF;

END TerminaStore$$