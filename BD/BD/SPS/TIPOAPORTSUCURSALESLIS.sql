-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOAPORTSUCURSALESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOAPORTSUCURSALESLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOAPORTSUCURSALESLIS`(
# =================================================================
# -------- SP PARA LISTAR TIPOS DE PRODUCTOS POR SUCURSAL----------
# =================================================================
	Par_InstrumentoID			INT(11),			-- ID del instrumento
	Par_TipoInstrumentoID		INT(11),			-- ID del tipo de instrumento
	Par_SucursalID				INT(11),			-- ID de la sucursal
	Par_EstadoID				INT(11),			-- ID del estado
	Par_NumLis					TINYINT UNSIGNED,	-- Numero de lista

	Par_EmpresaID				INT(11),			-- Parametro de auditoria
	Aud_Usuario					INT(11),			-- Parametro de auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal				INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE Var_Sentencia				VARCHAR(9000);

	# Declaracion de constantes
	DECLARE	Cadena_Vacia				CHAR(1);
	DECLARE	Fecha_Vacia					DATE;
	DECLARE	Entero_Cero					INT(11);
	DECLARE	Lis_Principal 				INT(11);
	DECLARE Lis_PorSucursal				INT(11);
	DECLARE Lis_PorEstado				INT(11);
	DECLARE Lis_PorSucursalTasas 		INT(11);
	DECLARE Lis_PorEstadoTasas			INT(11);
	DECLARE Lis_PorPrincipalTasas 		INT(11);
	DECLARE Estatus_Activo				CHAR(1);

	SET	Cadena_Vacia					:= '';				-- Constante Cadena Vacia
	SET	Fecha_Vacia						:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero						:= 0;				-- Entero cero
	SET	Lis_Principal					:= 1;				-- Lsita principal
	SET Lis_PorSucursal					:= 2;				-- Lista por sucursal
	SET Lis_PorEstado					:= 5;				-- Lista por estado
	SET Lis_PorSucursalTasas			:= 7;				-- Lista por sucursal y tasas
	SET Lis_PorEstadoTasas 				:= 10;				-- Lista por estados y tasas
	SET Lis_PorPrincipalTasas 			:= 12;				-- Lista por tasas
	SET Estatus_Activo					:= 'A';				-- Estatus activo


	# 1. Lista Sucursales guardadas
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	Tip.TipProdSucID,	Tip.InstrumentoID,	LPAD(Tip.SucursalID, 3, '0') AS SucursalID,	Tip.EstadoID,	Estatus_Activo AS Estatus,
				Suc.NombreSucurs AS NombreSucursal,	Est.Nombre AS NombreEstado
			FROM	TIPOAPORTSUCURSALES Tip
					INNER JOIN SUCURSALES Suc ON Tip.SucursalID = Suc.SucursalID
					INNER JOIN ESTADOSREPUB Est ON Tip.EstadoID = Est.EstadoID
			WHERE 	Tip.InstrumentoID		= Par_InstrumentoID
			AND 	Tip.TipoInstrumentoID	= Par_TipoInstrumentoID
			AND 	Tip.Estatus 			= Estatus_Activo;
	END IF;


	# 2. Lista sucursales usando por filtro la sucursalID
	IF(Par_NumLis = Lis_PorSucursal) THEN

		IF(IFNULL(Par_SucursalID,Entero_Cero) = Entero_Cero)THEN
			SELECT LPAD(Suc.SucursalID, 3, '0') AS SucursalID,	Est.EstadoID,	Estatus_Activo AS Estatus,
						Suc.NombreSucurs AS NombreSucursal,		Est.Nombre AS NombreEstado
			FROM SUCURSALES Suc
				INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
			WHERE Suc.Estatus = Estatus_Activo
			ORDER BY Suc.SucursalID,	Est.EstadoID;

		ELSE
			SELECT LPAD(Suc.SucursalID, 3, '0') AS SucursalID,	Est.EstadoID,	Estatus_Activo AS Estatus,
						Suc.NombreSucurs AS NombreSucursal,		Est.Nombre AS NombreEstado
			FROM	SUCURSALES Suc
					INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
			WHERE 	Suc.SucursalID = Par_SucursalID AND Suc.Estatus = Estatus_Activo
			ORDER BY Suc.SucursalID,	Est.EstadoID;
		END IF;

	END IF;

	# 5. Lista sucursales usando por filtro EstadoID
	IF(Par_NumLis = Lis_PorEstado) THEN

		IF(IFNULL(Par_EstadoID,Entero_Cero) = Entero_Cero)THEN
			SELECT LPAD(Suc.SucursalID, 3, '0') AS SucursalID,	Est.EstadoID,	Estatus_Activo AS Estatus,
						Suc.NombreSucurs AS NombreSucursal,		Est.Nombre AS NombreEstado
			FROM	SUCURSALES Suc
					INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
			WHERE 	Suc.Estatus = Estatus_Activo
			ORDER BY Suc.SucursalID, Est.EstadoID;

		ELSE
			SELECT LPAD(Suc.SucursalID, 3, '0') AS SucursalID,	Est.EstadoID,	Estatus_Activo AS Estatus,
						Suc.NombreSucurs AS NombreSucursal,		Est.Nombre AS NombreEstado
			FROM SUCURSALES Suc
				INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
			WHERE Est.EstadoID = Par_EstadoID AND Suc.Estatus = Estatus_Activo
			ORDER BY Suc.SucursalID, Est.EstadoID;
		END IF;

	END IF;



	# 7. Lista sucursales usando por filtro la tipoInstrumentoID, InstrumentoID y SucursalID
	IF(Par_NumLis = Lis_PorSucursalTasas) THEN
		IF(IFNULL(Par_SucursalID,Entero_Cero) = Entero_Cero)THEN
			SELECT LPAD(Suc.SucursalID, 3, '0') AS SucursalID,	Est.EstadoID,Estatus_Activo AS Estatus,
							Suc.NombreSucurs AS NombreSucursal,	Est.Nombre AS NombreEstado
				FROM 	TIPOAPORTSUCURSALES Tip
						INNER JOIN SUCURSALES Suc ON Suc.SucursalID=Tip.SucursalID
						INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
				WHERE 	Suc.Estatus				= Estatus_Activo
				AND 	Tip.InstrumentoID		= Par_InstrumentoID
                AND 	Tip.TipoInstrumentoID	= Par_TipoInstrumentoID
				ORDER BY Suc.SucursalID,	Est.EstadoID;
		ELSE
			SELECT LPAD(Suc.SucursalID, 3, '0') AS SucursalID,	Est.EstadoID,Estatus_Activo AS Estatus,
						Suc.NombreSucurs AS NombreSucursal,		Est.Nombre AS NombreEstado
				FROM 	TIPOAPORTSUCURSALES Tip
						INNER JOIN SUCURSALES Suc ON Suc.SucursalID=Tip.SucursalID
						INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
				WHERE 	Tip.SucursalID 			= Par_SucursalID
				AND 	Tip.InstrumentoID		= Par_InstrumentoID
				AND 	Tip.TipoInstrumentoID	= Par_TipoInstrumentoID
				AND 	Suc.Estatus 			= Estatus_Activo
				ORDER BY Suc.SucursalID, Est.EstadoID;
		END IF;
	END IF;

	IF(Par_NumLis = Lis_PorEstadoTasas) THEN

		IF(IFNULL(Par_EstadoID,Entero_Cero) = Entero_Cero)THEN
			SELECT LPAD(Suc.SucursalID, 3, '0') AS SucursalID,	Est.EstadoID,	Estatus_Activo AS Estatus,
						Suc.NombreSucurs AS NombreSucursal,		Est.Nombre AS NombreEstado
			FROM 	TIPOAPORTSUCURSALES Tip
					INNER JOIN SUCURSALES Suc ON Suc.SucursalID=Tip.SucursalID
					INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
			WHERE 	Tip.InstrumentoID		= Par_InstrumentoID
			AND 	Tip.TipoInstrumentoID	= Par_TipoInstrumentoID
			AND 	Suc.Estatus 			= Estatus_Activo
			ORDER BY Suc.SucursalID,  Est.EstadoID;

		ELSE
			SELECT LPAD(Suc.SucursalID, 3, '0') AS SucursalID,	Est.EstadoID,	Estatus_Activo AS Estatus,
						Suc.NombreSucurs AS NombreSucursal,		Est.Nombre AS NombreEstado
			FROM 	TIPOAPORTSUCURSALES Tip
					INNER JOIN SUCURSALES Suc ON Suc.SucursalID=Tip.SucursalID
					INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
			WHERE  	Tip.InstrumentoID		= Par_InstrumentoID
			AND 	Tip.TipoInstrumentoID	= Par_TipoInstrumentoID
			AND 	Est.EstadoID 			= Par_EstadoID
			AND 	Suc.Estatus 			= Estatus_Activo
			ORDER BY Suc.SucursalID,  Est.EstadoID;
		END IF;

	END IF;


	IF(Par_NumLis = Lis_PorPrincipalTasas) THEN
	SELECT	Tip.TasaAportSucID,		Tip.TipoAportacionID,
				LPAD(Tip.SucursalID, 3, '0') AS SucursalID,	Tip.EstadoID,	Estatus_Activo AS Estatus,
				Suc.NombreSucurs AS NombreSucursal,			Est.Nombre AS NombreEstado
			FROM	TASAAPORTSUCURSALES Tip
					INNER JOIN SUCURSALES Suc ON Tip.SucursalID = Suc.SucursalID
					INNER JOIN ESTADOSREPUB Est ON Tip.EstadoID = Est.EstadoID
			WHERE 	Tip.TipoAportacionID 	= Par_InstrumentoID
			AND 	Tip.TasaAportacionID	= Par_TipoInstrumentoID
			AND 	Tip.Estatus 			= Estatus_Activo;
	END IF;


END TerminaStore$$