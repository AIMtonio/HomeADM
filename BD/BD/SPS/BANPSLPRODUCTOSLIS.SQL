-- SP BANPSLPRODUCTOSLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS BANPSLPRODUCTOSLIS;

DELIMITER $$

CREATE PROCEDURE `BANPSLPRODUCTOSLIS`(
	-- -------------------------------------------------------------------------------------------------
-- Stored procedure para listar las configuraciones de los productos de servicios en linea ---------
-- -------------------------------------------------------------------------------------------------
	Par_ProductoID					INT(11),				-- Id del producto
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
	DECLARE Lis_L01	  				TINYINT;				-- L01 = Lista de servcios en movil
	DECLARE Lis_L02	  				TINYINT;				-- L02 = Detalle del servicio
	DECLARE Lis_L03	  				TINYINT;				-- Opcion de lista de productos activos en ventanilla
	DECLARE Var_SI 					CHAR(1); 				-- Variable con valor SI (S)
	DECLARE Est_Activo 				CHAR(1); 				-- Estatus activo
	DECLARE Banca_Linea				CHAR(1);
	DECLARE Banca_Movil				CHAR(1);

	-- Declaracion de variables
	DECLARE Var_TipoFront1 			TINYINT;				-- Tipo front 1
	DECLARE Var_IVA 				DECIMAL(5,2); 			-- Iva de la sucursal

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Lis_L01 					:= 1;					-- L01 = Lista de servcios en movil
	SET Lis_L02 					:= 2;					-- L02 = Detalle del servicio
	SET Lis_L03 					:= 3;					-- Opcion de lista de productos activos en ventanilla
	SET Var_SI 						:= 'S';					-- Variable con valor SI (S)
	SET Est_Activo 					:= 'A';					-- Estatus activo
	SET Banca_Linea 				:= 'B';
	SET Banca_Movil					:= 'M';
	SET Var_TipoFront1 				:= 1; 					-- Tipo front 1

	-- L01 = Lista de servcios en movil bancamovilact 
	IF(Par_NumLis = Lis_L01) THEN
		SELECT IVA INTO Var_IVA
			FROM SUCURSALES
			WHERE SucursalID = Aud_Sucursal;

		SELECT 	P.ProductoID,			P.Producto,				CONCAT(PR.Servicio, ' - ', P.Producto) DescProducto,		P.ClasificacionServ,
				IF(S.CobComBancaMovil = Var_SI,
					-- onlineBankingAmountCust -- supplierAmount -- vatAmounMobBankClie
					(S.MtoCteBancaMovil+(IF(PR.TipoFront = Var_TipoFront1, Decimal_Cero, PR.Precio))+(CAST(S.MtoCteBancaMovil * Var_IVA AS DECIMAL(14,2)))),
				Entero_Cero) AS Comission
			FROM PSLCONFIGPRODUCTO P
			INNER JOIN PSLCONFIGSERVICIO S ON S.ServicioID = P.ServicioID AND S.ClasificacionServ = P.ClasificacionServ
			INNER JOIN PSLPRODBROKER PR ON PR.ProductoID = P.ProductoID
			WHERE P.Habilitado = Var_SI
			AND P.Estatus = Est_Activo
			AND S.BancaMovilAct = Var_SI
			ORDER BY CONCAT(PR.Servicio, ' - ', P.Producto);

	END IF;
    
    -- L02 = Detalle del servicio por numero de producto bancamovilact 
	IF(Par_NumLis = Lis_L02) THEN
		SELECT IVA INTO Var_IVA
			FROM SUCURSALES
			WHERE SucursalID = Aud_Sucursal;

		SELECT 	P.ProductoID,			P.Producto,				P.ServicioID, 			P.ClasificacionServ,	0 AS InstCommission,        
				IF(PR.TipoFront = Var_TipoFront1, Decimal_Cero, PR.Precio) MtoProveedor,
				IF(PR.TipoFront = Var_TipoFront1, PR.Precio, Decimal_Cero) Precio,
                0 AS VatInstitComm,
                0 AS TotalPay,
				IF(S.CobComBancaMovil = Var_SI,
					-- onlineBankingAmountCust -- supplierAmount -- vatAmounMobBankClie
					(S.MtoCteBancaMovil+(IF(PR.TipoFront = Var_TipoFront1, Decimal_Cero, PR.Precio))+(CAST(S.MtoCteBancaMovil * Var_IVA AS DECIMAL(14,2)))),
				Entero_Cero) AS Comission
			FROM PSLCONFIGPRODUCTO P
			INNER JOIN PSLCONFIGSERVICIO S ON S.ServicioID = P.ServicioID AND S.ClasificacionServ = P.ClasificacionServ
			INNER JOIN PSLPRODBROKER PR ON PR.ProductoID = P.ProductoID
			WHERE P.Habilitado = Var_SI
			AND P.Estatus = Est_Activo
			AND S.BancaMovilAct = Var_SI
			AND PR.ProductoID = Par_ProductoID
			ORDER BY CONCAT(PR.Servicio, ' - ', P.Producto);
	END IF;
    
	-- DESCRIPCION COMPLETA DE TODOS LOS PRODUCTOS CON ESTATUS ACTIVO QUE TAMBIEN ESTEN ACTIVOS EN VENTANILLA,.banca en linea act 

	IF(Par_NumLis = Lis_L03) THEN
		SELECT IVA INTO Var_IVA
			FROM SUCURSALES
			WHERE SucursalID = Aud_Sucursal;

		SELECT 	P.ProductoID,			P.Producto,				CONCAT(PR.Servicio, ' - ', P.Producto) DescProducto,		P.ServicioID, 			P.ClasificacionServ,
				P.Habilitado,			P.Estatus,				S.CContaServicio,											S.CContaComision,		S.CContaIVAComisi,
				S.NomenclaturaCC,		S.VentanillaAct,		S.CobComVentanilla,											S.MtoCteVentanilla,		S.MtoUsuVentanilla,
				S.BancaLineaAct,		S.CobComBancaLinea,		S.MtoCteBancaLinea,											S.BancaMovilAct,		S.CobComBancaMovil,
				S.MtoCteBancaMovil,		PR.TipoReferencia,		PR.TipoFront,
				IF(PR.TipoFront = Var_TipoFront1, Decimal_Cero, PR.Precio) MtoProveedor,
				IF(PR.TipoFront = Var_TipoFront1, PR.Precio, Decimal_Cero) Precio,
				CAST(S.MtoCteBancaLinea * Var_IVA AS DECIMAL(14,2)) IVAMtoCteBancaLinea,
				CAST(S.MtoCteBancaMovil * Var_IVA AS DECIMAL(14,2)) IVAMtoCteBancaMovil
		FROM PSLCONFIGPRODUCTO P
			INNER JOIN PSLCONFIGSERVICIO S ON S.ServicioID = P.ServicioID AND S.ClasificacionServ = P.ClasificacionServ
			INNER JOIN PSLPRODBROKER PR ON PR.ProductoID = P.ProductoID
		WHERE P.Habilitado = Var_SI
			AND P.Estatus = Est_Activo
			AND S.BancaLineaAct = Var_SI
		ORDER BY CONCAT(PR.Servicio, ' - ', P.Producto);
	END IF;

-- Fin del SP
END TerminaStore$$