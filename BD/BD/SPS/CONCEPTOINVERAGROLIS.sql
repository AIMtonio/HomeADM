-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOINVERAGROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOINVERAGROLIS`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOINVERAGROLIS`(
	/*  SP PARA LISTAR CONCEPTOS DE INVERSION FIRA */
    Par_SolicitudCredito	BIGINT(20),				-- ID DE LA SOLICITUD DE CREDITO
    Par_ClienteID			INT(11),				-- ID dcel cliente
	Par_TipoRecurso			CHAR(2),				-- Tipo de recurso.
	Par_NumList				TINYINT UNSIGNED,		-- no. del tipo de consulta

	Par_EmpresaID			INT(11),				-- Parametros de auditoria
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN
	-- DEclaracion variables
    DECLARE Var_TotalPrestamo	DECIMAL(16,2);
	DECLARE Var_TotalSolicita	DECIMAL(16,2);
    DECLARE Var_TotalOtrasF		DECIMAL(16,2);

	-- Declaracion de constantes
	DECLARE Lis_Prestamo		INT(11);
	DECLARE Lis_Solicitante		INT(11);
	DECLARE Lis_OtrasFuentes	INT(11);

	-- Asignacion de constantes
	SET Lis_Prestamo 			:= 1;
    SET Lis_Solicitante 		:= 2;
    SET Lis_OtrasFuentes 		:= 3;

	-- lista prestmos
	IF(Par_NumList = Lis_Prestamo) THEN

		SET Var_TotalPrestamo :=(SELECT SUM(Monto) FROM CONCEPTOINVERAGRO
								WHERE SolicitudCreditoID = Par_SolicitudCredito
									AND ClienteID = Par_ClienteID
									AND TipoRecurso = Par_TipoRecurso);

		SELECT Con.ConceptoFiraID, Cat.Descripcion, Con.NoUnidad, Con.ClaveUnidad, Con.Unidad, Con.Monto, Con.TipoRecurso, Var_TotalPrestamo AS TotalPrestamo
			FROM CONCEPTOINVERAGRO Con , CATCONCEPTOSINVERAGRO Cat
		WHERE Con.SolicitudCreditoID = Par_SolicitudCredito
			AND Con.ClienteID = Par_ClienteID
            AND Con.TipoRecurso = Par_TipoRecurso
            AND Cat.ConceptoFiraID = Con.ConceptoFiraID
            GROUP BY ConceptoInvID LIMIT 15;

    END IF;

    -- lista solicitante
	IF(Par_NumList = Lis_Solicitante) THEN

		SET Var_TotalSolicita :=(SELECT SUM(Monto) FROM CONCEPTOINVERAGRO
								WHERE SolicitudCreditoID = Par_SolicitudCredito
									AND ClienteID = Par_ClienteID
									AND TipoRecurso = Par_TipoRecurso);

		SELECT Con.ConceptoFiraID, Cat.Descripcion,  Con.NoUnidad, Con.ClaveUnidad, Con.Unidad, Con.Monto, Con.TipoRecurso, Var_TotalSolicita AS TotalSolicitante
			FROM CONCEPTOINVERAGRO Con , CATCONCEPTOSINVERAGRO Cat
		WHERE Con.SolicitudCreditoID = Par_SolicitudCredito
			AND Con.ClienteID = Par_ClienteID
            AND Con.TipoRecurso = Par_TipoRecurso
            AND Cat.ConceptoFiraID = Con.ConceptoFiraID
            GROUP BY ConceptoInvID LIMIT 15;

    END IF;


     -- lista solicitante
	IF(Par_NumList = Lis_OtrasFuentes) THEN

		SET Var_TotalOtrasF :=(SELECT SUM(Monto) FROM CONCEPTOINVERAGRO
								WHERE SolicitudCreditoID = Par_SolicitudCredito
									AND ClienteID = Par_ClienteID
									AND TipoRecurso = Par_TipoRecurso);

		SELECT Con.ConceptoFiraID, Cat.Descripcion,  Con.NoUnidad, Con.ClaveUnidad, Con.Unidad, Con.Monto, Con.TipoRecurso, Var_TotalOtrasF AS TotalotrasFuentes
			FROM CONCEPTOINVERAGRO Con , CATCONCEPTOSINVERAGRO Cat
		WHERE Con.SolicitudCreditoID = Par_SolicitudCredito
			AND Con.ClienteID = Par_ClienteID
            AND Con.TipoRecurso = Par_TipoRecurso
            AND Cat.ConceptoFiraID = Con.ConceptoFiraID
            GROUP BY ConceptoInvID LIMIT 15;

    END IF;


END TerminaStore$$