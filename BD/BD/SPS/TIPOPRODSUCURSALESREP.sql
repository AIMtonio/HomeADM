-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPRODSUCURSALESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOPRODSUCURSALESREP`;DELIMITER $$

CREATE PROCEDURE `TIPOPRODSUCURSALESREP`(
# ==============================================================================
# ------- SP PARA MOSTRAR REPORTE PDF DE LOS TIPOS DE CEDES POR SUCURSAL--------
# ==============================================================================
	Par_TipoProdID		INT(11),				-- ID del tipo de Producto
	Par_TipoInstrumento INT(11),
	Par_NumRep			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Rep_Principal		INT(11);
	DECLARE Estatus_Activo		CHAR(1);

	-- Declaracion de Variables
	DECLARE Var_NumSucursales	INT(10);

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Rep_Principal			:= 1;
	SET Estatus_Activo			:= 'A';


	SET Par_TipoProdID			:= IFNULL(Par_TipoProdID,Entero_Cero);
	SET Par_TipoInstrumento		:= IFNULL(Par_TipoInstrumento,Entero_Cero);


	IF(Par_NumRep = Rep_Principal) THEN
		SELECT		COUNT(DISTINCT(Tip.SucursalID))  INTO Var_NumSucursales
			FROM 	TIPOPRODSUCURSALES Tip
					INNER JOIN SUCURSALES Suc ON Tip.SucursalID = Suc.SucursalID
					INNER JOIN ESTADOSREPUB Est ON Tip.EstadoID = Est.EstadoID
			WHERE 	Tip.InstrumentoID 		= Par_TipoProdID
			AND   	Tip.TipoInstrumentoID	= Par_TipoInstrumento
			AND   	Tip.Estatus 			= Estatus_Activo;


		SELECT		Tip.TipProdSucID,	Tip.InstrumentoID,	LPAD(Tip.SucursalID, 3, '0') AS SucursalID,
					Var_NumSucursales AS NumSucursales,		0,	Tip.EstadoID,
					Tip.Estatus, 		Suc.NombreSucurs AS NombreSucursal, Est.Nombre AS NombreEstado
			FROM 	TIPOPRODSUCURSALES Tip
					INNER JOIN SUCURSALES Suc ON Tip.SucursalID = Suc.SucursalID
					INNER JOIN ESTADOSREPUB Est ON Tip.EstadoID = Est.EstadoID
			WHERE 	Tip.InstrumentoID 		= Par_TipoProdID
			AND 	Tip.TipoInstrumentoID	= Par_TipoInstrumento
			AND 	Tip.Estatus				= Estatus_Activo
			ORDER BY Tip.SucursalID;
	END IF;

END TerminaStore$$