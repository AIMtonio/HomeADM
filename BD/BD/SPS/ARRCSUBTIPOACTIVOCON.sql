-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRCSUBTIPOACTIVOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRCSUBTIPOACTIVOCON`;DELIMITER $$

CREATE PROCEDURE `ARRCSUBTIPOACTIVOCON`(
# =====================================================================================
# -- STORED PROCEDURE PARA CONSULTAR LOS SUBTIPOS DE ACTIVOS
# =====================================================================================
	Par_SubTipoActivoID		INT(11),			-- Numero de ID de un Sub tipo de Activo
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

    Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
    DECLARE Con_ActiInacti 	    INT(11);		-- Consulta de Activos e Inactivo por ID

    -- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero cero
	DECLARE	Decimal_Cero		DECIMAL(14,2);	-- Decimal cero

    DECLARE Est_Activo			CHAR(1);		-- Indica el estatus activo A=activo
    DECLARE Est_Inactivo		CHAR(1);		-- Indica el estatus inactivo I=inactivo

    -- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Valor de cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Valor de fecha vacia.
	SET	Entero_Cero				:= 0;				-- Valor de entero cero.
	SET	Decimal_Cero			:= 0.0;				-- Valor de decimal cero.

    SET Con_ActiInacti		    := 1;				-- Valor consulta 1
    SET Est_Activo			    := 'A';      		-- Estatus Activo=A
	SET Est_Inactivo			:= 'I';      		-- Estatus Inactivo=I

    -- Valores por default
    SET Par_SubTipoActivoID		:= IFNULL(Par_SubTipoActivoID,Entero_Cero);
	SET Par_NumCon				:= IFNULL(Par_NumCon,Entero_Cero);

    -- Consulta 1 Activos e inactivo
	IF (Par_NumCon = Con_ActiInacti) THEN
		SELECT 	SubTipoActivoID, Descripcion, Estatus
			FROM ARRCSUBTIPOACTIVO
			WHERE SubTipoActivoID = Par_SubTipoActivoID
			AND ESTATUS IN (Est_Activo, Est_Inactivo);
    END IF;

END TerminaStore$$