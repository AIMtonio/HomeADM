-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTCONSOLIDALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTCONSOLIDALIS`;
DELIMITER $$

CREATE PROCEDURE `APORTCONSOLIDALIS`(
# ============================================================
# ------ SP PARA LISTAS DE APORTACIONES CONSOLIDADAS ---------
# ============================================================
	Par_ClienteID			INT(11),			-- NÚMERO DE CLIENTE.
	Par_AportacionID		INT(11),			-- NÚMERO DE APORTACION.
	Par_NumLis				TINYINT UNSIGNED,	-- NÚMERO DE LISTA.
	/* Parámetros de Auditoría */
	Par_Empresa				INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE	Var_AportID			INT(11);
	DECLARE	Var_ClienteID		INT(11);
	DECLARE Var_FechaVenc		DATE;

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	EstatusActivo		CHAR(1);
	DECLARE	Esta_Vigente		CHAR(1);
	DECLARE Lis_ConsolidaSaldos	INT(11);
	DECLARE Cons_SI				CHAR(1);
	DECLARE Cons_NO				CHAR(1);
	DECLARE ReinvCapital		CHAR(3);
	DECLARE ReinvCapInt			CHAR(3);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET Lis_ConsolidaSaldos	:= 1;			-- Lista aportaciones a consolidar en la renovación.
	SET	EstatusActivo		:= 'A';			-- Estatus Activo --
	SET	Esta_Vigente		:= 'N';			-- Estatus Vigente  --
	SET Cons_SI				:= 'S';
	SET Cons_NO				:= 'N';
	SET ReinvCapital		:= 'C';
	SET ReinvCapInt			:= 'CI';

	/** LISTA 13.
	 ** LISTA APORTACIONES DE UN CLIENTE
	 ** PARA LA CONSOLIDACIÓN DE SUS APORTACIONES. */
	IF(Par_NumLis = Lis_ConsolidaSaldos) THEN
			SET Var_AportID := (SELECT AportacionID FROM APORTCONSOLIDADAS WHERE AportConsID = Par_AportacionID);
			SELECT
				AportConsID AS AportacionID,	FechaVencimiento,	Capital AS Monto,	Interes AS InteresGenerado,	ISR AS InteresRetener,
				TotalAport AS Total,		Reinvertir,			TotalCons AS TotalReinversion
			FROM APORTCONSOLIDADAS
				WHERE AportacionID = Var_AportID
					AND AportConsID != Par_AportacionID;
	END IF;

END TerminaStore$$