-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAMIENTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAMIENTOSLIS`;DELIMITER $$

CREATE PROCEDURE `ARRENDAMIENTOSLIS`(
	-- STORED PROCEDURE PARA LISTA DE ARRENDAMIENTOS
	Par_Nombre 				VARCHAR(50),        -- Nombre del CLIENTE
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de consulta

	Aud_EmpresaID			INT(11),			-- Id de la empresa
	Aud_Usuario				INT(11),			-- Usuario
	Aud_FechaActual			DATETIME,			-- Fecha actual
	Aud_DireccionIP 		VARCHAR(15),		-- Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Id del programa
	Aud_Sucursal			INT(11),			-- Numero de sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Numero de transaccion
    )
TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_Descripcion		VARCHAR(100);	-- Variable de la descripcion. Cardinal Sistemas Inteligentes

	-- Declaracion de Constantes
	DECLARE Entero_Cero     	INT(11);		-- Entero cero
	DECLARE Lis_Principal   	INT(11);		-- Lista Principal
	DECLARE Decimal_Cero    	DECIMAL(14,2);	-- Decimal cero
	DECLARE Cadena_Vacia    	CHAR(1);		-- Cadena Vacia
	DECLARE Lis_DesArrenda		INT(11);		-- Lista para la pantalla de pagare de arrendamiento). Cardinal Sistemas Inteligentes
	DECLARE Lis_ProdArrenda		INT(11);		-- Lista para la pantalla de autorizacion de arrendamiento. Cardinal Sistemas Inteligentes
	DECLARE Lis_Autorizados		INT(11);		-- Lista para la pantalla de entrega de arrendamiento. Cardinal Sistemas Inteligentes
	DECLARE Lis_ArrendaGral 	INT(11);		-- Lista para la pantalla de pago de arrendamiento. Cardinal Sistemas Inteligentes
	DECLARE Est_Generado		CHAR(1);		-- Estatus Generado. Cardinal Sistemas Inteligentes
	DECLARE Est_Autorizado		CHAR(1);		-- Estatus Autorizado. Cardinal Sistemas Inteligentes
	DECLARE Est_Vigente			CHAR(1);		-- Estatus Vigente. Cardinal Sistemas Inteligentes
	DECLARE Est_Vencido			CHAR(1);		-- Estatus Vencido. Cardinal Sistemas Inteligentes
	DECLARE Lis_ArrendaSuc		INT(11);		-- Lista de arrendamientos por sucursal
	DECLARE Lis_ArrendaMovCA	INT(11);		-- Lista para la pantalla de Movimientos de cargos y abonos de arrendamiento. Cardinal Sistemas Inteligentes

	-- Asignacion de Constantes
	SET Entero_Cero         := 0;
	SET Lis_Principal       := 1; 		-- Consulta por llave primaria
	SET Decimal_Cero        := 0.0;     -- Constante 0.0 --
	SET Cadena_Vacia        := '';      -- Constante Vacia --
	SET Lis_DesArrenda		:= 2;		-- Lista 2. Cardinal Sistemas Inteligentes
	SET Lis_ProdArrenda		:= 3;		-- Lista 3 para la consulta de arrendmientos con su nombre de producto. Cardinal Sistemas Inteligentes
	SET Lis_Autorizados		:= 4;		-- Lista 4 para la consulta de arrendamientos autorizados con su nombre de producto. Cardinal Sistemas Inteligentes
	SET Lis_ArrendaSuc		:= 5;		-- Lista 5 para consultar arrendamientos por sucursal
	SET Lis_ArrendaGral		:= 6;		-- Lista 6 para consultar general para la pantalla de pago de arrendamientos
	SET Est_Generado		:='G';		-- Estatus Generado. Cardinal Sistemas Inteligentes
	SET Est_Autorizado		:='A';		-- Estatus Autorizado. Cardinal Sistemas Inteligentes
	SET Est_Vigente			:='V';		-- Estatus Vigente. Cardinal Sistemas Inteligentes
	SET Est_Vencido	  		:='B';		-- Estatus Vencido. Cardinal Sistemas Inteligentes
	SET Lis_ArrendaMovCA	:= 7;		-- Lista 7 Arrendamientos Vigentes y vencidos . Cardinal Sistemas Inteligentes

	-- CONSULTA PRINCIPAL
	IF(Par_NumLis = Lis_Principal)THEN
		SELECT  A.ArrendaID,    C.NombreCompleto,  A.FechaApertura,    A.FechaUltimoVen,   P.Descripcion,
				CASE A.Estatus
					WHEN "G"    THEN "GENERADO"
					WHEN "A"    THEN "AUTORIZADO"
					WHEN "C"    THEN "CANCELADO"
					WHEN "V"    THEN "VIGENTE"
					WHEN "B"    THEN "VENCIDO"
					WHEN "P"    THEN "PAGADO"
					ELSE "NO IDENTIFICADO" END AS Estatus
			FROM ARRENDAMIENTOS A
				INNER JOIN CLIENTES C                       ON A.ClienteID                  = C.ClienteID
				  AND  C.NombreCompleto   LIKE CONCAT("%", Par_Nombre, "%")
				INNER JOIN PRODUCTOARRENDA P    ON P.ProductoArrendaID  = A.ProductoArrendaID
		LIMIT 0, 15;
	END IF;

	-- Lista para la pantalla de Pagare de Arrendamiento. Cardinal Sistemas Inteligentes
	IF(Par_NumLis = Lis_DesArrenda) THEN
		SET Var_Descripcion	:= CONCAT("%", Par_Nombre, "%");

		SELECT	arrenda.ArrendaID AS ArrendaID,	cli.NombreCompleto AS Cliente
			FROM ARRENDAMIENTOS AS arrenda
			INNER JOIN CLIENTES AS cli ON cli.ClienteID = arrenda.ClienteID
			WHERE	arrenda.ArrendaID  LIKE Var_Descripcion
			ORDER BY arrenda.ArrendaID
			LIMIT 0, 15;
	END IF;
	-- Fin Lista.  Cardinal Sistemas Inteligentes

	-- Lista para la pantalla de autorizacion de arrendamiento. Cardinal Sistemas Inteligentes
	IF(Par_NumLis = Lis_ProdArrenda) THEN
		SET Var_Descripcion	:= CONCAT("%", Par_Nombre, "%");

		SELECT	arrenda.ArrendaID AS ArrendaID,	prod.NombreCorto AS NombreCorto, cli.NombreCompleto AS NombreCliente
			FROM ARRENDAMIENTOS AS arrenda
			INNER JOIN PRODUCTOARRENDA	AS prod ON arrenda.ProductoArrendaID = prod.ProductoArrendaID
			INNER JOIN CLIENTES			AS cli	ON arrenda.ClienteID = cli.ClienteID
			WHERE (prod.NombreCorto	LIKE Var_Descripcion
			   OR cli.NombreCompleto  LIKE Var_Descripcion)
			  AND arrenda.Estatus = Est_Generado
			ORDER BY arrenda.ArrendaID
			LIMIT 0, 15;
	END IF;
	-- Fin Lista.  Cardinal Sistemas Inteligentes

	-- Lista para la pantalla de entrega de arrendamiento. Cardinal Sistemas Inteligentes
	IF(Par_NumLis = Lis_Autorizados) THEN
		SET Var_Descripcion	:= CONCAT("%", Par_Nombre, "%");

		SELECT	arrenda.ArrendaID AS ArrendaID,	prod.NombreCorto AS NombreCorto, cli.NombreCompleto AS NombreCliente
			FROM ARRENDAMIENTOS AS arrenda
			INNER JOIN PRODUCTOARRENDA	AS prod ON arrenda.ProductoArrendaID = prod.ProductoArrendaID
			INNER JOIN CLIENTES			AS cli	ON arrenda.ClienteID = cli.ClienteID
			WHERE (prod.NombreCorto	LIKE Var_Descripcion
			   OR cli.NombreCompleto  LIKE Var_Descripcion)
			  AND arrenda.Estatus = Est_Autorizado
			ORDER BY arrenda.ArrendaID
			LIMIT 0, 15;
	END IF;
	-- Fin Lista.  Cardinal Sistemas Inteligentes

	-- Lista por sucursal para la pantalla de pago de arrendamiento. Cardinal Sistemas Inteligentes
	IF(Par_NumLis = Lis_ArrendaSuc) THEN
		SELECT	arrendamiento.ArrendaID,	 	cli.ClienteID, 		cli.NombreCompleto,	suc.NombreSucurs,	arrendamiento.FechaApertura,
				arrendamiento.FechaUltimoVen, 	prodAr.Descripcion,
				CASE arrendamiento.Estatus
					WHEN "V"    THEN "VIGENTE"
					WHEN "B"    THEN "VENCIDO" END
					AS Estatus
			FROM ARRENDAMIENTOS arrendamiento
			INNER JOIN CLIENTES cli ON arrendamiento.ClienteID = cli.ClienteID
			INNER JOIN PRODUCTOARRENDA prodAr ON arrendamiento.ProductoArrendaID = prodAr.ProductoArrendaID
			INNER JOIN SUCURSALES suc ON suc.SucursalID = cli.SucursalOrigen
			WHERE (arrendamiento.Estatus = Est_Vigente OR arrendamiento.Estatus = Est_Vencido )
			  AND cli.NombreCompleto LIKE CONCAT("%", Par_Nombre, "%")
			  AND cli.SucursalOrigen = Aud_Sucursal
		LIMIT 0, 25;
	END IF;

	-- Lista general para la pantalla de pago de arrendamiento. Cardinal Sistemas Inteligentes
	IF(Par_NumLis = Lis_ArrendaGral) THEN
		SELECT	arrendamiento.ArrendaID,	 	cli.NombreCompleto,	arrendamiento.FechaApertura, arrendamiento.FechaUltimoVen, 	prodAr.Descripcion,
				CASE arrendamiento.Estatus
					WHEN "V"    THEN "VIGENTE"
					WHEN "B"    THEN "VENCIDO" END
					AS Estatus
			FROM ARRENDAMIENTOS arrendamiento
			INNER JOIN CLIENTES cli ON arrendamiento.ClienteID = cli.ClienteID
			INNER JOIN PRODUCTOARRENDA prodAr ON arrendamiento.ProductoArrendaID = prodAr.ProductoArrendaID
			WHERE (arrendamiento.Estatus = Est_Vigente OR arrendamiento.Estatus = Est_Vencido )
			  AND cli.NombreCompleto LIKE CONCAT("%", Par_Nombre, "%")
		LIMIT 0, 25;
	END IF;

	-- Lista para la pantalla de Cargos y Abonos de arrendamiento. Cardinal Sistemas Inteligentes
	IF(Par_NumLis = Lis_ArrendaMovCA) THEN
		SET Var_Descripcion	:= CONCAT("%", Par_Nombre, "%");

		SELECT	arrenda.ArrendaID AS ArrendaID,	cli.NombreCompleto AS Cliente, prod.NombreCorto AS ProductoDescri
			FROM ARRENDAMIENTOS AS arrenda
			INNER JOIN CLIENTES AS cli ON cli.ClienteID = arrenda.ClienteID
			INNER JOIN PRODUCTOARRENDA	AS prod ON prod.ProductoArrendaID = arrenda.ProductoArrendaID
			WHERE	arrenda.ArrendaID  LIKE Var_Descripcion
			  AND	arrenda.Estatus IN(Est_Vigente, Est_Vencido)
			ORDER BY arrenda.ArrendaID
			LIMIT 0, 15;
	END IF;
	-- Fin Lista.  Cardinal Sistemas Inteligentes
END TerminaStore$$