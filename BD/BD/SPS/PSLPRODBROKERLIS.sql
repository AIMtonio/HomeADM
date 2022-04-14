-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLPRODBROKERLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLPRODBROKERLIS`;DELIMITER $$

CREATE PROCEDURE `PSLPRODBROKERLIS`(
	-- Stored procedure para listar los productos del Broker
	Par_FechaCatalogo 				DATETIME, 				-- Fecha y hora en la que se consulto el catalogo
	Par_ServicioID 					INT(11), 				-- Identificador del servicio
	Par_Servicio 					VARCHAR(100), 			-- Nombre del servicio
	Par_TipoServicio 				INT(11), 				-- ID del tipo de servicio
	Par_ProductoID 					INT(11), 				-- ID del producto
	Par_Producto 					VARCHAR(200), 			-- Nombre del producto
	Par_TipoFront 					INT(11), 		 		-- TipoFront de GestoPago
	Par_DigVerificador 				CHAR(1), 		 		-- Digito verificador de GestoPago,
	Par_Precio 						DECIMAL(14,2), 			-- Precio del producto,
	Par_ShowAyuda 					CHAR(1), 		 		-- Campo ShowAyuda de GestoPago,
	Par_TipoReferencia 				VARCHAR(20),			-- Campo ShowAyuda de GestoPago,

	Par_NumLis						TINYINT UNSIGNED,		-- Numero de lista

	Par_EmpresaID 					INT(11), 				-- Parametros de auditoria
	Par_Usuario						INT(11),				-- Parametros de auditoria
	Par_FechaActual					DATETIME,				-- Parametros de auditoria
	Par_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Par_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Par_Sucursal 					INT(11), 				-- Parametros de auditoria
	Par_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;					-- Entero vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Lis_Completa			INT(11);				-- Numero de lista para devolver todos los productos


	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Lis_Completa				:= 1;					-- Numero de lista para devolver todos los productos

	-- Valores por default
	SET Par_NumLis				:= IFNULL(Par_NumLis,Entero_Cero);

	-- lISTA DE PRODUCTOS --
	IF(Par_NumLis = Lis_Completa) THEN
		SELECT	FechaCatalogo,			ServicioID,			Servicio,			TipoServicio,			ProductoID,
				Producto,				TipoFront,			DigVerificador,		Precio,					ShowAyuda,
				TipoReferencia, 		ClasificacionServ
			FROM	PSLPRODBROKER;
	END IF;


-- Fin del SP
END TerminaStore$$