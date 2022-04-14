-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURAPROVLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTURAPROVLIS`;DELIMITER $$

CREATE PROCEDURE `FACTURAPROVLIS`(
	Par_NoFactura		VARCHAR(20),
	Par_ProveedorID    	INT,
	Par_NumLis			TINYINT UNSIGNED,

	Par_EmpresaID 		INT(11),
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE	Entero_Cero				INT;
DECLARE	Lis_Principal			INT;
DECLARE	Lis_FactProve 			INT;
DECLARE	Lis_FacPorProv 			INT;
DECLARE	Lis_AltaPagParc			INT;
DECLARE Lis_AltaPagParcPro		INT;
DECLARE Lis_FactProvAnt			INT;
DECLARE	PerFisica				CHAR(1);
DECLARE	PerMoral				CHAR(1);
DECLARE	Est_Alta				CHAR(1); -- Corresponde con el campo Estatus (Alta) de la tabla FACTURAPROV
DECLARE	Est_ParcPag				CHAR(1); -- Corresponde con el campo Estatus (Parcialmente Pagada) de la tabla FACTURAPROV
DECLARE	Est_Vencido				CHAR(1); -- Corresponde con el campo Estatus (Vencido) de la tabla FACTURAPROV
DECLARE	Est_Requisicion			CHAR(1); -- Corresponde con el campo Estatus (en proceso de requisicion) de la tabla FACTURAPROV
DECLARE	Est_Aprobado			CHAR(1); -- Corresponde con el campo Estatus (Aprobado) de la tabla REQGASTOSUCURMOV

-- Asignacion de constantes
SET	Entero_Cero				:= 0; -- Entero Cero
SET	Lis_Principal			:= 1; -- Lista principal
SET	Lis_FactProve			:= 2; -- Lista de Facuturas por proveedor
SET	Lis_FacPorProv			:= 3; -- lista de facturas filtrada por proveedor
SET	Lis_AltaPagParc			:= 4; -- lista de facturas con estatus A=Alta o P=Parcialmente Pagada
SET	Lis_AltaPagParcPro		:= 5; -- lista de facturas con estatus A= Alta o P=Parcialmente pagada por proveedor
SET Lis_FactProvAnt         := 6; -- Lista de facturas con estatus P=Parcialmente pagada por proveedor o R=En proceso de requisiciÃ³n
SET	PerFisica				:='F';
SET	PerMoral				:='M';
SET	Est_Alta				:='A'; -- Corresponde con el campo Estatus (Alta) de la tabla FACTURAPROV
SET	Est_ParcPag				:='P'; -- Corresponde con el campo Estatus (Parcialmente Pagada) de la tabla FACTURAPROV
SET	Est_Vencido				:='V'; -- Corresponde con el campo Estatus (Vencido) de la tabla FACTURAPROV
SET	Est_Requisicion			:='R'; -- Corresponde con el campo Estatus (en proceso de requisicion) de la tabla FACTURAPROV
SET	Est_Aprobado			:='A'; -- Corresponde con el campo Estatus (Aprobado) de la tabla REQGASTOSUCURMOV

-- Lista de Facturas por Proveedor
IF(Par_NumLis = Lis_FactProve) THEN
	SELECT	Fac.NoFactura,	CASE Prov.TipoPersona
								WHEN  PerFisica	THEN CONCAT(Prov.PrimerNombre, " ",Prov.ApellidoPaterno)
								WHEN  PerMoral	THEN Prov.RazonSocial
								END AS facturaProvID,
			Fac.Estatus,	Fac.ProveedorID
		FROM FACTURAPROV Fac,
			PROVEEDORES Prov
		WHERE Prov.ProveedorID = Fac.ProveedorID
		AND 	Fac.NoFactura LIKE CONCAT("%",Par_NoFactura, "%")
		LIMIT 0, 15;
END IF;

-- Lista de Facturas filtradas por Proveedor
IF(Par_NumLis = Lis_FacPorProv) THEN
	SELECT	Fac.NoFactura,	CASE Prov.TipoPersona
								WHEN  PerFisica	THEN CONCAT(Prov.PrimerNombre, " ",Prov.ApellidoPaterno)
								WHEN  PerMoral	THEN Prov.RazonSocial
								END AS facturaProvID,
			Fac.Estatus,	Fac.ProveedorID
		FROM FACTURAPROV Fac,
			PROVEEDORES Prov
		WHERE 	Prov.ProveedorID = Fac.ProveedorID
		AND 		Fac.ProveedorID	= Par_ProveedorID
		AND 		Fac.NoFactura LIKE CONCAT("%",Par_NoFactura, "%")
		LIMIT 0, 15;
END IF;


-- lista de facturas con estatus A=Alta o P=Parcialmente Pagada
IF(Par_NumLis = Lis_AltaPagParc) THEN
	SELECT	Fac.NoFactura,	CASE Prov.TipoPersona
								WHEN  PerFisica	THEN CONCAT(Prov.PrimerNombre," ",Prov.ApellidoPaterno)
								WHEN  PerMoral	THEN Prov.RazonSocial
								END AS facturaProvID,
			Fac.Estatus,		Fac.ProveedorID
		FROM FACTURAPROV Fac,
			PROVEEDORES Prov
		WHERE Prov.ProveedorID = Fac.ProveedorID
		AND (Fac.Estatus = Est_Alta
		OR 	Fac.Estatus = Est_ParcPag)
		AND (Fac.NoFactura LIKE CONCAT("%",Par_NoFactura, "%")
		OR	Prov.RazonSocial LIKE CONCAT("%",Par_NoFactura, "%")
		OR	Prov.PrimerNombre LIKE CONCAT("%",Par_NoFactura, "%")
		OR	Prov.ApellidoPaterno LIKE CONCAT("%",Par_NoFactura, "%"))
		LIMIT 0, 15;
END IF;
-- lista de facturas con estatus A=Alta o P=Parcialmente Pagada y que sean del mismo proveedor
IF(Par_NumLis = Lis_AltaPagParcPro) THEN
	SELECT	Fac.NoFactura,	CASE Prov.TipoPersona
								WHEN  PerFisica	THEN CONCAT(Prov.PrimerNombre," ",Prov.ApellidoPaterno)
								WHEN  PerMoral	THEN Prov.RazonSocial
								END AS facturaProvID,
			Fac.Estatus,		Fac.ProveedorID
		FROM FACTURAPROV Fac,
			PROVEEDORES Prov
		WHERE Prov.ProveedorID = Fac.ProveedorID

		AND (Fac.ProveedorID = Par_ProveedorID
		AND Fac.Estatus = Est_Alta)
		AND (Fac.NoFactura LIKE CONCAT("%",Par_NoFactura, "%")
		OR	Prov.RazonSocial LIKE CONCAT("%",Par_NoFactura, "%")
		OR	Prov.PrimerNombre LIKE CONCAT("%",Par_NoFactura, "%")
		OR	Prov.ApellidoPaterno LIKE CONCAT("%",Par_NoFactura, "%"))
		LIMIT 0, 15;
END IF;

-- Lista de facturas con estatus P=Parcialmente pagada por proveedor o R=En proceso de requisiciÃ³n
IF(Par_NumLis = Lis_FactProvAnt) THEN
	SELECT	Req.NoFactura, CASE Prov.TipoPersona
									WHEN  PerFisica	THEN CONCAT(Prov.PrimerNombre," ",Prov.ApellidoPaterno)
									WHEN  PerMoral	THEN Prov.RazonSocial
									END AS facturaProvID,Fac.Estatus,Fac.ProveedorID
FROM	REQGASTOSUCURMOV Req,
		FACTURAPROV Fac,
		PROVEEDORES Prov
	WHERE	Prov.ProveedorID= Par_ProveedorID
		AND Prov.ProveedorID= Fac.ProveedorID
		AND Req.ProveedorID	= Fac.ProveedorID
		AND	Fac.NoFactura	= Req.NoFactura
		AND Req.Estatus		= 'A'
		AND Req.ClaveDispMov= Entero_Cero
		AND (Fac.Estatus	= Est_Requisicion
			OR Fac.Estatus	= Est_ParcPag)
		AND Fac.SaldoFactura > Entero_Cero
		AND (Fac.NoFactura LIKE CONCAT('%',Par_NoFactura, '%')
			OR	Prov.RazonSocial LIKE CONCAT('%',Par_NoFactura, '%')
			OR	Prov.PrimerNombre LIKE CONCAT('%',Par_NoFactura, '%')
			OR	Prov.ApellidoPaterno LIKE CONCAT('%',Par_NoFactura, '%'))
	GROUP BY Req.NoFactura, Prov.TipoPersona, Fac.Estatus, Fac.ProveedorID
	LIMIT 0, 15;
END IF;

END TerminaStore$$