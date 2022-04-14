-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALENDARIOPRODCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALENDARIOPRODCON`;DELIMITER $$

CREATE PROCEDURE `CALENDARIOPRODCON`(
/* CONSULTA EL ESQUEMA DE CALENDARIOS POR PRODUCTO DE CREDITO.
 * */
	Par_ProduCredID			INT(11),			-- Numero del producto de credito.
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta.

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria ID de la Empresa
	Aud_Usuario				INT(11),			-- Parametro de Auditoria ID del Usuario
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria Fecha Actual

	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(60),		-- Parametro de Auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria ID de la Sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria Numero de la Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Entero_Cero		INT(11);
	DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE SalidaSI		CHAR(1);
	DECLARE SalidaNO		CHAR(1);
	DECLARE Con_Principal	INT(11);

	-- Asignacion  de constantes
	SET	Cadena_Vacia		:= '';		-- Cadena Vacia
	SET	Entero_Cero			:= 0;		-- Entero Cero
	SET	Decimal_Cero		:= 0.0;		-- Decimal Cero
	SET	SalidaSI			:= 'S';		-- Salida: SI
	SET	SalidaNO			:= 'N';		-- Salida: NO
	SET	Con_Principal		:= 1;		-- Consulta Principal

	SET Aud_FechaActual := NOW();

    -- 1.- Consulta Principal
	IF(Par_NumCon = Con_Principal) THEN
		SELECT
			ProductoCreditoID,	FecInHabTomar,		AjusFecExigVenc,	PermCalenIrreg,	AjusFecUlAmoVen,
			TipoPagoCapital,	IguaCalenIntCap,	Frecuencias,		PlazoID,		DiaPagoCapital,
			DiaPagoInteres,		TipoDispersion,		DiaPagoQuincenal,	DiasReqPrimerAmor
		FROM CALENDARIOPROD
			WHERE ProductoCreditoID = Par_ProduCredID;
	END IF;

END TerminaStore$$