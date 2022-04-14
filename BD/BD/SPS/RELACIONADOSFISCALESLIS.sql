DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACIONADOSFISCALESLIS`;
DELIMITER $$
CREATE PROCEDURE `RELACIONADOSFISCALESLIS` (
# ==========================================================================
# ------ STORED PARA LISTA DE RELACIONADOS FISCALES  -----------------------
# ==========================================================================
	Par_ClienteID				INT(11),		-- ID del cliente tabla CLIENTES
    Par_Ejercicio				INT(11),		-- Anio del ejercicio
	Par_NumLista				INT(11),		-- Numero de lista

	Par_EmpresaID 				INT(11), 		-- Parametro de Auditoria
	Aud_Usuario 				INT(11), 		-- Parametro de Auditoria
	Aud_FechaActual 			DATETIME, 		-- Parametro de Auditoria
	Aud_DireccionIP 			VARCHAR(15), 	-- Parametro de Auditoria
	Aud_ProgramaID 				VARCHAR(50), 	-- Parametro de Auditoria
	Aud_Sucursal 				INT(11), 		-- Parametro de Auditoria
	Aud_NumTransaccion 			BIGINT(20) 		-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE Fecha_Vacia			DATE;

	DECLARE Lis_RelaFiscales	INT(11);		-- Lista 1: relacionados fiscales grid
	DECLARE TipoRel_Cte			CHAR(1);		-- Tipo de relacionado cliente
    DECLARE Cont_SI				CHAR(1);		-- Constante si

	-- Seteo de valores
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero     	:= 0.0;
	SET Cadena_Vacia    	:= '';
	SET SalidaSI        	:= 'S';
	SET Fecha_Vacia     	:= '1900-01-01';

	SET Lis_RelaFiscales	:= 1;
    SET TipoRel_Cte			:= 'C';
    SET Cont_SI				:= 'S';

    -- Liata 1: relacionados fiscales grid
	IF(Par_NumLista = Lis_RelaFiscales)THEN
		SELECT 	REL.TipoRelacionado,	REL.CteRelacionadoID,	REL.ParticipacionFiscal,
        IF(REL.TipoRelacionado = TipoRel_Cte,CTE.TipoPersona, REL.TipoPersona) AS TipoPersona,
		IF(REL.TipoRelacionado = TipoRel_Cte,CTE.PrimerNombre, REL.PrimerNombre) AS PrimerNombre,
		IF(REL.TipoRelacionado = TipoRel_Cte,CTE.SegundoNombre, REL.SegundoNombre) AS SegundoNombre,
		IF(REL.TipoRelacionado = TipoRel_Cte,CTE.TercerNombre, REL.TercerNombre) AS TercerNombre,
		IF(REL.TipoRelacionado = TipoRel_Cte,CTE.ApellidoPaterno, REL.ApellidoPaterno) AS ApellidoPaterno,
		IF(REL.TipoRelacionado = TipoRel_Cte,CTE.ApellidoMaterno, REL.ApellidoMaterno) AS ApellidoMaterno,
		IF(REL.TipoRelacionado = TipoRel_Cte,CTE.RegistroHacienda, REL.RegistroHacienda) AS RegistroHacienda,
		IF(REL.TipoRelacionado = TipoRel_Cte,CTE.Nacion, REL.Nacion) AS Nacion,
		IF(REL.TipoRelacionado = TipoRel_Cte,CTE.PaisResidencia, REL.PaisResidencia) AS PaisResidencia,
		IF(REL.TipoRelacionado = TipoRel_Cte,CTE.RFC, REL.RFC) AS RFC,
		IF(REL.TipoRelacionado = TipoRel_Cte,CTE.CURP, REL.CURP) AS CURP,

		IF(REL.TipoRelacionado = TipoRel_Cte,DIR.EstadoID, REL.EstadoID) AS EstadoID,
		IF(REL.TipoRelacionado = TipoRel_Cte,DIR.MunicipioID, REL.MunicipioID) AS MunicipioID,
		IF(REL.TipoRelacionado = TipoRel_Cte,DIR.LocalidadID, REL.LocalidadID) AS LocalidadID,
		IF(REL.TipoRelacionado = TipoRel_Cte,DIR.ColoniaID, REL.ColoniaID) AS ColoniaID,
		IF(REL.TipoRelacionado = TipoRel_Cte,DIR.Calle, REL.Calle) AS Calle,
		IF(REL.TipoRelacionado = TipoRel_Cte,DIR.NumeroCasa, REL.NumeroCasa) AS NumeroCasa,
		IF(REL.TipoRelacionado = TipoRel_Cte,DIR.NumInterior, REL.NumInterior) AS NumInterior,
		IF(REL.TipoRelacionado = TipoRel_Cte,DIR.Piso, REL.Piso) AS Piso,
		IF(REL.TipoRelacionado = TipoRel_Cte,DIR.CP, REL.CP) AS CP,
		IF(REL.TipoRelacionado = TipoRel_Cte,DIR.Lote, REL.Lote) AS Lote,
		IF(REL.TipoRelacionado = TipoRel_Cte,DIR.Manzana, REL.Manzana) AS Manzana,
		IF(REL.TipoRelacionado = TipoRel_Cte,DIR.DireccionCompleta, REL.DireccionCompleta) AS DireccionCompleta
		FROM RELACIONADOSFISCALES REL
			LEFT JOIN CLIENTES CTE
				ON REL.TipoRelacionado = TipoRel_Cte
					AND REL.CteRelacionadoID = CTE.ClienteID
			LEFT JOIN DIRECCLIENTE DIR
				ON REL.TipoRelacionado = TipoRel_Cte
					AND REL.CteRelacionadoID = DIR.ClienteID
						AND DIR.Fiscal = Cont_SI
		WHERE REL.ClienteID = Par_ClienteID
			AND REL.Ejercicio = Par_Ejercicio;
	END IF;

END TerminaStore$$