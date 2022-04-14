-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTACLASIFACTIVOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTACLASIFACTIVOCON`;

DELIMITER $$
CREATE PROCEDURE `SUBCTACLASIFACTIVOCON`(
	-- Store Procedure para la Consulta de SubCuentas por Clasificacion de Activos
	-- Activos --> Taller de Productos --> Guia Contable
	-- Modulo de Activos
	Par_ConceptoActivoID	INT(11),		-- ID del concepto contable de activo
	Par_TipoActivoID		INT(11), 		-- Id del tipo de activo
	Par_NumCon				TINYINT UNSIGNED,-- Numero de consulta

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante cadena vacia
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha vacia
	DECLARE Entero_Cero			INT(11);		-- Constante Entero cero
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Constante Decimal cero
	DECLARE Salida_SI			CHAR(1);		-- Constante de salida SI

	DECLARE Salida_NO			CHAR(1);		-- Constante de salida NO
	DECLARE Entero_Uno			INT(11);		-- Constante Entero Uno
	DECLARE Con_SubCta			TINYINT UNSIGNED;-- Consulta 1 : Conceptos contables activos


	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI				:= 'S';

	SET Salida_NO				:= 'N';
	SET Entero_Uno				:= 1;
	SET Con_SubCta				:= 1;

	-- Consulta 1: Concetos contables activos
	IF( Par_NumCon = Con_SubCta ) THEN

		SELECT ConceptoActivoID,	TipoActivoID,		SubCuenta
		FROM SUBCTACLASIFACTIVO
		WHERE ConceptoActivoID = Par_ConceptoActivoID
		  AND TipoActivoID = Par_TipoActivoID;

	END IF;

END TerminaStore$$