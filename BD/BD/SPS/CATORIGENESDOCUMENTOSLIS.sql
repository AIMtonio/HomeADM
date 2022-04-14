-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATORIGENESDOCUMENTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS CATORIGENESDOCUMENTOSLIS;

DELIMITER $$
CREATE PROCEDURE `CATORIGENESDOCUMENTOSLIS`(
	-- Store Procedure: Que Lista los Origenes de Documentos de Guarda Valores
	-- Modulo Guarda Valores
	Par_CatOrigenDocumentoID	INT(11),			-- ID de Tabla
	Par_NombreOrigen			VARCHAR(50),		-- Nombre del Origen
	Par_NumLista				TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);			-- Constante de Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Est_Activo			CHAR(1);			-- Estatus Activo

	DECLARE Lis_Principal		TINYINT UNSIGNED;	-- Lista Principal
	DECLARE Lis_ListaCombo		TINYINT UNSIGNED;	-- Lista de Instrumentos Activos
	DECLARE Lis_Filtra			TINYINT UNSIGNED;	-- Lista de Filtado Instrumentos
	DECLARE Lis_FiltaActivo		TINYINT UNSIGNED;	-- Lista de Filtrado de Instrumentos Activos

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Est_Activo				:= 'A';

	SET Lis_Principal			:= 1;
	SET Lis_ListaCombo			:= 2;
	SET Lis_Filtra				:= 3;
	SET Lis_FiltaActivo			:= 4;

	-- Se realiza la Lista principal
	IF( Par_NumLista = Lis_Principal ) THEN

		SELECT	CatOrigenDocumentoID,	NombreOrigen,	Descripcion,	Estatus
		FROM CATORIGENESDOCUMENTOS;

	END IF;

	-- Se realiza la Lista de Origenes de Documentos Activos
	IF( Par_NumLista = Lis_ListaCombo ) THEN

		SELECT	CatOrigenDocumentoID,	NombreOrigen,	Descripcion,	Estatus
		FROM CATORIGENESDOCUMENTOS
		WHERE Estatus = Est_Activo;

	END IF;

	-- Se realiza la Lista de Origenes de Documentos
	IF( Par_NumLista = Lis_Filtra ) THEN

		SELECT	CatOrigenDocumentoID,	Descripcion,
		CASE WHEN Estatus = 'A' THEN 'ACTIVO'
			 WHEN Estatus = 'I' THEN 'INACTIVO'
			 ELSE 'INDEFINIDO'
		END AS Estatus
		FROM CATORIGENESDOCUMENTOS
		WHERE NombreOrigen LIKE CONCAT("%", Par_NombreOrigen, "%")
		LIMIT 0,15;

	END IF;

	-- Se realiza la Lista de Filtrado de Origenes de Documentos Activos
	IF( Par_NumLista = Lis_FiltaActivo ) THEN

		SELECT	CatOrigenDocumentoID, NombreOrigen AS Descripcion
		FROM CATORIGENESDOCUMENTOS
		WHERE NombreOrigen LIKE CONCAT("%", Par_NombreOrigen, "%")
		  AND Estatus = Est_Activo
		LIMIT 0,15;

	END IF;
END TerminaStore$$